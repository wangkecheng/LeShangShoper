//
//  HomeHeaderCell.h
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeHeaderModel.h"
@interface HomeHeaderCell : UITableViewCell
@property(nonatomic,copy)void(^clickBlock)(NSString *str);
@property(nonatomic,strong)NSMutableArray *arrModel;
@end
