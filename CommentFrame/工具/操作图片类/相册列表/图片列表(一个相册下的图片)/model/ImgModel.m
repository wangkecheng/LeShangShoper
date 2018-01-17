//
//  ImgModel.m
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "ImgModel.h"

@implementation ImgModel
+(ImgModel *)modelByAsset:(PHAsset *)asset{
	ImgModel * model  = [[ImgModel alloc]init];
	model.asset = asset;
	return model;
}
-(void)setAsset:(PHAsset *)asset{
	_asset = asset;
	__weak typeof (self) weakSelf = self;
	
	[[WSPHPhotoLibrary library]getImgByPHAsset:asset isOriginal:NO finishBlock:^(UIImage *image) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		strongSelf.image = image;//这里先做一个操作 就是将图片先请求下来
		
	}];
	[[WSPHPhotoLibrary library]getImgByPHAsset:asset isOriginal:YES finishBlock:^(UIImage *image) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		strongSelf.bigImage = image;//这里先做一个操作 就是将图片先请求下来
	}];
	
}

@end
