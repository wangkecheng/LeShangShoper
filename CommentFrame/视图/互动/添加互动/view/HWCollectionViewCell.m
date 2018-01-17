
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

-(void)setModel:(ImgModel *)model{
	 _model = model;
	[_profilePhoto setImage:model.image];
	 _closeButton.hidden = NO;
}
-(void)setAddImgModel:(ImgModel *)addImgModel{
	_addImgModel = addImgModel;
	_closeButton.hidden = YES;
	[_profilePhoto setImage:addImgModel.image];
}
- (IBAction)deletePhoto:(id)sender {
	if (_deleteBlock) {
		_deleteBlock(_model);
	}
}

@end
