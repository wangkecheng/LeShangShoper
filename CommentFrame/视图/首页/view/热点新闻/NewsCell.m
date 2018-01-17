//
//  NewsCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "NewsCell.h"
@implementation NewsModel

@end

@interface NewsCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *newsImg;

@end
@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setNewsModel:(NewsModel *)newsModel{
	_newsModel = newsModel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
