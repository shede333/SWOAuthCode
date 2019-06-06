//
//  SWOAuthCodeView.h
//  Pods
//
//  Created by shaowei on 2019/6/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SWOAuthCodeView;
@protocol SWOAuthCodeViewDelegate <NSObject>

@required

@optional

/**
 输入框内容有改变时，回调此方法
 
 @param mqView SWOAuthCodeView
 @param currentText 当前输入框内容
 */
- (void)oauthCodeView :(SWOAuthCodeView *)mqView inputTextChange:(NSString *)currentText;

/**
 输入框内容长度达到最大值maxLenght时，输入框失去焦点，回调此方法
 
 @param mqView SWOAuthCodeView
 @param finalText 输入框最终的文本
 */
- (void)oauthCodeView:(SWOAuthCodeView *)mqView didInputFinish:(NSString *)finalText;

@end


/**
 验证码输入框
 */
@interface SWOAuthCodeView : UIView

/**
 代理对象
 */
@property (nonatomic, weak) id<SWOAuthCodeViewDelegate> delegate;

/**
 键盘类型，默认为：UIKeyboardTypeNumberPad
 */
@property (nonatomic, assign) UIKeyboardType keyBoardType;

/**
 当输入口内容达到最大值时，是否结束编辑状态（即失去焦点），默认为YES
 */
@property (nonatomic, assign) BOOL isEndEditWhenTextToMax;

/**
 验证码的最大长度
 */
@property (nonatomic, assign, readonly) NSInteger maxLenght;

/**
 正常状态时，输入框的边界的颜色，默认：RGBA(255, 255, 255, 0.25);
 */
@property (nonatomic, strong) UIColor *boxNormalBorderColor;

/**
 高亮状态时（即输入时），输入框的边界的颜色，默认：RGBA(48, 117, 238, 1);
 */
@property (nonatomic, strong) UIColor *boxHighlightBorderColor;

/**
 输入框的圆角半径，默认：4
 */
@property (nonatomic, assign) CGFloat boxCornerRadius;

/**
 输入框边框的宽度，默认：0.5
 */
@property (nonatomic, assign) CGFloat boxBorderWidth;

/**
 输入框的背景色，默认：clearColor
 */
@property (nonatomic, strong) UIColor *boxBGColor;

/**
 输入框内的文本颜色，默认：whiteColor
 */
@property (nonatomic, strong) UIColor *boxTextColor;

/**
 输入框内文本的字体，默认：[UIFont systemFontOfSize:24]
 */
@property (nonatomic, strong) UIFont *boxTextFont;

+ (instancetype)new NS_UNAVAILABLE;  //不支持此初始化方法
- (instancetype)init NS_UNAVAILABLE;  //不支持此初始化方法
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;  //不支持此初始化方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;  //不支持此初始化方法

/**
 初始化函数
 
 @param maxLength 验证码的最大长度(最小值为3)
 @return 实例对象
 */
- (instancetype)initWithMaxLength:(NSInteger)maxLength NS_DESIGNATED_INITIALIZER;

/**
 开始编辑，即弹出键盘
 */
- (void)beginEdit;

/**
 取消编辑状态，即隐藏键盘
 */
- (void)endEdit;

/**
 获取：验证码输入框的文本内容

 @return 验证码输入框的文本内容
 */
- (NSString *)textContent;

/**
 设置所有输入框的边缘颜色
 
 @param color 输入框的边缘颜色
 */
- (void)setAllBoxBorderColor:(UIColor *)color;

/**
 设置输入框内容
 
 @param text 输入框的内容（建议为纯数字或者空）
 */
- (void)setInputBoxText:(nullable NSString *)text;

/**
 清空输入框内容
 */
- (void)emptyInputBoxText;

@end

NS_ASSUME_NONNULL_END
