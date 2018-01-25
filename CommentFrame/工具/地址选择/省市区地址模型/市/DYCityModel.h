//
//  DYCityModel.h
//  地址选择
//
//  Created by warron on 2016/10/25.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "DYAddressModel.h"
#import "DYCountyModel.h"
@interface DYCityModel : DYAddressModel

-(instancetype)initWithDict:(NSDictionary *)dict;
  
@property(nonatomic,strong)DYCountyModel *countyModel;

@property (nonatomic,strong)NSMutableArray *arrCountry;
@end
