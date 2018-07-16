
//
//  SpecialOfferListVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/16.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "SpecialOfferListVC.h"
#import "ProductDetailVC.h"
#import "ProductDetailListCell.h"
#import "SearchProductVC.h"
#define ProductDetailListCell_ @"ProductDetailListCell"
#import "InteligentServiceView.h"
@interface SpecialOfferListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *priceImg;
@property (weak, nonatomic) IBOutlet UIImageView *hotImg;

@property (weak, nonatomic) IBOutlet UIButton *hotBtn;
 
@property (assign, nonatomic)NSInteger page;
@property(nonatomic,strong)NSMutableArray * arrModel;
@property(nonatomic,strong)NSString *sortkey;
@property(nonatomic,strong)NSString *sort;
@property (nonatomic, strong)DSAlert *alertControl;
@end

@implementation SpecialOfferListVC

- (void)viewDidLoad {
	[super viewDidLoad];
    weakObj;
   
    [_priceBtn setEnlargeEdgeWithTop:5 right:20 bottom:5 left:20];
    [_hotBtn setEnlargeEdgeWithTop:5 right:20 bottom:5 left:20];
    _arrModel = [NSMutableArray array];
    UITextField *searchField =  [[UITextField alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH - 100, 36)];
    [searchField setPlaceholder:@"    探索您心仪的宝贝"];
    searchField.delegate = self;
    searchField.layer.cornerRadius = 18;
    searchField.layer.masksToBounds = YES;
    [searchField setTextColor:UIColorFromHX(0xaaaaaa)];
    searchField.font=[UIFont fontWithName:@"PingFangSC-Medium" size:13]==nil?[UIFont systemFontOfSize:13]:[UIFont fontWithName:@"PingFangSC-Medium" size:13];
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
    
    _collectionView.backgroundColor = UIColorFromHX(0xf0f0f0);
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = YES;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:ProductDetailListCell_ bundle:nil]forCellWithReuseIdentifier:ProductDetailListCell_];
    
    [_flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    _flowlayout.minimumInteritemSpacing = 10;//同一行
    _flowlayout.minimumLineSpacing = 10;//同一列
	
	_collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
	_collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNextPage)];
    UIButton * btn = [self addRightBarButtonWithFirstImage:IMG(@"bg_special_zone") action:nil];
    btn.userInteractionEnabled = NO;
    [self getPage];
    
    [[DDFactory factory]addObserver:self selector:@selector(collectionAction:) channel:CollectionActionBroadCast];//接收收藏通知
    
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

-(void)collectionAction:(NSNotification *)notify{
    [[DDFactory factory]removeChannel:CollectionActionBroadCast];;
    CollectionModel * model = notify.object;
    if ([model isKindOfClass:[CollectionModel class]]) {
        for (CollectionModel * modelT in _arrModel) {
            if ([model.cid isEqualToString:modelT.cid] ) {
                modelT.collect  = model.collect;
                [self reloadItemDataIndex:[_arrModel indexOfObject:modelT] section:0];
                break;
            }
        }
    }else{
        [_collectionView reloadData];
    }
}
- (IBAction)priceSortAction:(UIButton *)sender {//价格
       _sortkey = @"price";
       _page = 1;
    [_hotImg setImage:IMG(@"ico_paihang")];
    if ([_sort isEqualToString:@"1"]) {
         _sort = @"-1";// 排序方式 1，正序 从高到低，2，逆序
        [_priceImg setImage:IMG(@"ico_paihangDescending")];
    }else{
        _sort = @"1";
        [_priceImg setImage:IMG(@"ico_paihangAssent")];
    }
    [self getPage];
}

