//
//  AdvertItemView.m
//  CommentFrame
//
//  Created by warron on 2018/1/13.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "AdvertItemView.h"
@interface AdvertItemView()
@property (weak, nonatomic) IBOutlet UILabel *titLbl;
@property (strong, nonatomic)AdvertModel  * model;
@property (copy, nonatomic)void(^clickBlock)(AdvertModel  * model);
@end

@implementation AdvertItemView

+(AdvertItemView *)instanceByFrame:(CGRect)frame model:(AdvertModel  *)model clickBlock:(void(^)(AdvertModel *model))clickBlock{
	AdvertItemView * view = [DDFactory getXibObjc:@"AdvertItemView"];
	view.frame = frame;
	view.model = model;
	view.titLbl.text = model.title;
	view.clickBlock = clickBlock;
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:view action:@selector(clickAction)];
	[view addGestureRecognizer:tap];
	return view;
}
-(void)clickAction{
	if (_clickBlock) {
		_clickBlock(_model);
	}
}

@end
