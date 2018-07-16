
//
//  HotProductCell.m
//  CommentFrame
//
//  Created by oldDevil on 2018/2/26.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "HotProductCell.h"

@interface HotProductCell()<UIScrollViewDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIScrollView *btnScrollview;

@property (weak, nonatomic) IBOutlet UIPageControl *pageContro;
@end
@implementation HotProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)setHotProudctArr:(NSArray *)hotProudctArr{
    _hotProudctArr = hotProudctArr;
    UIButton *lastBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,0,0)];//创建个对象 用来暂存上一个对象
    [_btnScrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//每次加载试图的时候先清除原有试图
    
    for (int i  = 0 ;i< hotProudctArr.count;i++) {
        CollectionModel *model = hotProudctArr[i];
        CGFloat w = SCREENWIDTH/4.0;
        CGFloat x = CGRectGetMaxX(lastBtn.frame);//上个视图横向坐标的最大值
        CGFloat h = w;
 
        if ( i == 2 || i == 3 || i == 6 || i == 7) {// 如果是第二和第三个 宽度减2
            w -= 2;
            x += 2;// 往右偏移两个像素 
        }
        //下边这里不用管 只是添加视图而已
        DDButton *btn = [[DDButton alloc]initWithFrame:CGRectMake(x,0,w, h + 20)  titleX:0 titleY:h + 3 titleW:w titleH:14  imageX:2 imageY:0 imageW:w - 4 imageH:w];
        btn.imageView.layer.cornerRadius = 5;
        btn.imageView.layer.masksToBounds = YES;
        [btn sd_setImageWithURL:IMGURL(model.logoUrl) forState:0 placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
        [btn setTitle:[DDFactory getString:model.name   withDefault:@"未知"] forState:0]; 
         btn.titleLabel.textAlignment = 1;
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12]==nil?[UIFont systemFontOfSize:12]:[UIFont fontWithName:@"PingFangSC-Medium" size:12];
        [btn setTitleColor:UIColorFromHX(0x666666) forState:0];
         btn.tag = i;
         btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnScrollview addSubview:btn];
         lastBtn = btn;
    } 
    NSInteger totalPage = hotProudctArr.count/4;
    if (hotProudctArr.count%4!=0) {//这里是当轮播个数为奇数的时候， 将_scrollView的contentSize仍然设置为_scrollView 高度的整数倍，实际上就是虚拟了一个多的空AdvertItemView 凑整
        totalPage+=1;
    }
    _pageContro.numberOfPages = totalPage;
    _pageContro.currentPage = 0;
    _pageContro.pageIndicatorTintColor = UIColorFromHX(0xdcdcdc);
//    _pageContro.currentPageIndicatorTintColor = UIColorFromHX(0x1393fc);
    _btnScrollview.contentSize = CGSizeMake(SCREENWIDTH * totalPage, 0);
    _btnScrollview.bounces = NO ;
    _btnScrollview.showsVerticalScrollIndicator = NO;
    _btnScrollview.delegate = self;
    _btnScrollview.pagingEnabled = YES;
}
- (void)refresh{
    CGFloat offsetX =  _btnScrollview.contentOffset.x + CGRectGetWidth(_btnScrollview.frame);
    if (offsetX + CGRectGetWidth(_btnScrollview.frame)>_btnScrollview.contentSize.width) {
        offsetX = 0;
    }
    [_btnScrollview setContentOffset:CGPointMake(offsetX,0)];
     _pageContro.currentPage = (_btnScrollview.contentOffset.x) /CGRectGetWidth(_btnScrollview.frame);
//    if (_refreshBlock) {
//        _refreshBlock();
//    }
}
-(void)btnClick:(UIButton *)btn{
    if (_clickBlock) {
        _clickBlock(btn.tag,_hotProudctArr[btn.tag]);
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageContro.currentPage = (scrollView.contentOffset.x) /CGRectGetWidth(scrollView.frame);
}

+(CGFloat)getH{
    return 45 + SCREENWIDTH / 4.0 + 28 + 13 + 20;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
