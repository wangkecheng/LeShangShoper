//
//  LeftTopHeadView.h
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTopHeadView : UIView
+(instancetype)headerViewWithFrame:(CGRect)frame ;
-(void)setUserInfo;
@property(nonatomic,copy)void(^leftTopHeaderViewBlock)(void);
@end
