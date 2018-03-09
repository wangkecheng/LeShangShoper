//
//  InteractionModel.h
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InteractionModel : NSObject
@property (nonatomic,strong)NSString *name;//用户姓名
@property (nonatomic,strong)NSString *headUrl;//头像
@property (nonatomic,strong)NSString *createAt;//发布时间（毫秒时间戳）
@property (nonatomic,strong)NSString *giveNumber;//点赞数
@property (nonatomic,strong)NSString *commentNumber;//评论数
@property (nonatomic,strong)NSArray *imageUrls;//图片地址数组
@property (nonatomic,strong)NSString *uid;//用户id
@property (nonatomic,strong)NSString *content;//内容
@property (nonatomic,strong)NSString *interactId;//互动Id
@property (nonatomic,strong)NSString *own;//我的动态
@property (nonatomic,strong)NSString *isUser;
@property (nonatomic,assign)BOOL isStatusSeeAll;//是否是查看全部的状态
@property (nonatomic,assign)BOOL needHideSeeAllBtn;//是否是需要隐藏

@property (nonatomic,assign)BOOL ceshi;

@property (nonatomic,assign)CGFloat cellH;
@property (nonatomic,assign)CGFloat contentH;
@end
