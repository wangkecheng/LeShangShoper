//
//  PersonalCenterVC.m
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "PersonalCenterVC.h"
#import "LeftTopHeadView.h"
#import "LoginVC.h"
#import "SettingVC.h"
#import "CollectionVC.h"
#import "WSLeftSlideManagerVC.h"
#import "WSPHPhotoLibrary.h"
#import "AlbumListVC.h"
#import "ResetPersonInfoView.h"
@interface PersonalCenterVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *dianJiLoginLbl;//点击登录lbl

@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
//选择的图片数据
@property(nonatomic,strong) NSMutableArray *arrSelected;
@property (nonatomic, strong)UIImagePickerController *imaPicker;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *rankLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalCreditsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;

@property (weak, nonatomic) IBOutlet UISwitch *switchSex;
@property (nonatomic, strong)DSAlert *alertControl;

@end

@implementation PersonalCenterVC
-(instancetype)initWithBackgroundImage:(UIImage *)image{
	if(self){
		self.view.backgroundColor = [UIColor redColor];
		[_imgBackground setImage:image];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.frame = [UIScreen mainScreen].bounds;

	//设置ON一边的背景颜色，默认是绿色
	_switchSex.onTintColor =   UIColorFromRGB(44, 155, 234);
	//设置滑块颜色
	_switchSex.thumbTintColor =  [UIColor whiteColor];
	_switchSex.layer.borderWidth  = 1;
	_switchSex.layer.borderColor  = UIColorFromRGB(44, 155, 234).CGColor;
	_switchSex.layer.cornerRadius = CGRectGetHeight(_switchSex.frame)/2;
	_switchSex.layer.masksToBounds = YES;
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewClick)];
	[_topView addGestureRecognizer:tap];
	weakObj;
	self.didLeftSildeAction = ^{
		UserInfoModel * model  = [CacheTool getUserModel];
		 if (model.isMember == 1) {//如果存在
			weakSelf.dianJiLoginLbl.alpha = 0;
			weakSelf.nameLbl.alpha = weakSelf.rankLbl.alpha = 1;
			weakSelf.nameLbl.text = model.name;
			weakSelf.addressLbl.text = model.addr;
			weakSelf.rankLbl.text = [NSString stringWithFormat:@"LV.%@",model.lv];
			weakSelf.totalCreditsLbl.text = [NSString stringWithFormat:@"%@ 积分",model.integral];
			[weakSelf.headerBtn  sd_setImageWithURL:IMGURL(model.headUrl) forState:0 placeholderImage:IMG(@"image1.jpg")];
		}else{
			weakSelf.dianJiLoginLbl.alpha = 1;
			weakSelf.nameLbl.alpha = weakSelf.rankLbl.alpha = 0;
		}
	};
	
	_imaPicker = [[UIImagePickerController alloc] init];
	
	_arrSelected = [NSMutableArray array];
}

-(void)headerViewClick{
	UserInfoModel * model  = [CacheTool getUserModel];
	if (model.isMember != 1) {//如果存在
		LoginVC * loginVC = [[LoginVC alloc]init];
		[self presentViewController:loginVC animated:YES completion:nil];
	}
}

- (IBAction)resetHeaderImg:(id)sender {
	weakObj;
	SRActionSheet *actionSheet =  [SRActionSheet sr_actionSheetViewWithTitle:nil cancelTitle:nil destructiveTitle:nil otherTitles:@[ @"拍照上传", @"从相册中选择",@"取消"] otherImages:nil selectSheetBlock:^(SRActionSheet *actionSheet, NSInteger index) {
		if (index == 0) {//拍照
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				 weakSelf.imaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
				 weakSelf.imaPicker.delegate = self;
				[weakSelf presentViewController:weakSelf.imaPicker animated:NO completion:nil];
			}
		}
		else if(index == 1){//从相册中选择图片
			weakObj;
			[self.arrSelected removeAllObjects];
			AlbumListVC *VC = [[AlbumListVC alloc]
							   initWithArrSelected:self.arrSelected
							   maxCout:1
							   selectBlock:^(NSMutableArray<ImgModel *> *imgModelArr) {
								   dispatch_async(dispatch_get_main_queue(), ^{
									   ImgModel * imageModel = [imgModelArr firstObject];
									   if (imageModel) {
										   [weakSelf finishSelectImg:imageModel.image];
									   }
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
		[picker dismissViewControllerAnimated:YES completion:nil]; 
		[self finishSelectImg:theImage];
	}
}

- (void)finishSelectImg:(UIImage *)image{
	[_headerBtn setImage:image forState:0];
}

- (IBAction)resetUserName:(id)sender {
	weakObj;
	ResetPersonInfoView *alertView = [ResetPersonInfoView instanceByFrame:CGRectMake(0, 0, SCREENWIDTH - 40,180) type:TypeUserName cancelBlock:^BOOL{
		[weakSelf.alertControl ds_dismissAlertView];
		return YES;
	} okBlock:^BOOL(NSString *str) {
		[weakSelf.alertControl ds_dismissAlertView];
		UserInfoModel * model = [CacheTool getUserModel];
		model.name = weakSelf.userNameLbl.text = str;
		[CacheTool writeToDB:model];
		return YES;
	}];
	_alertControl = [[DSAlert alloc]initWithCustomView:alertView];
}
- (IBAction)resetAddress:(id)sender {
	weakObj;
	ResetPersonInfoView *alertView = [ResetPersonInfoView instanceByFrame:CGRectMake(0, 0, SCREENWIDTH - 40,180) type:TypeUserName cancelBlock:^BOOL{
		[weakSelf.alertControl ds_dismissAlertView];
		return YES;
	} okBlock:^BOOL(NSString *str) {
		[weakSelf.alertControl ds_dismissAlertView];
		UserInfoModel * model = [CacheTool getUserModel];
		model.addr = weakSelf.addressLbl.text = str;
		[CacheTool writeToDB:model];
		return YES;
	}];
	_alertControl = [[DSAlert alloc]initWithCustomView:alertView];

}


-(void)resetUserInfo{
	UserInfoModel * model = [CacheTool getUserModel];
	[BaseServer postObjc:model path:@"/user/update" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
		
	} failed:^(NSError *error) {
		
	}];
}
 
- (IBAction)switchAction:(id)sender {

}

- (IBAction)toCollectionVC:(id)sender {
	
	 CollectionVC *VC = [[CollectionVC alloc]init];
	 WSLeftSlideManagerVC * managerVC = (WSLeftSlideManagerVC *)CurrentAppDelegate.window.rootViewController;
	[managerVC pushVC:VC];
}

- (IBAction)toSettingVC:(id)sender {
	
	SettingVC *VC = [DDFactory getVCById:@"SettingVC"];
	WSLeftSlideManagerVC * managerVC = (WSLeftSlideManagerVC *)CurrentAppDelegate.window.rootViewController;
	[managerVC pushVC:VC];
}

- (IBAction)loginOutAction:(id)sender {
	UserInfoModel * model = [CacheTool getUserModel];;
	 model.isMember = NO;
	[CacheTool writeToDB:model];//状态设置为NO，表示登出
	LoginVC * loginVC = [[LoginVC alloc]init];
	[self presentViewController:loginVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
} 
@end
