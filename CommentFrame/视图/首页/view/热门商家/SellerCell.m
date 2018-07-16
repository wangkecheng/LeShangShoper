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
    CGFloat marginRL = 20;//左右距离屏幕距离
    CGFloat marginV = 35;//横向间距
	CGFloat btnW = (CGRectGetWidth(_scrollView.frame) - marginV * 3  - marginRL * 2)/4.0;
	CGFloat btnH = btnW + 15;
	CGFloat imgW = btnW;
    
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger pageCount = sellerArr.count/8;//总页数
    if (sellerArr.count%8!=0 && sellerArr.count!=0) {
        pageCount += 1;
    }
    NSInteger count = sellerArr.count;
	for (int i  = 0 ;i< count;i++) {
		ManufacturersModel *model = sellerArr[i];
        marginV = 35;
        CGFloat marginH = 10;//竖向间距
        if (i == 0) {
            marginV = marginRL;
        }
       
        CGFloat x = CGRectGetMaxX(lastBtn.frame) + marginV;
        CGFloat y = CGRectGetMinY(lastBtn.frame);
        if (i%4 == 0 && i!=0 && i%8!=0) {//这里是换行
            x = i/8 * SCREENWIDTH +  marginRL;
            y = CGRectGetMaxY(lastBtn.frame) + marginH;
        }
        if (i%8 == 0 && i!=0) {//换页
             y = 0;
             x = CGRectGetMaxX(lastBtn.frame) +  2 * marginRL;
        }
     
		DDButton *btn = [[DDButton alloc]initWithFrame:CGRectMake(x,y,btnW, btnH)
												titleX:-20 titleY:imgW + 4 titleW:btnW + 40 titleH:btnH - imgW - 5
												imageX:0 imageY:0 imageW:imgW imageH:imgW];
		btn.imageView.layer.cornerRadius = 10;
		btn.imageView.layer.masksToBounds = YES;
        [btn sd_setImageWithURL:IMGURL(model.logoUrl) forState:0 placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
		[btn setTitle:[DDFactory getString:model.name   withDefault:@"未知"] forState:0]; 
		 btn.titleLabel.textAlignment = 1;
      btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13]==nil?[UIFont systemFontOfSize:13]:[UIFont fontWithName:@"PingFangSC-Medium" size:13];
		[btn setTitleColor:UIColorFromHX(0x666666) forState:0];
		 btn.tag = i;
		[btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:btn];
		lastBtn = btn;
	}
	_pageContro.numberOfPages = pageCount;
	_pageContro.currentPage = 0; 
	_pageContro.pageIndicatorTintColor = UIColorFromHX(0xdcdcdc);
//    _pageContro.currentPageIndicatorTintColor = UIColorFromRGB(19, 147, 252);
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.pagingEnabled = YES;
    _scrollView.pagingEnabled = YES;
	_scrollView.alwaysBounceHorizontal = YES;
	_scrollView.bounces = YES;
	_scrollView.delegate = self;
	_scrollView.contentSize = CGSizeMake(pageCount * CGRectGetWidth(_scrollView.frame), 0);
}
+(CGFloat)getH{
   return  ((SCREENWIDTH - 3 * 35 - 2 * 20)/4.0 + 15) * 2 + 50 + 10;
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
