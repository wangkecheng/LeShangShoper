//
//  NSDate+DateInterval.h
//  lubanlianmeng
//
//  Created by warron on 2016/10/24.
//  Copyright © 2016年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category) 

/**两个Date之间的比较*/
- (NSDateComponents *)intervalToDate:(NSDate *)date;

/**与当前时间比较*/
- (NSDateComponents *)intervalToNow;

//获取一个时间的 组成部分
+(NSDateComponents *)componentsByDate:(NSDate *)date;
@end
