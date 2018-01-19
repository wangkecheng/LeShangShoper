//
//  NewsCell.h
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NewsModel : NSObject

@property(nonatomic,strong)NSString * name;//发布人
@property(nonatomic,strong)NSString * title;//标题
@property(nonatomic,strong)NSString * content;//内容
@property(nonatomic,strong)NSString * createAt;//发布时间
@property(nonatomic,strong)NSString * did;// 失信id
@property(nonatomic,strong)NSString * logoUrl;//logo地址
@end

@interface NewsCell : UITableViewCell
@property(nonatomic,strong)NewsModel *newsModel;
@end


