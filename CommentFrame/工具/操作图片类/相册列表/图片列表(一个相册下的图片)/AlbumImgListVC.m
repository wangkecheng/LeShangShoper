//
//  AlbumImgListVC.m
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "AlbumImgListVC.h"
#import "ImgCell.h"
#define ImgCell_ @"ImgCell"

#import "LWImageBrowser.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define NavigationBarH 20
//设置可添加图片最多个数!!!
#define kMaxImageCount 9

typedef void(^SelectBlock)(NSMutableArray *);
@interface AlbumImgListVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)PHFetchResult<PHAsset *> *currntAlbumAssets;//当前相册下所有的PHAsset集合

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowOut;
@property (nonatomic, strong) NSMutableArray *arrModel;
@property (nonatomic, copy) SelectBlock selectBlock;
@property(nonatomic,assign)NSInteger maxCount;

@property (nonatomic, strong) NSMutableArray *arrSelected;

@property(nonatomic,strong) NSMutableArray *imgViewArray;
@end

@implementation AlbumImgListVC
- (id)initWithCollection:(PHAssetCollection *)collection
			 selectedArr:(NSMutableArray *)arrSelected
				maxCount:(NSInteger)maxCount
			 selectBlock:(void(^)(NSMutableArray<ImgModel *> *imgModel))selectBlock{
	
	if (self = [super init]) {
		self.title =  collection.localizedTitle;
		_arrModel = [NSMutableArray array];
		_currntAlbumAssets = [WSPHPhotoLibrary enumerateAssetsInAssetCollection:collection];
		for (PHAsset * asset in [WSPHPhotoLibrary enumerateAssetsInAssetCollection:collection]) {
			ImgModel *model = [ImgModel modelByAsset:asset];
			[_arrModel addObject:model];
		}
		_selectBlock = selectBlock;
		_maxCount = maxCount;
		_arrSelected =  arrSelected;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_flowOut.sectionInset = UIEdgeInsetsZero;
	_flowOut.minimumInteritemSpacing = 5;
	_flowOut.minimumLineSpacing = 5;
	
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	_collectionView.showsVerticalScrollIndicator = NO;
	_collectionView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:_collectionView];
	
	[_collectionView registerNib:[UINib nibWithNibName:ImgCell_ bundle:nil] forCellWithReuseIdentifier:ImgCell_];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(actionRightBar)];
	self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self changeTitle];
	[_collectionView reloadData];
}


#pragma mark - 改变标题
- (void)changeTitle{
	self.title = [NSString stringWithFormat:@"%ld/%ld",(long)self.arrSelected.count, _maxCount];
	if (_selectBlock) {
		_selectBlock(_arrSelected);
	}//选择一次  就调用一次block  在block实现方法中可以做操作
}

- (void)actionRightBar {
	
	if (_selectBlock) {
		_selectBlock(_arrSelected);
	}
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	return _arrModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	ImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImgCell_ forIndexPath:indexPath];
	ImgModel * model = _arrModel[indexPath.row];
		model.isSelect = NO;
	for (ImgModel * modelT in _arrSelected) {
		if ([model.asset.localIdentifier isEqualToString:modelT.asset.localIdentifier]) {
			model.isSelect = YES;
		}
	}
	[cell setModel:model];
	 
	__weak typeof(self) weakSelf = self;
	cell.selcetBlock = ^(ImgModel * model) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		for (ImgModel *modelT in strongSelf.arrSelected) {
			if ([modelT.asset.localIdentifier isEqualToString:model.asset.localIdentifier] ) {
				[strongSelf.arrSelected removeObject:modelT];//表示是取消选择 注意这里不能remove model不是同一个对象
				[strongSelf changeTitle];
				return NO;//返回NO 表示未已经到达最大数
			}
		}
		if (strongSelf.arrSelected.count <  _maxCount){//没满上限就添加
			[strongSelf.arrSelected addObject:model];
		}else{//满了上限 就不添加，提示
			//                [weakSelf.view makeToast:[NSString stringWithFormat:@"只能选择%ld张图片",_maxCount]];
			[strongSelf changeTitle];
			return YES;//选择数达到最大，将刚点击的那一项取消选择
		}
		[strongSelf changeTitle];
		return NO;//返回NO 表示未已经到达最大数
	};
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	//点击放大查看 可滑动
	ImgCell *cell = (ImgCell*)[collectionView cellForItemAtIndexPath:indexPath];
	NSMutableArray *arr = [NSMutableArray arrayWithCapacity:_arrModel.count];
	for (ImgModel * model in _arrModel) {
		LWImageBrowserModel* broModel = [[LWImageBrowserModel alloc]
										 initWithplaceholder:model.bigImage
										 thumbnailURL:nil
										 HDURL:nil
										 containerView:cell.contentView
										 positionInContainer:cell.contentView.frame
										 index:indexPath.row];
		[arr addObject:broModel];
	}
	
	LWImageBrowser* browser = [[LWImageBrowser alloc]
							   initWithImageBrowserModels:arr
							   currentIndex:indexPath.row];
	browser.isScalingToHide = NO;
	browser.isShowPageControl = NO;
	browser.isShowSaveImgBtn = NO;
	[browser show];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	float wid = CGRectGetWidth(self.collectionView.bounds);
	return CGSizeMake((wid-3*5)/4, (wid-3*5)/4);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}
@end

