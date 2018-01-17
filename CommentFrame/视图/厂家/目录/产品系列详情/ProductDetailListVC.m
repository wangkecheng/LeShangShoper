
//
//  ProductDetailListVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/10.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "ProductDetailListVC.h"
#import "ProductDetailListCell.h"
#define ProductDetailListCell_ @"ProductDetailListCell"
@interface ProductDetailListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
@property (strong, nonatomic)NSMutableArray *arrModel;
@property (assign, nonatomic)NSInteger page;
 

@end

@implementation ProductDetailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
	_collectionView.backgroundColor = UIColorFromRGB(242, 242, 242);;
	_collectionView.delegate = self;
	_collectionView.showsHorizontalScrollIndicator = YES;
	_collectionView.dataSource = self;
	[_collectionView registerNib:[UINib nibWithNibName:ProductDetailListCell_ bundle:nil]forCellWithReuseIdentifier:ProductDetailListCell_];
	
	[_flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
	_flowlayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
	_flowlayout.minimumInteritemSpacing = 5;//同一行
	_flowlayout.minimumLineSpacing = 5;//同一列
	
	_arrModel = [[NSMutableArray alloc]init];
	_collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
	_collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
	[self getPage];
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}
- (void)getPage{
	
	[self getData:1];
}

- (void)getNextPage{
	
	[self getData:_page + 1];
}

- (void)getData:(NSInteger)pageIndex {
	_page = pageIndex;
	HDModel *m = [HDModel model];
//	m.page = [NSString stringFromInt:_page];
	
	weakObj;
	[BaseServer postObjc:m path:@"app/yymember/listmemberwatermark.html" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
		NSArray *tempArr = [NSArray yy_modelArrayWithClass:[ProductDetailListModel class] json:result[@"data"][@"data"]];
		if (weakSelf.page == 1){
			[weakSelf.arrModel removeAllObjects];
		}
		[weakSelf.arrModel addObjectsFromArray:tempArr];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if (weakSelf.arrModel == 0) {
				[weakSelf.collectionView setHolderImg:@"alertImg" isHide:NO];
			} else{
				[weakSelf.collectionView setHolderImg:@"alertImg" isHide:YES];
			}
			[weakSelf.collectionView reloadData];
			[weakSelf.collectionView.mj_header endRefreshing];
			if (weakSelf.page == [result[@"data"][@"totalPages"]integerValue]) {
				//最后一页
				[weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
			} else {
				[weakSelf.collectionView.mj_footer endRefreshing];
			}
		});
	} failed:^(NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[weakSelf.collectionView.mj_header endRefreshing];
			[weakSelf.collectionView.mj_footer endRefreshing];
		});
	}];
}

//设置每一组cell的个数(组数默认是1 )
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	
	return  10;_arrModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	weakObj;
	ProductDetailListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductDetailListCell_ forIndexPath:indexPath];
//	[cell setModel: _arrModel[indexPath.row]];
	cell.collectionBlock = ^(ProductDetailListModel *model) {
		
	};
	cell.backgroundColor = [UIColor redColor];
	return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat cellW = (CGRectGetWidth(collectionView.frame) - 20) /2.0 ;
	CGFloat cellH  =  cellW *16.0/11;
	return   CGSizeMake(cellW,cellH);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	 
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
