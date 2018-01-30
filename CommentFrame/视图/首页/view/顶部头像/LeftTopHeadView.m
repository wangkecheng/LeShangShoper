
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
    headerImgW = 10;
    view.headerImg.layer.cornerRadius = headerImgW/2.0 ;
	view.rankLbl.layer.borderColor = UIColorFromRGB(251, 142, 0).CGColor; 
	view.backgroundColor = [UIColor clearColor];
	
	view.nameLbl.font = [UIFont systemFontOfSize:14];
	view.rankLbl.font = [UIFont systemFontOfSize:13];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:view action:@selector(headerViewClick)];
	[view addGestureRecognizer:tap];
	[[DDFactory factory] addObserver:view selector:@selector(setUserInfo) channel:@"ReInitUserInfo"];//发送通知，重新更改用户信息
	return view;
}

-(void)setUserInfo{
	[[DDFactory factory] removeChannel:@"ReInitUserInfo"];//移除通知源
	UserInfoModel * model  = [CacheTool getUserModel];
	_rankLbl.alpha = 1;
	if (model.isMember == 1) {//如果存在
        NSString * nameStr = [DDFactory getString:model.name  withDefault:@"未知"];
        if (nameStr.length>4) {
            nameStr = [nameStr substringToIndex:3];
            nameStr = [nameStr stringByAppendingString:@"..."];
        }
		_nameLbl.text = nameStr;
		_rankLbl.text = [NSString stringWithFormat:@"LV.%@",[DDFactory getString:model.lv  withDefault:@"0"]];
        UIImage *image = [UIImage imageWithData:model.headImgData];
		if (image) { 
			[_headerImg setImage:image];
		}else{
			[_headerImg sd_setImageWithURL:IMGURL(model.headUrl) placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
		}
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
