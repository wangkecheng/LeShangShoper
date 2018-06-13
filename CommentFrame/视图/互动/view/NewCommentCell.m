//
//  NewCommentCell.m
//  CommentFrame
//
//  Created by 王帅 on 2018/6/13.
//  Copyright © 2018 warron. All rights reserved.
//

#import "NewCommentCell.h"

@implementation NewCommentModel
@end
@interface NewCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation NewCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    _headImg.layer.cornerRadius = CGRectGetWidth(_headImg.frame)/2.0;
    _headImg.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_backView addGestureRecognizer:tap];
    UserInfoModel * model = [CacheTool getUserModel];
    [_headImg sd_setImageWithURL:IMGURL(model.headUrl) placeholderImage:IMG(@"icon_touxiang")];
}
-(void)setModel:(NewCommentModel *)model{
    _model = model;
}
-(void)tap{
    if (_clickBlock) {
        _clickBlock(_model);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
}

@end
