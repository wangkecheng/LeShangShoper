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
#import "CommentInteractionVC.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
#import "YBPopupMenu.h"
#import "MyInteractionVC.h"
#import "InteligentServiceView.h" 
@interface InteractionVC ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate>

@property (strong, nonatomic)NSMutableArray *arrModel;
@property (assign, nonatomic)NSInteger page;
@property (weak, nonatomic)IBOutlet UITableView *tableview;
@property (strong, nonatomic)YBPopupMenu *popMenu;
@property (assign, nonatomic)BOOL isMyInteraction;// NO 全部 YES 我的
@property (nonatomic, strong)DSAlert *alertControl;
@end

@implementation InteractionVC

- (void)viewDidLoad {
	[super viewDidLoad];
	 _arrModel = [[NSMutableArray alloc]init];
	 _tableview.backgroundColor = self.view.backgroundColor = UIColorFromHX(0xf0f0f0);
	 _tableview.delegate = self;
	 _tableview.dataSource = self;
	[_tableview setSeparatorStyle:0];
    
    [_tableview registerNib:[UINib nibWithNibName:InteractionCell_ bundle:nil]forCellReuseIdentifier:InteractionCell_];
	
	[_tableview hideSurplusLine]; 
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
    _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
    [self addRightBarButtonWithFirstImage:IMG(@"ic_top_add") action:@selector(addInteraction:)];
	[self getPage];
    
    UIButton * serviceBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 60, SCREENHEIGHT/2.0 + 50, 60,60*23/19.0)];
    [serviceBtn setImage:IMG(@"ic_service") forState:0];
    [serviceBtn addTarget:self action:@selector(serviceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serviceBtn];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    weakObj;
    self.finishLoginBlock = ^{//登录完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf getPage];
        });
    };
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

-(void)addInteraction:(UIButton *)btn{//添加互动
    weakObj;
    CGFloat y = CGRectGetMaxY(btn.frame);
    if ([[[DDFactory getCurrentDeviceModel] uppercaseString]containsString:@"IPX"]) {
        y += 28;
    }//,@"全部动态" ,@"message"
      _popMenu = [YBPopupMenu showAtPoint:CGPointMake(SCREENWIDTH - CGRectGetWidth(btn.frame)/2.0 + 1, y) titles:@[@"发布动态",@"我的动态",@"全部动态"] icons:@[@"publismsg",@"mymsg",@"message"] menuWidth:150 otherSettings:^(YBPopupMenu *popupMenu) {
 
        __strong typeof (weakSelf) strongSelf = weakSelf;
        popupMenu.dismissOnSelected = YES;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = strongSelf;
        popupMenu.offset = 10;
        popupMenu.cornerRadius = 0;
        popupMenu.type = YBPopupMenuTypeDark;
        popupMenu.rectCorner = UIRectCornerAllCorners;
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
    }];
}  //推荐用这种写法

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    HDBaseVC *VC = nil;
    weakObj;
    if (index == 0) {
        VC = [[AddInteractionVC alloc]initWithBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf getPage];
            });
        }];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (index == 1){
        _isMyInteraction = YES;
        _page = 1;
        VC  = [[MyInteractionVC alloc]init];
        HDMainNavC * navi = (HDMainNavC *)self.navigationController;
        [navi pushVC:VC isHideBack:YES isHideTabBar:NO animated:YES];
        [self.tabBarController setHidesBottomBarWhenPushed:NO];
    }else{
         _page = 1;
        _isMyInteraction = NO;
    }
    
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
     m.own = @"1";//看所有的
