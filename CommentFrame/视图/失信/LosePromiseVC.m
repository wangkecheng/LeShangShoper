//
//  LosePromiseVC.m
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "LosePromiseVC.h"
#import "LosePromiseCell.h"
#import "LosePromiseDetailVC.h"
#define LosePromiseCell_ @"LosePromiseCell"
#import "InteligentServiceView.h"
@interface LosePromiseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)NSMutableArray *arrModel;
@property (assign, nonatomic)NSInteger page;
@property (weak, nonatomic)IBOutlet UITableView *tableview;

@property (nonatomic, strong)DSAlert *alertControl;
@end

@implementation LosePromiseVC

- (void)viewDidLoad {
	[super viewDidLoad];
	
	 _arrModel = [[NSMutableArray alloc]init];
	[_tableview registerNib:[UINib nibWithNibName:LosePromiseCell_ bundle:nil]forCellReuseIdentifier:LosePromiseCell_];
	_tableview.backgroundColor =  UIColorFromRGB(242, 242, 242);
	_tableview.delegate = self;
	_tableview.dataSource = self;
	[_tableview setSeparatorStyle:0];
	
	[_tableview hideSurplusLine];
	
	_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
	_tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
	[self getPage];
    
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
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",result[@"data"][@"company"]]]];
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

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
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
	[BaseServer postObjc:m path:@"/dishonesty/list" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
		NSArray *tempArr = [NSArray yy_modelArrayWithClass:[LosePromissAndNewsModel class] json:result[@"data"][@"rows"]];
		if (weakSelf.page == 1) {
			[weakSelf.arrModel removeAllObjects];
		}
		[weakSelf.arrModel addObjectsFromArray:tempArr];
		dispatch_async(dispatch_get_main_queue(), ^{
			[weakSelf.tableview reloadData];
			[weakSelf.tableview.mj_header endRefreshing];
			[weakSelf.tableview.mj_footer endRefreshing];
			if (weakSelf.arrModel.count == [result[@"data"][@"total"] integerValue]) {
				[weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
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
	
	return  148;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	LosePromiseCell* cell =  [tableView dequeueReusableCellWithIdentifier:LosePromiseCell_ forIndexPath:indexPath];
	[cell setModel:_arrModel[indexPath.section]];
	[cell setSelectionStyle:0];
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    LosePromiseDetailVC *VC  =[[LosePromiseDetailVC alloc]initWithTitle:@"失信详情"];
    VC.model = _arrModel[indexPath.section];
    [self.navigationController pushViewController:VC animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UIView *view = [[UIView alloc]init];
	CGFloat H = 0.01; 
	[view setFrame:CGRectMake(0, 0, SCREENWIDTH, H)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	 
	return 0.01;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
