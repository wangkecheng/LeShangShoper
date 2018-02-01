//
//  NewsModel.h
//  CommentFrame
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LosePromissAndNewsModel.h"
@interface NewsModel : NSObject
+(NewsModel *)modelByDict:(NSDictionary *)dict;
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)NSMutableArray<LosePromissAndNewsModel *> *arrModel;
@end
