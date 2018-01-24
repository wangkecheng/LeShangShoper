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
    // Initialization code
}
-(void)setModel:(ManufacturersModel *)model{
	_model = model;
	[_img sd_setImageWithURL:IMGURL(model.logoUrl) placeholderImage:IMG(@"Icon") options:SDWebImageAllowInvalidSSLCertificates];
	_titleLbl.text = model.name;
	_locationLbl.text  = model.addr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
