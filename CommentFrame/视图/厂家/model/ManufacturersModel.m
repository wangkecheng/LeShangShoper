//  ManufacturersModel.m
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "ManufacturersModel.h"

@implementation ManufacturersModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _seriesArr = [NSMutableArray array];
        [self yy_modelSetWithJSON:dict];
        for (NSDictionary * dictT in dict[@"series"]) {
            SeriesModel * seriesModel = [[SeriesModel alloc]initWithDict:dictT];
            [_seriesArr addObject:seriesModel];
        }
    }
    return self;
}
@end

@implementation SeriesModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _brandsArr = [NSMutableArray array];
        [self yy_modelSetWithJSON:dict];
        for (NSDictionary * dictT in dict[@"brands"]) {
            BrandsModel * seriesModel = [[BrandsModel alloc]initWithDict:dictT];
            [_brandsArr addObject:seriesModel];
        }
    }
    return self;
}
@end

@implementation BrandsModel
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self yy_modelSetWithJSON:dict];
    }
    return self;
}
@end

