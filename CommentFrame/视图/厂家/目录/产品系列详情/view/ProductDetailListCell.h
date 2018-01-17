//
//  ProductDetailListCell.h
//  CommentFrame
//
//  Created by warron on 2018/1/10.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailListModel.h"
@interface ProductDetailListCell : UICollectionViewCell

@property (nonatomic,copy)void(^collectionBlock)(ProductDetailListModel * model);
@property(nonatomic)ProductDetailListModel * model;
@end
