//
//  AlbumImgListVC.h
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "HDBaseVC.h"
#import "ImgModel.h"
@interface AlbumImgListVC : HDBaseVC

- (id)initWithCollection:(PHAssetCollection *)collection
			 selectedArr:(NSMutableArray *)arrSelected
				maxCount:(NSInteger)maxCount
			 selectBlock:(void(^)(NSMutableArray<ImgModel *> *imgModel))selectBlock;
@end
