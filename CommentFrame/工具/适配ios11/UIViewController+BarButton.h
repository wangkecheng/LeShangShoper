//
//  ZTNavigationViewController.h
//  ZTNavigationItem
//
//  Created by ZT on 2017/10/31.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BarButton)
- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action;

- (UIButton *)addRightBarButtonWithFirstImage:(UIImage *)firstImage action:(SEL)action;
- (UIButton *)addRightBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action;
- (void)addLeftBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action;

- (void)addRightTwoBarButtonsWithFirstImage:(UIImage *)firstImage firstAction:(SEL)firstAction secondImage:(UIImage *)secondImage secondAction:(SEL)secondAction;
- (void)addRightThreeBarButtonsWithFirstImage:(UIImage *)firstImage firstAction:(SEL)firstAction secondImage:(UIImage *)secondImage secondAction:(SEL)secondAction thirdImage:(UIImage *)thirdImage thirdAction:(SEL)thirdAction;
- (void)addRightFourBarButtonsWithFirstImage:(UIImage *)firstImage firstAction:(SEL)firstAction secondImage:(UIImage *)secondImage secondAction:(SEL)secondAction thirdImage:(UIImage *)thirdImage thirdAction:(SEL)thirdAction fourthImage:(UIImage *)fourthImage fourthAction:(SEL)fourthAction;

@end
