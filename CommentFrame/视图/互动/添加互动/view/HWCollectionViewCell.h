
//
//  AlbumListVC.m
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImgModel.h"
typedef void(^HWCellDelegateBlock)(UIImage * model);

@interface HWCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic)UIImage * model;

@property (strong, nonatomic)UIImage * addImgModel;

@property (nonatomic,copy)HWCellDelegateBlock deleteBlock;

@property (nonatomic,strong)NSString * imgUrlStr;
@end
