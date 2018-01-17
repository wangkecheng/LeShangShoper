//
//  NSString+Category.h
//  CommentFrame
//
//  Created by warron on 2017/4/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
//是否是电话号码
- (BOOL)isPhoneNumber;

//判断是否是纯字母
-(BOOL)isPureCharacters;
//判断是否是纯数字
- (BOOL)isPureNum;

//判断是否包含连续的数组或字母，yes为包含
-(BOOL)rangeString;

//是否是钱
- (BOOL) isPrice;

//判断身份证号是否合法
-(BOOL)judgeIdentityStringValid;

// 判断银行卡号是否合法
-(BOOL)isBankCard;

//判断是否为整形：
- (BOOL)isPureInt;

//数字转字符
+ (NSString *)stringFromDouble:(double)num;

+ (NSString *)stringFromNum:(NSNumber *)num;

+ (NSString *)stringFromInt:(NSInteger )num;

/**
 获取缓存Cell使用的key
 
 @param indexPath indexPath
 @return key
 */
+ (NSString *)stringKeyFromIndexPath:(NSIndexPath *)indexPath;
//字符串是否为空
-(BOOL)isEmpty;
@end
