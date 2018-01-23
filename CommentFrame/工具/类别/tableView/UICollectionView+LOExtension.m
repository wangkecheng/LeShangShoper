//
//  UICollectionView+LOExtension.m
//  CommentFrame
//
//  Created by warron on 2017/8/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "UICollectionView+LOExtension.h"

@implementation UICollectionView(LOExtension)

 
//设置占位图片
-(void)setHolderImg:(NSString *)img isHide:(BOOL)isHide{
    [self setHolderImg:img holderStr:@"暂无数据" isHide:isHide];
}

//设置占位文字及图片
-(void)setHolderImg:(NSString *)img holderStr:(NSString *)holderStr isHide:(BOOL)isHide{
    if (!isHide) {
        if (img.length==0||img == nil) {
            img = @"alertImg";
        }
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 105, 105)];
        contentView.tag = 20001;//自己规定的
        contentView.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0 - 64) ;
        [self addSubview:contentView];
        
        UIImageView *imgView = [[UIImageView alloc]initWithImage:IMG(img)];
        imgView.frame = CGRectMake(0, 0, 80, 80);
        imgView.center = CGPointMake(CGRectGetWidth(contentView.frame)/2.0, CGRectGetWidth(imgView.frame)/2.0);
        [contentView addSubview:imgView];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame) + 5, CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame) - CGRectGetHeight(imgView.frame) - 5)];
        lbl.text =  holderStr;
        lbl.textAlignment = 1;
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.textColor = [UIColor grayColor];
        [contentView addSubview:lbl];
        return;
    }
    
    //隐藏的话就将其移除
    for (int i = 0; i<self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        if (view.tag == 20001) {
            [UIView animateWithDuration:0.5 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
    }
}

@end
