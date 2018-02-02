

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
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation ManufacturersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(ManufacturersModel *)model{
	_model = model;
	_nameLbl.text =[DDFactory getString:model.name  withDefault:@"未知"];
   
}
-(void)setLineViewAlpah:(BOOL)isShow{
     _lineView.alpha = 0;
    if (isShow) {
         _lineView.alpha = 1;
    }
}


-(void)setSeriesModel:(SeriesModel *)seriesModel{
    _seriesModel = seriesModel;
    _nameLbl.text = [DDFactory getString:seriesModel.name  withDefault:@"未知"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
