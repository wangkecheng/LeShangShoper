//
//  DYDistractModel.m
//  地址选择
//
//  Created by warron on 2016/10/25.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "DYCountyModel.h"

@implementation DYCountyModel

-(instancetype)initWithCountyName:(NSString *)countyName{
    if (self = [super init]) {
        self.name = countyName;
    }
    return self;
}
@end
