
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
	[_img sd_setImageWithURL:IMGURL(model.logoUrl)];
	_titleLbl.text  = model.name;
	_priceLbl.text = model.price;
	_specificationLbl.text = model.spec;
//	_usePlaceLbl.text = model.
	_factoryLbl.text = model.merchantName;
}
-(void)setSpecialModel:(CollectionModel *)model{
    _collectionBtn.alpha = _specialImg.alpha = 1;
    [_collectionBtn setImage:IMG(@"ic_collection_n") forState:0];
    [_collectionBtn setImage:IMG(@"ic_collection_p") forState:0];//如果已经收藏了
}

- (IBAction)collectionAction:(id)sender {
	if (_collectBlock) {
		_collectBlock(_model);
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
