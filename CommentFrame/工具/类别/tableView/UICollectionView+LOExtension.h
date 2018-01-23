//
//  UICollectionView+LOExtension.h
//  CommentFrame
//
//  Created by warron on 2017/8/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView(LOExtension)
 
//设置占位图片
-(void)setHolderImg:(NSString *)img isHide:(BOOL)isHide;
//设置占位文字及图片
-(void)setHolderImg:(NSString *)img holderStr:(NSString *)holderStr isHide:(BOOL)isHide;
@end
