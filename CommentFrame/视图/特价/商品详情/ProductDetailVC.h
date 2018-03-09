//
//  ProductDetailVC.h
//  CommentFrame
//
//  Created by warron on 2018/1/16.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "HDBaseVC.h"
#import "CollectionModel.h"
@interface ProductDetailVC : HDBaseVC
@property (strong, nonatomic)CollectionModel * model;
@property (copy, nonatomic)void(^collectActionBlock)(CollectionModel * model,BOOL isCollect);//如果是从收藏夹进入商品详情
//并取消了收藏 就要刷新收藏夹的数据， 同样 若用户先点了 已收藏(取消收藏)，收藏夹被刷新了，再点击 加入搜藏夹，收藏夹也要刷新
@property (nonatomic,assign)BOOL isNeedResetMargin;//设置顶部距离
@end
