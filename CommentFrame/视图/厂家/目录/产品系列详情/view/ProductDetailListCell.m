
//
//  ProductDetailListCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/10.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "ProductDetailListCell.h"
@interface ProductDetailListCell()

@property (weak, nonatomic) IBOutlet UIImageView *reminderImg;//提示图片 比如特价商品图片
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLbl;//编号
@property (weak, nonatomic) IBOutlet UILabel *specificationLbl;//规格
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;//
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;//关注数

@end
@implementation ProductDetailListCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
}

-(void)setModel:(ProductDetailListModel *)model{
	_model = model;
    [_collectionBtn setImage:IMG(@"ic_collection_n") forState:0];
    [_collectionBtn setImage:IMG(@"ic_collection_p") forState:0];
}

- (IBAction)collectionAction:(id)sender {
	if (_collectionBlock) {
		_collectionBlock(_model);
	}
}
@end
