
//
//  CommentInteractionVC.m
//  CommentFrame
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "CommentInteractionVC.h"
#import "CommentInteractionCell.h"
#define CommentInteractionCell_ @"CommentInteractionCell"

@interface CommentInteractionVC ()
<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (strong, nonatomic)NSMutableArray *arrModel;
@property (assign, nonatomic)NSInteger page;
@property (weak, nonatomic)IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewBottom;
@end

@implementation CommentInteractionVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	//注册键盘通知
	[self registeKeyboardNotifications];
	  [IQKeyboardManager sharedManager].enableAutoToolbar = NO;//不显示工具条
	[IQKeyboardManager sharedManager].enable = NO;//解觉键盘提升时 ， 输入框没有紧贴键盘顶部的bug， 不加这个代码 在系统原生键盘上不会出现这个问题
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[IQKeyboardManager sharedManager].enableAutoToolbar = YES;//显示工具条
    [IQKeyboardManager sharedManager].enable = YES;
    //移除键盘通知
    [self unregisteKeyboardNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    _arrModel = [[NSMutableArray alloc]init];
    [_tableview registerNib:[UINib nibWithNibName:CommentInteractionCell_ bundle:nil]forCellReuseIdentifier:CommentInteractionCell_];
    _tableview.backgroundColor = self.view.backgroundColor = UIColorFromRGB(242, 242, 242);
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _commentTextView.delegate = self;
    [_tableview setSeparatorStyle:0];
    
    [_tableview hideSurplusLine];
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
//    _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getPage)];
    [self getPage];
}

- (void)getPage{
    
    [self getData:1];
}

- (void)getData:(NSInteger)pageIndex {
    _page = pageIndex;
    HDModel *m = [HDModel model];
	m.interactId = _interactionModel.interactId;
//    m.pageNumber = [NSString stringFromInt:pageIndex];
    weakObj;
    [BaseServer postObjc:m path:@"/interact/comment/list" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
        NSArray *tempArr = [NSArray yy_modelArrayWithClass:[CommentInteractionModel class] json:result[@"data"]];
        if (weakSelf.page == 1) {
            [weakSelf.arrModel removeAllObjects];
        }
        [weakSelf.arrModel addObjectsFromArray:tempArr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableview reloadData];
            [weakSelf.tableview.mj_header endRefreshing];
//            [weakSelf.tableview.mj_footer endRefreshing];
//            if (weakSelf.arrModel.count == [result[@"data"][@"total"] integerValue]) {
//                [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
//            }
            [weakSelf.tableview setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:YES];
            if (weakSelf.arrModel.count == 0) {
                [weakSelf.tableview setHolderImg:@"alertImg" holderStr:[DDFactory getString:result[@"msg"] withDefault:@"暂无数据"] isHide:NO];
            }
        });
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableview.mj_header endRefreshing];
            [weakSelf.tableview.mj_footer endRefreshing];
        });
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _arrModel.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  [CommentInteractionCell cellHByModel:_arrModel[indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentInteractionCell* cell =  [tableView dequeueReusableCellWithIdentifier:CommentInteractionCell_ forIndexPath:indexPath];
    [cell setModel:_arrModel[indexPath.section]];
    [cell setSelectionStyle:0];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    CGFloat H = 5;
    [view setFrame:CGRectMake(0, 0, SCREENWIDTH, H)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
    return 5;
}

- (IBAction)sendComment:(UIButton *)sender {
    
    NSString *comment = self.commentTextView.text;
    if (!comment.length) {
        [self.view makeToast:@"留言不能为空"];
        return;
    }
    weakObj;
    HDModel * m = [HDModel model];
    m.interactId = _interactionModel.interactId;
	m.content = comment;
    [BaseServer postObjc:m path:@"/interact/comment/add" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.commentTextView.text = @"";
            weakSelf.placeholder.alpha = 1;
			if(weakSelf.finishComBlock){
				weakSelf.finishComBlock(weakSelf.interactionModel);
			}
        });
    } failed:^(NSError *error) {
        
    }];
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
    
    [UIView animateWithDuration:animationDuration animations:^{
//        _commentView.frame = CGRectMake(0, SCREENHEIGHT - keyboardRect.size.height - CGRectGetHeight(_commentView.frame), SCREENHEIGHT, CGRectGetHeight(_commentView.frame));
        self.commentViewBottom.constant =  keyboardRect.size.height;
    }];
}
- (void)keyboardWillBeHidden:(NSNotification *)noti {
    NSTimeInterval animationDuration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];  //键盘动画时间
    [UIView animateKeyframesWithDuration:animationDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.commentViewBottom.constant = 0;
    } completion:nil];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
	if (textView.text.length != 0) {
		_placeholder.alpha = 0;
	}
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{//将要停止编辑(不是第一响应者时)
    if (textView.text.length == 0) {
        _placeholder.alpha = 1;
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length!=0) {
        _placeholder.alpha = 0;//开始编辑时
    }
    else if (text.length + textView.text.length== 0){
        _placeholder.alpha = 1;//删除时
    }
    if ([text isEqualToString:@"\n"]){
        //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
        return  NO;
    }
    return  YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

