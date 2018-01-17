
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
@interface CollectionVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic)NSInteger page;
@property(nonatomic,strong)NSMutableArray * arrModel;
@end

@implementation CollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"收藏夹";
    [_tableView registerNib:[UINib nibWithNibName:CollectionCell_ bundle:nil] forCellReuseIdentifier:CollectionCell_];
	
	_tableView.backgroundColor = UIColorFromRGB(242, 242, 242);;
	[_tableView hideSurplusLine];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
	_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
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
	
	return _arrModel.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CollectionCell_ forIndexPath:indexPath];
	[cell setModel:_arrModel[indexPath.row]];
	[cell setSelectionStyle:0];//不要分割线
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	
	return 0.01;
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

