//
//  ProductDetailListVC.h
//  CommentFrame
//
//  Created by warron on 2018/1/10.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "HDBaseVC.h"
#import "ManufacturersModel.h"
@interface ProductDetailListVC : HDBaseVC
@property(nonatomic,strong)BrandsModel *brandsModel;
@property(nonatomic,strong)NSString *mid;
@property(nonatomic,strong)NSString *name;// 系列名
@end
