
//
//  InteligentService.m
//  CommentFrame
//
//  Created by warron on 2018/1/14.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "InteligentServiceView.h"
@interface InteligentServiceView()

@property (copy, nonatomic) void(^clickBlock)(void);
@end

@implementation InteligentServiceView

+(InteligentServiceView * )instanceByFrame:(CGRect) frame clickBlock:(void(^)(void))clickBlock{
	InteligentServiceView *view = [DDFactory getXibObjc:@"InteligentServiceView"];
	view.frame = frame;
	view.clickBlock = clickBlock;
	return view;
}

- (IBAction)serviceAction:(id)sender {
	if (_clickBlock) {
		_clickBlock();
	}
}
@end
