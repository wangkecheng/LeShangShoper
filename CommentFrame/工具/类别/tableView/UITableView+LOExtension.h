//
//  UITableView+LOExtension.h
//
//  Created by warron on 2016/9/13.
//  Copyright © 2016年 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (LOExtension)


/**
 隐藏多余的分割线
 */
- (void)hideSurplusLine;

//设置下滑线起始X坐标    ";
-(void)setSepareteX:(CGFloat)X;

//设置占位图片
-(void)setHolderImg:(NSString *)img isHide:(BOOL)isHide;
//设置占位文字及图片
-(void)setHolderImg:(NSString *)img holderStr:(NSString *)holderStr isHide:(BOOL)isHide;
@end

