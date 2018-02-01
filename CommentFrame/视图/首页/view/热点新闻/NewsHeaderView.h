//
//  NewsHeaderView.h
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsHeaderView : UITableViewHeaderFooterView
+(instancetype)headerViewWithFrame:(CGRect)frame;

/*
时间
是否显示热点新闻 1.显示 2 不显示
 */
-(void)setTime:(NSString *)time isShowSubTit:(BOOL)isShowSubTit;
@end
