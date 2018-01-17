//
//  AlphabetTitleView.h
//  CommentFrame
//
//  Created by warron on 2017/12/16.
//  Copyright © 2017年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlphabetTitleModel.h"
@interface AlphabetTitleView : UIView
+(instancetype)headerViewWithFrame:(CGRect)frame;
@property(nonatomic,copy)void(^foldedBlock)(AlphabetTitleModel *model);
@property(nonatomic,strong)AlphabetTitleModel * model;
@property(nonatomic,strong)AlphabetTitleModel * schoolTitmodel;

@end
