//
//  NSString+Category.m
//  CommentFrame
//
//  Created by warron on 2017/4/21.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString(Category)

- (BOOL)isPhoneNumber
{
    if (![self hasPrefix:@"1"]) {
        return NO;
    }
    NSString * MOBILE = @"^[1-9]\\d{10}$";
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return  [regextestMobile evaluateWithObject:self];
}

//判断是否是纯字母
-(BOOL)isPureCharacters{
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
    if(str.length > 0) {
        return NO;
    }
    return YES;
}
//判断是否是纯数字
- (BOOL)isPureNum{
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(str.length > 0) {
        return NO;
    }
    return YES;
}

//判断是否包含连续的数组或字母，yes为包含
-(BOOL)rangeString {
    BOOL result = NO;
    for (int i = 0; i < self.length; i++) {
        if (self.length - i < 4 ) {
            break;
        }
        NSString *newStr = [self substringWithRange:NSMakeRange(i, 4)];
        if ([self isPureCharacters] || [self isPureNum]) {
            NSLog(@"%@",newStr);
            result = YES; break;
        }
    }
    return result;
}

- (BOOL) isPrice {
    NSString *format =@"(^[1-9]([0-9]+)?(.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9].[0-9]([0-9])?$)";
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", format];
    if ([regextest evaluateWithObject:self] == YES)
        return YES;
    else
        return NO;
}
//判断是否为整形：
- (BOOL)isPureInt{
    NSScanner* scanner = [NSScanner scannerWithString:self];
    int val;
    return[scanner scanInt:&val] && [scanner isAtEnd];
}

#pragma mark 判断身份证号是否合法
-(BOOL)judgeIdentityStringValid{
    if (self.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:self]) return NO;
    //** 开始进行校验 *//
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex  = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum      += subStrIndex * idCardWiIndex;
    }
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark 判断银行卡号是否合法
-(BOOL)isBankCard{
    if(self.length==0){
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < self.length; i++){
        c = [self characterAtIndex:i];
        if (isdigit(c)){
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--){
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo){
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}
+ (NSString *)stringFromDouble:(double)num {
    return [NSString stringWithFormat:@"%f",num];
}

+ (NSString *)stringFromNum:(NSNumber *)num {
    return [NSString stringWithFormat:@"%ld",[num integerValue]];
}

+ (NSString *)stringFromInt:(NSInteger )num{
    return [NSString stringWithFormat:@"%ld",num ];
}
+ (NSString *)stringFromNumber:(NSNumber *)num {
	return [NSString stringWithFormat:@"%@",num];
}
  
+ (NSString *)stringKeyFromIndexPath:(NSIndexPath *)indexPath {
	NSString *section = [self stringFromInt:indexPath.section];
	NSString *row = [self stringFromInt:indexPath.row];
	return [NSString stringWithFormat:@"%@-%@",section,row];
}

/*
 *功能说明：
 *    判断字符串为空
 *参数说明：
 *string : 需要判断的字符串
 */
-(BOOL)isEmpty{
    
    return ((self == nil)
            ||([self isEqual:[NSNull null]])
            ||([self isEqualToString:@"<null>"])
            ||([self isEqualToString:@"(null)"])
            ||([self isEqualToString:@" "])
            ||([self isEqualToString:@""])
            ||([self isEqualToString:@""])
            ||([self isEqualToString:@"(\n)"])
            ||([self isEqualToString:@"yanyu"])
            );
}
@end
