//
//  CommentInteractionVC.h
//  CommentFrame
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "HDBaseVC.h"
#import "InteractionModel.h"
@interface CommentInteractionVC : HDBaseVC
@property (nonatomic,strong)InteractionModel *interactionModel;
@property (nonatomic,strong)NSString *interactId;//互动Id
@property (nonatomic,copy)void(^finishComBlock)(InteractionModel *interactionModel);
@end
