//
//  UserProtocolVC.h
//  CommentFrame
//
//  Created by warron on 2018/1/27.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "HDBaseVC.h"

typedef enum{
	ProtocolTypeUse,
	ProtocolTypePrivacy
}ProtocolType;
@interface UserProtocolVC : HDBaseVC

-(instancetype)initWithType:(ProtocolType)type;
@end
