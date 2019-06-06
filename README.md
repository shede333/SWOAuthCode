# SWOAuthCode

[![CI Status](https://img.shields.io/travis/shede333/SWOAuthCode.svg?style=flat)](https://travis-ci.org/shede333/SWOAuthCode)
[![Version](https://img.shields.io/cocoapods/v/SWOAuthCode.svg?style=flat)](https://cocoapods.org/pods/SWOAuthCode)
[![License](https://img.shields.io/cocoapods/l/SWOAuthCode.svg?style=flat)](https://cocoapods.org/pods/SWOAuthCode)
[![Platform](https://img.shields.io/cocoapods/p/SWOAuthCode.svg?style=flat)](https://cocoapods.org/pods/SWOAuthCode)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SWOAuthCode is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SWOAuthCode'
```

## Use

```
//创建view时，需要指定验证码的长度
SWOAuthCodeView *oacView = [[SWOAuthCodeView alloc] initWithMaxLength:6];
[self.view addSubview:oacView];
/* -----设置可选的属性 start----- */
oacView.delegate = self; //设置代理
oacView.boxNormalBorderColor = [UIColor blueColor]; //方框的边框正常状态时的边框颜色
oacView.boxHighlightBorderColor = [UIColor redColor]; //方框的边框输入状态时的边框颜色
oacView.boxBorderWidth = 2; //方框的边框宽度
oacView.boxCornerRadius = 6; //方框的圆角半径
oacView.boxBGColor = [UIColor whiteColor];  //方框的背景色
oacView.boxTextColor = [UIColor blackColor]; //方框内文字的颜色
/* -----设置可选的属性 end----- */

//显示键盘，可以输入验证码了
[oacView beginEdit];

//可选步骤：Masonry布局/设置frame
[oacView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(oacView.superview).offset(15);
    make.right.equalTo(oacView.superview).offset(-15);
    make.top.equalTo(oacView.superview).offset(150);
    make.height.mas_equalTo(44);
}];
```

## 功能

* 很大程度上支持UI自定义化；
* 支持自动布局；
* 设置、修改输入框内容；
* 清空输入框内容；
* 设置所有输入框的边框颜色（比如错误状态时，全部设置为红色）；
* 变更输入框状态;

## Screenshot

![](https://raw.githubusercontent.com/shede333/SWOAuthCode/master/Screenshot/OAuthCode1.png)

![](https://raw.githubusercontent.com/shede333/SWOAuthCode/master/Screenshot/OAuthCode2.png)

## Author

shede333, 333wshw@163.com

此项目的思路，借鉴于：<https://github.com/meiqi1992/MQVerCodeInputView>

## License

SWOAuthCode is available under the MIT license. See the LICENSE file for more info.


