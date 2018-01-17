//
//  CollectionModel.h
//  CommentFrame
//
//  Created by warron on 2018/1/9.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject

@property (nonatomic,strong)NSString *name;//商品名
@property (nonatomic,strong)NSString *cid;//商品id
@property (nonatomic,strong)NSString *logoUrl;//logo地址
@property (nonatomic,strong)NSString *brand;//品牌
@property (nonatomic,strong)NSString *spec;//规格
@property (nonatomic,strong)NSString *price;//价格
@property (nonatomic,strong)NSString *hot;//1，非热门，2热门
@property (nonatomic,strong)NSString *merchantName;//商家名
@property (nonatomic,strong)NSString *bargain;//1,非特价，2，特价
@property (nonatomic,strong)NSString *mid;//商家id
 
@end
