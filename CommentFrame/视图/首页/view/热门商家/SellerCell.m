//
//  SellerCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "SellerCell.h"

@implementation SellerModel
 
@end
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
	CGFloat btnW = (CGRectGetWidth(_scrollView.frame) - 60)/3.0;
	CGFloat btnH = btnW + 20;
	CGFloat imgW = btnW;
	for (int i  = 0 ;i< sellerArr.count;i++) {
		SellerModel *model = sellerArr[i];
		DDButton *btn = [[DDButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastBtn.frame) + 20,CGRectGetMinY(lastBtn.frame),btnW, btnH)
												titleX:0 titleY:imgW + 5 titleW:btnW titleH:btnH - imgW
												imageX:0 imageY:0 imageW:imgW imageH:imgW];
		btn.imageView.layer.cornerRadius = 10;
		btn.imageView.layer.masksToBounds = YES;
       
        if (model.logoUrl) {
            [btn sd_setImageWithURL:IMGURL(model.logoUrl) forState:0 placeholderImage:IMG(@"Icon")];
        }
		
		[btn setTitle:model.name forState:0];
		 btn.titleLabel.textAlignment = 1;
         btn.titleLabel.font = [UIFont systemFontOfSize:14];
		[btn setTitleColor:[UIColor blackColor] forState:0];
		 btn.tag = i;
		[btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:btn];
		lastBtn = btn;
	}
    NSInteger pageCount = sellerArr.count/3;
    if (sellerArr.count%3!=0 && sellerArr.count!=0) {
        pageCount+=1;
    }
	_pageContro.numberOfPages = pageCount;
	_pageContro.currentPage = 0;
	_pageContro.pageIndicatorTintColor = [UIColor grayColor];
	_pageContro.currentPageIndicatorTintColor = UIColorFromRGB(33, 145, 241);
	
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.pagingEnabled = YES;
	_scrollView.alwaysBounceHorizontal = YES;
	_scrollView.bounces = NO;
	_scrollView.delegate = self;
	_scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame) + 20, 0);
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
