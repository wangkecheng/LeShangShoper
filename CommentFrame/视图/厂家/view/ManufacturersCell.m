

//
//  ManufacturersCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "ManufacturersCell.h"
@interface ManufacturersCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@end
@implementation ManufacturersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(ManufacturersModel *)model{
	_model = model;
	_nameLbl.text = model.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
