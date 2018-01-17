//
//  ImgCell.h
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImgModel.h"
#import <Photos/Photos.h>
@interface ImgCell : UICollectionViewCell

@property(nonatomic,copy)BOOL(^selcetBlock)(ImgModel *);

@property(nonatomic,strong) ImgModel * model;
@end
