//
//  AddInteractionVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "AddInteractionVC.h"
#import "BRPlaceholderTextView.h"
#import "AlbumListVC.h"
#import "WSPHPhotoLibrary.h"
#import "HWCollectionViewCell.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
@interface AddInteractionVC ()<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,
UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

//选择的图片数据
@property(nonatomic,strong) NSMutableArray *arrSelected;
@property (nonatomic, strong)UIImagePickerController *imaPicker;
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *noteTextView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewH;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)NSMutableArray *arrImgUrl;
@property (nonatomic, copy)void(^publishedBlock)(void);

@end

@implementation AddInteractionVC

-(instancetype)initWithBlock:(void(^)())publishedBlock{
	self = [super init];
	if (self) {
		_publishedBlock = publishedBlock;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"添加互动";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(publishAction)];
	self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
	
	//文字样式
	[_noteTextView setFont:[UIFont fontWithName:@"Heiti SC" size:14]];
  //_noteTextView.maxTextLength = 400;
	_noteTextView.delegate = self;
	_noteTextView.font = [UIFont boldSystemFontOfSize:14];
	_noteTextView.placeholder= @"这一刻的想法...";
	[_noteTextView setPlaceholderColor:[UIColor lightGrayColor]];
	[_noteTextView setPlaceholderOpacity:1];
	
	_imaPicker = [[UIImagePickerController alloc] init];
	_imaPicker.delegate = self;
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	_collectionView.backgroundColor = [UIColor whiteColor];
	_collectionView.scrollEnabled  = NO;
	
	_arrSelected = [NSMutableArray array];
	_flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
	_flowLayout.minimumInteritemSpacing = 3;//同一行
	_flowLayout.minimumLineSpacing = 3;//同一列
	
	UIButton *btn =(UIButton *) self.navigationItem.leftBarButtonItem.customView;
	[btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

//返回到上一级
-(void)back{
	[self.view endEditing:YES];
		weakObj;
//	if (_noteTextView.text.length == 0 && _arrSelected.count == 0) {
//		[self.navigationController popViewControllerAnimated:YES];
//		return;
//	}

//	SRActionSheet *actionSheet =  [SRActionSheet sr_actionSheetViewWithTitle:@"是否保存草稿" cancelTitle:nil destructiveTitle:@"取消" otherTitles:@[@"保存",@"不保存"] otherImages:nil selectSheetBlock:^(SRActionSheet *actionSheet, NSInteger index) {
//		if (index == 0) { //保存到数据库
//			dispatch_async(dispatch_get_main_queue(), ^{
//
//			});
//		}
//		else if(index == 1){
//			[weakSelf.navigationController popViewControllerAnimated:YES];
//		}
//	}];
//	actionSheet.otherActionItemAlignment = SROtherActionItemAlignmentCenter;
//	[actionSheet show];
}

-(void)publishAction{//发布操作
	weakObj;
 //上传图片
	HDModel *m = [HDModel model];
	m.content = _noteTextView.text;
	[BaseServer uploadImages:_arrImgUrl path:@"/interact/add" param:m isShowHud:YES success:^(id result) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (weakSelf.publishedBlock) {
				weakSelf.publishedBlock();
			}
			[weakSelf.navigationController popViewControllerAnimated:YES];
		});
	} failed:^(NSError *error) {
		
	}];
}
#pragma mark 选择图片
- (void)selectImgFromAlbum{
	weakObj;
	SRActionSheet *actionSheet =  [SRActionSheet sr_actionSheetViewWithTitle:nil cancelTitle:nil destructiveTitle:nil otherTitles:@[ @"拍照上传", @"从相册中选择",@"取消"] otherImages:nil selectSheetBlock:^(SRActionSheet *actionSheet, NSInteger index) {
		if (index == 0) {//拍照
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				weakSelf.imaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
				weakSelf.imaPicker.delegate = self;
				[weakSelf.navigationController presentViewController:weakSelf.imaPicker animated:NO completion:nil];
			}
			
		}
		else if(index == 1){//从相册中选择图片
			weakObj;
			AlbumListVC *VC = [[AlbumListVC alloc]
							   initWithArrSelected:self.arrSelected
							   maxCout:9
							   selectBlock:^(NSMutableArray<ImgModel *> *imgModelArr) {
								   dispatch_async(dispatch_get_main_queue(), ^{
									   [weakSelf.collectionView reloadData];
								   });
							   }];
			HDMainNavC *nav = [[HDMainNavC alloc]initWithRootViewController:VC];
			[weakSelf presentViewController:nav animated:YES completion:nil];
		}
	}];
	actionSheet.otherActionItemAlignment = SROtherActionItemAlignmentCenter;
	[actionSheet show];
}
#pragma mark - 拍照获得数据
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
	weakObj;
	UIImage *theImage = nil;
	// 判断，图片是否允许修改
	if ([picker allowsEditing]){
		//获取用户编辑之后的图像
		theImage = [info objectForKey:UIImagePickerControllerEditedImage];
	} else {
		// 照片的元数据参数
		theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	}
	if (theImage) {//保存图片到相册中
		[[WSPHPhotoLibrary library] saveImage:theImage assetCollectionName:@"乐山商城" sucessBlock:^(NSString *str, PHAsset *obj) {
			
		} faildBlock:^(NSError *error) {
		}];
	}
}

