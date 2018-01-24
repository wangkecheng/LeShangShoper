//
//  LosePromiseDetailVC.h
//  CommentFrame
//
//  Created by warron on 2018/1/14.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "HDBaseVC.h"
#import "LosePromissAndNewsModel.h"
@interface LosePromiseDetailVC : HDBaseVC
-(instancetype)initWithTitle:(NSString *)title;
@property (strong, nonatomic)LosePromissAndNewsModel * model;
@end
