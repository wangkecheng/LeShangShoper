//
//  AdvertCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "AdvertCell.h"
#import "AdvertItemView.h"
 
@interface AdvertCell()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AdvertCell

- (void)awakeFromNib {
    [super awakeFromNib];
     _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showNextNotice) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)setAlertArr:(NSArray *)alertArr{
	_alertArr = alertArr;
}

-(void)layoutSubviews{
	[super layoutSubviews];
	CGFloat viewWidth = CGRectGetWidth(_scrollView.frame);
	CGFloat itemH = CGRectGetHeight(_scrollView.frame)/2;
	UIView* lastView = [[UIView  alloc]initWithFrame:CGRectMake(0,-itemH,0, itemH)];
	for (CollectionModel *model in _alertArr) {
		
		AdvertItemView * view = [AdvertItemView instanceByFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame), viewWidth, itemH)
														  model:model clickBlock:_clickBlock];
		[_scrollView addSubview:view];
		lastView = view;
	}
	CGFloat sizeY = CGRectGetMaxY(lastView.frame);
	if (_alertArr.count%2!=0) {
		sizeY+= itemH;//这里是当轮播个数为奇数的时候， 将_scrollView的contentSize仍然设置为_scrollView 高度的整数倍，实际上就是虚拟了一个多的空AdvertItemView 凑整
	}
	_scrollView.contentSize = CGSizeMake(0, sizeY);
	_scrollView.bounces = NO ;
	_scrollView.showsVerticalScrollIndicator = NO;
	_scrollView.delegate = self;
	_scrollView.pagingEnabled = YES; 
}
- (void)showNextNotice {
	CGFloat offsetY =  _scrollView.contentOffset.y + CGRectGetHeight(_scrollView.frame);
	if (offsetY + CGRectGetHeight(_scrollView.frame)>_scrollView.contentSize.height) {
		offsetY = 0;
	}
	[_scrollView setContentOffset:CGPointMake(0,offsetY)];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
