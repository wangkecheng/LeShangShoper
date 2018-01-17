//
//  PHPhotoLibrary+warron.h
//  SaveImg
//
//  Created by warron on 2017/12/20.
//  Copyright © 2017年 warron. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import <Photos/Photos.h>
@interface WSPHPhotoLibrary:NSObject// 保存图片到指定相册
+(WSPHPhotoLibrary *)library;
//获取所有相册
+(PHFetchResult<PHAssetCollection *> *)getAlbumGroup;

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 */
+(PHFetchResult<PHAsset *> *)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection;

/**
 *  获取 PHAsset 对应的 image
 *  @param asset PHAsset
 *  @param original    是否要原图
 */
-(void)getImgByPHAsset:(PHAsset *)asset isOriginal:(BOOL)isOriginal finishBlock:(void(^)(UIImage *image))finishBlock;
/**
 *  保存图片到相簿
 *  @param assetCollectionName 相簿名
 *  @param sucessBlock         成功回调
 *  @param sucessBlock         失败回调
 */
-(void)saveImage:(UIImage *)image assetCollectionName:(NSString *)collectionName
	 sucessBlock:(void (^)(NSString *str,PHAsset * obj))sucessBlock faildBlock:(void (^)(NSError * error))faildBlock;
@end
