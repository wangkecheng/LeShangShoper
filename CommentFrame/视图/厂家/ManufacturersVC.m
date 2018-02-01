//
//  ManufacturersVC.m
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "ManufacturersVC.h"
#import "AlphabetTitleView.h"
#import "AlphabetTitleModel.h"
#import "ManufacturersCell.h"
#import "SearchManufacturersVC.h"
#import "CatalugeListVC.h"
#define ManufacturersCell_ @"ManufacturersCell"
@interface ManufacturersVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic)NSInteger page;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property(nonatomic,strong)NSMutableArray * arrModel;

@end

@implementation ManufacturersVC

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_arrModel = [NSMutableArray array];
	_sectionTitles = [NSMutableArray array];
	[_tableView registerNib:[UINib nibWithNibName:ManufacturersCell_ bundle:nil] forCellReuseIdentifier:ManufacturersCell_];
	
	_tableView.backgroundColor = UIColorFromHX(0xf0f0f0);
	[_tableView hideSurplusLine];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.tableFooterView=[UIView new];
    [_tableView setSeparatorStyle:0];
	_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
	[self getPage];
	
	[self addRightBarButtonWithFirstImage:IMG(@"ic_home_search") action:@selector(toSearchManufacturersVC)];
    
    //修改索引颜色
//    _tableView.sectionIndexBackgroundColor = [UIColor redColor];//修改右边索引的背景色
    _tableView.sectionIndexColor = [UIColor blackColor];//修改右边索引字体的颜色
//    _tableView.sectionIndexTrackingBackgroundColor = [UIColor blueColor];//修改右边索引点击时候的背景色
}

-(void)toSearchManufacturersVC{
	SearchManufacturersVC * VC = [[SearchManufacturersVC alloc]init];
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
	weakObj;
	[BaseServer postObjc:m path:@"/merchant/all" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
		
		__strong typeof (weakSelf) strongSelf = weakSelf;
		NSMutableArray *tempArr = [NSMutableArray array];
		for (NSDictionary * dict in result[@"data"]) {
			AlphabetTitleModel * alphabetTitleModel  = [AlphabetTitleModel yy_modelWithJSON:dict];
			alphabetTitleModel.childrenArrModel = [NSArray yy_modelArrayWithClass:[ManufacturersModel class] json:dict[@"children"]];
			[tempArr addObject:alphabetTitleModel];
		}
		
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
//            [strongSelf.tableView.mj_footer endRefreshing];
//            if (strongSelf.arrModel.count == [result[@"data"][@"total"] integerValue]) {
//                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
		});
	} failed:^(NSError *error) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		[strongSelf.tableView.mj_header endRefreshing];
		[strongSelf.tableView.mj_footer endRefreshing];
	}];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
	return _arrModel.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	AlphabetTitleModel * alphabetTitleModel = _arrModel[section];
	return alphabetTitleModel.childrenArrModel.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell * cell = nil;
	weakObj;
	ManufacturersCell *headerCell = [tableView dequeueReusableCellWithIdentifier:ManufacturersCell_ forIndexPath:indexPath];
	AlphabetTitleModel * alphabetTitleModel = _arrModel[indexPath.section];
	[headerCell setModel:alphabetTitleModel.childrenArrModel[indexPath.row]];
	[headerCell setSelectionStyle:0];//不要分割线
	cell = headerCell;
	
	return cell;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
	NSMutableArray *titleArr = [NSMutableArray array];
	for (AlphabetTitleModel * model in _arrModel) {
		[titleArr addObject:model.name];
	}
	return titleArr;
}
//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (index + 1 <= _arrModel.count) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return index;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 58;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	CatalugeListVC * VC =  [[CatalugeListVC alloc]init];
	AlphabetTitleModel * alphabetTitleModel = _arrModel[indexPath.section];
	VC.model = alphabetTitleModel.childrenArrModel[indexPath.row];
	[self.navigationController pushViewController:VC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	weakObj;
	AlphabetTitleView *view = [AlphabetTitleView headerViewWithFrame:CGRectMake(5, 0, SCREENWIDTH - 10, 35)];
	view.foldedBlock = ^(AlphabetTitleModel *model) {
		NSInteger section =  [_sectionTitles indexOfObject:model];
		dispatch_async(dispatch_get_main_queue(), ^{
//             [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
		});
	};
//    if (section <=  self.sectionTitles.count ) {
 
		[view setModel:_arrModel[section]];
//    }
	return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01)];
	
	view.backgroundColor = UIColorFromHX(0xf0f0f0);
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