//    if (_isMyInteraction) {
//        m.own = @"2";//看自己的
//    }
    if (_page == 1) {
        [_arrModel removeAllObjects];
    }
	weakObj;
	[BaseServer postObjc:m path:@"/interact/list" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
		NSArray *tempArr = [NSArray yy_modelArrayWithClass:[InteractionModel class] json:result[@"data"][@"rows"]];
     
		[strongSelf.arrModel addObjectsFromArray:tempArr];
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        for (InteractionModel * model in strongSelf.arrModel) {
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                model.cellH = [InteractionCell cellHByModel:model];
                dispatch_group_leave(group);
            });
        }
        dispatch_group_notify(group, queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{ //通知主线程刷新
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.tableview reloadData];
            });
        });
        dispatch_async(dispatch_get_main_queue(), ^{ //通知主线程刷新
             __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableview.mj_header endRefreshing];
            [strongSelf.tableview.mj_footer endRefreshing];
            if (strongSelf.arrModel.count == [result[@"data"][@"total"] integerValue]) {
                [strongSelf.tableview.mj_footer endRefreshingWithNoMoreData];
            }
            [strongSelf.tableview setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:YES];
            if (strongSelf.arrModel.count == 0) {
                [strongSelf.tableview setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:NO];
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
    if (_arrModel.count >0) {
        InteractionModel *model =  _arrModel[indexPath.section];
        return  model.cellH;//[InteractionCell cellHByModel:model];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSString *CellIdentifier = [NSString stringWithFormat:@"allCell%ld%ld",indexPath.section,indexPath.row];// 定义cell标识  每个cell对应一个自己的标识
	InteractionCell* cell =  [tableView dequeueReusableCellWithIdentifier:InteractionCell_ forIndexPath:indexPath];// 通过不同标识创建cell实例
//    if (!cell) {// 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
//      cell= (InteractionCell *)[[[NSBundle  mainBundle] loadNibNamed:@"InteractionCell" owner:self options:nil]  lastObject];
//    }
    if (_arrModel.count > 0) {
        if (_isMyInteraction) {
            [cell setMyInteractionModel:_arrModel[indexPath.section]];
        }else{
            [cell setModel:_arrModel[indexPath.section]];
        }
    } 
	[cell setSelectionStyle:0];
	weakObj;
    cell.seeBigImgBlock = ^(InteractionModel *model, NSInteger index) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        NSMutableArray* tmps = [NSMutableArray array];
       
        for (int i = 0;i< model.imageUrls.count;i++) {//找出所有图片
            LWImageBrowserModel* broModel = [[LWImageBrowserModel alloc]  initWithplaceholder:IMG(@"Icon") thumbnailURL:IMGURL(model.imageUrls[i]) HDURL:IMGURL(model.imageUrls[i]) containerView:self.view
                positionInContainer:self.view.frame index:i];
            [tmps addObject:broModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            LWImageBrowser* browser = [[LWImageBrowser alloc]
                                       initWithImageBrowserModels:tmps
                                       currentIndex:index];
            browser.isScalingToHide = NO;
            browser.isShowSaveImgBtn = YES;
            [browser show];
        });
    };
    cell.seeAllBlock = ^(InteractionModel *model) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:[strongSelf.arrModel indexOfObject:model]] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
	cell.pardiseBlock = ^(InteractionModel *model) {
          __strong typeof (weakSelf) strongSelf = weakSelf;
        if ([CacheTool isToLoginVC:strongSelf]) {
            return;//方法内部做判断
        }
		HDModel * m = [HDModel model];
		m.interactId = model.interactId; 
		[BaseServer postObjc:m path:@"/interact/give" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
            
            model.giveNumber = [NSString stringFromInt:[model.giveNumber integerValue] + 1];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:[strongSelf.arrModel indexOfObject:model]] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
		} failed:^(NSError *error) {
			
		}];
	};
    
	cell.commentBlock = ^(InteractionModel *model) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
        if ([CacheTool isToLoginVC:strongSelf]) {
            return;//方法内部做判断
        }
        CommentInteractionVC * VC = [[CommentInteractionVC alloc]init];
		VC.finishComBlock = ^(InteractionModel *interactionModel) {//评论完成 到这里 这里的评论数加1
			interactionModel.commentNumber = [NSString stringFromInt:[model.commentNumber integerValue] + 1];
			[strongSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:[strongSelf.arrModel indexOfObject:interactionModel]] withRowAnimation:UITableViewRowAnimationAutomatic];
		};
        VC.interactionModel = model;
        [strongSelf.navigationController pushViewController:VC animated:YES];
	};
    cell.deleteBlock = ^(InteractionModel *model) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if ([CacheTool isToLoginVC:strongSelf]) {
            return;//方法内部做判断
        }
        HDModel * m = [HDModel model];
        m.did = model.interactId;
        [BaseServer postObjc:m path:@"/interact/remove" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.arrModel removeObject:model];
                [strongSelf.tableview reloadData];
            });
        } failed:^(NSError *error) {
            
        }];
    };
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UIView *view = [[UIView alloc]init];
	CGFloat H = 10;
	[view setFrame:CGRectMake(0, 0, SCREENWIDTH, H)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		return 0;
	}
	return 10;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
@end
