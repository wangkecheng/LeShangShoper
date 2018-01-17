//
//  RegisterVC.h
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "HDBaseVC.h"

@interface RegisterVC : HDBaseVC

-(instancetype)initWithPhone:(NSString *)phoneNum finishBlock:(void(^)(NSString *phoneNum))finishBlock;
@end
