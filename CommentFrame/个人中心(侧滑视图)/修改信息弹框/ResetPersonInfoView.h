//
//  ResetPersonInfoView.h
//  CommentFrame
//
//  Created by warron on 2018/1/13.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum ResetPersonInfoType{
	TypeUserName,
	TypeAddress
}ResetPersonInfoType;
@interface ResetPersonInfoView : UIView

+(ResetPersonInfoView *)instanceByFrame:(CGRect)frame type:(ResetPersonInfoType)type cancelBlock:(BOOL(^)(void))cancelBlock okBlock:(BOOL(^)(NSString *str ))okBlock;
@end
