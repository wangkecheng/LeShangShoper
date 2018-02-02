

//
//  NotifyCenterTool.m
//  CommentFrame
//
//  Created by warron on 2017/12/1.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "NotifyCenterTool.h"
#import <Foundation/NSNotification.h>
@implementation NotifyCenterTool

+(instancetype)share{
    
    static NotifyCenterTool * baidu ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baidu = [[NotifyCenterTool alloc]init];
    });
    return baidu;
}
-(void)initNotifycation{
    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >10) {
//        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
//                    SRActionSheet *actionSheet =  [SRActionSheet sr_actionSheetViewWithTitle:@"开始PK需要您的同意推送权限才能使用" cancelTitle:nil destructiveTitle:nil otherTitles:@[@"去设置",@"取消"] otherImages:nil selectSheetBlock:^(SRActionSheet *actionSheet, NSInteger index) {
//                        if (index == 0) {
//                            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                                [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
//                            }
//                        }
//                    }];
//                    actionSheet.otherActionItemAlignment = SROtherActionItemAlignmentCenter;
//                    [actionSheet show];
//                }
//            });
//        }];
//    }
//    else if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0){
//
//
//        if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
//            [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
//                        SRActionSheet *actionSheet =  [SRActionSheet sr_actionSheetViewWithTitle:@"开始PK需要您的同意推送权限才能使用" cancelTitle:nil destructiveTitle:nil otherTitles:@[@"去设置",@"取消"] otherImages:nil selectSheetBlock:^(SRActionSheet *actionSheet, NSInteger index) {
//                            if (index == 0) {
//                                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                                if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                                    [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
//                                }
//                            }
//                        }];
//                        actionSheet.otherActionItemAlignment = SROtherActionItemAlignmentCenter;
//                        [actionSheet show];
//                    }
//                });
//            }];
//        }
//    }else{
//
//        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//        if (type == UIRemoteNotificationTypeNone) {
//            UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//            if (type == UIRemoteNotificationTypeNone) {
//                SRActionSheet *actionSheet =  [SRActionSheet sr_actionSheetViewWithTitle:@"开始PK需要您的同意推送权限才能使用" cancelTitle:nil destructiveTitle:nil otherTitles:@[@"去设置",@"取消"] otherImages:nil selectSheetBlock:^(SRActionSheet *actionSheet, NSInteger index) {
//                    if (index == 0) {
//                        NSURL *settingsURL = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
//                        if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
//                            [[UIApplication sharedApplication]openURL:settingsURL options:nil completionHandler:nil];
//                        }
//                    }
//                }];
//                actionSheet.otherActionItemAlignment = SROtherActionItemAlignmentCenter;
//                [actionSheet show];
//            }
//        }
//    }
    
}
@end

