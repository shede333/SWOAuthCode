//
//  SWViewController.m
//  SWOAuthCode
//
//  Created by shede333 on 06/05/2019.
//  Copyright (c) 2019 shede333. All rights reserved.
//

#import "SWViewController.h"

#import <Masonry/Masonry.h>
#import <SWOAuthCode/SWOAuthCodeView.h>

@interface SWViewController ()<SWOAuthCodeViewDelegate>

@property (nonatomic, strong) SWOAuthCodeView *oacView;

@end

@implementation SWViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = SWColorHex(0x8D6AAC);
    
    //创建view时，需要指定验证码的长度
    SWOAuthCodeView *oacView = [[SWOAuthCodeView alloc] initWithMaxLength:6];
    self.oacView = oacView;
    [self.view addSubview:oacView];
    /* -----设置可选的属性 start----- */
    oacView.delegate = self; //设置代理
    oacView.boxNormalBorderColor = [UIColor blueColor]; //方框的边框正常状态时的边框颜色
    oacView.boxHighlightBorderColor = [UIColor redColor]; //方框的边框输入状态时的边框颜色
    oacView.boxBorderWidth = 2; //方框的边框宽度
    oacView.boxCornerRadius = 6; //方框的圆角半径
    oacView.boxBGColor = [UIColor whiteColor];  //方框的背景色
    oacView.boxTextColor = [UIColor blackColor]; //方框内文字的颜色
    oacView.backgroundColor = [UIColor lightGrayColor]; //底色为：灰色
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
    
    //测试布局
    [self testLayout];
}

- (void)testLayout{
    //3秒后，布局大小改变，看看能够自动适应
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.oacView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.oacView.superview).offset(30);
            make.right.equalTo(self.oacView.superview).offset(-30);
            make.top.equalTo(self.oacView.superview).offset(200);
            make.height.mas_equalTo(35);
        }];
    });
}

#pragma mark - SWOAuthCodeViewDelegate

- (void)oauthCodeView :(SWOAuthCodeView *)mqView inputTextChange:(NSString *)currentText{
    NSLog(@"currentText: %@", currentText);
}

- (void)oauthCodeView:(SWOAuthCodeView *)mqView didInputFinish:(NSString *)finalText{
    NSLog(@"didInputFinish: %@", finalText);
}

#pragma mark - action

- (IBAction)actionShowErrorState:(id)sender {
    [self.oacView setAllBoxBorderColor:[UIColor redColor]];
}

- (IBAction)actionEndEdit:(id)sender {
    [self.oacView endEdit];
}

- (IBAction)actionAddRandomText:(id)sender {
    NSInteger firstInt = pow(10, 10);
    NSString *randomText = [NSString stringWithFormat:@"%ld", (NSInteger)(firstInt + arc4random()%(firstInt * 8))];
    randomText = [randomText substringToIndex:(arc4random()%randomText.length)];
    NSLog(@"actionAddRandomText: %@, len: %ld", randomText, randomText.length);
    [self.oacView setInputBoxText:randomText];
}

- (IBAction)actionEmptyText:(id)sender {
    [self.oacView setInputBoxText:nil];
}

@end
