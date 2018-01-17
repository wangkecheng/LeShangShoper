
//
//  LeftTopHeadView.m
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "LeftTopHeadView.h"
@interface LeftTopHeadView()
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *rankLbl;
@end

@implementation LeftTopHeadView
+(instancetype)headerViewWithFrame:(CGRect)frame{
	LeftTopHeadView *view = [DDFactory getXibObjc:@"LeftTopHeadView"];
	view.frame = frame;
	[view setUserInfo]; 
	view.rankLbl.layer.cornerRadius = 5;
	view.rankLbl.layer.borderWidth = 1;
	view.rankLbl.layer.masksToBounds = YES;
	CGFloat headerImgW =  (CGRectGetHeight(frame) - 6);
	view.headerImg.layer.cornerRadius = headerImgW/2.0 ;
	view.rankLbl.layer.borderColor = UIColorFromRGB(251, 142, 0).CGColor; 
	view.backgroundColor = [UIColor clearColor];
	
	view.nameLbl.font = [UIFont systemFontOfSize:14];
	view.rankLbl.font = [UIFont systemFontOfSize:13];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:view action:@selector(headerViewClick)];
	[view addGestureRecognizer:tap];
	return view;
}

-(void)setUserInfo{
	UserInfoModel * model  = [CacheTool getUserModel];
	_rankLbl.alpha = 1;
	if (model.isMember == 1) {//如果存在
		_nameLbl.text = model.name;
		_rankLbl.text = [NSString stringWithFormat:@"LV.%@",model.lv];
		[_headerImg  sd_setImageWithURL:IMGURL(model.headUrl) placeholderImage:IMG(@"image1.jpg")];
	}else{
		_rankLbl.alpha = 0;
	}
}

-(void)headerViewClick{
	if (_leftTopHeaderViewBlock) {
		_leftTopHeaderViewBlock();
	}
}
@end
