//
//  InteligentServiceAlertView.h
//  CommentFrame
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteligentServiceAlertView : UIView
+(InteligentServiceAlertView * )instanceByFrame:(CGRect) frame WXClickBlock:(BOOL(^)(void))WXClickBlock PhClickBlock:(BOOL(^)(void))PhClickBlock;
@end
