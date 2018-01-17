
//
//  ManufacturersModel.m
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "ManufacturersModel.h"

@implementation ManufacturersModel
// 当属性中为数组时，需要关联其他类，使得数组中存放该类的对象
// 字典中的key为当前类的属性，value为要关联的类的class
+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"seriesArr" : [SeriesModel class]};
}
@end

@implementation SeriesModel

@end

