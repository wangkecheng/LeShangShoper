//
//  InteractionCell.h
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractionModel.h"
@interface InteractionCell : UITableViewCell

@property(nonatomic,strong)InteractionModel *model;

@property(nonatomic,copy)void(^pardiseBlock)(InteractionModel *model);

@property(nonatomic,copy)void(^commentBlock)(InteractionModel *model);

@property(nonatomic,copy)void(^seeBigImgBlock)(InteractionModel * model,NSInteger index);

+(CGFloat)cellHByModel:(InteractionModel *)model;
@end

