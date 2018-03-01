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
@interface InteractionVC ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate>

@property (strong, nonatomic)NSMutableArray *arrModel;
@property (assign, nonatomic)NSInteger page;
@property (weak, nonatomic)IBOutlet UITableView *tableview;
@property (strong, nonatomic)YBPopupMenu *popMenu;
@property (assign, nonatomic)BOOL isMyInteraction;// NO 全部 YES 我的
@end

@implementation InteractionVC

- (void)viewDidLoad {
	[super viewDidLoad];
	_arrModel = [[NSMutableArray alloc]init];
	[_tableview registerNib:[UINib nibWithNibName:InteractionCell_ bundle:nil]forCellReuseIdentifier:InteractionCell_];
	 _tableview.backgroundColor = self.view.backgroundColor = UIColorFromHX(0xf0f0f0);
	 _tableview.delegate = self;
	 _tableview.dataSource = self;
	[_tableview setSeparatorStyle:0];
	
	[_tableview hideSurplusLine]; 
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
    _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
    [self addRightBarButtonWithFirstImage:IMG(@"ic_top_add") action:@selector(addInteraction:)];
	[self getPage];
}

-(void)addInteraction:(UIButton *)btn{//添加互动
    weakObj;
    _popMenu = [YBPopupMenu showAtPoint:CGPointMake(SCREENWIDTH - CGRectGetWidth(btn.frame)/2.0 + 1, CGRectGetMaxY(btn.frame)) titles:@[@"发布动态",@"我的动态",@"全部动态"] icons:@[@"publismsg",@"mymsg",@"message"] menuWidth:150 otherSettings:^(YBPopupMenu *popupMenu) {
 
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
    if (index == 0) {
		VC = [[AddInteractionVC alloc]init];
 
    }else if (index == 1){
        _isMyInteraction = YES;
         [self getPage];
    }else{
        _isMyInteraction = NO;
        [self getPage];
    }
    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
    }
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
     m.own = @"1";//看所有的
    if (_isMyInteraction) {
        m.own = @"2";//看自己的
    }
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
			if (weakSelf.arrModel.count == [result[@"data"][@"total"] integerValue]) {
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
	
	return  [InteractionCell cellHByModel:_arrModel[indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	InteractionCell* cell =  [tableView dequeueReusableCellWithIdentifier:InteractionCell_ forIndexPath:indexPath];
    if (_isMyInteraction) {
        [cell setMyInteractionModel:_arrModel[indexPath.section]];
    }else{
        [cell setModel:_arrModel[indexPath.section]];
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
        CommentInteractionVC * VC = [[CommentInteractionVC alloc]init];
		VC.finishComBlock = ^(InteractionModel *interactionModel) {//评论完成 到这里 这里的评论数加1
			interactionModel.commentNumber = [NSString stringFromInt:[model.commentNumber integerValue] + 1];
			[strongSelf.tableview reloadSections:[NSIndexSet indexSetWithIndex:[strongSelf.arrModel indexOfObject:interactionModel]] withRowAnimation:UITableViewRowAnimationAutomatic];
		};
        VC.interactionModel = model;
        [strongSelf.navigationController pushViewController:VC animated:YES];
	};
    cell.deleteBlock = ^(InteractionModel *model) {
        
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
