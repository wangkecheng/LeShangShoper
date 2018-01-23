//
//  NSDate+DateInterval.m
//  lubanlianmeng
//
//  Created by warron on 2016/10/24.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate(Category)
// 得到的结果如下图（可用作判断会话时间显示：例如：几分钟之前，今天，昨天 等

- (NSDateComponents *)intervalToDate:(NSDate *)date{
    // 日历对象
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    // 获得一个时间元素
    NSCalendarUnit  unit =  NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    
    return [calender components:unit fromDate:self toDate:date options:kNilOptions];
}
- (NSDateComponents *)intervalToNow{
    //获取当地时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDate *dateCurrent  = [NSDate date];
    NSTimeInterval interval = [zone secondsFromGMTForDate:dateCurrent];
    NSDate *localeDate = [dateCurrent dateByAddingTimeInterval:interval];
    return [self intervalToDate:localeDate];
}

+(NSDateComponents *)componentsByDate:(NSDate *)date{

    // 日历对象
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    // 获得一个时间元素
    NSCalendarUnit  unit =  NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    
   return [calender components:unit fromDate:date];
}
// 得到的结果为相差的天数
- (int)intervalSinceNow:(NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    // 这里的格式根据自己的需要自行确定（yyyy-MM-dd hh:mm:ss）
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[date dateFromString:theDate];
    
    NSInteger unitFlags = NSDayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:d];
    NSDate *newBegin  = [cal dateFromComponents:comps];
    
    // 当前时间
    NSCalendar *cal2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps2 = [cal2 components:unitFlags fromDate:[NSDate date]];
    NSDate *newEnd  = [cal2 dateFromComponents:comps2];
    
    
    NSTimeInterval interval = [newEnd timeIntervalSinceDate:newBegin];
    NSInteger resultDays=((NSInteger)interval)/(3600*24);
    
    return (int) resultDays;
}
@end
