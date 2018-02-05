
//
//  CollectionVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/6.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "CollectionVC.h"
#import "CollectionCell.h"
#define CollectionCell_ @"CollectionCell"
#import "SearchProductVC.h"
#import "ProductDetailVC.h"
@interface CollectionVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic)NSInteger page;
@property(nonatomic,strong)NSMutableArray * arrModel;
@end

@implementation CollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"收藏夹";
     _arrModel = [NSMutableArray array];
    [_tableView registerNib:[UINib nibWithNibName:CollectionCell_ bundle:nil] forCellReuseIdentifier:CollectionCell_];
	 self.view.backgroundColor =  _tableView.backgroundColor = [UIColor whiteColor];
	[_tableView hideSurplusLine];
	 _tableView.delegate = self;
	 _tableView.dataSource = self;
	 _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
	 _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
    [self addRightBarButtonWithFirstImage:IMG(@"ic_home_search") action:@selector(toSearchManufacturersVC)];
    [self getPage];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.extendedLayoutIncludesOpaqueBars = YES;
}

-(void)toSearchManufacturersVC{
    //打开搜索界面
    SearchProductVC * VC = [[SearchProductVC alloc]init];
    HDMainNavC * navi = (HDMainNavC *)self.navigationController;
    [navi pushVC:VC isHideBack:YES animated:YES];
}

- (void)getPage{
	
	[self getData:1];
}

- (void)getNextPage{
	
	[self getData:_page + 1];
}

- (void)getData:(NSInteger)pageIndex{
	_page = pageIndex;
	HDModel *m = [HDModel model];
	 m.pageNumber = [NSString stringFromInt:pageIndex];
	weakObj;
	[BaseServer postObjc:m path:@"/commodity/collect/list" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
		
		__strong typeof (weakSelf) strongSelf = weakSelf;
		NSArray * tempArr = [NSArray yy_modelArrayWithClass:[CollectionModel class] json:result[@"data"][@"rows"]];
		
		if (strongSelf.page == 1) {
			[strongSelf.arrModel removeAllObjects];
		}
		[strongSelf.arrModel addObjectsFromArray:tempArr];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[strongSelf.tableView reloadData];
			[strongSelf.tableView.mj_header endRefreshing];
			[strongSelf.tableView.mj_footer endRefreshing];
			[strongSelf.tableView setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:YES];
			if (strongSelf.arrModel.count == 0) {
				[strongSelf.tableView setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:NO];
			}
		});
	} failed:^(NSError *error) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		[strongSelf.tableView.mj_header endRefreshing];
		[strongSelf.tableView.mj_footer endRefreshing];
	}];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
    return _arrModel.count;//10;//
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CollectionCell_ forIndexPath:indexPath];
    [cell setModel:_arrModel[indexPath.row]];
	weakObj;
	cell.collectBlock = ^BOOL(CollectionModel *model) {
		__strong typeof (weakSelf) strongSelf  = weakSelf;
		[strongSelf.arrModel removeObject:model];
		HDModel * m = [HDModel model];
		m.cid = model.cid;
		[BaseServer postObjc:m path:@"/commodity/collect/remove" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
			__strong typeof (weakSelf) strongSelf  = weakSelf;
			dispatch_async(dispatch_get_main_queue(), ^{
				[strongSelf.tableView reloadData];//取消收藏
			});
		} failed:^(NSError *error) {
			
		}];
		return YES;
	};
	[cell setSelectionStyle:0];//不要分割线
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 145;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductDetailVC *VC  = [[ProductDetailVC alloc] init];
	weakObj;
	VC.collectActionBlock = ^(CollectionModel *model, BOOL isCollect) {
		__strong typeof (weakSelf) strongSelf  = weakSelf;
     dispatch_async(dispatch_get_main_queue(), ^{
	  [[DDFactory factory]broadcast:model channel:CollectionActionBroadCast];// 总共两个个地方发送 收藏列表发送(商品详情回调block回调，在cell回调中发送 2个)发送给特价 产品系列详情ProductDetailListVC(cell回调block中发送，商品详情回调block回调 2个)
		if (isCollect) {//此时就是重新下载数据了
			[strongSelf getPage];
		}else{
			for (int i = 0; i<strongSelf.arrModel.count; i++) {
				CollectionModel *modelT =	strongSelf.arrModel[i];
				if ([model.cid isEqualToString:modelT.cid]) {
					[strongSelf.arrModel removeObject:modelT];
					[strongSelf.tableView reloadData];
					break;
				}
			}
		}
	 });
	};
    CollectionModel * model  = _arrModel[indexPath.row] ;
    VC.model  =  [CollectionModel yy_modelWithJSON:[model yy_modelToJSONData]];//这里创建个新的
    [self.navigationController pushViewController:VC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    CGFloat H = 0.01;
//        view.backgroundColor = [UIColor clearColor];
//    if (section == 0) {
//        H = 12;//从搜索页面返回后就有一个顶部的留空 不知道为啥 解决这个问题 治标方法
//        view.backgroundColor = [UIColor whiteColor];
//    }
    view.frame = CGRectMake(0, 0, SCREENWIDTH, H);

	return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	  CGFloat H = 0.01;
//    if (section == 0) {
//        H = 12;//从搜索页面返回后就有一个顶部的留空 不知道为啥 解决这个问题 治标方法
//    }
	return H;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.01;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
	//打开搜索界面
	return NO;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
@end

