
//
//  ProductDetailVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/16.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "ProductDetailVC.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
@interface ProductDetailVC ()
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UILabel *indicatorLbl;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *specificationLbl;//规格
@property (weak, nonatomic) IBOutlet UILabel *usePlaceLbl;//使用位置
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;//编号
@property (weak, nonatomic) IBOutlet UILabel *factoryLbl;//工厂或者公司
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;//购物车
@property (weak, nonatomic) IBOutlet UIImageView *specialImg;//是否是特价
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@property (strong, nonatomic)CollectionModel * detailModel;
@end

@implementation ProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"商品详情";
  
	HDModel * m = [HDModel model];
	m.cid  = _model.cid;
	weakObj;
	[BaseServer postObjc:m path:@"/commodity/info" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
	__strong typeof (weakSelf) strongSelf = weakSelf;
		strongSelf.detailModel = [CollectionModel yy_modelWithJSON:result[@"data"]];
		dispatch_async(dispatch_get_main_queue(), ^{
			[strongSelf setViewData];
		});
	} failed:^(NSError *error) {
		
	}];
	
}

-(void)setViewData{
    _specialImg.alpha = 0;
    if ([_detailModel.collect integerValue] == 2) {
          _specialImg.alpha = 1;
    }
	_titleLbl.text = _detailModel.name;
	SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH,CGRectGetHeight(_scrollContentView.frame))  imageURLStringsGroup:_detailModel.imageHashs];
	cycleView.showPageControl = NO;
    [cycleView setPlaceholderImage:IMG(@"Icon")];
	cycleView.autoScroll = NO;
	[self.scrollContentView addSubview:cycleView];
	weakObj;
	cycleView.clickItemOperationBlock = ^(NSInteger currentIndex) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		NSMutableArray* tmps = [[NSMutableArray alloc] init];
		for (int i = 0;i< strongSelf.detailModel.imageHashs.count;i++) {//找出所有图片
			LWImageBrowserModel* broModel = [[LWImageBrowserModel alloc]  initWithplaceholder:strongSelf.detailModel.imageHashs[i]
																				 thumbnailURL:nil
																						HDURL:nil
																				containerView:self.view
																		  positionInContainer:self.view.frame
																						index:i];
			[tmps addObject:broModel];
		}
		LWImageBrowser* browser = [[LWImageBrowser alloc]
								   initWithImageBrowserModels:tmps
								   currentIndex:currentIndex];
		browser.isScalingToHide = NO;
		browser.isShowSaveImgBtn = NO;
		[browser show];
	};
	cycleView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		strongSelf.indicatorLbl.text = [NSString stringWithFormat:@"%ld/6",currentIndex+1];
	};
	_specificationLbl.text = _detailModel.spec;//规格
//	_usePlaceLbl.text = _detailModel //使用位置
	_numberLbl.text = [NSString stringWithFormat:@"编号：%@",_detailModel.cid];//编号
	_factoryLbl.text = _detailModel.merchantName;//工厂或者公司
	_priceLbl.text =  [NSString stringWithFormat:@"￥%@",_detailModel.price];
	_specialImg.alpha = 0;
	if([_detailModel.bargain integerValue] == 2){
			_specialImg.alpha = 1;
	}
	[_collectBtn setTitle:@"加入收藏夹" forState:0];
	if([_detailModel.collect integerValue] == 2){
	    [_collectBtn setTitle:@"已收藏" forState:0];
	}
}

- (IBAction)addToCartAction:(id)sender {//加入收藏夹
	HDModel *m = [HDModel model];
	m.cid = _model.cid;
	[BaseServer postObjc:m path:@"/commodity/collect" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
		
	} failed:^(NSError *error) {
		
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
