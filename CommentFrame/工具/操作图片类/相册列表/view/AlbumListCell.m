
//
//  AlbumListCell.m
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "AlbumListCell.h"
@interface AlbumListCell()

@property (weak, nonatomic) IBOutlet UIImageView *imavHead;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;

@end
@implementation AlbumListCell

- (void)awakeFromNib {
    [super awakeFromNib];
	if([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0){
		self.layoutMargins = UIEdgeInsetsZero;
		self.preservesSuperviewLayoutMargins = NO;
	}
	self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
	self.clipsToBounds = YES;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setModel:(AlbumListModel *)model{
	_model = model;
	_lblInfo.text = [NSString stringWithFormat:@"%@(%ld)",_model.collection.localizedTitle,_model.collection.estimatedAssetCount];
	if (model.image) {
		_imavHead.image = model.image;//表示在数据源中已经请求到了图片数据
	}else{//否则 没有请求到的话，那就cell自己来请求
		__weak typeof (self) weakSelf = self;
		[[WSPHPhotoLibrary library]getImgByPHAsset:[model.assets firstObject] isOriginal:NO finishBlock:^(UIImage *image) {
			__strong typeof (weakSelf) strongSelf = weakSelf;
			strongSelf.imavHead.image = image;//这里先做一个操作 就是将图片先请求下来
			strongSelf.model.image = image;
		}];
	} 
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
