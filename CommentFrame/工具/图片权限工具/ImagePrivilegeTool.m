
//
//  ImagePrivilegeTooll.m
//  CommentFrame
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "ImagePrivilegeTool.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CLLocationManager.h>
@implementation ImagePrivilegeTool

+(instancetype)share{
    
    static ImagePrivilegeTool * baidu ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baidu = [[ImagePrivilegeTool alloc]init];
    });
    return baidu;
}

-(BOOL)judgeLibraryPrivilege{
//
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusDenied){
        //无权限 引导去开启
        SRActionSheet *actionSheet =  [SRActionSheet sr_actionSheetViewWithTitle:@"发布互动选择图片需要您的同意才能访问系统相册" cancelTitle:nil destructiveTitle:nil otherTitles:@[@"去设置",@"取消"] otherImages:nil selectSheetBlock:^(SRActionSheet *actionSheet, NSInteger index){
            if (index == 0) {//https://www.jianshu.com/p/6de8b464d7f2
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }
        }];
        actionSheet.otherActionItemAlignment = SROtherActionItemAlignmentCenter;
        [actionSheet show]; 
        return NO ;
    }
    return YES;
}

-(BOOL)judgeCapturePrivilege{
    //判断相机是否能够使用
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusDenied){
        //无权限 引导去开启
        SRActionSheet *actionSheet =  [SRActionSheet sr_actionSheetViewWithTitle:@"发布互动选择图片需要您的同意才能使用相机" cancelTitle:nil destructiveTitle:nil otherTitles:@[@"去设置",@"取消"] otherImages:nil selectSheetBlock:^(SRActionSheet *actionSheet, NSInteger index){
            if (index == 0) {//https://www.jianshu.com/p/6de8b464d7f2
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }
        }];
        actionSheet.otherActionItemAlignment = SROtherActionItemAlignmentCenter;
        [actionSheet show];
        return NO ;
    }
    return  YES;
}
// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 前面的摄像头是否可用
- (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
@end
