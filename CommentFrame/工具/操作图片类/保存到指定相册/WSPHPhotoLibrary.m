//
//  PHPhotoLibrary+warron.m
//  SaveImg
//
//  Created by warron on 2017/12/20.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "WSPHPhotoLibrary.h"
@interface WSPHPhotoLibrary()// 保存图片到指定相册
@property(nonatomic,copy)void(^sucessBlock)(NSString * str,PHAsset * obj);
@property(nonatomic,copy)void(^faildBlock)(NSError * error);
@property(nonatomic,copy)void(^finishBlock)(UIImage *image);
@end
@implementation WSPHPhotoLibrary
+(WSPHPhotoLibrary *)library{
	WSPHPhotoLibrary *wSPHPhotoLibrary = [[WSPHPhotoLibrary alloc]init];
	return wSPHPhotoLibrary;
}
-(void)saveImage:(UIImage *)image assetCollectionName:(NSString *)collectionName
	 sucessBlock:(void (^)(NSString *str,PHAsset *obj))sucessBlock faildBlock:(void (^)(NSError * error))faildBlock{
	if (sucessBlock) {
		_sucessBlock = sucessBlock;
	}
	if (faildBlock) {
		_faildBlock = faildBlock;
	}
	// 1. 获取当前App的相册授权状态
	PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
	
	// 2. 判断授权状态
	if (authorizationStatus == PHAuthorizationStatusAuthorized) {
		
		// 2.1 如果已经授权, 保存图片(调用步骤2的方法)
		[self saveImage:image toCollectionWithName:collectionName sucessBlock:_sucessBlock faildBlock:_faildBlock];
		
	} else if (authorizationStatus == PHAuthorizationStatusNotDetermined) { // 如果没决定, 弹出指示框, 让用户选择
		
		[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
			
			
			// 如果用户选择授权, 则保存图片
			if (status == PHAuthorizationStatusAuthorized) {
				dispatch_async(dispatch_get_main_queue(), ^{
					[self saveImage:image toCollectionWithName:collectionName sucessBlock:nil faildBlock:nil];
				});
			}
		}];
		
	} else if(authorizationStatus == PHAuthorizationStatusDenied){//拒绝了权限
		if (_faildBlock) {
			NSError *error = [[NSError alloc] initWithDomain:@"warronDomain"
			code:1001 userInfo:@{NSLocalizedDescriptionKey:@"错误描述",
			NSLocalizedFailureReasonErrorKey:@"未开启访问相册权限",
			NSLocalizedRecoverySuggestionErrorKey:@"请在设置界面, 授权访问相册",
			NSLocalizedRecoveryOptionsErrorKey:@[@""]}];
			_faildBlock(error);
		}
	}
}

// 保存图片
-(void)saveImage:(UIImage *)image toCollectionWithName:(NSString *)collectionName
	 sucessBlock:(void (^)(NSString *str,PHAsset * obj))sucessBlock faildBlock:(void (^)(NSError * error))faildBlock{
	if (sucessBlock) {
		_sucessBlock = sucessBlock;
	}
	if (faildBlock) {
		_faildBlock = faildBlock;
	}
	// 1. 获取相片库对象
	PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
	
	 NSMutableArray *imageIds = [NSMutableArray array];
	// 2. 调用changeBlock
	[library performChanges:^{
		
		// 2.1 创建一个相册变动请求
		PHAssetCollectionChangeRequest *collectionRequest;
		
		// 2.2 取出指定名称的相册
		PHAssetCollection *assetCollection = [self getCurrentPhotoCollectionWithTitle:collectionName];
		
		// 2.3 判断相册是否存在
		if (assetCollection) { // 如果存在就使用当前的相册创建相册请求
			collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
		} else { // 如果不存在, 就创建一个新的相册请求
			collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionName];
		}
		
		// 2.4 根据传入的相片, 创建相片变动请求
		PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
		
		// 2.4 创建一个占位对象
		PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
		
		// 2.5 将占位对象添加到相册请求中
		[collectionRequest addAssets:@[placeholder]];
		//记录本地标识，等待完成后取到相册中的图片对象
		[imageIds addObject:assetRequest.placeholderForCreatedAsset.localIdentifier];
	} completionHandler:^(BOOL success, NSError * error) {
		
		// 3. 判断是否出错, 如果报错, 声明保存不成功
		if (success) {
			//成功后取相册中的图片对象
			__block PHAsset *imageAsset = nil;
			PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
			[result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				
				imageAsset = obj;
				*stop = YES;
			}];
			if (imageAsset) {//加载图片数据
				[[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
				 options:nil resultHandler:^(NSData * imageData, NSString * dataUTI, UIImageOrientation orientation, NSDictionary * info) {
					 
				 }];
			}
			if (_sucessBlock) {
				_sucessBlock(@"保存成功",imageAsset);
			}
		} else {
			if (_faildBlock) {
				_faildBlock(error);
			}
		}
	}];
}
- (PHAssetCollection *)getCurrentPhotoCollectionWithTitle:(NSString *)collectionName {
	
	//遍历搜索集合并取出对应的相册
	for (PHAssetCollection *assetCollection in [WSPHPhotoLibrary getAlbumGroup]) {
		
		if ([assetCollection.localizedTitle containsString:collectionName]) {
			return assetCollection;
		}
	}
	
	return nil;
}

//获取所有相册
+(PHFetchResult<PHAssetCollection *> *)getAlbumGroup{
	return [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
}

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
+(PHFetchResult<PHAsset *> *)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection{
	PHFetchOptions *options = [[PHFetchOptions alloc] init];
	options.includeHiddenAssets = YES;
	options.includeAllBurstAssets = YES;
	 	// 获得某个相簿中的所有PHAsset对象
	return  [PHAsset fetchAssetsInAssetCollection:assetCollection options:options]; 
}
-(void)getImgByPHAsset:(PHAsset *)asset isOriginal:(BOOL)isOriginal finishBlock:(void(^)(UIImage *image))finishBlock{
	
	_finishBlock = finishBlock;
	// 是否要原图
	CGSize size = isOriginal ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeMake(400, 400);
	PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
	options.synchronous = NO;// 同步获得图片, 若为YES只会返回1张图片
	options.resizeMode = PHImageRequestOptionsResizeModeExact;
	options.normalizedCropRect = CGRectMake(0, 0, size.width, size.height);
	options.networkAccessAllowed = YES;
	options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
	options.version = PHImageRequestOptionsVersionOriginal;
	PHImageContentMode model = PHImageContentModeDefault;
	if (!isOriginal) {
		model = PHImageContentModeDefault;
	}
	// 从asset中获得图片
	[[PHImageManager defaultManager] requestImageForAsset:asset
											   targetSize:size
											  contentMode:model
												  options:options
											resultHandler:^(UIImage * result, NSDictionary * _Nullable info) {
												dispatch_async(dispatch_get_main_queue(), ^{
													if (self.finishBlock)
														self.finishBlock(result);
													});
				 }];
}

@end
