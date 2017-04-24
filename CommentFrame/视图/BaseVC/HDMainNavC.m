//
//  AppDelegate.m
//  CommentFrame
//
//  Created by warron on 2017/4/21.
//  Copyright © 2017年 warron. All rights reserved.
//
#import "HDMainNavC.h"

@interface HDMainNavC ()

@end

@implementation HDMainNavC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNavigationBarBgColor];
}

-(void)setNavigationBarBgColor{
    
    //设置NavigationBar背景颜色
    [self.navigationBar setBackgroundImage:[DDFactory imageWithColor:UIColorFromHX(0x222222)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    self.navigationBar.opaque = YES;
    // 设置NavigationBar渲染颜色
}
/**
 *  通过拦截push方法来设置每个push进来的控制器的返回按钮
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 15, 15)];
        [btn setImage:IMG(@"ic_fanhui.png") forState:UIControlStateNormal];
        [btn setImage:IMG(@"c4_ic_zuo.png") forState:UIControlStateHighlighted]; // 让按钮内部的所有内容左对齐
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //设置内边距，让按钮靠近屏幕边缘
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
       UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [viewController.navigationItem setLeftBarButtonItem:item];
        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
    }
    // 一旦调用super的pushViewController方法,就会创建子控制器viewController的view并调用viewController的viewDidLoad方法。可以在viewDidLoad方法中重新设置自己想要的左上角按钮样式
    [super pushViewController:viewController animated:animated];
}

-(BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}
-(void)back{
    
    [self popViewControllerAnimated:YES];
}
@end
