//
//  HotelAlertView.h
//  CommentFrame
//
//  Created by warron on 2018/1/16.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSAlertView : UIView
+(WSAlertView *)instanceWithTitle:(NSString *)title content:(NSString *)content attachInfo:(id)attachInfo leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle leftBtnBlock:(void(^)(id attachInfo))leftBtnBlock rightBtnBlock:(void(^)(id attachInfo))rightBtnBlock;
-(void)show;//显示
-(void)dissmiss;//移除
@end
