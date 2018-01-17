//
//  AlbumListVC.h
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "HDBaseVC.h"
#import "ImgModel.h"
@interface AlbumListVC : HDBaseVC

- (id)initWithArrSelected:(NSMutableArray *)arrSelected
				  maxCout:(NSInteger)maxCout
			  selectBlock:(void(^)(NSMutableArray<ImgModel *> * imgModelArr))selectBlock;
@end
