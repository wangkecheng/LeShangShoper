
//
//  LeftTopHeadView.m
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "LeftTopHeadView.h"
@interface LeftTopHeadView()
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *rankLbl;
@property (weak, nonatomic) IBOutlet UILabel *loginTipLbl;

@end

@implementation LeftTopHeadView

+(instancetype)headerViewWithFrame:(CGRect)frame{
	LeftTopHeadView *view = [DDFactory getXibObjc:@"LeftTopHeadView"];

    [view setUserInfo];
    view.rankLbl.layer.cornerRadius = 3;
//  view.rankLbl.layer.borderWidth = 1;
    view.rankLbl.layer.masksToBounds = YES;
//  view.rankLbl.layer.borderColor = UIColorFromRGB(251, 142, 0).CGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:view action:@selector(headerViewClick)];
    [view addGestureRecognizer:tap];
    
    [[DDFactory factory] addObserver:view selector:@selector(setUserInfo) channel:@"ReInitUserInfo"];//发送通知，重新更改用户信息
     view.frame = frame;
	return view;
}

-(void)setUserInfo{
	[[DDFactory factory] removeChannel:@"ReInitUserInfo"];//移除通知源
	UserInfoModel * model  = [CacheTool getUserModel]; 
	if (model.isMember == 1) {//如果存在
          _nameLbl.alpha = _rankLbl.alpha = 1;
          _loginTipLbl.alpha = 0;
        NSString * nameStr = [DDFactory getString:model.name  withDefault:@"未知"];
        if (nameStr.length>4) {
            nameStr = [nameStr substringToIndex:3];
            nameStr = [nameStr stringByAppendingString:@"..."];
        }
		_nameLbl.text = nameStr;
		_rankLbl.text = [NSString stringWithFormat:@"LV.%@",[DDFactory getString:model.lv  withDefault:@"0"]];
        [_headerBtn sd_setImageWithURL:IMGURL(model.headUrl) forState:0  placeholderImage:IMG(@"icon_touxiang")  options:SDWebImageAllowInvalidSSLCertificates]; 
	}else{
		
        _nameLbl.alpha = _rankLbl.alpha = 0;
        _loginTipLbl.alpha = 1;
	}
}
- (IBAction)headerViewClick:(id)sender {
    [self headerViewClick];
}

-(void)headerViewClick{
    if (_leftTopHeaderViewBlock) {
        _leftTopHeaderViewBlock();
    }
}
@end
