//
//  NewsCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "NewsCell.h"
 
@interface NewsCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *newsImg;

@end
@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _newsImg.layer.cornerRadius = 3;
}
-(void)setNewsModel:(LosePromissAndNewsModel *)newsModel{
	_newsModel = newsModel;
    _titleLbl.text = newsModel.title;
    [_newsImg sd_setImageWithURL:IMGURL(newsModel.logoUrl) placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
