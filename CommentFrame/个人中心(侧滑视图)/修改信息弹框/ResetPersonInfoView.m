
//  ResetPersonInfoView.m
//  CommentFrame
//
//  Created by warron on 2018/1/13.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "ResetPersonInfoView.h"
#import "BRPlaceholderTextView.h"
@interface ResetPersonInfoView()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *textView;
@property (copy, nonatomic)BOOL(^cancelBlock)(void);
@property (copy, nonatomic)BOOL(^okBlock)(NSString *str);
@end

@implementation ResetPersonInfoView
+(ResetPersonInfoView *)instanceByFrame:(CGRect)frame type:(ResetPersonInfoType)type cancelBlock:(BOOL(^)(void))cancelBlock okBlock:(BOOL(^)(NSString *str))okBlock{
	ResetPersonInfoView * view = [DDFactory getXibObjc:@"ResetPersonInfoView"];
	view.frame =frame;
	view.cancelBlock = cancelBlock;
	view.okBlock = okBlock;
	view.textView.layer.cornerRadius = 0;
	view.textView.layer.borderWidth = 1;
	view.textView.layer.borderColor = UIColorFromHX(0x808080).CGColor;
	
	//文字样式
	[view.textView setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]];
	//_noteTextView.maxTextLength = 400;
	view.textView.delegate = view;
	view.textView.font = [UIFont boldSystemFontOfSize:14];
	[view.textView setPlaceholderColor:UIColorFromHX(0xcacacf)];
    [view.textView setPlaceholderFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]];
	[view.textView setPlaceholderOpacity:1];
	if (type == TypeUserName) {
		view.titleLbl.text = @"更改姓名";
		view.textView.placeholder= @"输入姓名";
	}else if(type == TypeAddress){
		view.titleLbl.text = @"更改地址";
		view.textView.placeholder= @"输入地址";
	}
	return view;
}

- (IBAction)cancelAction:(UIButton *)sender {
	sender.userInteractionEnabled = NO ;
	if (_cancelBlock) {
		if (_cancelBlock()) {//回调过去并返回一个YES
				sender.userInteractionEnabled = YES ;
		}
	}
}

- (IBAction)confirmAction:(UIButton *)sender {
	sender.userInteractionEnabled = NO ;
	if (_okBlock) {
		if (_okBlock(_textView.text)) {//回调过去并返回一个YES
			sender.userInteractionEnabled = YES ;
		}
	}
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		return  NO;
	}
    if ([textView.text stringByAppendingString:text].length>8) {
        [self makeToast:@"请输入8字以内的姓名"];
        return NO;
    }
	return YES;
}
@end
