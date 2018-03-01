//
//  SellerCell.h
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManufacturersModel.h"
@interface SellerCell : UITableViewCell
@property(nonatomic,strong)NSArray *sellerArr;
@property(nonatomic,copy)void(^clickBlock)(NSInteger index,ManufacturersModel *model);


@end


