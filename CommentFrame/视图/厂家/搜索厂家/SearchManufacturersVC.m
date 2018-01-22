

//
//  SearchManufacturersVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/8.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "SearchManufacturersVC.h"
#import "SearchManufacturersCell.h"
#import "CatalugeListVC.h"
#import "SearchManufacturersHeaderView.h"
#define SearchManufacturersCell_ @"SearchManufacturersCell"
@interface SearchManufacturersVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UISearchBar *searchBar;

@property (assign, nonatomic)NSInteger page; 
@property(nonatomic,strong)NSMutableArray * arrModel;

@end

@implementation SearchManufacturersVC

- (void)viewDidLoad {
    [super viewDidLoad];
	_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 7, SCREENWIDTH - 10, 30)];
	[_searchBar setPlaceholder:@"探索厂家"];
	_searchBar.delegate = self;
	_searchBar.layer.cornerRadius = 5;
	_searchBar.layer.masksToBounds = YES;
	[DDFactory removeSearhBarBack:_searchBar];
	UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
	searchField.textColor = [UIColor blackColor];
	[searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
	searchField.font=[UIFont systemFontOfSize:14];
	//    [searchField setBackground:[DDFactory imageWithColor:UIColorFromRGB(228, 183, 20)]];
	//    [searchField setBackground:[DDFactory imageWithColor:[UIColor redColor]]];
	searchField.backgroundColor=UIColorFromRGB(236, 237, 238);
	UIImage *image = [UIImage imageNamed:@"ic_home_search"];
	UIImageView *iconView = [[UIImageView alloc] initWithImage:image];
	iconView.frame = CGRectMake(0, 0, image.size.width , image.size.height);
	searchField.leftView = iconView;
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(searchField.frame) - 10, CGRectGetWidth(searchField.frame) - 10)];
    [rightBtn setImage:IMG(@"ic_search_delete") forState:0];
    [rightBtn addTarget:self action:@selector(delegateInputText) forControlEvents:UIControlEventTouchUpInside];
    searchField.rightView = rightBtn;
    searchField.rightViewMode=UITextFieldViewModeWhileEditing;
	searchField.leftViewMode=UITextFieldViewModeAlways;
	self.navigationItem.titleView = _searchBar;
	
	[self addRightBarButtonItemWithTitle:@"取消" action:@selector(back)];

	_arrModel = [NSMutableArray array];
	[_tableView registerNib:[UINib nibWithNibName:SearchManufacturersCell_ bundle:nil] forCellReuseIdentifier:SearchManufacturersCell_];
	
	_tableView.backgroundColor = UIColorFromRGB(242, 242, 242);;
	[_tableView hideSurplusLine];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.tableFooterView=[UIView new];
	
	_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
	_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
 
}

-(void)back{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)delegateInputText{
    [_searchBar resignFirstResponder];
    _searchBar.text = nil;
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
	m.keyword = _searchBar.text;
	m.pageNumber = [NSString stringFromInt:_page];
	weakObj;
	[BaseServer postObjc:m path:@"/merchant/list" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
		
		__strong typeof (weakSelf) strongSelf = weakSelf;
		NSArray * tempArr = [NSArray yy_modelArrayWithClass:[ManufacturersModel class] json:result[@"data"][@"rows"]];
		NSMutableArray * arrTempAll = [NSMutableArray array];
		[arrTempAll addObjectsFromArray:tempArr];
		
		if (strongSelf.page == 1) {
			[strongSelf.arrModel removeAllObjects];
		}
		
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
	return _arrModel.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell * cell = nil;
	
	SearchManufacturersCell *headerCell = [tableView dequeueReusableCellWithIdentifier:SearchManufacturersCell_ forIndexPath:indexPath];
	[headerCell setModel:_arrModel[indexPath.section]];
	[headerCell setSelectionStyle:0];//不要分割线
	cell = headerCell;
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 58;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	 CatalugeListVC * VC =  [[CatalugeListVC alloc]init];
	 VC.model = _arrModel[indexPath.section];
	[self.navigationController pushViewController:VC animated:YES];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		SearchManufacturersHeaderView *headerView= [SearchManufacturersHeaderView instanceByFrame:CGRectMake(0, 0, SCREENHEIGHT, 60)];
		return headerView;
	}
	UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 5)];
	view.backgroundColor = [UIColor clearColor];

	return 	view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		
		return 60;
	}
	return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01)];
	
	view.backgroundColor = [UIColor clearColor];
	return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.01;
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	if ([text isEqualToString:@"\n"]){
		[searchBar resignFirstResponder];//按回车取消第一相应者
		[self getPage];
		return NO;
	}
	return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
