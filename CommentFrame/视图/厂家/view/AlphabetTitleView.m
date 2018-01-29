

//
//  AlphabetTitleView.m
//  CommentFrame
//
//  Created by warron on 2017/12/16.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "AlphabetTitleView.h"
@interface AlphabetTitleView()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *pointImg;

@end
@implementation AlphabetTitleView
+(instancetype)headerViewWithFrame:(CGRect)frame{
	AlphabetTitleView *view = [DDFactory getXibObjc:@"AlphabetTitleView"];
	view.backgroundColor = UIColorFromRGB(242, 242, 242);
	return view;
}
-(void)setModel:(AlphabetTitleModel *)model{
	_model = model;
	_titleLbl.text = [DDFactory getString:model.name  withDefault:@"#"];
	[_pointImg setImage:IMG(@"IQButtonBarArrowDown") forState:0];
	if (model.isFolded) {
	[_pointImg setImage:IMG(@"IQButtonBarArrowUp") forState:0];
	}
} 

- (IBAction)foldBtnAction:(UIButton *)sender {
	_model.isFolded = !_model.isFolded;//这里改变的时候由于它和外部sectionTitle中的是同一个， 所以那个也会改变
	if (_foldedBlock) {
		_foldedBlock(_model);
	}
}
@end
