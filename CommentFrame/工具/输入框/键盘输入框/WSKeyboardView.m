//
//  CustomKeyboard.m
//  keyboard
//
//  Created by zhaowang on 14-3-25.
//  Copyright (c) 2014年 anyfish. All rights reserved.
//

#import "WSKeyboardView.h"
#define kLineWidth 1
#define kNumFont [UIFont systemFontOfSize:27]


@interface WSKeyboardView()

@property (nonatomic,strong)NSArray *arrLetter;

@property (nonatomic,copy)void(^inputBlock)(NSInteger number,UITextField *textField);
@property (nonatomic,copy)void(^backspaceBlock)(UITextField *textField);
@property (nonatomic,copy)void(^pointBlock)(UITextField *textField);
@property (nonatomic,assign)KeyboardType keyboardType;
@property (nonatomic,strong)UITextField *textField;
@end

@implementation WSKeyboardView

+(WSKeyboardView *)decimalBoardByField:(UITextField *)textField
                            inputBlock:(void(^)(NSInteger number,UITextField *textField))inputBlock
                        backspaceBlock:(void(^)(UITextField *textField))backspaceBlock
                            pointBlock:(void(^)(UITextField *textField))pointBlock{
    WSKeyboardView * board = [self decimalBoardByFrame:CGRectMake(0, 200, SCREENWIDTH, 240) field:textField inputBlock:inputBlock backspaceBlock:backspaceBlock pointBlock:pointBlock];
    return board;
}
+(WSKeyboardView *)decimalBoardByFrame:(CGRect)frame
                                 field:(UITextField *)textField
                            inputBlock:(void(^)(NSInteger number,UITextField *textField))inputBlock
                        backspaceBlock:(void(^)(UITextField *textField))backspaceBlock
                            pointBlock:(void(^)(UITextField *textField))pointBlock{
    WSKeyboardView * board = [[WSKeyboardView alloc]initWithFrame:frame keyboardType:KeyboardTypeDecimalPad];
    board.inputBlock = inputBlock;
    board.textField  = textField;
    textField.inputView = board;
    board.backspaceBlock = backspaceBlock;
    board.pointBlock = pointBlock;
    return board;
}


+(WSKeyboardView *)numberBoardByField:(UITextField *)textField
                           inputBlock:(void(^)(NSInteger number,UITextField *textField))inputBlock
                       backspaceBlock:(void(^)(UITextField *textField))backspaceBlock {
      WSKeyboardView * board = [self numberBoardByFrame:CGRectMake(0, 200, SCREENWIDTH, 240) field:textField inputBlock:inputBlock backspaceBlock:backspaceBlock];
    return board;
}
+(WSKeyboardView *)numberBoardByFrame:(CGRect)frame
                                field:(UITextField *)textField
                           inputBlock:(void(^)(NSInteger number,UITextField *textField))inputBlock
                       backspaceBlock:(void(^)(UITextField *textField))backspaceBlock{
    WSKeyboardView * board = [[WSKeyboardView alloc]initWithFrame:frame keyboardType:KeyboardTypeNumberPad];
    board.textField  = textField;
    textField.inputView = board;
    board.inputBlock = inputBlock;
    board.backspaceBlock = backspaceBlock;
    return board;
}
- (id)initWithFrame:(CGRect)frame keyboardType:(KeyboardType)keyboardType{
    self = [super initWithFrame:frame];
    if (self) {
        _keyboardType = keyboardType;
        _arrLetter = [NSArray arrayWithObjects:@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"RST",@"UVW",@"XYZW", nil];
        for (int i=0; i<4; i++){
            for (int j=0; j<3; j++){
                UIButton *button = [self creatButtonWithX:i Y:j];
                [self addSubview:button];
            }
        }
        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/3.0, 0, kLineWidth, CGRectGetHeight(frame))];
        line1.backgroundColor = color;
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/3.0 * 2, 0, kLineWidth, CGRectGetHeight(frame))];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        CGFloat frameH =  CGRectGetHeight(self.frame)/4.0;
        for (int i=0; i<3; i++){
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frameH*(i+1), SCREENWIDTH, kLineWidth)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
        
    }
    return self;
}

-(UIButton *)creatButtonWithX:(NSInteger) x Y:(NSInteger) y{
    UIButton *button;
    CGFloat frameX = 0.0;
    CGFloat frameW = SCREENWIDTH/3.0;
    CGFloat frameH =  CGRectGetHeight(self.frame)/4.0;
    switch (y){
        case 0:
            frameX = 0.0;
            break;
        case 1:
            frameX = SCREENWIDTH/3.0;
            break;
        case 2:
            frameX = SCREENWIDTH/3.0 * 2;
            break;
        default:
            break;
    }
    CGFloat frameY = frameH*x; 
    button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, frameW, frameH)];
    NSInteger num = y+3*x+1;
    button.tag = num;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *colorNormal = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
    UIColor *colorHightlighted = [UIColor colorWithRed:186.0/255 green:189.0/255 blue:194.0/255 alpha:1.0];
    
    if (num == 10 || num == 12){
        UIColor *colorTemp = colorNormal;
        colorNormal = colorHightlighted;
        colorHightlighted = colorTemp;
    }
    button.backgroundColor = colorNormal;
    CGSize imageSize = CGSizeMake(frameW, 54);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [colorHightlighted set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [button setImage:pressedColorImg forState:UIControlStateHighlighted];
    
    if (num<10) {
        UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, (frameH - 28)/2.0 - 5, frameW, 28)];
        labelNum.text = [NSString stringWithFormat:@"%ld",(long)num];
        labelNum.textColor = [UIColor blackColor];
        labelNum.textAlignment = NSTextAlignmentCenter;
        labelNum.font = kNumFont;
        [button addSubview:labelNum];
        
        if (num != 1) {
            UILabel *labelLetter = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labelNum.frame), frameW, 16)];
            labelLetter.text = [_arrLetter objectAtIndex:num-2];
            labelLetter.textColor = [UIColor blackColor];
            labelLetter.textAlignment = NSTextAlignmentCenter;
            labelLetter.font = [UIFont systemFontOfSize:12];
            [button addSubview:labelLetter];
        }
    }
    else if (num == 11 || num == 10){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frameW, frameH)];
        label.text = @"0";
        button.alpha = 1;
        if (num == 10) {
             label.text = @".";
            if (_keyboardType == KeyboardTypeNumberPad) {//如果是数字键盘就不显示
                button.alpha = 0;
            }
        }
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kNumFont;
        [button addSubview:label];
    }
    else {
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake((frameW - 22)/2.0, (frameH - 17)/2.0, 22, 17)];
        arrow.image = [UIImage imageNamed:@"arrowInKeyboard"];
        [button addSubview:arrow];
    }
    return button;
}


-(void)clickButton:(UIButton *)sender{
    if (sender.tag == 10) {//点
        
        if (_pointBlock) {
            _pointBlock(_textField);
        }
        return;
    }
    else if(sender.tag == 12) {//删除
        if (_textField.text.length != 0) {
           _textField.text = [_textField.text substringToIndex:_textField.text.length -1];
        }
        if (_backspaceBlock) {
            _backspaceBlock(_textField);
        }
    }
    else  {
        NSInteger num = sender.tag;
        if (sender.tag == 11) {
            num = 0;
        }
        
       _textField.text = [_textField.text stringByAppendingString:[NSString stringWithFormat:@"%ld",num]];
        if (_inputBlock) {
          _inputBlock(num,_textField);
        }
    }
}
@end
