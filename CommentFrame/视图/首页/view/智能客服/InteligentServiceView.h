//
//  InteligentService.h
//  CommentFrame
//
//  Created by warron on 2018/1/14.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteligentServiceView : UIView

+(InteligentServiceView * )instanceByFrame:(CGRect) frame clickBlock:(void(^)(void))clickBlock;
@end
