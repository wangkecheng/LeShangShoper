
//
//  CatalugeListVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/10.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "CatalugeListVC.h"
#import "ManufacturersCell.h"
#import "CatalugeListHeaderView.h"
#import "ProductDetailListVC.h"
#define ManufacturersCell_ @"ManufacturersCell"
@interface CatalugeListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic)NSInteger page;
@property(nonatomic,strong)NSMutableArray * arrModel;
@end

@implementation CatalugeListVC

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = _model.name;
	
	_arrModel = [NSMutableArray array];
	[_tableView registerNib:[UINib nibWithNibName:ManufacturersCell_ bundle:nil] forCellReuseIdentifier:ManufacturersCell_];
	
	_tableView.backgroundColor = UIColorFromRGB(242, 242, 242);;
	[_tableView hideSurplusLine];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.tableHeaderView = [CatalugeListHeaderView instanceByFrame:CGRectMake(0, 0, SCREENWIDTH, 240)];
	_tableView.tableFooterView=[UIView new];
	_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
	_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
	//	[self getPage];
	for (int i = 0 ; i< 10; i++) {
		ManufacturersModel * model = [[ManufacturersModel alloc]init];
		model.name =@"warron";
		[_arrModel addObject:model];
	}
	[self.tableView reloadData];
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
	weakObj;
	[BaseServer postObjc:m path:@"getUniversityList.php" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
		
		__strong typeof (weakSelf) strongSelf = weakSelf;
		NSArray * tempArr = [NSArray yy_modelArrayWithClass:[ManufacturersModel class] json:result[@"data"]];
		
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return _arrModel.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell * cell = nil;
	weakObj;
	ManufacturersCell *headerCell = [tableView dequeueReusableCellWithIdentifier:ManufacturersCell_ forIndexPath:indexPath];
	[headerCell setModel:_arrModel[indexPath.row]];
	[headerCell setSelectionStyle:0];//不要分割线
	cell = headerCell;
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 58;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	ProductDetailListVC * VC = [[ProductDetailListVC alloc]init];
	[self.navigationController pushViewController:VC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	weakObj;
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
	return 5;
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
@end

