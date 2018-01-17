//
//  LoginVC.h
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "HDBaseVC.h"

@interface LoginVC : HDBaseVC
-(instancetype)initWithFinishBlock:(void(^)(void))finishLoginBlock;
@end
