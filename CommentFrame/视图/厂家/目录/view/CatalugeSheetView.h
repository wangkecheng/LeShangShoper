//
//  CatalugeSheetView.h
//  CommentFrame
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManufacturersModel.h"
@interface CatalugeSheetView : UIView
+(CatalugeSheetView *)instanceByFrame:(CGRect)frame clickBlock:(void(^)(BrandsModel *model))clickBlock;
-(void)showWithSeriesModel:(SeriesModel *)model;
@end
