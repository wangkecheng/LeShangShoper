
//
//  HotProductCell.m
//  CommentFrame
//
//  Created by oldDevil on 2018/2/26.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "HotProductCell.h"

@interface HotProductCell()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *btnContentView;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation HotProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)setHotProudctArr:(NSArray *)hotProudctArr{
    _hotProudctArr = hotProudctArr;
    UIButton *lastBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [_btnContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i  = 0 ;i< hotProudctArr.count;i++) {
        CollectionModel *model = hotProudctArr[i];
        CGFloat w = SCREENWIDTH/4.0;
        CGFloat x = CGRectGetMaxX(lastBtn.frame);
        CGFloat h = w;
        if (i == 2 || i == 3) {
            w -= 1;
            x += 1;
        }
        DDButton *btn = [[DDButton alloc]initWithFrame:CGRectMake(x,0,w, h + 15)  titleX:0 titleY:h + 2 titleW:w titleH:11  imageX:2 imageY:0 imageW:w - 4 imageH:w];
        btn.imageView.layer.cornerRadius = 5;
        btn.imageView.layer.masksToBounds = YES;
        [btn sd_setImageWithURL:IMGURL(model.logoUrl) forState:0 placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
        [btn setTitle:[DDFactory getString:model.name   withDefault:@"未知"] forState:0]; 
         btn.titleLabel.textAlignment = 1;
         btn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
        [btn setTitleColor:UIColorFromHX(0x666666) forState:0];
         btn.tag = i;
         btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnContentView addSubview:btn];
        lastBtn = btn;
    }
}
- (void)refresh{
    if (_refreshBlock) {
        _refreshBlock();
    }
}
-(void)btnClick:(UIButton *)btn{
    if (_clickBlock) {
        _clickBlock(btn.tag,_hotProudctArr[btn.tag]);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
