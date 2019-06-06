//
//  SWOACItemBoxView.m
//  Pods
//
//  Created by shaowei on 2019/6/5.
//

#import "SWOACItemBoxView.h"

#import <Masonry/Masonry.h>

@interface SWOACItemBoxView()

@property (nonatomic, strong) CAShapeLayer *cursorLayer;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SWOACItemBoxView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    //光标
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake((CGRectGetHeight(self.frame)-2)/2,5,2,(CGRectGetHeight(self.frame)-10))];
    CAShapeLayer *cursorLayer = [CAShapeLayer layer];
    self.cursorLayer = cursorLayer;
    cursorLayer.path = path.CGPath;
    [self.layer addSublayer:cursorLayer];
    cursorLayer.hidden = YES; //默认隐藏
    
    //文本
    UILabel *textLabel = [[UILabel alloc] init];
    [self addSubview:textLabel];
    self.textLabel = textLabel;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(textLabel.superview);
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat sHeight = CGRectGetHeight(self.frame);
    CGFloat sWidth = CGRectGetHeight(self.frame);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake((sWidth-2)/2, 5, 2, sHeight-10)];
    self.cursorLayer.path = path.CGPath;
}

//模拟光标的动画
- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}

#pragma mark - Function - Public

- (void)setCursorIsHidden:(BOOL)isHidden{
    self.cursorLayer.hidden = isHidden;
    NSString *animationKey = @"kOpacityAnimation";
    if (isHidden) {
        [self.cursorLayer removeAnimationForKey:animationKey];
    }else{
        if (![self.cursorLayer animationForKey:animationKey]) {
            [self.cursorLayer addAnimation:[self opacityAnimation] forKey:animationKey];
        }
    }
}

#pragma mark - Function重写

//+ (Class)layerClass{
//    return [CAShapeLayer class];
//}



@end
