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
@property (nonatomic,strong)NSString *collect;////1,未收藏，2，已收藏
@property (nonatomic,strong)NSArray  *imageUrls;
@property (nonatomic,strong)NSString *typeName;
@property (nonatomic,strong)NSString *broseNumber;
@end

//bargain = 1;
//brand = "? string:\U54c1\U724c ?";
//cid = 5a601c6af03d2a3095346d7e;
//collect = 1;
//hot = 2;
//imageUrls =         (
//					 "/commodity/cover/0?hash=a16eec60b1f2f8d02a01d052cb5fbe8e",
//					 "/commodity/cover/1?hash=a16eec60b1f2f8d02a01d052cb5fbe8e"
//					 );
//merchantName = "\U6d4b\U8bd5\U5382\U5bb6";
//mid = 5a5e010170a60a09fec3fcb4;
//name = "\U9996\U9875\U6d4b\U8bd53";
//price = 230;
//series = "? string:\U7cfb\U5217 ?";
//spec = "200*200";

