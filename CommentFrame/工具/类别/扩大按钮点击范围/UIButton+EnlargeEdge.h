//
//  UIButton+ EnlargeEdge.h
//  lubanlianmeng
//
//  Created by warron on 2016/11/4.
//  Copyright © 2016年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIButton(EnlargeEdge)
- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end
