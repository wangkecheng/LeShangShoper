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
#import "ImagePrivilegeTool.h"
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
@property (nonatomic, copy)void(^publishedBlock)(void);

@end

@implementation AddInteractionVC

-(instancetype)initWithBlock:(void(^)(void))publishedBlock{
	self = [super init];
	if (self) {
		_publishedBlock = publishedBlock;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"添加互动";
	
    UIButton *publishBtn = [self addRightBarButtonItemWithTitle:@"发布" action:@selector(publishAction)];
    publishBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14] ==nil? [UIFont systemFontOfSize:14]:[UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [publishBtn setTitleColor:UIColorFromHX(0x1393fc) forState:0];
	
	//文字样式 
    [_noteTextView setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:14]==nil?[UIFont systemFontOfSize:14]:[UIFont fontWithName:@"PingFangSC-Medium" size:14]];
    [_noteTextView setPlaceholderColor:UIColorFromHX(0xcacacf)];
    [_noteTextView setPlaceholderFont:[UIFont fontWithName:@"PingFangSC-Medium" size:14]==nil?[UIFont systemFontOfSize:14]:[UIFont fontWithName:@"PingFangSC-Medium" size:14]];
    _noteTextView.maxTextLength = 500;
	_noteTextView.delegate = self;
	_noteTextView.placeholder= @"这一刻的想法...";
 
	[_noteTextView setPlaceholderOpacity:1];
    weakObj;
    _noteTextView.didAttachMaxLength = ^(BRPlaceholderTextView *textView, NSInteger maxTextLength) {
        [textView resignFirstResponder];
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.view makeToast:[NSString stringWithFormat:@"最多只能输入%ld字",maxTextLength]];
    };
    
	_imaPicker = [[UIImagePickerController alloc] init];
	_imaPicker.delegate = self;
    if ([_imaPicker.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        [_imaPicker.navigationBar setBarTintColor:UIColorFromHX(0x1393fc)];
        [_imaPicker.navigationBar setTranslucent:NO];
        [_imaPicker.navigationBar setTintColor:UIColorFromHX(0x1393fc)];
    }else{
        [_imaPicker.navigationBar setBackgroundColor:UIColorFromHX(0x1393fc)];
    }
    _imaPicker.navigationBar.tintColor = [UIColor whiteColor];
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	_collectionView.backgroundColor = [UIColor whiteColor];
	_collectionView.scrollEnabled  = NO;
    _flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 0, 0);
    _flowLayout.minimumInteritemSpacing = 3;//同一行
    _flowLayout.minimumLineSpacing = 3;//同一列
    
	_arrSelected = [NSMutableArray array];
	 
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
    [self.view endEditing:YES];
    if ([CacheTool isToLoginVC:self]) {
        return;//方法内部做判断
    }
	weakObj;
    //上传图片
	HDModel *m = [HDModel model];
	m.content = _noteTextView.text; 
	NSMutableArray *arrImg = [NSMutableArray array];
	for (ImgModel  *model in _arrSelected) {
      if ([model isKindOfClass:[ImgModel class]]) {
          [arrImg addObject:model.image];
      }else{
          [arrImg addObject:model];
      }
	}
    if (m.content.length == 0) {
        [self.view makeToast:@"请输入文字"];
        return;
    }
      [MBProgressHUD showMessage:@"正在发布" toView:self.view];
	[BaseServer uploadImages:arrImg path:@"/interact/add" param:m isShowHud:NO success:^(id result) {
		dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUDForView:strongSelf.view];
			if (strongSelf.publishedBlock) {
				strongSelf.publishedBlock();
			}
            [strongSelf.view makeToast:@"发布成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
		});
	} failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUDForView:strongSelf.view];
        });
	}];
}
#pragma mark 选择图片
- (void)selectImgFromAlbum{
	weakObj;
	SRActionSheet *actionSheet =  [SRActionSheet sr_actionSheetViewWithTitle:nil cancelTitle:nil destructiveTitle:nil otherTitles:@[ @"拍照上传", @"从相册中选择",@"取消"] otherImages:nil selectSheetBlock:^(SRActionSheet *actionSheet, NSInteger index) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
		if (index == 0) {//拍照
            if (![[ImagePrivilegeTool share]judgeCapturePrivilege]) {//判读是否有相册选择权限 类中给提示
                return;
            }
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				strongSelf.imaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
				strongSelf.imaPicker.delegate = self;
				[strongSelf.navigationController presentViewController:strongSelf.imaPicker animated:NO completion:nil];
			}
		}
		else if(index == 1){//从相册中选择图片
            if (![[ImagePrivilegeTool share]judgeLibraryPrivilege]) {//判读是否有相册选择权限 类中给提示
                return;
            }
//            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
//                strongSelf.imaPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//                strongSelf.imaPicker.delegate = self;
//                strongSelf.imaPicker.allowsEditing = YES;
//                [strongSelf presentViewController:strongSelf.imaPicker animated:NO completion:nil];
//            }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            strongSelf.imaPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            strongSelf.imaPicker.delegate = self;
            [strongSelf.navigationController presentViewController:strongSelf.imaPicker animated:NO completion:nil];
        }
//            AlbumListVC *VC = [[AlbumListVC alloc]
//                               initWithArrSelected:self.arrSelected
//                               maxCout:9
//                               selectBlock:^(NSMutableArray<ImgModel *> *imgModelArr) {
//                                   dispatch_async(dispatch_get_main_queue(), ^{
//
//                                       [weakSelf.collectionView reloadData];
//                                   });
//                               }];
//            HDMainNavC *nav = [[HDMainNavC alloc]initWithRootViewController:VC];
//            [weakSelf presentViewController:nav animated:YES completion:nil];
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
    if (_arrSelected.count<9) {
         [_arrSelected addObject:theImage];
         [_collectionView reloadData];
    }
    if (theImage && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//保存图片到相册中
        [[WSPHPhotoLibrary library] saveImage:theImage assetCollectionName:@"新易陶" sucessBlock:^(NSString *str, PHAsset *obj) {

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
	
	CGFloat w = (CGRectGetWidth(collectionView.frame) - 60) / 4.0;
	return CGSizeMake(w,w);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	UINib *nib = [UINib nibWithNibName:@"HWCollectionViewCell" bundle: [NSBundle mainBundle]];
	[collectionView registerNib:nib forCellWithReuseIdentifier:@"HWCollectionViewCell"];
	HWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWCollectionViewCell" forIndexPath:indexPath];
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
         ImgModel * imgModel = _arrSelected[i];
        UIImage * image;
        UIImage * bgiImage;
        if ([imgModel isKindOfClass:[UIImage class]]) {
            image = (UIImage *)imgModel;
        }else{
            bgiImage = imgModel.bigImage;
            image = imgModel.image;
        }
            LWImageBrowserModel* broModel = [[LWImageBrowserModel alloc]  initWithplaceholder:bgiImage==nil?image:bgiImage thumbnailURL:nil HDURL:nil
                containerView:cell.contentView positionInContainer:cell.contentView.frame
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
	_collectionViewH.constant = ((SCREENWIDTH - 60) /4.0)* ((int)(_arrSelected.count)/4+1)+15 + 35;
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

