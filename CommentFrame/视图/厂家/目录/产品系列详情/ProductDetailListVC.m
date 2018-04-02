
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
    
	_collectionView.backgroundColor = UIColorFromHX(0xf0f0f0);
	_collectionView.delegate = self;
	_collectionView.showsHorizontalScrollIndicator = YES;
	_collectionView.dataSource = self;
	[_collectionView registerNib:[UINib nibWithNibName:ProductDetailListCell_ bundle:nil]forCellWithReuseIdentifier:ProductDetailListCell_];
	
	[_flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
	_flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
	_flowlayout.minimumInteritemSpacing = 10;//同一行
	_flowlayout.minimumLineSpacing = 10;//同一列
	
	_arrModel = [[NSMutableArray alloc]init];
	_collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
	_collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
	[self getPage];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    weakObj;
    self.finishLoginBlock = ^{//登录完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf getPage];
        });
    };
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
    [cell setModel: _arrModel[indexPath.row]];
	cell.collectionBlock = ^BOOL(CollectionModel *model) {
		__strong typeof (weakSelf) strongSelf  = weakSelf;
        if ([CacheTool isToLoginVC:strongSelf]) {
            return YES;//方法内部做判断
        }
		HDModel *m = [HDModel model];
		m.cid = model.cid;
		weakObj;
		if ([model.collect integerValue] == 1) {
			    model.collect = @"2";
			[BaseServer postObjc:m path:@"/commodity/collect" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
				dispatch_async(dispatch_get_main_queue(), ^{
                
                    [strongSelf.view makeToast:@"取消成功"];
				});
			} failed:^(NSError *error) {
				
			}];
		}else{//取消收藏
			model.collect = @"1";
			[BaseServer postObjc:m path:@"/commodity/collect/remove" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
				dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.view makeToast:@"取消成功"];
				});
			} failed:^(NSError *error) {
				
			}];
		} 
        //从我的收藏 或者 厂家下的目录 进入后 点击收藏 需要刷新特价当中的按钮状态
      [[DDFactory factory]broadcast:model channel:CollectionActionBroadCast];// 总共两个个地方发送 收藏列表发送(商品详情回调block回调，在cell回调中发送 2个)发送给特价 产品系列详情ProductDetailListVC(cell回调block中发送，商品详情回调block回调 2个)
		[strongSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[strongSelf.arrModel indexOfObject:model] inSection:0]]];
		return YES;
	};
	return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat cellW = (CGRectGetWidth(collectionView.frame) - 32) /2.0 ;
	CGFloat cellH  =  cellW *16.0/11;
	return   CGSizeMake(cellW,cellH);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailVC *VC  = [[ProductDetailVC alloc] init];
	weakObj;
	VC.collectActionBlock = ^(CollectionModel *model, BOOL isCollect) {
		__strong typeof (weakSelf) strongSelf  = weakSelf;
		dispatch_async(dispatch_get_main_queue(), ^{
			
				for (int i = 0; i<strongSelf.arrModel.count; i++) {
					CollectionModel *modelT =	strongSelf.arrModel[i];
					if ([model.cid isEqualToString:modelT.cid]) {
						if (isCollect) {//
							modelT.collect = @"2";
						}else{
							modelT.collect = @"1";
						}
						[strongSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[strongSelf.arrModel indexOfObject:modelT] inSection:0]]];
                     [[DDFactory factory]broadcast:model channel:CollectionActionBroadCast];// 总共两个个地方发送 收藏列表发送(商品详情回调block回调，在cell回调中发送 2个)发送给特价 产品系列详情ProductDetailListVC(cell回调block中发送，商品详情回调block回调 2个)
						break;
					}
				}
		});
	};
    CollectionModel * model = _arrModel[indexPath.row];
    VC.model  = model;
    model.browseNumber = [NSString stringFromInt:[model.browseNumber integerValue] + 1];
    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_arrModel indexOfObject:model] inSection:0]]];//点击一次 加一次浏览量
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
