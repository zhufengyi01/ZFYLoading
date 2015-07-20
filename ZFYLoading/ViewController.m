//
//  ViewController.m
//  ZFYLoading
//
//  Created by 朱封毅 on 14/07/15.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "ViewController.h"
#import "ZFYLoading.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor= [UIColor whiteColor];
    
    UIView *view= [[UIView alloc]initWithFrame:CGRectMake(50, 100, 200, 280)];
    view.backgroundColor = [UIColor redColor];
    view.tag = 2;
    [self.view addSubview:view];
    
    //1.回调不是很合理 按钮事件应该在ZFYLoading内部处理 只回调处理事件即可
    //2.转圈圈事件应该在内部处理
    
     //模拟加载失败，重新加载回调
    //[ZFYLoading showLoadViewInview:view];
   //数据加载完成后消失
    //[ZFYLoading showNullWithstatus:@"没有数据" inView:self.view];
//    [ZFYLoading showFailWithstatus:@"加载失败" inView:view didStartLoadingBlock:^{
//        
//        
//    }];
    //[self performSelector:@selector(dis) withObject:self afterDelay:4];
//    
    //[ZFYLoading showNullWithstatus:@"没有数据" inView:self.view];
     //[ZFYLoading showLoadViewWithStatus:@"正在加载..." inView:self.view];
    //[ZFYLoading showLoadViewInview:self.view];
    [ZFYLoading showNullWithstatus:@"数据为空" inView:self.view];
}
//4秒后消失，也就是数据加载完成后执行
-(void)dis
{
    
    //    //数据加载完成后消失
    [ZFYLoading showFailWithstatus:@"加载失败" inView:[self.view viewWithTag:2] didStartLoadingBlock:^{
    NSLog(@"--didStartLoading--");
    [ZFYLoading dismiss];
}];

}


@end
