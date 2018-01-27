//
//  CollectionCell.h
//  CommentFrame
//
//  Created by warron on 2018/1/9.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"
@interface CollectionCell : UITableViewCell
@property(nonatomic,strong)CollectionModel *model;
@property(nonatomic,strong)CollectionModel *specialModel;
@property(nonatomic,copy)BOOL(^collectBlock)(CollectionModel * model);
@end
