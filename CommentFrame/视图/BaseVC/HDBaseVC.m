//
//  AppDelegate.m
//  CommentFrame
//
//  Created by warron on 2017/4/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "HDBaseVC.h"

@interface HDBaseVC ()

@end

@implementation HDBaseVC

- (void)viewDidLoad {//  带xib的继承这个
   
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;//TableView的顶部有一部分空白区域 去除
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
