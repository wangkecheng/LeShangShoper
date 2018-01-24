//
//  AdvertCell.h
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"

@interface AdvertCell : UITableViewCell
@property (nonatomic, strong)NSArray *alertArr;

@property (copy, nonatomic)void(^clickBlock)(CollectionModel  * model);
@end
