//
//  InteracteHeaderView.m
//  CommentFrame
//
//  Created by 王帅 on 2018/6/13.
//  Copyright © 2018 warron. All rights reserved.
//

#import "InteracteHeaderView.h"
#import "NewCommentCell.h"
#define NewCommentCell_ @"NewCommentCell"
@interface InteracteHeaderView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * arrModel;
@property (nonatomic,strong)UITableView * tableView;
@end
@implementation InteracteHeaderView

-(instancetype)init{
    if (self = [super init]) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        [_tableView hideSurplusLine];
        _tableView.separatorStyle = 0;
        [_tableView registerNib:[UINib nibWithNibName:NewCommentCell_ bundle:nil] forCellReuseIdentifier:NewCommentCell_];
        _arrModel = [NSMutableArray array];
    }
    return self;
}
-(void)refresh{
    [_arrModel removeAllObjects];
    weakObj;
    [BaseServer postObjc:nil path:@"/interact/comment/ids" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            for (NSString *interactId in result[@"data"][@"ids"]) {
                NewCommentModel *model = [[NewCommentModel alloc]init];
                model.interactId = interactId;
                [strongSelf.arrModel addObject:model];
            }
            [strongSelf setFrame];
        });
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf setFrame];
        });
    }];
}
-(void)setFrame{
    NSInteger count = _arrModel.count;
    if (count > 3) {
        count = 3;
    }
    self.frame = CGRectMake(0, 0, SCREENWIDTH, count * 50);
    [_tableView setFrame:self.bounds];
    [_tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrModel.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:NewCommentCell_ forIndexPath:indexPath];
    cell.selectionStyle = 0;
    weakObj;
    cell.clickBlock = ^(NewCommentModel *model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.arrModel removeObject:model];
            [strongSelf setFrame];
            if (strongSelf.toCommentInteractionVCBlock) {  strongSelf.toCommentInteractionVCBlock(model.interactId);
            }
        });
        HDModel * m = [HDModel model];
        m.interactId = model.interactId;
        [BaseServer postObjc:m path:@"/interact/comment/look" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                __strong typeof (weakSelf) strongSelf = weakSelf;
                  [strongSelf.tableView reloadData];
            });
        } failed:^(NSError *error) {
            
        }];
    };
    if (_arrModel.count - 1 >= indexPath.row) {
        cell.model = _arrModel[indexPath.row];
    }
    return  cell;
}
@end
