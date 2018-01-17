//
//  AlphabetTitleModel.h
//  CommentFrame
//
//  Created by warron on 2017/12/16.
//  Copyright © 2017年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlphabetTitleModel : NSObject
 
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSArray *childrenArrModel;
@property (nonatomic,assign)BOOL isFolded;
@end
