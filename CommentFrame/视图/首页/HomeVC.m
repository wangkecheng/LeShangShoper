//  HomeVC.m
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "HomeVC.h"
#import "HomeHeaderCell.h"
#import "SellerCell.h"
#import "AdvertCell.h"
#import "NewsHeaderView.h"
#import "NewsCell.h"
#import "LoginVC.h"
#define HomeHeaderCell_ @"HomeHeaderCell"
#define SellerCell_ @"SellerCell"
#define AdvertCell_ @"AdvertCell"
#define NewsCell_ @"NewsCell"
#import "LeftTopHeadView.h"
#import "InteligentServiceView.h"
#import "SearchProductVC.h"
@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic)NSInteger page;

@property(nonatomic,strong)NSMutableArray * arrNewsModel;
@property(nonatomic,strong)NSMutableArray * arrAdvertModel;
@property(nonatomic,strong)NSMutableArray * arrHomeHeaderModel;
@property(nonatomic,strong)NSMutableArray * arrMerchantModel;
@property (nonatomic, strong)DSAlert *alertControl;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_arrHomeHeaderModel = [NSMutableArray array];
	_arrMerchantModel = [NSMutableArray array];
    _arrAdvertModel = [NSMutableArray array];
    _arrNewsModel = [NSMutableArray array];
	weakObj;
	LeftTopHeadView * headerView = [LeftTopHeadView headerViewWithFrame:CGRectMake(0, 0, 100, 44)];
	headerView.leftTopHeaderViewBlock = ^{
		__strong typeof (weakSelf) strongSelf = weakSelf;
		UserInfoModel * model  = [CacheTool getUserModel];
		if (model.isMember) {//如果存在 就是侧滑
			[[DDFactory factory]broadcast:nil channel:LeftSildeAction];//打开侧滑
			return;
		}
		LoginVC * loginVC = [[LoginVC alloc]init];
		[strongSelf presentViewController:loginVC animated:YES completion:nil];
	};
	 
	[self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:headerView]];
	
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
	
	[_tableView registerNib:[UINib nibWithNibName:HomeHeaderCell_ bundle:nil] forCellReuseIdentifier:HomeHeaderCell_];
	[_tableView registerNib:[UINib nibWithNibName:SellerCell_ bundle:nil] forCellReuseIdentifier:SellerCell_];
	[_tableView registerNib:[UINib nibWithNibName:AdvertCell_ bundle:nil] forCellReuseIdentifier:AdvertCell_];
	[_tableView registerNib:[UINib nibWithNibName:NewsCell_ bundle:nil] forCellReuseIdentifier:NewsCell_];
	
	_tableView.backgroundColor = UIColorFromRGB(242, 242, 242);;
	[_tableView hideSurplusLine];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	 
	_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
	_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
    
    UIButton * serviceBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 60, SCREENHEIGHT/2.0 + 50, 60,60*23/19.0)];
    [serviceBtn setImage:IMG(@"ic_service.png") forState:0];
    [serviceBtn addTarget:self action:@selector(serviceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serviceBtn];
    
          [self getPage];
  
//    InteligentServiceAlertView *alertView = [InteligentServiceAlertView instanceByFrame:CGRectMake(0, 0, SCREENWIDTH - 50, (SCREENWIDTH - 50)*482/610.0) WXClickBlock:^BOOL{
//
//        return YES;
//    } PhClickBlock:^BOOL{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:18783999629"]];
//        return YES;
//    }];
//    [self.view addSubview:alertView]; //改用按钮的方式
  
}

-(void)serviceAction{//智能服务
        weakObj;
    
    InteligentServiceAlertView *alertView = [InteligentServiceAlertView instanceByFrame:CGRectMake(0, 0, SCREENWIDTH - 50, (SCREENWIDTH - 50)*482/610.0) WXClickBlock:^BOOL{
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.alertControl ds_dismissAlertView];
        return YES;
    } PhClickBlock:^BOOL{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:18783999629"]];
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.alertControl ds_dismissAlertView];
        return YES;
    }];
    _alertControl = [[DSAlert alloc]initWithCustomView:alertView];
}
- (void)getPage{
	
	[self getData:1];
	[self getAdvertismentData];
	[self getMerchantData];
    [self getArrAdvertModel];
}
//广告数据请求
-(void)getAdvertismentData{
	weakObj;
	[BaseServer postObjc:nil path:@"/advert/home/list" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
		NSArray *arr =  [NSArray yy_modelArrayWithClass:[HomeHeaderModel class] json:result[@"data"]];
		[weakSelf.arrHomeHeaderModel removeAllObjects];
		[weakSelf.arrHomeHeaderModel addObjectsFromArray:arr];
		dispatch_async(dispatch_get_main_queue(), ^{
            if ( weakSelf.tableView.numberOfSections>0) {
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[weakSelf.tableView reloadData];
//					[weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
				});
				
			}
		});
	} failed:^(NSError *error) {
		
	}];
}

