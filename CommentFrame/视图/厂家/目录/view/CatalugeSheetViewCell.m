
//
//  CatalugeSheetViewCell.m
//  CommentFrame
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "CatalugeSheetViewCell.h"
@interface CatalugeSheetViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *img;//图片
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;//标题
@end

@implementation CatalugeSheetViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

-(void)setModel:(BrandsModel *)model{
    _model = model;
    NSLog(@"%@",IMGURL(model.url));
    [_img sd_setImageWithURL:IMGURL(model.url) placeholderImage:IMG(@"Icon") options:SDWebImageAllowInvalidSSLCertificates];
    [_titleLbl setText:[DDFactory getString:model.name  withDefault:@"未知品牌"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
