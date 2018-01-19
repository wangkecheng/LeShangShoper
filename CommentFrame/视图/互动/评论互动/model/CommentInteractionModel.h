//
//  CommentInteractionModel.h
//  CommentFrame
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInteractionModel : NSObject

@property (nonatomic,strong)NSString * name;//用户姓名
@property (nonatomic,strong)NSString * uid;//用户id
@property (nonatomic,strong)NSString * content;//内容
@property (nonatomic,strong)NSString * headUrl;//头像
@property (nonatomic,strong)NSString * createAt;//发布时间（毫秒时间戳）
@end
