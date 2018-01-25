//
//  HomeHeaderCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "HomeHeaderCell.h"
@interface HomeHeaderCell()

@property(nonatomic,strong)NSMutableArray *arrUrlModel;
@property(nonatomic,strong)NSMutableArray *arrimageUrlModel;
@end
@implementation HomeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
}
-(void)setArrModel:(NSMutableArray *)arrModel{
	_arrModel = arrModel;
	_arrUrlModel = [NSMutableArray array];//点击图片后跳转的地址
	_arrimageUrlModel = [NSMutableArray array];//图片地址数组
	for (HomeHeaderModel *model in _arrModel) {
		[_arrUrlModel addObject:model.url];
		[_arrimageUrlModel addObject:IMGURL(model.imageUrl)];
	}
	SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH,200)  imageURLStringsGroup:_arrimageUrlModel];
	cycleView.backgroundColor=[UIColor whiteColor];
//    [cycleView setPlaceholderImage:IMG(@"Icon")];
	cycleView.currentPageDotImage = [DDFactory circleImage:[DDFactory imageWithColor:[UIColor whiteColor]] size:CGSizeMake(10,10)];
	
	cycleView.pageDotImage = [DDFactory circleImage:[DDFactory imageWithColor:[UIColor lightGrayColor]] size:CGSizeMake(10,10)];;
	
	[self.contentView addSubview:cycleView];
	cycleView.clickItemOperationBlock = ^(NSInteger currentIndex) {
		if(_clickBlock){
			_clickBlock(_arrUrlModel[currentIndex]);
		}
	};
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	
}

@end
