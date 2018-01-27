//
//  ProductDetailListCell.h
//  CommentFrame
//
//  Created by warron on 2018/1/10.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"
@interface ProductDetailListCell : UICollectionViewCell

@property (nonatomic,copy)BOOL(^collectionBlock)(CollectionModel * model);
@property(nonatomic,strong)CollectionModel * model;
@end
