//
//  SearchManufacturersCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/9.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "SearchManufacturersCell.h"
@interface SearchManufacturersCell()
@property (weak, nonatomic) IBOutlet UIImageView *img;//图片
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;//标题
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;//

@end
@implementation SearchManufacturersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _img.layer.cornerRadius = 5;
}
-(void)setModel:(ManufacturersModel *)model{
	_model = model;
	[_img sd_setImageWithURL:IMGURL(model.logoUrl) placeholderImage:IMG(@"Icon") options:SDWebImageAllowInvalidSSLCertificates];
	_titleLbl.text = [DDFactory getString:model.name  withDefault:@"未知"];
	_locationLbl.text  = [DDFactory getString:model.addr  withDefault:@"未知地点"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
