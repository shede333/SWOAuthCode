//
//  SWOAuthCodeView.m
//  Pods
//
//  Created by shaowei on 2019/6/5.
//

#import "SWOAuthCodeView.h"
#import "SWOACItemBoxView.h"

#import <Masonry/Masonry.h>


/**
 仅支持键盘输入的UITextView（即禁止粘贴、选择、全选）
 */
@interface SWOACOnlyKBTextView : UITextView

@end

@implementation SWOACOnlyKBTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return [super canPerformAction:action withSender:sender];
}

@end


@interface SWOAuthCodeView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *containerView; //放置所有Box的容器view
@property (nonatomic, strong) NSArray<SWOACItemBoxView *> *boxViewArr; //所有的Box对象
@property (nonatomic, strong) SWOACOnlyKBTextView *textView; //接收输入事件的透明TextView

@property (nonatomic, assign) NSInteger maxLenght;

@end

@implementation SWOAuthCodeView

- (instancetype)initWithMaxLength:(NSInteger)maxLength{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        NSAssert(maxLength >= 3, @"maxLength %ld < 3", maxLength);
        self.maxLenght = MAX(3, maxLength);
        [self setupDefaultValue];
        [self setupUI];
    }
    return self;
}

- (void)setupDefaultValue{
    //初始化默认值
    self.maxLenght = 6;
    
    self.boxNormalBorderColor = SWColorWithRGBA(255, 255, 255, 0.25);
    self.boxHighlightBorderColor = SWColorWithRGBA(48, 117, 238, 1);
    self.boxCornerRadius = 4;
    self.boxBorderWidth = 0.5f;
    self.boxBGColor = [UIColor clearColor];
    self.boxTextColor = [UIColor whiteColor];
    self.boxTextFont = [UIFont systemFontOfSize:24];
    
    self.backgroundColor = [UIColor clearColor];
    self.isEndEditWhenTextToMax = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSArray *boxViewArr = self.boxViewArr;
    [boxViewArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                         withFixedItemLength:self.frame.size.height
                                 leadSpacing:0
                                 tailSpacing:0];
}

- (void)setupUI{
    //创建输入验证码view
    if (_maxLenght<=0) {
        return;
    }
    
    //添加textView
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textView.superview);
    }];
    
    //放置所有Box的容器view
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView.superview);
    }];
    
    NSMutableArray *boxViewArr = [NSMutableArray array];
    for (int index = 0; index < self.maxLenght; index++) {
        //用于显示边框的View
        SWOACItemBoxView *boxView = [[SWOACItemBoxView alloc] init];
        boxView.layer.masksToBounds = YES;
        [self.containerView addSubview:boxView];
        [boxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(boxView.superview);
        }];
        [boxViewArr addObject:boxView];
        
        //光标
        boxView.cursorLayer.fillColor =  self.boxHighlightBorderColor.CGColor;
        if (index == 0) {
            //初始化第一个view为选择状态
            [boxView setCursorIsHidden:NO];
            boxView.layer.borderColor = self.boxHighlightBorderColor.CGColor;
        }else{
            //未选中状态
            [boxView setCursorIsHidden:YES];
            boxView.layer.borderColor = self.boxNormalBorderColor.CGColor;
        }
        
        //显示数字的Label
        UILabel *itemLabel = boxView.textLabel;
        [boxView addSubview:itemLabel];
    }
    self.boxViewArr = boxViewArr;
    
    //属性boxUI
    [self updateBoxViewUI];
}

- (void)updateBoxViewUI{
    if (!self.boxViewArr) {
        return;
    }
    
    NSString *contentText = self.textView.text;
    NSInteger index = 0;
    for (SWOACItemBoxView *boxView in self.boxViewArr) {
        boxView.layer.cornerRadius = self.boxCornerRadius;
        boxView.layer.borderWidth = self.boxBorderWidth;
        boxView.backgroundColor = self.boxBGColor;
        boxView.textLabel.textColor = self.boxTextColor;
        boxView.textLabel.font = self.boxTextFont;
        
        BOOL isHideCursor = (index != contentText.length);
        boxView.layer.borderColor = isHideCursor?self.boxNormalBorderColor.CGColor:self.boxHighlightBorderColor.CGColor;
        
        index ++;
    }
    self.textView.font = self.boxTextFont;
}

