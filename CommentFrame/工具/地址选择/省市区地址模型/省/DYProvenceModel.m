//
//  DYProvenceModel.m
//  地址选择
//
//  Created by warron on 2016/10/25.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "DYProvenceModel.h"

@implementation DYProvenceModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.name = dict[@"name"];
        _arrCtiys =  [[NSMutableArray alloc]init];
        for (NSDictionary *cityDict in dict[@"sub"]) {
            if ([cityDict[@"name"] containsString:@"北京"]
                ||[cityDict[@"name"] containsString:@"天津市"]
                ||[cityDict[@"name"] containsString:@"上海市"]
                ||[cityDict[@"name"] containsString:@"重庆市"]
                ||[cityDict[@"name"] containsString:@"台湾"]) {//这里的 _arrCtiys是三级城市
                for (NSString *disName in cityDict[@"sub"]) {
                    DYCountyModel *model = [[DYCountyModel alloc]initWithCountyName:disName];
                    [_arrCtiys addObject:model];
                }
            }else{
                _cityModel = [[DYCityModel alloc]initWithDict:cityDict];
                [_arrCtiys addObject:_cityModel];
            }
           
        }
    }
    return self;
}

@end
