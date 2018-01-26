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
@property (nonatomic, strong) UIImage *headImg;//如果上传了头像 暂时存储下来
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
		self.view.backgroundColor = [UIColor whiteColor];
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
             [weakSelf.switchSex setOn:NO];
             if ([model.sex integerValue] == 2) {
                  [weakSelf.switchSex setOn:YES];
             }
              UIImage *image = [UIImage imageWithData:model.headImgData];
             if (image) { 
				[weakSelf.headerBtn  setImage:image forState:0];
             }else{
               [weakSelf.headerBtn  sd_setImageWithURL:IMGURL(model.headUrl) forState:0 placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
             }
			weakSelf.dianJiLoginLbl.alpha = 0;
			weakSelf.nameLbl.alpha = weakSelf.rankLbl.alpha = 1;
			weakSelf.userNameLbl.text =weakSelf.nameLbl.text = model.name;
            weakSelf.phoneLbl.text = model.mobile;
			weakSelf.addressLbl.text = model.addr;
			weakSelf.rankLbl.text = [NSString stringWithFormat:@"LV.%@",model.lv];
			weakSelf.totalCreditsLbl.text = [NSString stringWithFormat:@"%@ 积分",model.integral];
			
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
 
	 [picker dismissViewControllerAnimated:YES completion:nil];
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
		[self finishSelectImg:theImage];
	}
}

- (void)finishSelectImg:(UIImage *)image{
    UserInfoModel * model =  [CacheTool getUserModel];
    model.headImgData = UIImagePNGRepresentation(image);
    [CacheTool writeToDB:model]; 
    [_headerBtn setImage:image forState:0];
    [self resetUserInfo:image];
	[[DDFactory factory] broadcast:nil channel:@"ReInitUserInfo"];//发送通知，重新更改用户信息
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
		[weakSelf resetUserInfo:nil];
		return YES;
	}];
	_alertControl = [[DSAlert alloc]initWithCustomView:alertView];
}
- (IBAction)resetAddress:(id)sender {
	weakObj;
	ResetPersonInfoView *alertView = [ResetPersonInfoView instanceByFrame:CGRectMake(0, 0, SCREENWIDTH - 40,180) type:TypeAddress cancelBlock:^BOOL{
		[weakSelf.alertControl ds_dismissAlertView];
		return YES;
	} okBlock:^BOOL(NSString *str) {
		[weakSelf.alertControl ds_dismissAlertView];
		UserInfoModel * model = [CacheTool getUserModel];
		model.addr = weakSelf.addressLbl.text = str;
		[CacheTool writeToDB:model];
		[weakSelf resetUserInfo:nil];
		return YES;
	}];
	_alertControl = [[DSAlert alloc]initWithCustomView:alertView];

}


-(void)resetUserInfo:(UIImage *)image{
    NSArray *imgsArr = nil;
    if (image) {//当 图片数据有的时候才传入
        imgsArr = @[image];
    }
	[BaseServer uploadImages:imgsArr path:@"/user/update" param:[CacheTool getUserModel] isShowHud:YES
					 success:^(id result) {
						 
					 } failed:^(NSError *error) {
						 
	 }];
}
 
- (IBAction)switchAction:(UISwitch *)sender {
    UserInfoModel * model = [CacheTool getUserModel];
    model.sex = @"1";//男
    if (sender.isOn) {
        model.sex = @"2";//女
    }
    [CacheTool writeToDB:model];
	[self resetUserInfo:nil];
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
	 model.isMember = 0;
     model.isRecentLogin = 1;
	[CacheTool writeToDB:model];//状态设置为NO，表示登出
	LoginVC * loginVC = [[LoginVC alloc]init];
	[self presentViewController:loginVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
} 
@end
