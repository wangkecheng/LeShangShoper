
//  AlbumListVC.m
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "HWCollectionViewCell.h"

@interface HWCollectionViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@end

@implementation HWCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(UIImage *)model{
	 _model = model;
	[_profilePhoto setImage:model];
	 _closeButton.hidden = NO;
}

-(void)setAddImgModel:(UIImage *)addImgModel{
	_addImgModel = addImgModel;
	_closeButton.hidden = YES;
	[_profilePhoto setImage:addImgModel];
}

- (IBAction)deletePhoto:(id)sender {
	if (_deleteBlock) {
		_deleteBlock(_model);
	}
}
-(void)setImgUrlStr:(NSString *)imgUrlStr{
    _closeButton.hidden = YES;
    _imgUrlStr = imgUrlStr;
    [_profilePhoto sd_setImageWithURL:IMGURL(imgUrlStr) placeholderImage:IMG(@"Icon") options:SDWebImageAllowInvalidSSLCertificates];
}
@end
