
//
//  SearchManufacturersHeaderView.m
//  CommentFrame
//
//  Created by warron on 2018/1/14.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "SearchManufacturersHeaderView.h"
@interface SearchManufacturersHeaderView()

@end

@implementation SearchManufacturersHeaderView
+(SearchManufacturersHeaderView * )instanceByFrame:(CGRect)frame{
	SearchManufacturersHeaderView * view = [DDFactory getXibObjc:@"SearchManufacturersHeaderView"];
	view.frame = frame;
	return view;
}
@end
