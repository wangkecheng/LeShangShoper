
//
//  ProductDetailVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/16.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "ProductDetailVC.h"

@interface ProductDetailVC ()
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UILabel *indicatorLbl;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *specificationLbl;//规格
@property (weak, nonatomic) IBOutlet UILabel *usePlaceLbl;//使用位置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberLbl;//编号
@property (weak, nonatomic) IBOutlet UILabel *factoryLbl;//工厂或者公司
@property (weak, nonatomic) IBOutlet UIButton *shoppingCartBtn;//购物车
@property (weak, nonatomic) IBOutlet UIImageView *specialImg;//是否是特价


@end

@implementation ProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"商品详情";
	NSMutableArray * arr = [NSMutableArray array];
	for (int i = 0 ;i<6; i++) {
		[arr addObject:@"image0.jpg"];
	}
	SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH,CGRectGetHeight(_scrollContentView.frame))  imageNamesGroup:arr];
	cycleView.backgroundColor=[UIColor redColor];
	cycleView.showPageControl = NO;
	cycleView.autoScroll = NO;
	[self.scrollContentView addSubview:cycleView];
	weakObj;
	cycleView.clickItemOperationBlock = ^(NSInteger currentIndex) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		
	};
	cycleView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		strongSelf.indicatorLbl.text = [NSString stringWithFormat:@"%ld/6",currentIndex+1];
	};
										  
}

- (IBAction)addToCartAction:(id)sender {//加入购物车
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
