//
//  ManufacturersCell.h
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManufacturersModel.h"
@interface ManufacturersCell : UITableViewCell
@property(nonatomic,strong)ManufacturersModel *model;
-(void)setLineViewAlpah:(BOOL)isShow;//设置是否显示分割线

@property(nonatomic,strong)SeriesModel *seriesModel;
@end
