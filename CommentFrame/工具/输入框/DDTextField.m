//
//  LBTextField.m
//  输入框
//
//  Created by warron on 2016/10/26.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "DDTextField.h"

@implementation DDTextField

// 设置Placeholder
- (void)customWithPlaceholder: (NSString *)placeholder color: (UIColor *)color font: (UIFont *)font {
    
    // 方法一：修改attributedPlaceholder;
    self.attributedPlaceholder = [self attributedStringWithString:placeholder color:color font:font];
    
    // 方法二：使用KVC,最为简单
    //    self.placeholder = placeholder;
    //    [self setValue:color forKeyPath:@"_placeholderLabel.color"];
    //    [self setValue:font forKeyPath:@"_placeholderLabel.font"];
}
-(NSAttributedString *)attributedStringWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = color;
    attrs[NSFontAttributeName] = font;
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    return attributedStr;
}
//// 重写这个方法是为了使Placeholder居中
//- (void)drawPlaceholderInRect:(CGRect)rect {
//    [super drawPlaceholderInRect:CGRectMake(5, self.frame.size.height* 0.5 , 0, 0)];
//}
@end
