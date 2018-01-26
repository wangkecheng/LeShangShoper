
//
//  SpecialOfferListVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/16.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "SpecialOfferListVC.h"
#import "ProductDetailVC.h"
#import "CollectionCell.h"
#define CollectionCell_ @"CollectionCell"
#import "SearchProductVC.h"
@interface SpecialOfferListVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *priceImg;
@property (weak, nonatomic) IBOutlet UIImageView *hotImg;

@property (weak, nonatomic) IBOutlet UIButton *hotBtn;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic)NSInteger page;
@property(nonatomic,strong)NSMutableArray * arrModel;
@property(nonatomic,strong)NSString *sortkey;
@property(nonatomic,strong)NSString *sort;
@end

@implementation SpecialOfferListVC

- (void)viewDidLoad {
	[super viewDidLoad];
    [_priceBtn setEnlargeEdgeWithTop:5 right:20 bottom:5 left:20];
    [_hotBtn setEnlargeEdgeWithTop:5 right:20 bottom:5 left:20];
    _arrModel = [NSMutableArray array];
	UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 7, SCREENWIDTH - 100, 30)];
	[searchBar setPlaceholder:@"探索您心仪的宝贝"];
	searchBar.delegate = self;
	searchBar.layer.cornerRadius = 5;
	searchBar.layer.masksToBounds = YES;
	
	[DDFactory removeSearhBarBack:searchBar];
	UITextField *searchField = [searchBar valueForKey:@"_searchField"];
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
	searchField.leftViewMode=UITextFieldViewModeAlways;
	
	self.navigationItem.titleView = searchBar;
	[_tableView registerNib:[UINib nibWithNibName:CollectionCell_ bundle:nil] forCellReuseIdentifier:CollectionCell_];
     _tableView.backgroundColor = UIColorFromRGB(242, 242, 242);;
	[_tableView hideSurplusLine];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
	_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
    UIButton * btn = [self addRightBarButtonWithFirstImage:IMG(@"bg_special_zone") action:nil];
    btn.userInteractionEnabled = NO;
    [self getPage];
}

- (IBAction)priceSortAction:(UIButton *)sender {//价格
       _sortkey = @"price";
       _page = 1;
    [_hotImg setImage:IMG(@"ico_paihang")];
    if ([_sort isEqualToString:@"-1"]) {
         _sort = @"1";// 排序方式 1，正序 从高到低，2，逆序
        [_priceImg setImage:IMG(@"ico_paihangDescending")];
    }else{
        _sort = @"-1";
        [_priceImg setImage:IMG(@"ico_paihangAssent")];
    }
    [self getPage];
}

- (IBAction)hotSortAction:(UIButton *)sender {//热度
         _sortkey = @"hot";
         _page = 1;
        [_priceImg setImage:IMG(@"ico_paihang")];
    if ([_sort isEqualToString:@"-1"]) {
        _sort = @"1"; //1，非热门，2，热门，默认全部
        [_hotImg setImage:IMG(@"ico_paihangAssent")];
    }else{
        _sort = @"2";
        [_hotImg setImage:IMG(@"ico_paihangDescending")];
    }
       [self getPage];
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
    m.sort = _sort;
    m.sortKey = _sortkey;
	weakObj;
	[BaseServer postObjc:m path:@"/commodity/list" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
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
            if (strongSelf.arrModel.count == [result[@"data"][@"total"] integerValue]) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
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
	ProductDetailVC *VC  = [[ProductDetailVC alloc] init];
	CollectionModel * model = _arrModel[indexPath.row];
	VC.model  = model;
	[self.navigationController pushViewController:VC animated:YES];
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
	SearchProductVC * VC = [[SearchProductVC alloc]init];
	HDMainNavC * navi = (HDMainNavC *)self.navigationController;
	[navi pushVC:VC isHideBack:YES animated:YES];
	return NO;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end

