//
//  SellerCell.h
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SellerModel:NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *mid;
@property(nonatomic,strong)NSString *logoUrl;
@end
@interface SellerCell : UITableViewCell
@property(nonatomic,strong)NSArray *sellerArr;
@property(nonatomic,copy)void(^clickBlock)(NSInteger index,SellerModel *model);
@end


