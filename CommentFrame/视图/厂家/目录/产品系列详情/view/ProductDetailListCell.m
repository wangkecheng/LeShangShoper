
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

-(void)setModel:(CollectionModel *)model{
	_model = model;
	[_img sd_setImageWithURL:IMGURL(model.logoUrl) placeholderImage:IMG(@"Icon") options:SDWebImageAllowInvalidSSLCertificates];
    [_collectionBtn setImage:IMG(@"ic_collection_n") forState:0];
    if ([model.collect integerValue] == 2) {////1,未收藏，2，已收藏
       [_collectionBtn setImage:IMG(@"ic_collection_p") forState:0];
    }
    _reminderImg.alpha = 0;
    if ([model.bargain integerValue] == 2) {//1,非特价，2，特价
          _reminderImg.alpha = 1;
	}
    _serialNumberLbl.text = [NSString stringWithFormat:@"编号:%@",  [DDFactory getString:model.cid withDefault:@"未知"]];
    _specificationLbl.text = [NSString stringWithFormat:@"规格:%@",[DDFactory getString:model.spec  withDefault:@"0 * 0"]];
	_priceLbl.text = [NSString stringWithFormat:@"￥%@", [DDFactory getString:model.price withDefault:@"0"]];
    [_focusBtn setTitle:[NSString stringWithFormat:@" %@", [DDFactory getString:model.broseNumber withDefault:@"0"]] forState:0];
}

- (IBAction)collectionAction:(UIButton *)sender {
	sender.userInteractionEnabled = NO;
	if (_collectionBlock) {
		if (_collectionBlock(_model)) {
			sender.userInteractionEnabled = YES;
		}
	}
}
@end
