//
//  HotProductCell.h
//  CommentFrame
//
//  Created by oldDevil on 2018/2/26.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"
@interface HotProductCell : UITableViewCell
@property(nonatomic,strong)NSArray *hotProudctArr;
@property(nonatomic,copy)void(^clickBlock)(NSInteger index,CollectionModel *model);
@property(nonatomic,copy)void(^refreshBlock)(void);

@end
