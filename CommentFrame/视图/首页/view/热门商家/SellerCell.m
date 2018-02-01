//
//  SellerCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "SellerCell.h"
 
@interface SellerCell()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageContro;
@end

@implementation SellerCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setSellerArr:(NSArray *)sellerArr{
	_sellerArr = sellerArr;
	UIButton *lastBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,0,0)];
	CGFloat btnW = (CGRectGetWidth(_scrollView.frame) - 72)/3.0;
	CGFloat btnH = btnW + 25;
	CGFloat imgW = btnW;
    NSInteger count = sellerArr.count;
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	for (int i  = 0 ;i< count;i++) {
		ManufacturersModel *model = sellerArr[i];
        CGFloat margin = 18;
        if (i%3 == 0 && i !=0) {
            margin = 36;
        }
		DDButton *btn = [[DDButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastBtn.frame) + margin,CGRectGetMinY(lastBtn.frame),btnW, btnH)
												titleX:0 titleY:imgW + 10 titleW:btnW titleH:btnH - imgW - 10
												imageX:0 imageY:0 imageW:imgW imageH:imgW];
		btn.imageView.layer.cornerRadius = 10;
		btn.imageView.layer.masksToBounds = YES;
       
        if (model.logoUrl) {
            [btn sd_setImageWithURL:IMGURL(model.logoUrl) forState:0 placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
        }
		
		[btn setTitle:[DDFactory getString:model.name   withDefault:@"未知"] forState:0]; 
		 btn.titleLabel.textAlignment = 1;
         btn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];;
		[btn setTitleColor:UIColorFromHX(0x666666) forState:0];
		 btn.tag = i;
		[btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:btn];
		lastBtn = btn;
	}
    NSInteger pageCount = sellerArr.count/3;
    if (sellerArr.count%3!=0 && sellerArr.count!=0) {
        pageCount += 1;
    }
	_pageContro.numberOfPages = pageCount;
	_pageContro.currentPage = 0; 
	_pageContro.pageIndicatorTintColor = UIColorFromHX(0xdcdcdc);
	_pageContro.currentPageIndicatorTintColor = UIColorFromHX(0x1393fc);
	
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.pagingEnabled = YES;
    _scrollView.pagingEnabled = YES;
	_scrollView.alwaysBounceHorizontal = YES;
	_scrollView.bounces = YES;
	_scrollView.delegate = self;
	_scrollView.contentSize = CGSizeMake(pageCount * CGRectGetWidth(_scrollView.frame), 0);
}

-(void)btnClick:(UIButton *)btn{
	if (_clickBlock) {
		_clickBlock(btn.tag,_sellerArr[btn.tag]);
	}
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	_pageContro.currentPage = (scrollView.contentOffset.x + 20) /CGRectGetWidth(scrollView.frame);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
