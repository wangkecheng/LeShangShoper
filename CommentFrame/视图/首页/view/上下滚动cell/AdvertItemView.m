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
@property (strong, nonatomic)CollectionModel  * model;
@property (copy, nonatomic)void(^clickBlock)(CollectionModel  * model);
@end

@implementation AdvertItemView

+(AdvertItemView *)instanceByFrame:(CGRect)frame model:(CollectionModel  *)model clickBlock:(void(^)(CollectionModel *model))clickBlock{
	AdvertItemView * view = [DDFactory getXibObjc:@"AdvertItemView"];
	view.frame = frame;
	view.model = model;
	view.titLbl.text = model.name;
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
