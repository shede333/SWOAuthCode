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

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) SWOACOnlyKBTextView *textView;
@property (nonatomic, strong) NSArray<SWOACItemBoxView *> *boxViewArr;

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

- (void)setupUI{
    //创建输入验证码view
    if (_maxLenght<=0) {
        return;
    }
    
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView.superview);
    }];
    
    //添加textView
    [self.containerView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textView.superview);
    }];
    
    NSMutableArray *boxViewArr = [NSMutableArray array];
    UIView *lastDivideView = nil;
    for (int index = 0; index < self.maxLenght; index++) {
        UIView *divideView = [[UIView alloc] init];  // 用于等分的view
        divideView.backgroundColor = [UIColor clearColor];
        divideView.userInteractionEnabled = NO; //不响应任何事件
        [self.containerView addSubview:divideView];
        if (index == 0) {
            //第一个
            [divideView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(divideView.superview);
            }];
        }else if (index == (self.maxLenght - 1)){
            //最后一个
            [divideView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.bottom.equalTo(divideView.superview);
                make.left.equalTo(lastDivideView.mas_right);
                make.width.equalTo(lastDivideView);
            }];
        }else{
            //中间的
            [divideView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(divideView.superview);
                make.left.equalTo(lastDivideView.mas_right);
                make.width.equalTo(lastDivideView);
            }];
        }
        
        //用于显示边框的View
        SWOACItemBoxView *boxView = [[SWOACItemBoxView alloc] init];
        boxView.layer.masksToBounds = YES;
        [divideView addSubview:boxView];
        [boxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(boxView.superview);
            make.height.equalTo(boxView.superview);
            make.width.equalTo(boxView.superview.mas_height);
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
        
        lastDivideView = divideView;
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

- (void)textViewDidChange:(UITextView *)textView{
    NSString *contentText = textView.text;
    //有空格去掉空格
    contentText = [contentText stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL isFinish = NO;
    if (contentText.length >= self.maxLenght) {
        //文本超出最大长度
        contentText = [contentText substringToIndex:self.maxLenght];
        isFinish = YES;
    }
    textView.text = contentText;
    
    if ([self.delegate respondsToSelector:@selector(oauthCodeView:inputTextChange:)]) {
        //将textView的值修改情况传出去
        [self.delegate oauthCodeView:self inputTextChange:contentText];
    }
    
    //更新Label
    for (int i= 0; i < self.boxViewArr.count; i++) {
        SWOACItemBoxView *boxView = self.boxViewArr[i];
        BOOL isHideCursor = (i != contentText.length); //是否显示光标
        boxView.layer.borderColor = isHideCursor?self.boxNormalBorderColor.CGColor:self.boxHighlightBorderColor.CGColor;
        [boxView setCursorIsHidden:isHideCursor];
        
        //修改所有Label里的内容
        if (i < contentText.length) {
            boxView.textLabel.text = [contentText substringWithRange:NSMakeRange(i, 1)];
        }else{
            boxView.textLabel.text = @"";
        }
    }
    
    if (isFinish) {
        //完成最大长度输入
        if (self.isEndEditWhenTextToMax) {
            [self endEdit];
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
    }
    return _containerView;
}

@end
