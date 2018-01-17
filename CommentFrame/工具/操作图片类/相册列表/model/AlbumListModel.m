
//
//  AlbumListModel.m
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "AlbumListModel.h"

@implementation AlbumListModel

+(AlbumListModel *)modelByAssetCollection:(PHAssetCollection *)collection{
	AlbumListModel * model  = [[AlbumListModel alloc]init];
	model.collection = collection;
	return model;
}
-(void)setCollection:(PHAssetCollection *)collection{
	_collection = collection;
	_assets = [WSPHPhotoLibrary enumerateAssetsInAssetCollection:collection];
	__weak typeof (self) weakSelf = self;
	[[WSPHPhotoLibrary library]getImgByPHAsset:[_assets firstObject] isOriginal:NO finishBlock:^(UIImage *image) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		strongSelf.image = image;//这里先做一个操作 就是将图片先请求下来
	}];
}
@end
