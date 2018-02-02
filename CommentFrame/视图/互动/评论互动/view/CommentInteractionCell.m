
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
    [_headBtn sd_setImageWithURL:IMGURL(model.headUrl) forState:0 placeholderImage:IMG(@"Icon") options:SDWebImageAllowInvalidSSLCertificates];
    _nameLbl.text = [DDFactory getString:model.name  withDefault:@"未知用户"];
  
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.createAt integerValue]/1000];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"]; 
    _timeLbl.text = [formatter stringFromDate:confromTimesp];
    _contentLbl.text = [DDFactory getString: model.content withDefault:@""];
}

- (IBAction)headerBtnAction:(id)sender {
    
}

+(CGFloat)cellHByModel:(CommentInteractionModel *)model{
	CGFloat H = 84;
	H += [DDFactory autoHByText:model.content Font:[UIFont fontWithName:@"PingFang-SC-Medium" size:14] W:SCREENWIDTH - 82];
	return H;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
