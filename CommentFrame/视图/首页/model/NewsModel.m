

//
//  NewsModel.m
//  CommentFrame
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+(NewsModel *)modelByDict:(NSDictionary *)dict{
    NewsModel * newsModel = [[NewsModel alloc]init];
    NSArray * tempArr = [NSArray yy_modelArrayWithClass:[LosePromissAndNewsModel class] json:dict[@"list"]];
    newsModel.date = dict[@"date"];
    newsModel.arrModel = [NSMutableArray arrayWithArray:tempArr];
    return newsModel;
}
@end
