
//
//  NewsHeaderView.m
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "NewsHeaderView.h"

@implementation NewsHeaderView
+(instancetype)headerViewWithFrame:(CGRect)frame{
	NewsHeaderView *view = [DDFactory getXibObjc:@"NewsHeaderView"];
	view.frame  = frame;
	return view;
}
@end
