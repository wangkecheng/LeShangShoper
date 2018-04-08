//
//  MyInteractionCell.h
//  CommentFrame
//
//  Created by 王帅 on 08/04/2018.
//  Copyright © 2018 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractionModel.h"
@interface MyInteractionCell : UITableViewCell

@property(nonatomic,strong)InteractionModel *model;
@property(nonatomic,strong)InteractionModel *myInteractionModel;
@property(nonatomic,copy)void(^pardiseBlock)(InteractionModel *model);

@property(nonatomic,copy)void(^deleteBlock)(InteractionModel *model);
@property(nonatomic,copy)void(^commentBlock)(InteractionModel *model);
@property(nonatomic,copy)void(^seeAllBlock)(InteractionModel *model);

@property(nonatomic,copy)void(^seeBigImgBlock)(InteractionModel * model,NSInteger index);

+(CGFloat)cellHByModel:(InteractionModel *)model;
@end
