//
//  PersonalCenterVC.h
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "HDBaseVC.h"

@interface PersonalCenterVC : HDBaseVC

//初始化
-(instancetype)initWithBackgroundImage:(UIImage *)image;
@property(nonatomic,copy)void (^didLeftSildeAction)(void);
@end
