
//
//  CollectionCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/9.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "CollectionCell.h"
@interface CollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *img;//图片
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;//标题
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;//
@property (weak, nonatomic) IBOutlet UILabel *specificationLbl;//规格
@property (weak, nonatomic) IBOutlet UILabel *usePlaceLbl;//使用位置
@property (weak, nonatomic) IBOutlet UILabel *factoryLbl;//工厂或者公司
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *specialImg;

@end

@implementation CollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(CollectionModel *)model{
	_model = model;
	_collectionBtn.alpha = _specialImg.alpha = 0;
	[_img sd_setImageWithURL:IMGURL(model.logoUrl) placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates] ;
	 _titleLbl.text  = [DDFactory getString: model.name  withDefault:@"未知"];
	_priceLbl.text = [NSString stringWithFormat:@"￥ %0.2f",[model.price floatValue]];
	_specificationLbl.text =  [DDFactory getString:model.spec  withDefault:@"0 * 0"];
	_usePlaceLbl.text =  [DDFactory getString:model.typeName  withDefault:@"未知"];
	_factoryLbl.text = [DDFactory getString:model.merchantName  withDefault:@"未知"];
}
-(void)setSpecialModel:(CollectionModel *)model{
    _collectionBtn.alpha = _specialImg.alpha = 1;
    [_collectionBtn setImage:IMG(@"ic_collection_n") forState:0];
    if ([model.collect integerValue] == 2) {////1,未收藏，2，已收藏
        [_collectionBtn setImage:IMG(@"ic_collection_p") forState:0];//如果已经收藏了
    }
  
    [_img sd_setImageWithURL:IMGURL(model.logoUrl) placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
    _titleLbl.text  = [DDFactory getString: model.name  withDefault:@"未知"];
    _priceLbl.text =   [NSString stringWithFormat:@"￥ %0.2f",[[DDFactory getString:model.price  withDefault:@"0"] floatValue]];
    _specificationLbl.text =  [DDFactory getString:model.spec  withDefault:@"0 * 0"];
	_usePlaceLbl.text =  [DDFactory getString:model.typeName  withDefault:@"未知"];
    _factoryLbl.text = [DDFactory getString:model.merchantName  withDefault:@"未知"];
}

- (IBAction)collectionAction:(UIButton *)sender {
	sender.userInteractionEnabled = NO;
	if (_collectBlock) {
		if (_collectBlock(_model)) {
			sender.userInteractionEnabled = YES;
		}
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