//处理输入框里的文本变化、输入状态的变化
- (void)handleTextContentChange{
    NSString *originText = self.textView.text;
    NSString *contentText = originText;
    
    //有空格去掉空格
    contentText = [contentText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //检测文本长度
    if (contentText.length > self.maxLenght) {
        //文本超出最大长度
        contentText = [contentText substringToIndex:self.maxLenght];
    }
    if (![contentText isEqualToString:originText]) {
        //文本有变化，则更新输入框内容
        self.textView.text = contentText;
    }
    
    //修改所有Label里的内容
    NSArray *boxViewArr = self.boxViewArr;
    for (int i= 0; i < boxViewArr.count; i++) {
        SWOACItemBoxView *boxView = self.boxViewArr[i];
        if (i < contentText.length) {
            boxView.textLabel.text = [contentText substringWithRange:NSMakeRange(i, 1)];
        }else{
            boxView.textLabel.text = @"";
        }
    }
    
    //更新光标状态
    if (self.textView.isFirstResponder) {
        //输入中
        for (int i= 0; i < boxViewArr.count; i++) {
            SWOACItemBoxView *boxView = boxViewArr[i];
            BOOL isHideCursor = (i != contentText.length); //是否隐藏光标
            boxView.layer.borderColor = isHideCursor?self.boxNormalBorderColor.CGColor:self.boxHighlightBorderColor.CGColor;
            [boxView setCursorIsHidden:isHideCursor];
        }
    }else{
        //不在输入状态，则不显示光标
        for (int i= 0; i < boxViewArr.count; i++) {
            SWOACItemBoxView *boxView = boxViewArr[i];
            BOOL isHideCursor = YES; //隐藏光标
            boxView.layer.borderColor = isHideCursor?self.boxNormalBorderColor.CGColor:self.boxHighlightBorderColor.CGColor;
            [boxView setCursorIsHidden:isHideCursor];
        }
    }
}

#pragma mark - Function - Public

- (void)beginEdit{
    [self.textView becomeFirstResponder];
}

- (void)endEdit{
    [self.textView resignFirstResponder];
}

- (NSString *)textContent{
    return self.textView.text;
}

- (void)setAllBoxBorderColor:(UIColor *)color{
    for (SWOACItemBoxView *boxView in self.boxViewArr) {
        boxView.layer.borderColor = color.CGColor;
    }
}

- (void)setInputBoxText:(nullable NSString *)text{
    self.textView.text = text;
    [self handleTextContentChange];
}

- (void)emptyInputBoxText{
    [self setInputBoxText:nil];
}

#pragma mark - Function重写

- (void)setBoxNormalBorderColor:(UIColor *)boxNormalBorderColor{
    _boxNormalBorderColor = boxNormalBorderColor;
    [self updateBoxViewUI];
}

- (void)setBoxHighlightBorderColor:(UIColor *)boxHighlightBorderColor{
    _boxHighlightBorderColor = boxHighlightBorderColor;
    [self updateBoxViewUI];
}

- (void)setBoxCornerRadius:(CGFloat)boxCornerRadius{
    _boxCornerRadius = boxCornerRadius;
    [self updateBoxViewUI];
}

- (void)setBoxBorderWidth:(CGFloat)boxBorderWidth{
    _boxBorderWidth = boxBorderWidth;
    [self updateBoxViewUI];
}

- (void)setBoxBGColor:(UIColor *)boxBGColor{
    _boxBGColor = boxBGColor;
    [self updateBoxViewUI];
}

- (void)setBoxTextColor:(UIColor *)boxTextColor{
    _boxTextColor = boxTextColor;
    [self updateBoxViewUI];
}

- (void)setBoxTextFont:(UIFont *)boxTextFont{
    _boxTextFont = boxTextFont;
    [self updateBoxViewUI];
}

#pragma mark - Function重写

- (void)setKeyBoardType:(UIKeyboardType)keyBoardType{
    _keyBoardType = keyBoardType;
    self.textView.keyboardType = keyBoardType;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    //显示: 光标
    [self handleTextContentChange];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    //隐藏: 光标
    [self handleTextContentChange];
}

- (void)textViewDidChange:(UITextView *)textView{
    //处理textView里的文本
    [self handleTextContentChange];
    
    NSString *contentText = self.textView.text;
    
    if ([self.delegate respondsToSelector:@selector(oauthCodeView:inputTextChange:)]) {
        //将textView的值修改情况传出去
        [self.delegate oauthCodeView:self inputTextChange:contentText];
    }
    
    if (contentText.length >= self.maxLenght) {
        //文本 达到/超出 最大长度
        if (self.isEndEditWhenTextToMax) {
            [self endEdit]; //结束输入状态
        }
        if ([_delegate respondsToSelector:@selector(oauthCodeView:didInputFinish:)]) {
            [_delegate oauthCodeView:self didInputFinish:contentText];
        }
    }
}

#pragma mark - Custom Accessors

- (SWOACOnlyKBTextView *)textView{
    if (!_textView) {
        _textView = [[SWOACOnlyKBTextView alloc] init];
        _textView.tintColor = [UIColor clearColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textView;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.userInteractionEnabled = NO;
    }
    return _containerView;
}

@end
