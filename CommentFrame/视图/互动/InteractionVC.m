//
//  InteractionVC.m
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "InteractionVC.h"
#import "InteractionCell.h"
#import "AddInteractionVC.h"
#define InteractionCell_ @"InteractionCell"
@interface InteractionVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)NSMutableArray *arrModel;
@property (assign, nonatomic)NSInteger page;
@property (weak, nonatomic)IBOutlet UITableView *tableview;
@end

@implementation InteractionVC

- (void)viewDidLoad {
	[super viewDidLoad];
	_arrModel = [[NSMutableArray alloc]init];
	[_tableview registerNib:[UINib nibWithNibName:InteractionCell_ bundle:nil]forCellReuseIdentifier:InteractionCell_];
	_tableview.backgroundColor = self.view.backgroundColor = UIColorFromRGB(242, 242, 242);
	_tableview.delegate = self;
	_tableview.dataSource = self;
	[_tableview setSeparatorStyle:0];
	
	[_tableview hideSurplusLine];
	[self addRightBarButtonWithFirstImage:IMG(@"ic_top_add") action:@selector(addInteraction)];
	_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
	_tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
	[self getPage];
}

-(void)addInteraction{//添加互动
	AddInteractionVC * VC = [[AddInteractionVC alloc]init];
	[self.navigationController pushViewController:VC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
	
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
    m.pageNumber = [NSString stringFromInt:pageIndex];
	weakObj;
	[BaseServer postObjc:m path:@"/interact/list" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
		NSArray *tempArr = [NSArray yy_modelArrayWithClass:[InteractionModel class] json:result[@"data"][@"rows"]];
		if (weakSelf.page == 1) {
			[weakSelf.arrModel removeAllObjects];
		}
		[weakSelf.arrModel addObjectsFromArray:tempArr];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[weakSelf.tableview reloadData];
			[weakSelf.tableview.mj_header endRefreshing];
			[weakSelf.tableview.mj_footer endRefreshing];
			if (weakSelf.page == [result[@"data"][@"total"] integerValue]) {
				[weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
			}
			[weakSelf.tableview setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:YES];
			if (weakSelf.arrModel.count == 0) {
				[weakSelf.tableview setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:NO];
			}
		});
	} failed:^(NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[weakSelf.tableview.mj_header endRefreshing];
			[weakSelf.tableview.mj_footer endRefreshing];
		});
	}];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
	return _arrModel.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return  120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	InteractionCell* cell =  [tableView dequeueReusableCellWithIdentifier:InteractionCell_ forIndexPath:indexPath];
	[cell setModel:_arrModel[indexPath.section]];
	[cell setSelectionStyle:0];
	cell.pardiseBlock = ^(InteractionModel *model) {
		HDModel * m = [HDModel model];
		m.interactId = model.uid;
		[BaseServer postObjc:m path:@"/interact/give" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
			
		} failed:^(NSError *error) {
			
		}];
	};
	cell.commentBlock = ^(InteractionModel *mode) {
//		HDModel * m = [HDModel model];
//		m.interactId = model.uid;
//		[BaseServer postObjc:m path:@"/interact/give" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
//
//		} failed:^(NSError *error) {
//
//		}];
	};
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UIView *view = [[UIView alloc]init];
	CGFloat H = 5;
	[view setFrame:CGRectMake(0, 0, SCREENWIDTH, H)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		return 30;
	}
	return 10;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
@end
