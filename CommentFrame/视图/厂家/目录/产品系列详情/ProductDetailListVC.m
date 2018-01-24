
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
#import "CollectionModel.h"
#import "ProductDetailVC.h"
@interface ProductDetailListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
@property (strong, nonatomic)NSMutableArray *arrModel;
@property (assign, nonatomic)NSInteger page;
 

@end

@implementation ProductDetailListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _brandsModel.name;
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
    m.pageNumber = [NSString stringFromInt:_page];
    m.mid = _mid;
    m.brand = _brandsModel.name;
	weakObj;
	[BaseServer postObjc:m path:@"/commodity/list" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
		NSArray *tempArr = [NSArray yy_modelArrayWithClass:[CollectionModel class] json:result[@"data"][@"rows"]];
                __strong typeof (weakSelf) strongSelf = weakSelf;
		if (strongSelf.page == 1){
			[strongSelf.arrModel removeAllObjects];
		}
		[strongSelf.arrModel addObjectsFromArray:tempArr];
		
		dispatch_async(dispatch_get_main_queue(), ^{
		 
            [strongSelf.collectionView reloadData];
            [strongSelf.collectionView setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:YES];
            if (strongSelf.arrModel.count == 0) {
                [strongSelf.collectionView setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:NO];
            }
            [strongSelf.collectionView.mj_header endRefreshing];
            if (strongSelf.arrModel.count == [result[@"data"][@"total"]integerValue]) {
                //最后一页
                [strongSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [strongSelf.collectionView.mj_footer endRefreshing];
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
	
	return  _arrModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	weakObj;
	ProductDetailListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductDetailListCell_ forIndexPath:indexPath];
//	[cell setModel: _arrModel[indexPath.row]];
	cell.collectionBlock = ^(CollectionModel *model) {
		
	};
	return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat cellW = (CGRectGetWidth(collectionView.frame) - 20) /2.0 ;
	CGFloat cellH  =  cellW *16.0/11;
	return   CGSizeMake(cellW,cellH);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailVC *VC  = [[ProductDetailVC alloc] init];
    CollectionModel * model = _arrModel[indexPath.row];
    VC.model  = model;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
