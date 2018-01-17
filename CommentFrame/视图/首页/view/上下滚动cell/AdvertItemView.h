//
//  AdvertItemView.h
//  CommentFrame
//
//  Created by warron on 2018/1/13.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertModel.h"
@interface AdvertItemView : UIView
+(AdvertItemView *)instanceByFrame:(CGRect)frame model:(AdvertModel  *)model clickBlock:(void(^)(AdvertModel *model))clickBlock;
@end
