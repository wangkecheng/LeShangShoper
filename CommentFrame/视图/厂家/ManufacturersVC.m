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

#import "InteligentServiceView.h"
#import "UITableView+SCIndexView.h"
@interface ManufacturersVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic)NSInteger page;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property(nonatomic,strong)NSMutableArray * arrModel;

@property (nonatomic, strong)DSAlert *alertControl;

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
    _tableView.sc_indexViewConfiguration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
    _tableView.sc_translucentForTableViewInNavigationBar = YES;
    UIButton * serviceBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 60, SCREENHEIGHT/2.0 + 50, 60,60*23/19.0)];
    [serviceBtn setImage:IMG(@"ic_service") forState:0];
    [serviceBtn addTarget:self action:@selector(serviceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serviceBtn];
}

-(void)serviceAction{//智能服务
    weakObj;
    InteligentServiceAlertView *alertView = [InteligentServiceAlertView instanceByFrame:CGRectMake(0, 0, SCREENWIDTH - 50, (SCREENWIDTH - 50)*580/606.0) WXClickBlock:^BOOL{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.alertControl ds_dismissAlertView];
        [BaseServer postObjc:nil path:@"/user/contact/tel" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
            __strong typeof (weakSelf) strongSelf  = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = result[@"data"][@"weixin"];
                [strongSelf.view makeToast:@"客服微信复制成功，请到微信添加好友"]; 
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSURL *url = [NSURL URLWithString:@"weixin://"] ;
                    if (![[UIApplication sharedApplication] canOpenURL:url]){
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                        
                    }
                    [[UIApplication sharedApplication] openURL:url];
                });
            });
            
        } failed:^(NSError *error) {
        }];
        return YES;
    } PhClickBlock:^BOOL{
        weakObj;
        [BaseServer postObjc:nil path:@"/user/contact/tel" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
            __strong typeof (weakSelf) strongSelf  = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",result[@"data"][@"custormer"]]]];
            });
        } failed:^(NSError *error) {
        }];
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.alertControl ds_dismissAlertView];
        return YES;
    }];
    _alertControl = [[DSAlert alloc]initWithCustomView:alertView];
    _alertControl.isTouchEdgeHide = YES;
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
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *descriptors = [NSArray arrayWithObject:descriptor];
        NSArray *resultArray = [tempArr sortedArrayUsingDescriptors:descriptors];
        NSMutableArray *indexNameArr = [NSMutableArray array];
        for (AlphabetTitleModel * model in resultArray) {
            [indexNameArr addObject:model.name];
        }
        strongSelf.tableView.sc_indexViewDataSource  = indexNameArr.copy;//设置索引
        
		if (strongSelf.page == 1) {
		    [strongSelf.arrModel removeAllObjects];
		}
		[strongSelf.arrModel addObjectsFromArray:resultArray];
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
    ManufacturersModel *model = alphabetTitleModel.childrenArrModel[indexPath.row];
	[headerCell setModel:model];
    [headerCell setLineViewAlpah:YES];
    if (model == [alphabetTitleModel.childrenArrModel lastObject]) {
         [headerCell setLineViewAlpah:NO];
    }
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
