//
//  FeedBackVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "FeedBackVC.h"
#import "BRPlaceholderTextView.h"
@interface FeedBackVC ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *noteTextView;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (nonatomic,strong)NSString *typeStr;//1,产品建议，2，程序错误
@property (weak, nonatomic) IBOutlet UIButton *productAdviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *bugAdviceBtn;

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"意见反馈";
	//文字样式
	//_noteTextView.maxTextLength = 400;
	_noteTextView.delegate = self;
    [_noteTextView setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]];
    [_noteTextView setPlaceholderColor:UIColorFromHX(0xcacacf)];
    [_noteTextView setPlaceholderFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]];
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *version =  [NSString stringWithFormat:@"%@.%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[infoDictionary objectForKey:@"CFBundleVersion"]];
	_noteTextView.placeholder = [NSString stringWithFormat:@"你正在使用%@版,欢迎反馈宝贵意见",version];
	[_noteTextView setPlaceholderColor:[UIColor lightGrayColor]];
	[_noteTextView setPlaceholderOpacity:1];
	self.tableView.backgroundColor = UIColorFromHX(0xf0f0f0);
	[self.tableView hideSurplusLine];
    _typeStr = @"1";//默认为产品建议
}

- (IBAction)adviceAction:(UIButton *)sender {
	_typeStr =@"1";
    [_productAdviceBtn setImage:IMG(@"btn_option_p") forState:0];
    [_bugAdviceBtn setImage:IMG(@"btn_option_n") forState:0];
}

- (IBAction)bugAction:(UIButton *)sender {
     _typeStr =@"2";
    [_bugAdviceBtn setImage:IMG(@"btn_option_p") forState:0];
    [_productAdviceBtn setImage:IMG(@"btn_option_n") forState:0];
}

- (IBAction)submitAction:(id)sender {
	HDModel * m = [HDModel model];
	m.type = _typeStr;
	m.desc = _noteTextView.text;
	m.contact = _accountField.text;
	[BaseServer postObjc:m path:@"/feedback/add" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
		
	} failed:^(NSError *error) {
		
	}];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	
	if ([text isEqualToString:@"\n"]){
		[textView resignFirstResponder];//按回车取消第一相应者
		return NO;
	}
	return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	 
	if ([string isEqualToString:@"\n"]){
		[textField resignFirstResponder];//按回车取消第一相应者
		return NO;
	}
	return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
		return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.01; 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
