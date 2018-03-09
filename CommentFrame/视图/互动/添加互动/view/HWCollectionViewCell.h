
//
//  AlbumListVC.m
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImgModel.h"
typedef void(^HWCellDelegateBlock)(ImgModel * model);

@interface HWCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic)ImgModel * model;

@property (strong, nonatomic)ImgModel * addImgModel;

@property (nonatomic,copy)HWCellDelegateBlock deleteBlock;

@property (nonatomic,strong)NSString * imgUrlStr;
@end
