//
//  AddInteractionVC.h
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddInteractionVC : UIViewController
-(instancetype)initWithBlock:(void(^)(void))publishedBlock;
@end
