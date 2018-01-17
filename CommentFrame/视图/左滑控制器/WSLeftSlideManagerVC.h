//
//  PersonalCenterVC.m
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonalCenterVC;
@interface WSLeftSlideManagerVC : UIViewController

@property (nonatomic, strong) PersonalCenterVC *leftVC;
@property (nonatomic, strong) HDMainTBC *mainTBC;

/**
 *  是否缩放内容视图 默认YES
 */
@property (nonatomic, assign) IBInspectable BOOL scaleContent;

/**
 *  菜单打开时原来内容页露在侧边的最大宽， 如果有缩放则指缩放完成之后的
 */
@property (nonatomic,assign) CGFloat contentViewVisibleWidth;

/**
 *  允许旋转 默认为NO
 */
@property (assign, nonatomic) BOOL allowRotate;

- (id)initWithMainVC:(HDMainTBC *)mainVC leftVC:(UIViewController *)leftVC;
- (void)pushVC:(UIViewController *)viewController;
- (void)hideMenu;
- (void)showMenu;
@end
