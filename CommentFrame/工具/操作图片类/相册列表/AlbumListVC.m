//  AlbumListVC.m
//  SaveImg
//
//  Created by warron on 2017/12/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "AlbumListVC.h"
#import "AlbumListCell.h"
#import "AlbumImgListVC.h"
#import "ImgModel.h"
#define AlbumListCell_ @"AlbumListCell"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define NavigationBarH 20
typedef void(^SelectBlock)(NSMutableArray *);
@interface AlbumListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrGroup;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) SelectBlock selectBlock;
@property (nonatomic, strong) NSMutableArray *arrSelected;//这个是一个指针 指向传过来的 arrSelected

@property(nonatomic,assign)NSInteger maxCout;//图片总数量限制
@end

@implementation AlbumListVC

- (id)initWithArrSelected:(NSMutableArray *)arrSelected
				  maxCout:(NSInteger)maxCout
			  selectBlock:(void(^)(NSMutableArray<ImgModel *> * imgModelArr))selectBlock{
	
	if (self = [super init]) {
		_maxCout = maxCout;
		_arrSelected =  arrSelected;
		_arrGroup = [[NSMutableArray alloc]init];
		_selectBlock = selectBlock;
		for (PHAssetCollection *collection in [WSPHPhotoLibrary getAlbumGroup]) {
			AlbumListModel * model = [AlbumListModel modelByAssetCollection:collection];
			[_arrGroup addObject:model];
		}
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"照片";
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.tableFooterView = [UIView new];
	_tableView.rowHeight = 50;
	[_tableView registerNib:[UINib nibWithNibName:AlbumListCell_ bundle:nil] forCellReuseIdentifier:AlbumListCell_];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(actionRightBar)];
	self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)actionRightBar {
	
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return _arrGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	AlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumListCell_ forIndexPath:indexPath];
	[cell setModel: _arrGroup[indexPath.row]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	AlbumListModel * model = _arrGroup[indexPath.row];
	AlbumImgListVC *mvc = [[AlbumImgListVC alloc]initWithCollection:model.collection
														selectedArr:_arrSelected
														   maxCount:_maxCout
														selectBlock:_selectBlock];
	[self.navigationController pushViewController:mvc animated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end

