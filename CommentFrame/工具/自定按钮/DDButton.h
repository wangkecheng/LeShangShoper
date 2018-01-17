//
//  LBButton.h
//  按钮图片文字
//
//  Created by warron on 2016/10/30.
//  Copyright © 2016年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDButton : UIButton
//直接设置标题 图片 x 和 w 图片和标题在水平线上
-(instancetype)initWithHorizontal:(CGRect)frame titleX:(CGFloat)titleX  titleW:(CGFloat)titleW imageX:(CGFloat)imageX imageW:(CGFloat)imageW;

//直接设置标题 图片 x 和 w 图片和标题在垂直线上
-(instancetype)initWithVertical:(CGRect)frame titleY:(CGFloat)titleY  titleH:(CGFloat)titleH imageY:(CGFloat)imageY imageH:(CGFloat)imageH;

-(instancetype)initWithFrame:(CGRect)frame titleX:(CGFloat)titleX titleY:(CGFloat)titleY titleW:(CGFloat)titleW titleH:(CGFloat)titleH imageX:(CGFloat)imageX imageY:(CGFloat)imageY imageW:(CGFloat)imageW imageH:(CGFloat)imageH;
@end
