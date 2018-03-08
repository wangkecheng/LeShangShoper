//
//  ImagePrivilegeTooll.h
//  CommentFrame
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<AssetsLibrary/AssetsLibrary.h>
@interface ImagePrivilegeTool : NSObject
+(instancetype)share;
-(BOOL)judgeLibraryPrivilege;
-(BOOL)judgeCapturePrivilege;
@end
