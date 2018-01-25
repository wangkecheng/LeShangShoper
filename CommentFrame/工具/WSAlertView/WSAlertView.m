//
//  HotelAlertView.m
//  CommentFrame
//
//  Created by warron on 2018/1/16.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "WSAlertView.h"


@interface WSAlertView()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic)id attachInfo;
@property (copy, nonatomic)void(^leftBtnBlock)(id attachInfo);
@property (copy, nonatomic)void(^rightBtnBlock)(id attachInfo);;
@end

@implementation WSAlertView
+(WSAlertView *)instanceWithTitle:(NSString *)title content:(NSString *)content attachInfo:(id)attachInfo leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle leftBtnBlock:(void(^)(id attachInfo))leftBtnBlock rightBtnBlock:(void(^)(id attachInfo))rightBtnBlock{
    WSAlertView *alertView =   [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([WSAlertView class]) owner:nil options:nil][0];
    alertView.frame = [UIScreen mainScreen].bounds;
    
    alertView.titleLbl.textColor = UIColorFromHX(0x333333);
    alertView.titleLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
   
    alertView.contentLbl.textColor = UIColorFromHX(0x333333);
    
    [alertView.leftBtn setTitleColor:UIColorFromHX(0x54a0f8) forState:0];
    [alertView.rightBtn setTitleColor:UIColorFromHX(0x54a0f8) forState:0];
    if (title.length > 0) {
        alertView.titleLbl.text = title;
    }
    if (content.length > 0) {
        alertView.contentLbl.text = content;
    }
    if (leftBtnTitle.length > 0) {
        [alertView.rightBtn setTitle:leftBtnTitle forState:0];
    }
    if (rightBtnTitle.length > 0) {
         [alertView.rightBtn setTitle:rightBtnTitle forState:0];
    }
    alertView.leftBtnBlock = leftBtnBlock;
    alertView.rightBtnBlock = rightBtnBlock;
    alertView.attachInfo = attachInfo; 
    alertView.alertView.layer.masksToBounds = YES;
    alertView.alertView.layer.cornerRadius = 4;
    alertView.backgroundColor = [UIColor clearColor];
    alertView.coverView.alpha = alertView.alertView.alpha = 0;
    return alertView;
}


-(void)show{//显示
    [[UIApplication sharedApplication].keyWindow addSubview:self];//每次都要添加到window中
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.coverView.alpha = 0.3;
        strongSelf.alertView.alpha = 1;
    }];
}

-(void)dissmiss{//移除
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.coverView.alpha = 0;
        strongSelf.alertView.alpha = 0;
    }completion:^(BOOL finished) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf removeFromSuperview];//从父视图中移除，节省空间
    }];
}

- (IBAction)leftBtnAction:(id)sender {
    [self  dissmiss];
    if (_leftBtnBlock) {
        _leftBtnBlock(_attachInfo);
    }
}
- (IBAction)rightBtnAction:(id)sender {
     [self  dissmiss];
    if (_rightBtnBlock) {
        _rightBtnBlock(_attachInfo);
    }
}
@end
