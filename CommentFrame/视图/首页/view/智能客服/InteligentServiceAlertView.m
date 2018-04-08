
//
//  InteligentServiceAlertView.m
//  CommentFrame
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "InteligentServiceAlertView.h"
@interface InteligentServiceAlertView()

@property (copy, nonatomic) BOOL(^WXClickBlock)(void);
@property (copy, nonatomic) BOOL(^PhClickBlock)(void);
@end
@implementation InteligentServiceAlertView
+(InteligentServiceAlertView * )instanceByFrame:(CGRect) frame WXClickBlock:(BOOL(^)(void))WXClickBlock PhClickBlock:(BOOL(^)(void))PhClickBlock {
    InteligentServiceAlertView *view = [DDFactory getXibObjc:@"InteligentServiceAlertView"];
    view.frame = frame;
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth = 0;
    view.backgroundColor = [UIColor clearColor];
    view.WXClickBlock = WXClickBlock;
    view.PhClickBlock = PhClickBlock;
    [BaseServer postObjc:nil path:@"/contact/add" isShowHud:NO isShowSuccessHud:NO success:nil failed:nil];
    return view;
}

- (IBAction)weiXinAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;

    if (_WXClickBlock) {
        if (_WXClickBlock()) {
             sender.userInteractionEnabled = YES;
        }
    }
}
- (IBAction)phoneAction:(UIButton *)sender {
     sender.userInteractionEnabled = NO;
    if (_PhClickBlock) {
        if (_PhClickBlock()) {
            sender.userInteractionEnabled = YES;
        }
    }
}
@end