- (void)finishSelectImg:(NSMutableArray *)imgArr{
	
	[_collectionView reloadData];
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return _arrSelected.count+1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
	
	CGFloat w = (CGRectGetWidth(collectionView.frame) - 20) / 4.0;
	return CGSizeMake(w,w);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	UINib *nib = [UINib nibWithNibName:@"HWCollectionViewCell" bundle: [NSBundle mainBundle]];
	[collectionView registerNib:nib forCellWithReuseIdentifier:@"HWCollectionViewCell"];
	HWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HWCollectionViewCell" forIndexPath:indexPath];
	if (indexPath.row == _arrSelected.count) {
		ImgModel *model = [[ImgModel alloc]init];
		model.image = [UIImage imageNamed:@"ic_interactive_add"];
		[cell  setAddImgModel:model];
	}
	else{
		[cell setModel:_arrSelected[indexPath.item]];
		weakObj;
		cell.deleteBlock = ^(ImgModel * model) {
			//删除照片
			if (!model) {
				return;
			}
			NSInteger index =  [weakSelf.arrSelected indexOfObject:model];
			[weakSelf.arrSelected removeObjectAtIndex:index];
			[weakSelf.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
			[weakSelf.collectionView reloadData];
			[weakSelf setCollectionViewHeight];
		};
	}
	[self setCollectionViewHeight];
	return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.item !=_arrSelected.count) {  //点击图片看大图
		//点击放大查看
		HWCollectionViewCell *cell = (HWCollectionViewCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0]];
		
		NSMutableArray* tmps = [[NSMutableArray alloc] init];
		for (int i = 0;i< self.arrSelected.count;i++) {//找出所有图片
			LWImageBrowserModel* broModel = [[LWImageBrowserModel alloc]  initWithplaceholder:_arrSelected[i]
																				 thumbnailURL:nil
																						HDURL:nil
																				containerView:cell.contentView
																		  positionInContainer:cell.contentView.frame 
																						index:i];
			[tmps addObject:broModel];
		}
		LWImageBrowser* browser = [[LWImageBrowser alloc]
								   initWithImageBrowserModels:tmps
								   currentIndex:indexPath.row];
		browser.isScalingToHide = NO;
		browser.isShowSaveImgBtn = NO;
		[browser show];
	}else{
		[self.view endEditing:YES];
		//添加新图片
		[self selectImgFromAlbum];
	}
}

//设置CollectionView高度
-(void)setCollectionViewHeight{
	_collectionViewH.constant = ((SCREENWIDTH - 30) /4.0)* ((int)(_arrSelected.count)/4+1)+15;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		return  NO;
	}
	return YES;
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
@end

