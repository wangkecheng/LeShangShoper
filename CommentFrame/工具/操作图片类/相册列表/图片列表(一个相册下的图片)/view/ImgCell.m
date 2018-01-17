//
//  ImgCell.m
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "ImgCell.h"
@interface ImgCell()
@property (weak, nonatomic) IBOutlet UIImageView *imavHead;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckMark; 
@end
@implementation ImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
     
}
-(void)setModel:(ImgModel *)model{
	_model = model;
	if (model.image) {
		_imavHead.image = model.image;//表示在数据源中已经请求到了图片数据
	}else{//否则 没有请求到的话，那就cell自己来请求
		__weak typeof (self) weakSelf = self;
		[[WSPHPhotoLibrary library]getImgByPHAsset:model.asset isOriginal:NO finishBlock:^(UIImage *image) {
			__strong typeof (weakSelf) strongSelf = weakSelf;
			strongSelf.imavHead.image = image;//这里先做一个操作 就是将图片先请求下来
			strongSelf.model.image = image;
		}];
	}
	[self setSelectImg:model.isSelect];
}
- (IBAction)actionBtn:(UIButton *)sender {
	
	if (sender.selected) {
		[self setSelectImg:NO];
	}else{
		[self setSelectImg:YES];
	}
	if (_selcetBlock) {//这个选择block不为空才走 防空
		if (_selcetBlock(_model)) {//将这个传过去， 控制器判断已选择数组中有的话， 就移除， 返回YES，表示需要设置为NO
			[self setSelectImg:NO];
		}
	}
}
-(void)setSelectImg:(BOOL)isSelect{
	_model.isSelect = isSelect;//设置是否选择的标识
	_btnCheckMark.selected = isSelect;
	if (isSelect){
		[_btnCheckMark setImage:[UIImage imageNamed:@"ico_check_select.png"] forState:0];
		return;
	}
	[_btnCheckMark setImage:[UIImage imageNamed:@"ico_check_nomal"] forState:0];
}
@end
