//
//  CacheTool.m
//  HelloDingDang
//
//  Created by warron on 2016/11/12.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import "CacheTool.h"
#import "LoginVC.h"
#import "WSLeftSlideManagerVC.h"
#import "HDMainTBC.h"
#import "PersonalCenterVC.h"
typedef void (^finishBlock)(BOOL isFinish);

@implementation CacheTool


//查找数据库中是否有用户
+(UserInfoModel *)getUserModelByID:(NSString *)ID{
  
    NSArray *arr = [UserInfoModel gy_queryObjsWithCondition:[GYWhereCondition condition].Where(@"keyId").Eq(ID) error:nil];
    if (arr.count!=0) {//有就返回
        return  arr[0];
    }
    else{//没有就创建一个
      UserInfoModel * model =  [[UserInfoModel alloc]init];
       return  model;
    }
}

//新方法 这个方法主要用用于登录后快速使用 获取已经登录的用户
+(UserInfoModel *)getUserModel{
    if ([UserInfoModel gy_tableExistsWithError:nil]){
       
        for (UserInfoModel *model in [UserInfoModel gy_queryObjsWithCondition:nil error:nil]) {
             if (model.isMember == 1) {//如果是登录
                 return model;
             }
        }
    }
    //gy_customPrimaryKeyValue 中自定义了主键值
   return [[UserInfoModel alloc]init]; //能够走到这里，说明没有已经登录的用户
}

+(NSArray *)getAllUser{//所有用户
   return  [UserInfoModel gy_queryObjsWithCondition:nil error:nil];
}

+(void)setAllUserNotRecentLoginUser{//设置所有用户都不是最近登录的,统一设置
    for (UserInfoModel *model in [self getAllUser]) {
        model.isRecentLogin = 0;
        [model gy_save];
    }
}

+(UserInfoModel *)getRecentLoginUser{//最近登录用户
    for (UserInfoModel *model in [self getAllUser]) {
        if (model.isRecentLogin == 1) {
            return model;
        }
    }
    return nil;
}

+(void)writeToDB:(UserInfoModel *)model{
    
    if ([UserInfoModel gy_tableExistsWithError:nil]){
         [UserInfoModel gy_updateTable];
         [model gy_save];
    }
    else{
        [UserInfoModel gy_createTable];
        [model gy_save];
    }
}

//设置根视图
+ (UIViewController *)setRootVCByIsMainVC:(BOOL)isMainVC {
    [CurrentAppDelegate.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	HDBaseVC * VC =(HDBaseVC *)[[HDMainNavC alloc]initWithRootViewController:[[LoginVC alloc]init]];// [[LoginVC alloc]init];//
	if (isMainVC) { 
        WSLeftSlideManagerVC *managerVC =   [[WSLeftSlideManagerVC alloc] initWithMainVC:[[HDMainTBC alloc]init] leftVC:[[PersonalCenterVC alloc]initWithBackgroundImage:IMG(@"bg_personal_center")]];
        managerVC.scaleContent = YES;
        VC = (HDBaseVC *)managerVC;
	}
    [CurrentAppDelegate.window setRootViewController:VC];
	return VC;
}
+(void)showLoginVC:(HDBaseVC *)theVC{
    
    [UserInfoModel gy_queryObjsWithCondition:nil completion:^(NSArray *result, GYDBError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UserInfoModel *model in result) {
                if (model.isMember == 1) {//如果是是登录
                    model.isMember = 0;
                    model.isRecentLogin = 1;
                }
                else{
                    model.isRecentLogin = 0;
                    model.isMember = 0;
                }
                [model gy_save];
            }
        });
    }];
    
	LoginVC *VC = [[LoginVC alloc]initWithFinishBlock:theVC.finishLoginBlock];//登录完成后 如果是从该页面弹出，那么block会回到 登录页面 的父视图
	[theVC.navigationController pushViewController:VC animated:YES];
}

@end
