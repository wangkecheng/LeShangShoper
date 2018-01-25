//
//  CommentInteractionCell.h
//  CommentFrame
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentInteractionModel.h"
@interface CommentInteractionCell : UITableViewCell
@property(nonatomic,strong)CommentInteractionModel * model;
+(CGFloat)cellHByModel:(CommentInteractionModel *)model;
@end
