//
//  ManufacturersModel.h
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandsModel : NSObject
-(instancetype)initWithDict:(NSDictionary *)dict;
@property(nonatomic,strong)NSString *name;//商品名
@property(nonatomic,strong)NSString *url;//商品图片

@end

@interface SeriesModel : NSObject
-(instancetype)initWithDict:(NSDictionary *)dict;
@property(nonatomic,strong)NSString *name;// 系列名
@property(nonatomic,strong)NSMutableArray<BrandsModel *> *brandsArr;//系列品牌列表
@end

@interface ManufacturersModel : NSObject

-(instancetype)initWithDict:(NSDictionary *)dict;
@property(nonatomic,strong)NSString *name;//商家名
@property(nonatomic,strong)NSString *mid;//商家id
@property(nonatomic,strong)NSString *addr;//详细地址

@property(nonatomic,strong)NSMutableArray<SeriesModel *> *seriesArr;//商家系列品牌列表
@property(nonatomic,strong)NSString *logoUrl;//商家logo
@property(nonatomic,strong)NSString *coverUrl;//

@end


