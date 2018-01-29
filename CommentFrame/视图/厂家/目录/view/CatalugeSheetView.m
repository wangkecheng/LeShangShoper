//
//  CatalugeSheetView.m
//  CommentFrame
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "CatalugeSheetView.h"
#import "CatalugeSheetViewCell.h"
#define  CatalugeSheetViewCell_ @"CatalugeSheetViewCell"
@interface CatalugeSheetView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *dissmissBtn;

@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (strong, nonatomic)SeriesModel *seriesModel;
@property (copy, nonatomic)void(^clickBlock)(BrandsModel *model);

@end

@implementation CatalugeSheetView
+(CatalugeSheetView *)instanceByFrame:(CGRect)frame clickBlock:(void(^)(BrandsModel *model))clickBlock{
    CatalugeSheetView * view = [DDFactory getXibObjc:@"CatalugeSheetView"];
    view.frame = frame;
    view.clickBlock = clickBlock; 
    [view setupUI];
    return view;
}

-(void)setupUI{
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:CatalugeSheetViewCell_ bundle:nil] forCellReuseIdentifier:CatalugeSheetViewCell_];
    [_dissmissBtn setEnlargeEdgeWithTop:10 right:300 bottom:10 left:10];
    //点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmiss)];
    tap.delegate = self;
    [_coverView addGestureRecognizer:tap];
    self.bottomConstraint.constant = -CGRectGetHeight(self.frame);
    [self layoutIfNeeded];
}
-(void)showWithSeriesModel:(SeriesModel *)model{
   
    _seriesModel = model;
    _titleLbl.text = [DDFactory getString:model.name  withDefault:@"未知系列"];
    weakObj;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.coverView.alpha = 0.3;
        strongSelf.bottomConstraint.constant = 0;//设置视图到底部的距离
        [strongSelf layoutIfNeeded];
    }];
    [_tableView reloadData];
}

- (IBAction)dissmissAction:(id)sender {//移除sheet框
    [self dissmiss];
}

-(void)dissmiss{
    weakObj;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.coverView.alpha = 0;
        strongSelf.bottomConstraint.constant = -CGRectGetHeight(strongSelf.frame);
    } completion:^(BOOL finished) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf removeFromSuperview];//记得每次都要从父视图移除，这样子可以节约一部分的资源
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _seriesModel.brandsArr.count;
}
 

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CatalugeSheetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CatalugeSheetViewCell_ forIndexPath:indexPath];
  
    [cell setModel: _seriesModel.brandsArr[indexPath.row]];
    [cell setSelectionStyle:0];//不要分割线
 
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dissmiss];
    if (_clickBlock) {
        _clickBlock(_seriesModel.brandsArr[indexPath.row]);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01)];
    view.backgroundColor = [UIColor clearColor];
    
    return  view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01)];
    
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if( [touch.view isDescendantOfView:self.bottomView]) {
        return NO;
    }
    return YES;
}
@end

