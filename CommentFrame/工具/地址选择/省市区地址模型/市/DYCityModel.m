//
//  DYCityModel.m
//  地址选择
//
//  Created by warron on 2016/10/25.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "DYCityModel.h"

@implementation DYCityModel


-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _arrCountry = [[NSMutableArray alloc]init];
        self.name = dict[@"name"];
        for (NSString *disName in dict[@"sub"]) {
            _countyModel = [[DYCountyModel alloc]initWithCountyName:disName];
            [_arrCountry addObject:_countyModel];
        }
    }
    return self;
}

@end
