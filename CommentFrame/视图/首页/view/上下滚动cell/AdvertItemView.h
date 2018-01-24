//
//  AdvertItemView.h
//  CommentFrame
//
//  Created by warron on 2018/1/13.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"
@interface AdvertItemView : UIView
+(AdvertItemView *)instanceByFrame:(CGRect)frame model:(CollectionModel  *)model clickBlock:(void(^)(CollectionModel *model))clickBlock;
@end
