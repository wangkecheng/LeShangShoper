//
//  NSString+StringSize.h
//  fadein
//
//  Created by WangYaochang on 16/3/17.
//  Copyright © 2016年 Maverick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringSize)

/**
 * 返回字符串的 自定义 大小
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (CGSize)textSizeWithSystemFontSize:(CGFloat)fontSize constrainedToSize:(CGSize)size;


- (CGSize)textSizeWithFontSize:(CGFloat)fontSize constrainedToSize:(CGSize)size lineSpace:(CGFloat)space;

/**
 字符串大小

 @param font 字体
 @param size 限制大小
 @param space 行距
 @return 尺寸
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineSpace:(CGFloat)space;

- (NSDictionary *)attributesWith:(UIFont *)font lineSpace:(CGFloat)space;

- (NSDictionary *)attributesWithFontSize:(CGFloat)fontSize lineSpace:(CGFloat)space;
- (CGFloat)autoHByText:(NSString *)text Font:(CGFloat)font W:(CGFloat)W;
//高度不变获取宽度
- (CGFloat)autoWByText:(NSString *)text Font:(CGFloat)font H:(CGFloat)H;
@end
