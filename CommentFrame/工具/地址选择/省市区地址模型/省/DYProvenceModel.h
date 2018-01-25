//
//  DYProvenceModel.h
//  地址选择
//
//  Created by warron on 2016/10/25.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "DYAddressModel.h"
#import "DYCityModel.h"
@interface DYProvenceModel : DYAddressModel

-(instancetype)initWithDict:(NSDictionary *)dict;

@property(nonatomic,strong)DYCityModel *cityModel;

@property (nonatomic,strong)NSMutableArray *arrCtiys;

@end
