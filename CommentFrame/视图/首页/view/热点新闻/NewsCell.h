//
//  NewsCell.h
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NewsModel : NSObject
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * img;
@end 
@interface NewsCell : UITableViewCell
@property(nonatomic,strong)NewsModel *newsModel;
@end


