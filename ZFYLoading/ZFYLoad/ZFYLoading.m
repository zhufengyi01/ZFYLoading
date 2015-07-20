//
//  ZFYLoading.m
//  ZFYLoading
//
//  Created by 朱封毅 on 14/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "ZFYLoading.h"
#import <QuartzCore/QuartzCore.h>

#define SingletonImplementation(Class) \
static Class *_instance; \
+(instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+(instancetype)shared##Class \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
-(id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}


//旋转动画时间
const float  Rotation_InterVal = 1.5f;

#define View_backgroundcolor    [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]
#define VLight_GrayColor        [UIColor colorWithRed:140.0/255 green:140.0/255 blue:140.0/255 alpha:1]
#define FailButton_Color        [UIColor blueColor]
#define Width                   [UIScreen mainScreen].bounds.size.width
#define Height                  [UIScreen mainScreen].bounds.size.height
#define fontName                @"Thonburi-Light"
#define AnimationKey            @"AnimationKey"

@interface ZFYLoading ()

@property (nonatomic ,weak)UILabel *statusLable;
@property (nonatomic ,weak)UIImageView *statusImageView;
@property (nonatomic ,weak)UIButton *statusButton;
@property (nonatomic ,assign)BOOL   isStrartAnimation;
@property (nonatomic ,weak)UIView   *currentView;

@end

@implementation ZFYLoading

SingletonImplementation(ZFYLoading)
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}
+(ZFYLoading *)lodingView{
    return [self sharedZFYLoading];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
         [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    self.backgroundColor = View_backgroundcolor;
    //0.状态label
    UILabel *statusLabel = [[UILabel alloc]init];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.textColor = VLight_GrayColor;
    statusLabel.font = [UIFont fontWithName:fontName size:12];
    [self addSubview:statusLabel];
    self.statusLable = statusLabel;
    //1.状态图片
    UIImageView *statusImageView = [[UIImageView alloc]init];
    [self addSubview:statusImageView];
    NSString *image_url = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ZFYLoad.bundle/images/loading_roll.png"];
    statusImageView.image =[UIImage imageWithContentsOfFile:image_url];
    statusImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.statusImageView = statusImageView;
    //2.加载按钮
    UIButton *statusButton = [[UIButton alloc]init];
    [statusButton setTitle:@"正在加载..." forState:UIControlStateNormal];
    [statusButton setTitleColor:VLight_GrayColor forState:UIControlStateNormal];
    statusButton.titleLabel.font = [UIFont fontWithName:fontName size:14];
    [self addSubview:statusButton];
    [statusButton addTarget:self action:@selector(failEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.statusButton = statusButton;
}

#pragma mark ---Loading Method
+(void)showLoadViewInview:(UIView *) view;
{
    [self showLoadViewWithStatus:nil inView:view];
}

+(void)showLoadViewWithStatus:(NSString *) string inView:(UIView *) view;
{
    [self showLoadViewWithImage:nil status:string inview:view];
}
+(void)showLoadViewWithImage:(UIImage *)image status:(NSString*)string inview:(UIView*)view;
{
    
    [self dismiss];
    self.lodingView.currentView = view;
    [view addSubview:self.lodingView];
    //有自定义图片加载自定义图片
    if (image) {
        self.lodingView.statusImageView.image = image;
    }
    if (string) {
         [self.lodingView.statusButton setTitle:string forState:UIControlStateNormal] ;
    }else{
        [self.lodingView.statusButton setTitle:@"正在加载中..." forState:UIControlStateNormal];
    }
    //执行动画
    [self.lodingView Rotaionaimation];
}

#pragma mark --Null dataMethod
+(void)showNullWithstatus:(NSString *)string inView:(UIView *) view;
{   [self dismiss];
    self.lodingView.currentView = view;
    [view addSubview:self.lodingView];
    self.lodingView.statusLable.text = string;
}
+(void)showNullWithImage:(UIImage *)image inView:(UIView *) view;
{
    [self showNullWithImage:image status:nil inview:view];
}
+(void)showNullWithImage:(UIImage *)image status:(NSString*)string inview:(UIView*)view;
{
    [self dismiss];
    self.lodingView.currentView = view;
    [view addSubview:self.lodingView];
    //有自定义图片加载自定义图片
    if (image) {
        self.lodingView.statusImageView.image = image;
    }
    self.lodingView.statusLable.text = string;
    //执行动画
    [self.lodingView Rotaionaimation];
}

#pragma mark --Fail dataMethod
+(void)showFailWithstatus:(NSString *)string inView:(UIView *)view didStartLoadingBlock:(void (^)())didStartLoadingBlock
{
    [self dismiss];
    self.lodingView.currentView = view;
    [view addSubview:self.lodingView];
    
    self.lodingView.didStartLoadingBlock = didStartLoadingBlock;
    [self.lodingView.statusButton setTitle:string forState:UIControlStateNormal];
    self.lodingView.statusLable.text = string;

}

-(void)failEvent:(UIButton *)sender
{
    if (_isStrartAnimation) {
        return;
    }
    [ZFYLoading showLoadViewInview:self.currentView];
    if (self.didStartLoadingBlock) {
        
        self.didStartLoadingBlock();
    }
}
+(void)dismiss;
{

    [self.lodingView dismiss];
}

-(void)dismiss;
{
    self.isStrartAnimation = NO;
    [self.statusImageView.layer removeAnimationForKey:AnimationKey];
    [self removeFromSuperview];
    self.currentView = nil;
}

#pragma  mark --Others Method
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void )Rotaionaimation
{
    self.isStrartAnimation = YES;
    self.statusLable.text = nil;
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 3];
    rotationAnimation.duration = Rotation_InterVal;
    rotationAnimation.repeatCount = MAX_CANON;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]; //缓入缓出
     [self.statusImageView.layer addAnimation:rotationAnimation forKey:AnimationKey];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.frame = self.currentView.bounds;
    CGRect rect = self.currentView.bounds;
    CGFloat lableW = 120;
    CGFloat lableH = 30;
    CGFloat imageW = 60;
    CGFloat imageH = 60;
    
    self.statusLable.frame = CGRectMake((rect.size.width - lableW) * 0.5, (rect.size.height - lableH) * 0.5, lableW, lableH);
    self.statusImageView.frame = CGRectMake(0, 0, imageW, imageH);;
    self.statusImageView.center = self.statusLable.center;;
    self.statusButton.frame =  self.statusLable.frame;
    self.statusButton.frame = CGRectMake(self.statusLable.frame.origin.x, self.statusLable.frame.origin.y + 60, self.statusLable.frame.size.width, self.statusLable.frame.size.height);
}
@end