
//
//  CommentInteractionCell.m
//  CommentFrame
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "CommentInteractionCell.h"
@interface CommentInteractionCell()
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@end
@implementation CommentInteractionCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
}
-(void)setModel:(CommentInteractionModel *)model{
    _model = model;
    [_headBtn sd_setImageWithURL:IMGURL(model.headUrl) forState:0];
    _nameLbl.text = model.name;
    _timeLbl.text = model.createAt;
    _contentLbl.text = model.content;
}

- (IBAction)headerBtnAction:(id)sender {
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
