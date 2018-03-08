//  HomeVC.m
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "HomeVC.h"
#import "HomeHeaderCell.h"
#import "SellerCell.h"
#import "HotProductCell.h"
#import "NewsHeaderView.h"
#import "NewsCell.h"
#import "LoginVC.h"
#define HomeHeaderCell_ @"HomeHeaderCell"
#define SellerCell_ @"SellerCell"
#define HotProductCell_ @"HotProductCell"
#define NewsCell_ @"NewsCell"
#define NewsHeaderView_ @"NewsHeaderView"
#import "LeftTopHeadView.h"
#import "InteligentServiceView.h" 
#import "SearchProductVC.h"
#import "CatalugeListVC.h"
#import "ProductDetailVC.h"
#import "NewsDetailVC.h"
#import "NewsModel.h"
#import "WSLeftSlideManagerVC.h"
@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
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
   
    weakObj;
	_arrHomeHeaderModel = [NSMutableArray array];
	_arrMerchantModel = [NSMutableArray array];
    _arrAdvertModel = [NSMutableArray array];
    _arrNewsModel = [NSMutableArray array];
    LeftTopHeadView * headerView = [LeftTopHeadView headerViewWithFrame:CGRectMake(0, 0, 125, 48)];
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
	UITextField *searchField =  [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetWidth(headerView.frame),0, SCREENWIDTH - 100, 36)];
    [searchField setPlaceholder:@"    探索您心仪的宝贝"];
    searchField.delegate = self;
    searchField.layer.cornerRadius = 18;
    searchField.layer.masksToBounds = YES;
	[searchField setTextColor:UIColorFromHX(0xaaaaaa)];
	searchField.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:13];
	searchField.backgroundColor= UIColorFromHX(0xf1f1f1);
	UIImage *image = [UIImage imageNamed:@"ic_home_search"];
    
    UIView * iconView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, image.size.width  + 20, image.size.height)];
    iconView.userInteractionEnabled = NO;
	UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
	imgView.frame = CGRectMake(0, 0, image.size.width , image.size.height);
    [iconView addSubview:imgView];
	[searchField setRightView:iconView];
	searchField.rightViewMode = UITextFieldViewModeAlways;
	self.navigationItem.titleView = searchField;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
	[_tableView registerNib:[UINib nibWithNibName:HomeHeaderCell_ bundle:nil] forCellReuseIdentifier:HomeHeaderCell_];
	[_tableView registerNib:[UINib nibWithNibName:SellerCell_ bundle:nil] forCellReuseIdentifier:SellerCell_];
	[_tableView registerNib:[UINib nibWithNibName:HotProductCell_ bundle:nil] forCellReuseIdentifier:HotProductCell_];
	[_tableView registerNib:[UINib nibWithNibName:NewsCell_ bundle:nil] forCellReuseIdentifier:NewsCell_];
    
	_tableView.backgroundColor = UIColorFromRGB(242, 242, 242);;
	[_tableView hideSurplusLine];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	 
    [_tableView setSeparatorStyle:0];
	_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
	_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
    
    UIButton * serviceBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 60, SCREENHEIGHT/2.0 + 50, 60,60*23/19.0)];
    [serviceBtn setImage:IMG(@"ic_service") forState:0];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //去除导航NavigationBar的黑线条
    [self.navigationController.navigationBar  setShadowImage:[[UIImage alloc] init]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //设置黑线条
    [self.navigationController.navigationBar  setShadowImage:[DDFactory imageWithColor:UIColorFromRGB(234, 234, 234)]]; 
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
	m.number = @"16";//查询数量，默认6
	[BaseServer postObjc:m path:@"/merchant/host/list" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
		NSArray *arr =  [NSArray yy_modelArrayWithClass:[ManufacturersModel class] json:result[@"data"]];
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
    m.number = @"8";
    [BaseServer postObjc:m path:@"/commodity/host/list" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
        NSArray *arr =  [NSArray yy_modelArrayWithClass:[CollectionModel class] json:result[@"data"]];
        [weakSelf.arrAdvertModel removeAllObjects];
        [weakSelf.arrAdvertModel addObjectsFromArray:arr];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( weakSelf.tableView.numberOfSections>1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (weakSelf.arrAdvertModel.count >0) {
                        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }else{
                          [weakSelf.tableView reloadData];
                    } 
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
        if (strongSelf.page == 1) {
            [strongSelf.arrNewsModel removeAllObjects];
        }
        for (NSDictionary *dict in result[@"data"][@"rows"]) {
            if (((NSArray *)dict[@"list"]).count>0) {
                NewsModel * model = [NewsModel modelByDict:dict];
                [strongSelf.arrNewsModel addObject:model];
            }
        }
		dispatch_async(dispatch_get_main_queue(), ^{
            if ( strongSelf.tableView.numberOfSections>3) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        __strong typeof (weakSelf) strongSelf = weakSelf;
                    [strongSelf.tableView.mj_header endRefreshing];
                    [strongSelf.tableView.mj_footer endRefreshing]; 
                    [strongSelf.tableView reloadData];
                    if (strongSelf.arrNewsModel.count == [result[@"data"][@"total"] integerValue]) {
                        [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
//					[weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
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
	return _arrNewsModel.count + 3;//
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section >= 3) {
         NewsModel *model = _arrNewsModel[section - 3];
        return model.arrModel.count;
    }
    return 1;
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
        cell.selectionStyle = 0;
	}else if (indexPath.section == 1){
		SellerCell *sellerCell = [tableView dequeueReusableCellWithIdentifier:SellerCell_ forIndexPath:indexPath];
		[sellerCell setSellerArr:_arrMerchantModel];
		sellerCell.clickBlock = ^(NSInteger index, ManufacturersModel *model) {
			//进入对应的商家
			__strong typeof (weakSelf) strongSelf = weakSelf;
			CatalugeListVC * VC =  [[CatalugeListVC alloc]init]; 
			VC.model = model;
			[strongSelf.navigationController pushViewController:VC animated:YES];
		};
		 cell = sellerCell;
         cell.selectionStyle = 0;
	}else if (indexPath.section == 2){
//        AdvertCell *advertCell = [tableView dequeueReusableCellWithIdentifier:AdvertCell_ forIndexPath:indexPath];
//
//        [advertCell setAlertArr:_arrAdvertModel];
//        advertCell.clickBlock = ^(CollectionModel *model) {
//            __strong typeof (weakSelf) strongSelf = weakSelf;
//            ProductDetailVC *VC  = [[ProductDetailVC alloc] init];
//            VC.model  = model;
//            [strongSelf.navigationController pushViewController:VC animated:YES];
//        };
        HotProductCell * hotCell = [tableView dequeueReusableCellWithIdentifier:HotProductCell_ forIndexPath:indexPath];
        [hotCell setHotProudctArr:_arrAdvertModel];
        hotCell.clickBlock = ^(NSInteger index, CollectionModel *model) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            ProductDetailVC *VC  = [[ProductDetailVC alloc] init];
            VC.model  = model;
            [strongSelf.navigationController pushViewController:VC animated:YES];
        };
        hotCell.refreshBlock = ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf getArrAdvertModel];
        };
        hotCell.selectionStyle = 0;
        cell = hotCell;
    }else{
		NewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:NewsCell_ forIndexPath:indexPath];
        NewsModel *model = _arrNewsModel[indexPath.section - 3];
        [newsCell setNewsModel:model.arrModel[indexPath.row]];
         cell = newsCell;
         cell.selectionStyle = 0;
	}
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.section == 0) {
		return  SCREENWIDTH *260/1125.0;
	}
	if (indexPath.section == 1) {
        return [SellerCell getH];
	}
	if (indexPath.section == 2) {
		return  [HotProductCell getH];//
	}
	return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section >= 3) {
        NewsDetailVC *VC  =[[NewsDetailVC alloc]init];
        NewsModel *newsModel = _arrNewsModel[indexPath.section - 3];
        VC.model = newsModel.arrModel[indexPath.row];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01)];
	if (section == 0 || section == 1 || section == 2) {
		view.frame = CGRectMake(0, 0, SCREENWIDTH, 0.01);
		return view;
	}
    CGFloat hederH = 25;
    BOOL isShowSubTit = YES;
    if (section != 3) {
        hederH = 0;//不显示 后面的日期了
        isShowSubTit = NO;
    } 
    NewsHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NewsHeaderView_];
    if (!headerView) {
        headerView = [NewsHeaderView headerViewWithFrame:CGRectMake(5, 0, SCREENWIDTH - 10, hederH)];
    }
    NewsModel *model = _arrNewsModel[section - 3];
    [headerView setTime:model.date isShowSubTit:isShowSubTit];
	return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	if (section == 0 || section == 1 || section == 2) {
		return 0.01;
	}
    CGFloat hederH = 25;
    if (section != 3) {
        hederH = 0;
    }
	return hederH;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01)];
    view.backgroundColor = [UIColor clearColor];
	return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	
    return 0.01;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
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
