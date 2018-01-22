//
//  HDApplyModel.h
//  DieKnight
//
//  Created by warron on 2017/2/22.
//  Copyright © 2017年 WangZhen. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求一般的数据 都用这个类来初始化请求数据
@interface HDModel : NSObject
+(HDModel *)model;
@property (nonatomic,strong)NSString *pageNumber;
@property (nonatomic,strong)NSString *pageSize;
@property (nonatomic,strong)NSString *name ;//姓名
@property (nonatomic,strong)NSString *verCode;//验证码

@property (nonatomic,strong)NSString *mobile;//手机号
@property (nonatomic,strong)NSString *addr;//地址
@property (nonatomic,strong)NSString *number;//查询数量，默认6

@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *desc;
@property (nonatomic,strong)NSString *contact;

@property (nonatomic,strong)NSString *interactId;

@property (nonatomic,strong)NSString *keyword;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *mid;
@property (nonatomic,strong)NSString *cid;
@end
