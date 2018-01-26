//
//  UIViewController+LBGideView.h
//  lubanlianmeng
//
//  Created by warron on 2016/10/11.
//  Copyright © 2016年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PageControl;

typedef void(^GuideBlock)(BOOL isFinish);
@interface GuideVC:UIViewController<UICollectionViewDataSource,
UICollectionViewDelegate,UIScrollViewDelegate>
+(instancetype)loadWithBlock:(GuideBlock)guideBlock;
+ (BOOL)hadLoaded;

@end
/*这里是要展示的图片，修改即可,当然不止三个  1242 * 2208的分辨率最佳,如果在小屏手机上显示不全，最好要求UI重新设计图片*/
/** pageIndicatorTintColor*/
#define pageTintColor [[UIColor whiteColor] colorWithAlphaComponent:0.5];
/** currentPageIndicatorTintColor*/
#define currentTintColor [UIColor redColor];


/*
 如果要修改立即体验按钮的样式
 重新- (UIButton*)removeBtn方法即可
 */
