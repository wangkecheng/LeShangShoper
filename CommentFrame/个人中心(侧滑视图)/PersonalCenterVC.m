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

@property (nonatomic, strong) DYPickerView *pickerView; // pickerView
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
		__strong typeof (weakSelf) strongSelf  = weakSelf;
        [strongSelf downloadUserData];
	};
	
	_imaPicker = [[UIImagePickerController alloc] init];
	
	_arrSelected = [NSMutableArray array];
}
-(void)downloadUserData{
    HDModel *m = [HDModel model];
    UserInfoModel * modelUser  = [CacheTool getUserModel];
    m.mobile = modelUser.mobile;
    weakObj;
    [BaseServer postObjc:m path:@"/user/info" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
        if ([result[@"data"] isKindOfClass:[NSDictionary class]]) {
            UserInfoModel *model = [CacheTool getUserModelByID:result[@"data"][@"mobile"]];
            [model yy_modelSetWithJSON:result[@"data"]];
            model.isMember = 1;
            model.isRecentLogin = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                [CacheTool writeToDB:model];
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf resetUserData];
            });
        }
    } failed:^(NSError *error) {
        
    }];
}
-(void)resetUserData{
    UserInfoModel * model  = [CacheTool getUserModel];
    if (model.isMember == 1) {//如果存在
        [_switchSex setOn:NO];
        if ([model.sex integerValue] == 2) {
            [_switchSex setOn:YES];
        }
        UIImage *image = [UIImage imageWithData:model.headImgData];
        if (image) {
            [_headerBtn  setImage:image forState:0];
        }else{
            [_headerBtn  sd_setImageWithURL:IMGURL(model.headUrl) forState:0 placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
        }
        _dianJiLoginLbl.alpha = 0;
        _nameLbl.alpha = _rankLbl.alpha = 1;
       _userNameLbl.text = _nameLbl.text =  [DDFactory getString:model.name  withDefault:@"未知"];
        _phoneLbl.text =  [DDFactory getString:model.mobile  withDefault:@"暂无"];
        _addressLbl.text =    [DDFactory getString:model.addr  withDefault:@"暂无"];
       _rankLbl.text = [NSString stringWithFormat:@"LV.%@", [DDFactory getString:model.lv  withDefault:@"0"]];
        _totalCreditsLbl.text = [NSString stringWithFormat:@"%@ 积分", [DDFactory getString:model.integral  withDefault:@"0"]];
        
    }else{
        _dianJiLoginLbl.alpha = 1;
        _nameLbl.alpha = _rankLbl.alpha = 0;
    }
    [[DDFactory factory] broadcast:nil channel:@"ReInitUserInfo"];//发送通知，重新更改用户信息
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
		[[WSPHPhotoLibrary library] saveImage:theImage assetCollectionName:@"新易陶" sucessBlock:^(NSString *str, PHAsset *obj) {
		
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
}

- (IBAction)resetUserName:(id)sender {
    [self registeKeyboardNotifications];
	weakObj;
	ResetPersonInfoView *alertView = [ResetPersonInfoView instanceByFrame:CGRectMake(0, 0, SCREENWIDTH - 45,(SCREENWIDTH - 45) * 350/570.0) type:TypeUserName cancelBlock:^BOOL{
            __strong typeof (weakSelf) strongSelf = weakSelf;
		[strongSelf.alertControl ds_dismissAlertView];
        [strongSelf unregisteKeyboardNotification];
		return YES;
	} okBlock:^BOOL(NSString *str) {
         __strong typeof (weakSelf) strongSelf = weakSelf;
		 [strongSelf.alertControl ds_dismissAlertView];
         [strongSelf unregisteKeyboardNotification];
		UserInfoModel * model = [CacheTool getUserModel];
		model.name = strongSelf.userNameLbl.text = strongSelf.nameLbl.text = str;
		[CacheTool writeToDB:model];
		[strongSelf resetUserInfo:nil];
		return YES;
	}];
	_alertControl = [[DSAlert alloc]initWithCustomView:alertView];
}

- (IBAction)resetAddress:(id)sender {
    
//    [self registeKeyboardNotifications];
//    weakObj;
//    ResetPersonInfoView *alertView = [ResetPersonInfoView instanceByFrame:CGRectMake(0, 0, SCREENWIDTH - 45,(SCREENWIDTH - 45) * 350/570.0) type:TypeAddress cancelBlock:^BOOL{
//        __strong typeof (weakSelf) strongSelf = weakSelf;
//        [strongSelf.alertControl ds_dismissAlertView];
//        [strongSelf unregisteKeyboardNotification];
//        return YES;
//    } okBlock:^BOOL(NSString *str) {
//        __strong typeof (weakSelf) strongSelf = weakSelf;
//        [strongSelf.alertControl ds_dismissAlertView];
//        [strongSelf unregisteKeyboardNotification];
//        UserInfoModel * model = [CacheTool getUserModel];
//        model.addr = weakSelf.addressLbl.text = str;
//        [CacheTool writeToDB:model];
//        [weakSelf resetUserInfo:nil];
//        return YES;
//    }];
//    _alertControl = [[DSAlert alloc]initWithCustomView:alertView];
        [self.pickerView show];
}
-(DYPickerView *)pickerView{
    if (!_pickerView) {
        weakObj;
        _pickerView = [[DYPickerView alloc] initWithSheetH:250 cancelBlock:^{
            
        } okBlock:^(SelectInfoModel * model) {
            
            __strong typeof (weakSelf) strongSelf = weakSelf;
            NSString *countyName = [NSString stringWithFormat:@"-%@",model.countyName];
            if (model.countyName.length==0) {
                countyName =@"";
            }
            UserInfoModel * userModel = [CacheTool getUserModel];
            userModel.addr = weakSelf.addressLbl.text = [NSString stringWithFormat:@"%@-%@%@",model.provenceName,model.cityName,countyName];
            [CacheTool writeToDB:userModel];
            [strongSelf resetUserInfo:nil];
        }];
    }
    return _pickerView;
}
#pragma mark - 键盘处理
- (void)registeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)unregisteKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)noti {
    
    CGRect keyboardRect = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]; //键盘尺寸
    NSTimeInterval animationDuration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];  //键盘动画时间
    weakObj;
    [UIView animateWithDuration:animationDuration animations:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.alertControl.center = CGPointMake(SCREENWIDTH/2.0, SCREENHEIGHT/2.0-keyboardRect.size.height/2.0);
    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)noti {
    NSTimeInterval animationDuration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];  //键盘动画时间
    weakObj;
    [UIView animateKeyframesWithDuration:animationDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.alertControl.center = CGPointMake(SCREENWIDTH/2.0, SCREENHEIGHT/2.0);
    } completion:nil];
}


-(void)resetUserInfo:(UIImage *)image{
	[[DDFactory factory] broadcast:nil channel:@"ReInitUserInfo"];//发送通知，重新更改用户信息
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
	
	SettingVC *VC = (SettingVC *)[DDFactory getVCById:@"SettingVC"];
	WSLeftSlideManagerVC * managerVC = (WSLeftSlideManagerVC *)CurrentAppDelegate.window.rootViewController;
	[managerVC pushVC:VC];
}

- (IBAction)loginOutAction:(id)sender {
	UserInfoModel * model = [CacheTool getUserModel];;
	 model.isMember = 0;
     model.isRecentLogin = 1;
	[CacheTool writeToDB:model];//状态设置为NO，表示登出
    [CacheTool setRootVCByIsMainVC:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
} 
@end