- (IBAction)hotSortAction:(UIButton *)sender {//热度
         _sortkey = @"browseNumber";
         _page = 1;
        [_priceImg setImage:IMG(@"ico_paihang")];
    if ([_sort isEqualToString:@"1"]) {
        _sort = @"-1"; //1，非热门，2，热门，默认全部
        [_hotImg setImage:IMG(@"ico_paihangAssent")];
    }else{
        _sort = @"1";
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
    m.bargain = @"2";
	weakObj;
	[BaseServer postObjc:m path:@"/commodity/list" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		NSArray * tempArr = [NSArray yy_modelArrayWithClass:[CollectionModel class] json:result[@"data"][@"rows"]];
		
		if (strongSelf.page == 1) {
			[strongSelf.arrModel removeAllObjects];
		}
		[strongSelf.arrModel addObjectsFromArray:tempArr];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[strongSelf.collectionView reloadData];
            [strongSelf.collectionView.mj_header endRefreshing];
            [strongSelf.collectionView.mj_footer endRefreshing];
            if (strongSelf.arrModel.count == [result[@"data"][@"total"] integerValue]) {
                [strongSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
			[strongSelf.collectionView setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:YES];
			if (strongSelf.arrModel.count == 0) {
				[strongSelf.collectionView setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:NO];
			}
		});
	} failed:^(NSError *error) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		[strongSelf.collectionView.mj_header endRefreshing];
		[strongSelf.collectionView.mj_footer endRefreshing];
	}];
}


//设置每一组cell的个数(组数默认是1 )
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  _arrModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    weakObj;
    ProductDetailListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductDetailListCell_ forIndexPath:indexPath];
    [cell setModel: _arrModel[indexPath.row]];
    cell.collectionBlock = ^BOOL(CollectionModel *model) {
        __strong typeof (weakSelf) strongSelf  = weakSelf;
        if ([CacheTool isToLoginVC:strongSelf]) {
            return YES;//方法内部做判断
        }
        HDModel *m = [HDModel model];
        m.cid = model.cid;
        weakObj;
        if ([model.collect integerValue] == 1) {
                model.collect = @"2";
            [BaseServer postObjc:m path:@"/commodity/collect" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.view makeToast:@"收藏成功"];
                });
            } failed:^(NSError *error) {
                
            }];
        }else{//取消收藏
            model.collect = @"1";
            [BaseServer postObjc:m path:@"/commodity/collect/remove" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
                dispatch_async(dispatch_get_main_queue(), ^{
            
                    [strongSelf.view makeToast:@"取消成功"];
                });
            } failed:^(NSError *error) {
                
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
       
            [strongSelf reloadItemDataIndex:[strongSelf.arrModel indexOfObject:model] section:0];
        });
        return YES;
    };
    return  cell;
}
-(void)reloadItemDataIndex:(NSInteger)index section:(NSInteger)section{
     [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:section]]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellW = (CGRectGetWidth(collectionView.frame) - 32) /2.0 ;
    CGFloat cellH  =  cellW *16.0/11;
    return   CGSizeMake(cellW,cellH);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductDetailVC *VC  = [[ProductDetailVC alloc] init];
    weakObj;
    VC.collectActionBlock = ^(CollectionModel *model, BOOL isCollect) {
        __strong typeof (weakSelf) strongSelf  = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (int i = 0; i<strongSelf.arrModel.count; i++) {
                CollectionModel *modelT =    strongSelf.arrModel[i];
                if ([model.cid isEqualToString:modelT.cid]) {
                    if (isCollect) {//
                        modelT.collect = @"2";
                    }else{
                        modelT.collect = @"1";
                    }
                    [strongSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[strongSelf.arrModel indexOfObject:modelT] inSection:0]]];
                    break;
                }
            }
        });
    };
    CollectionModel * model = _arrModel[indexPath.row];
    VC.model  = model;
    model.browseNumber = [NSString stringFromInt:[model.browseNumber integerValue] + 1];
    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_arrModel indexOfObject:model] inSection:0]]];//点击一次 加一次浏览量
    [self.navigationController pushViewController:VC animated:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //打开搜索界面
    [self toSearchVC];
    return NO;
}
-(void)toSearchVC{
    SearchProductVC * VC = [[SearchProductVC alloc]init];
    VC.isBargin = YES;
    HDMainNavC * navi = (HDMainNavC *)self.navigationController;
    [navi pushVC:VC isHideBack:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end

