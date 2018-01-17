//
//  RegisterVC.m
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "RegisterVC.h"
typedef enum ViewTagIndentifyer{
	
	TagFieldPhone = 1001,
	TagFieldVerCode, //验证码输入框
}Tag;
@interface RegisterVC ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic,assign)BOOL isShutDownCountTime;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *vercodeField;
@property (weak, nonatomic) IBOutlet UIButton *getVercodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (copy, nonatomic)void(^finishBlock)(NSString *phoneNum);
@property (weak, nonatomic) IBOutlet UITextField *addressField;


@end

@implementation RegisterVC
-(instancetype)initWithPhone:(NSString *)phoneNum finishBlock:(void(^)(NSString *phoneNum))finishBlock
{
	self = [super init];
	if (self) {
		_phoneField.text = phoneNum;
		_finishBlock = finishBlock;
	}
	return self;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	_phoneField.tag = TagFieldPhone;
	_vercodeField.tag = TagFieldVerCode;
	[_phoneField setClearButtonMode:UITextFieldViewModeWhileEditing];
	[_vercodeField setClearButtonMode:UITextFieldViewModeWhileEditing];
	
	[_phoneField setKeyboardType:UIKeyboardTypeNumberPad];
	
	_phoneField.delegate = self;
	_vercodeField.delegate = self;
	
	UserInfoModel *model = [CacheTool getRecentLoginUser];
	//	_userField.text = model.driverid;
}

- (IBAction)goLogin:(UIButton *)sender {//注册
	
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendVercodeAction:(id)sender {
	_getVercodeBtn.userInteractionEnabled = NO;
	HDModel *m = [HDModel model];
	m.mobile = _phoneField.text;
	weakObj;
	[BaseServer postObjc:m path:@"/sms/send" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
		weakSelf.getVercodeBtn.userInteractionEnabled = YES;
		dispatch_async(dispatch_get_main_queue(), ^{
			[weakSelf openCountdown];
		});
	} failed:^(NSError *error) {
		weakSelf.getVercodeBtn.userInteractionEnabled = YES;
	}];
}

- (IBAction)registerAction:(id)sender {
	_registerBtn.userInteractionEnabled = NO; 
	
	HDModel *m = [HDModel model];
	m.mobile = _phoneField.text;
	m.name = _userNameField.text;
	m.addr = _addressField.text;
	m.verCode = _vercodeField.text;
	weakObj;
	[BaseServer postObjc:m path:@"/user/register" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
		weakSelf.registerBtn.userInteractionEnabled = YES;
		if ([result[@"data"] isKindOfClass:[NSDictionary class]]) {
			[[NSUserDefaults standardUserDefaults] setObject:result[@"data"][@"token"] forKey:@"TOKEN"];
			
			UserInfoModel *model = [UserInfoModel yy_modelWithDictionary:result[@"data"][@"driver"]];
			model.isMember = 1;
			model.isRecentLogin = 1;
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[CacheTool writeToDB:model];
				if (weakSelf.finishBlock) {
					weakSelf.finishBlock(weakSelf.phoneField.text);
				}
				[weakSelf dismissViewControllerAnimated:YES completion:nil]; 
			});
		}
	} failed:^(NSError *error) {
		weakSelf.registerBtn.userInteractionEnabled = YES;
	}];
}

// 开启倒计时效果
-(void)openCountdown{
	
	__block NSInteger time = CountDownTime; //倒计时时间
	_isShutDownCountTime = NO;
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
	
	dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
	
	dispatch_source_set_event_handler(_timer, ^{
		
		if (_isShutDownCountTime) {
			time = 0;
		}
		
		if(time <= 0){
			//倒计时结束，关闭
			dispatch_source_cancel(_timer);
			dispatch_async(dispatch_get_main_queue(), ^{
				
				//设置按钮的样式
				[_getVercodeBtn  setTitle:@"重新发送" forState:UIControlStateNormal];
				_time.text = @"";
				_getVercodeBtn.userInteractionEnabled = YES;
			});
			
		}else{
			int seconds;
			if (time == CountDownTime)
				seconds = CountDownTime;
			else
				seconds = time % CountDownTime;
			dispatch_async(dispatch_get_main_queue(), ^{
				
				//设置按钮显示读秒效果
				[_getVercodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
				_time.text = [NSString stringWithFormat:@"%.2d", seconds];
				_getVercodeBtn.userInteractionEnabled = NO;
			});
			time--;
		}
	});
	dispatch_resume(_timer);
}

- (IBAction)toUserProtocol:(id)sender {

}

- (IBAction)toPrivacy:(id)sender {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

@end
