//
//  UserInfoModel.h
//  HelloDingDang
//
//  Created by 唐万龙 on 2016/11/8.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic,assign)NSInteger isMember;
@property (nonatomic,assign)NSInteger isRecentLogin;//是否是最近登录用户 
@property (nonatomic, copy) NSString *lv;//等级
@property (nonatomic, copy) NSString *addr;//地址
@property (nonatomic, copy) NSString *sex;//性别 1,男 2,女
@property (nonatomic, copy) NSString *mobile;//电话
@property (nonatomic, copy) NSString *name;//姓名
@property (nonatomic, copy) NSString *integral;//积分
@property (nonatomic, copy) NSString *headUrl;//头像地址
@property (nonatomic, strong) NSData *headImgData;//头像
@end

