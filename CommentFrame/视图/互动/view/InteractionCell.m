

//
//  InteractionCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "InteractionCell.h"
@interface InteractionCell()
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UILabel *titLbl;
@property (weak, nonatomic) IBOutlet UIView *imgsContaintView;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *pardiseBtn;

@end

@implementation InteractionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(InteractionModel *)model{
	_model = model;
	CGFloat w = CGRectGetWidth(self.contentView.frame) - 10;//默认一张的时候
	CGFloat h = w;//一张的时候
	NSArray * imgStrArr = [model.imageUrls componentsSeparatedByString:@","];
	if (imgStrArr.count == 2) {
		w = CGRectGetWidth(self.contentView.frame) / 2.0 - 15;
	}
	if (imgStrArr.count > 2) {
		w = CGRectGetWidth(self.contentView.frame) / 3.0 - 20;
	}
	h = w; 
}

- (IBAction)commentAction:(id)sender {
	if (_commentBlock) {
		_commentBlock(_model);
	}
}
- (IBAction)pardiseAction:(id)sender {
	if (_pardiseBlock) {
		_pardiseBlock(_model);
	}
}

@end
