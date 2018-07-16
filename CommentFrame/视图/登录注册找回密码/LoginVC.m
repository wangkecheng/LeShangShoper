//
//  LoginVC.m
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
typedef enum ViewTagIndentifyer{
	
	TagFieldPhone = 1001,
	TagFieldVerCode, //验证码输入框
}Tag; 
@interface LoginVC ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic,assign)BOOL isShutDownCountTime;
    @property (weak, nonatomic) IBOutlet UIView *inputView;
    
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *vercodeField;
@property (weak, nonatomic) IBOutlet UIButton *getVercodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *dissmissBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation LoginVC
- (instancetype)initWithFinishBlock:(void (^)(void))finishLoginBlock{
	self = [super init];
	if (self) {
		self.finishLoginBlock = finishLoginBlock;//这个继承的是父类的完成登录的 block 但是由于block本身为空，所以这个block只可能为其他视图的block
	}
	return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    _inputView.layer.cornerRadius = 5;
	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"token"];//登录注册不需要token这个地方置为空
	_userField.tag = TagFieldPhone;
	_vercodeField.tag = TagFieldVerCode;
	[_userField setClearButtonMode:UITextFieldViewModeWhileEditing];
	[_vercodeField setClearButtonMode:UITextFieldViewModeWhileEditing];
	
	[_userField setKeyboardType:UIKeyboardTypeNumberPad];
	
	_userField.delegate = self;
	_vercodeField.delegate = self;
	
	UserInfoModel *model = [CacheTool getRecentLoginUser];
	_userField.text = model.mobile;
    _dissmissBtn.alpha = 1;
    if (_isLoginOut) {
        _dissmissBtn.alpha = 0;
    }
    [WSKeyboardView numberBoardByField:_userField inputBlock:nil backspaceBlock:nil];
}

- (IBAction)dissMissAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendVertiCodeAction:(id)sender {
	_getVercodeBtn.userInteractionEnabled = NO;
    if (_userField.text.length == 0) {
        [self.view makeToast:@"请输入手机号"];
        return;
    }
    if(_userField.text.length != 11){
        [self.view makeToast:@"手机号格式错误"];
        return;
    }
	HDModel *m = [HDModel model];
	m.mobile = _userField.text;
    m.type = @"2";///1,注册，2，登陆。默认1，如果为2，可能返回1151用户不存在的状态码
	weakObj;
	[BaseServer postObjc:m path:@"/sms/send" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
		weakSelf.getVercodeBtn.userInteractionEnabled = YES;
		if ([result[@"code"] integerValue] == 1150) {
			[weakSelf alertViewWithMeg:@"用户正在审核"];
			return ;
        }
		if ([result[@"code"] integerValue] == 1151) {
			[weakSelf alertViewWithMeg:@"您尚未注册"];
			return ;
		}
		if ([result[@"code"] integerValue] == 1201) {
			[weakSelf alertViewWithMeg:@"发送手机验证码失败"];
			return ;
		}
		dispatch_async(dispatch_get_main_queue(), ^{
			[weakSelf openCountdown];
		});
	} failed:^(NSError *error) {
		weakSelf.getVercodeBtn.userInteractionEnabled = YES;
	}];
}

-(void)alertViewWithMeg:(NSString *)msg{
	dispatch_async(dispatch_get_main_queue(), ^{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
		[alertView show];
	});
}
- (IBAction)login:(UIButton *)sender {
    if (_userField.text.length == 0) {
        [self.view makeToast:@"请输入手机号"];
        return;
    }
    if (_vercodeField.text.length == 0) {
        [self.view makeToast:@"请输入验证码"];
        return;
    }
	_loginBtn.userInteractionEnabled = NO;
	HDModel *m = [HDModel model];
	m.mobile = _userField.text;
	m.verCode = _vercodeField.text;
   
	weakObj;
	[BaseServer postObjc:m path:@"/user/login" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
		strongSelf.loginBtn.userInteractionEnabled = YES;
		if ([result[@"code"] integerValue] == 1200) {
			[weakSelf alertViewWithMeg:@"手机验证码不正确"];
			return ;
		}
		[[NSUserDefaults standardUserDefaults] setObject:result[@"data"][@"token"] forKey:@"token"];
		HDModel *m = [HDModel model];
        m.mobile =  strongSelf.userField.text;
		[BaseServer postObjc:m path:@"/user/info" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
			if ([result[@"data"] isKindOfClass:[NSDictionary class]]) {
				UserInfoModel *model = [CacheTool getUserModelByID:result[@"data"][@"mobile"]];
                [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%@%@",POST_HOST,model.headUrl] withCompletion:nil];//清除头像缓存
				[model yy_modelSetWithJSON:result[@"data"]];
				model.isMember = 1;
				model.isRecentLogin = 0;
				dispatch_async(dispatch_get_main_queue(), ^{
					[CacheTool writeToDB:model];
					[CacheTool setRootVCByIsMainVC:YES finishBlock:strongSelf.finishLoginBlock];
				});
                if (strongSelf.finishLoginBlock) {
                    strongSelf.finishLoginBlock();
                }
			}
		} failed:^(NSError *error) {
			
		}];
		
	} failed:^(NSError *error) {
         __strong typeof (weakSelf) strongSelf = weakSelf;
		   strongSelf.loginBtn.userInteractionEnabled = YES;
	}];
}

- (IBAction)goRegister:(UIButton *)sender {//注册
	weakObj;
	RegisterVC * VC = [[RegisterVC alloc]initWithPhone:_userField.text finishBlock:^(NSString *phoneNum) {
		__strong typeof (weakSelf) strongSelf  = weakSelf;
		dispatch_async(dispatch_get_main_queue(), ^{
			strongSelf.userField.text = phoneNum;
		});
	}];
	[self presentViewController:[[HDMainNavC alloc]initWithRootViewController:VC] animated:YES completion:nil];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}
@end
