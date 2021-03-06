//
//  LosePromiseCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "LosePromiseCell.h"
@interface LosePromiseCell()
@property (weak, nonatomic) IBOutlet UILabel *titLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
    @property (weak, nonatomic) IBOutlet UIImageView *biaoZhiImg;
    
@end
@implementation LosePromiseCell

-(void)setModel:(LosePromissAndNewsModel *)model{
	_model = model;
	_titLbl.text = [DDFactory getString:model.title  withDefault:@""]; 
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.createAt integerValue]/1000];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _timeLbl.text = [formatter stringFromDate:confromTimesp];
   [_imgView sd_setImageWithURL:IMGURL(model.logoUrl) placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _biaoZhiImg.layer.cornerRadius = 17.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
@end
