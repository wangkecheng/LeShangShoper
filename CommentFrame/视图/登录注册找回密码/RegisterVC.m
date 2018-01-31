//
//  RegisterVC.m
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "RegisterVC.h"
#import "UserProtocolVC.h"
typedef enum ViewTagIndentifyer{
	
	TagFieldPhone = 1001,
	TagFieldVerCode, //验证码输入框
    TagFieldUserName,
    TagFieldAddress
}Tag;
@interface RegisterVC ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic,assign)BOOL isShutDownCountTime;
@property (nonatomic, strong)NSString * phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *vercodeField;
@property (weak, nonatomic) IBOutlet UIButton *getVercodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (copy, nonatomic)void(^finishBlock)(NSString *phoneNum);
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (nonatomic, strong) DYPickerView *pickerView; // pickerView

@end

@implementation RegisterVC
-(instancetype)initWithPhone:(NSString *)phoneNum finishBlock:(void(^)(NSString *phoneNum))finishBlock
{
	self = [super init];
	if (self) {
		  _phoneNum = phoneNum;
		_finishBlock = finishBlock;
	}
	return self;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	_phoneField.text = _phoneNum ;
	_phoneField.tag = TagFieldPhone;
	_vercodeField.tag = TagFieldVerCode;
    _userNameField.tag = TagFieldUserName;
    _addressField.tag = TagFieldAddress;
	
	[_phoneField setKeyboardType:UIKeyboardTypeNumberPad];
	
	_phoneField.delegate = self;
	_vercodeField.delegate = self;
    _userNameField.delegate = self;
    _addressField.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.hidden = NO;
}
- (IBAction)goLogin:(UIButton *)sender {//注册
	if (_finishBlock) {
		_finishBlock(_phoneField.text);
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendVercodeAction:(id)sender {
    if (_phoneField.text.length == 0) {
        [self.view makeToast:@"请输入手机号"];
        return;
    }
	_getVercodeBtn.userInteractionEnabled = NO;
	HDModel *m = [HDModel model];
	m.mobile = _phoneField.text;
    m.type = @"1";///1,注册，2，登陆。默认1，如果为2，可能返回1151用户不存在的状态码
	weakObj;
	[BaseServer postObjc:m path:@"/sms/send" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
		weakSelf.getVercodeBtn.userInteractionEnabled = YES;
		if ([result[@"code"] integerValue] == 1152) {
			[weakSelf alertViewWithMeg:@"用户已存在"];
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
- (IBAction)registerAction:(id)sender {
    if (_phoneField.text.length == 0) {
        [self.view makeToast:@"请输入手机号"];
        return;
    }
    if (_vercodeField.text.length == 0) {
        [self.view makeToast:@"请输入验证码"];
        return;
    }
    if (_userNameField.text.length == 0) {
       [self.view makeToast:@"请输入姓名"];
        return;
    }
    if (_addressField.text.length == 0) {
       [self.view makeToast:@"请输入详细地址"];
        return;
    }
	_registerBtn.userInteractionEnabled = NO; 
	
	HDModel *m = [HDModel model];
	m.mobile = _phoneField.text;
    m.verCode = _vercodeField.text;
	m.name = _userNameField.text;
	m.addr = _addressField.text;
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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == TagFieldAddress) {
        [self.pickerView show];
        return NO;
    }
    return YES;
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
            strongSelf.addressField.text = [NSString stringWithFormat:@"%@-%@%@",model.provenceName,model.cityName,countyName];
        }];
    }
    return _pickerView;
}

- (IBAction)toUserProtocol:(id)sender {
	UserProtocolVC  * VC = [[UserProtocolVC alloc]initWithType:ProtocolTypeUse];
	[self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)toPrivacy:(id)sender {
	UserProtocolVC  * VC = [[UserProtocolVC alloc]initWithType:ProtocolTypePrivacy];
	[self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

@end
