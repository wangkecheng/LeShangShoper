//
//  AlbumListModel.h
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "WSPHPhotoLibrary.h"
@interface AlbumListModel : NSObject

+(AlbumListModel *)modelByAssetCollection:(PHAssetCollection *)collection;

@property(nonatomic,strong) PHAssetCollection *collection;

@property(nonatomic,strong)PHFetchResult<PHAsset *> *assets;
@property(nonatomic,strong) UIImage *image;
@end