//热门商家
-(void)getMerchantData{
	weakObj;
	HDModel * m = [HDModel model];
	m.number = @"6";//查询数量，默认6
	[BaseServer postObjc:m path:@"/merchant/host/list" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
		NSArray *arr =  [NSArray yy_modelArrayWithClass:[SellerModel class] json:result[@"data"]];
		[weakSelf.arrMerchantModel removeAllObjects];
		[weakSelf.arrMerchantModel addObjectsFromArray:arr];
		dispatch_async(dispatch_get_main_queue(), ^{
            if ( weakSelf.tableView.numberOfSections>1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                      [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
					[weakSelf.tableView reloadData];
				});
            }
		});
	} failed:^(NSError *error) {
		
	}];
}

-(void)getArrAdvertModel{//热门商品
    weakObj;
    HDModel * m = [HDModel model];
    [BaseServer postObjc:m path:@"/commodity/host/list" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
        NSArray *arr =  [NSArray yy_modelArrayWithClass:[AdvertModel class] json:result[@"data"]];
        [weakSelf.arrAdvertModel removeAllObjects];
        [weakSelf.arrAdvertModel addObjectsFromArray:arr];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( weakSelf.tableView.numberOfSections>1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
						[weakSelf.tableView reloadData];
//					[weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }
        });
    } failed:^(NSError *error) {
        
    }];
}
- (void)getNextPage{
	
	[self getData:_page + 1];
}
- (void)getData:(NSInteger)pageIndex{
	_page = pageIndex;
	HDModel *m = [HDModel model];
    m.pageNumber = [NSString stringFromInt:pageIndex];
	weakObj;
	[BaseServer postObjc:m path:@"/news/list" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
		
		__strong typeof (weakSelf) strongSelf = weakSelf;
		NSArray * tempArr = [NSArray yy_modelArrayWithClass:[NewsModel class] json:result[@"data"][@"rows"]];
		if (strongSelf.page == 1) {
			[strongSelf.arrNewsModel removeAllObjects];
		}
		[strongSelf.arrNewsModel addObjectsFromArray:tempArr];
		
		dispatch_async(dispatch_get_main_queue(), ^{
            if ( weakSelf.tableView.numberOfSections>3) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[weakSelf.tableView reloadData];
//					[weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }
			[strongSelf.tableView.mj_header endRefreshing];
			[strongSelf.tableView.mj_footer endRefreshing];
            if (strongSelf.page == [result[@"data"][@"pageNumber"] integerValue]) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
//            [strongSelf.tableView setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:YES];
//            if (strongSelf.arrModel.count == 0) {
//                [strongSelf.tableView setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:NO];
//            }
		});
	} failed:^(NSError *error) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		[strongSelf.tableView.mj_header endRefreshing];
		[strongSelf.tableView.mj_footer endRefreshing];
	}];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 4;//
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section != 3) {
		return 1;
	}else{
		return _arrNewsModel.count;
	}
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell * cell = nil;
	weakObj;
	if (indexPath.section == 0) {
		HomeHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:HomeHeaderCell_ forIndexPath:indexPath];
		[headerCell setSelectionStyle:0];//不要分割线
		[headerCell setArrModel:_arrHomeHeaderModel];
		[headerCell setClickBlock:^(NSString *str) {
			
		}];
		cell = headerCell;
	}else if (indexPath.section == 1){
		SellerCell *sellerCell = [tableView dequeueReusableCellWithIdentifier:SellerCell_ forIndexPath:indexPath];
		[sellerCell setSellerArr:_arrMerchantModel];
		sellerCell.clickBlock = ^(NSInteger index, SellerModel *model) {
			//进入对应的商家
		};
		
		cell = sellerCell;
	}else if (indexPath.section == 2){
		AdvertCell *advertCell = [tableView dequeueReusableCellWithIdentifier:AdvertCell_ forIndexPath:indexPath];
		 
		[advertCell setAlertArr:_arrAdvertModel];
		advertCell.clickBlock = ^(AdvertModel *model) {
			
		};
		cell = advertCell;
	}else if (indexPath.section == 3){
		NewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:NewsCell_ forIndexPath:indexPath];
        [newsCell setNewsModel:_arrNewsModel[indexPath.row]];
         cell = newsCell;
	}
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.section == 0) {
		return  200;
	}
	if (indexPath.section == 1) {
		return   (CGRectGetWidth(tableView.frame) - 60)/3.0 + 40 + 50 ;
	}
	if (indexPath.section == 2) {
		return  50;
	}
	return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01)];
	if (section == 0 || section == 1 || section == 2) {
		view.frame = CGRectMake(0, 0, SCREENWIDTH, 0.01);
		return view;
	}
	NewsHeaderView *hewdderView = [NewsHeaderView headerViewWithFrame:CGRectMake(5, 0, SCREENWIDTH - 10, 75)];
	return hewdderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	if (section == 0 || section == 1 || section == 2) {
		return 0.01;
	}
	return 75;
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
