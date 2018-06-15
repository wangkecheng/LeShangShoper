//
//  CustomKeyboard.h
//  keyboard
//
//  Created by zhaowang on 14-3-25.
//  Copyright (c) 2014年 anyfish. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum KeyboardType{
    
    KeyboardTypeNumberPad = 1001,
    KeyboardTypeDecimalPad, //密码输入框
}KeyboardType;
@interface WSKeyboardView : UIView



//小数点键盘
+(WSKeyboardView *)decimalBoardByField:(UITextField *)textField
                            inputBlock:(void(^)(NSInteger number,UITextField *textField))inputBlock
                        backspaceBlock:(void(^)(UITextField *textField))backspaceBlock
                            pointBlock:(void(^)(UITextField *textField))pointBlock;
//小数点键盘 带frame
+(WSKeyboardView *)decimalBoardByFrame:(CGRect)frame
                                 field:(UITextField *)textField
                            inputBlock:(void(^)(NSInteger number,UITextField *textField))inputBlock
                        backspaceBlock:(void(^)(UITextField *textField))backspaceBlock
                            pointBlock:(void(^)(UITextField *textField))pointBlock;

//数字键盘
+(WSKeyboardView *)numberBoardByField:(UITextField *)textField
                           inputBlock:(void(^)(NSInteger number,UITextField *textField))inputBlock
                       backspaceBlock:(void(^)(UITextField *textField))backspaceBlock;

//带frame
+(WSKeyboardView *)numberBoardByFrame:(CGRect)frame
                                field:(UITextField *)textField
                           inputBlock:(void(^)(NSInteger number,UITextField *textField))inputBlock
                       backspaceBlock:(void(^)(UITextField *textField))backspaceBlock;
@end
