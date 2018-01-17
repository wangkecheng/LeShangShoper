//
//  CatalugeListHeaderView.h
//  CommentFrame
//
//  Created by warron on 2018/1/10.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatalugeListHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backImg;

+(CatalugeListHeaderView *)instanceByFrame:(CGRect)frame;
@end
