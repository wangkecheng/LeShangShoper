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

@end
@implementation LosePromiseCell

-(void)setModel:(LosePromiseModel *)model{
	_model = model;
	_titLbl.text = model.title;
	_timeLbl.text = model.createAt;
	[_imgView sd_setImageWithURL:IMGURL(model.logoUrl) placeholderImage:IMG(@"Icon")];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
@end
