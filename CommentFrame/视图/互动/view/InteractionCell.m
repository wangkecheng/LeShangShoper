

//
//  InteractionCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "InteractionCell.h"
static int Btn_Tag = 100;
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
	[_headerBtn sd_setImageWithURL:IMGURL(model.headUrl) forState:0 placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
	_nameLbl.text = model.name;
	_titLbl.text = model.content;
	
	NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.createAt integerValue]];
	NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"yy-HH-dd hh:mm:ss"];
	NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
	
	_timeLbl.text = [NSString stringWithFormat:@"%@",confromTimespStr];
	[_commentBtn setTitle:[NSString stringWithFormat:@" %@",model.commentNumber] forState:0];
	[_pardiseBtn setTitle:[NSString stringWithFormat:@" %@",model.giveNumber] forState:0]; 
	CGFloat w = CGRectGetWidth(self.contentView.frame) - 10;//默认一张的时候
	CGFloat h = w;//一张的时候
//	if (imgStrArr.count == 2) {
//		w = CGRectGetWidth(self.contentView.frame) / 2.0 - 15;
//	}
//	if (imgStrArr.count > 2) {
//		w = CGRectGetWidth(self.contentView.frame) / 3.0 - 20;
//	}
	CGFloat margin = 5;
    w = (CGRectGetWidth(self.contentView.frame)  - 4*margin ) / 3.0;
	h = w;
	NSInteger imgCount =  model.imageUrls.count;
	UIButton * lastBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, margin, 0, 0)];
	for (int i = 0;i<imgCount;i++ ) {
		NSString *imgUrl = _model.imageUrls[i];
		CGFloat x =  CGRectGetMaxX(lastBtn.frame) + margin;
		CGFloat y = CGRectGetMinY(lastBtn.frame);
		if(i%3 == 0 ){
			x = margin;
			y = CGRectGetMaxY(lastBtn.frame) + margin;
		}
		UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, w, h)];
		btn.tag = i + Btn_Tag;
		btn.layer.cornerRadius = 10;
		btn.layer.masksToBounds = YES;
		[btn addTarget:self action:@selector(bimImgAction:) forControlEvents:UIControlEventTouchUpInside];
	 	[btn sd_setImageWithURL:IMGURL(imgUrl) forState:0 placeholderImage:IMG(@"Icon") options:SDWebImageAllowInvalidSSLCertificates];
		
		[_imgsContaintView addSubview:btn];
		lastBtn = btn;
	}
}

-(void)bimImgAction:(UIButton *)btn{
	if(_seeBigImgBlock){
		_seeBigImgBlock(btn.tag - Btn_Tag);
	}
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

+(CGFloat)cellHByModel:(InteractionModel *)model{
	CGFloat H = 100;
	H += [DDFactory autoHByText:model.content Font:15 W:SCREENWIDTH - 10];//文字高度
	CGFloat margin = 5;
	CGFloat w = (SCREENWIDTH   - 4*margin )/ 3.0;//图片高宽
	NSInteger imgCount = model.imageUrls.count;
	NSInteger rows = imgCount/3;//图片共几排

	if(imgCount%3!=0 &&imgCount!=0){
		rows += 1;//如果有余数 说名可能为 5 8 那么就要再加一排
	}
		H += rows * w + (rows + 1)*margin;//图片上 图片之间 最下排的图片的间隙 间隙数 比行数多 1
	return H;
}
@end
