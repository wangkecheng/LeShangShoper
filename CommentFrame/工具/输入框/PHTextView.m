//
//  PlaceholderTextView.m
//  SaleHelper
//
//  Created by gitBurning on 14/12/8.
//  Copyright (c) 2014年 Burning_git. All rights reserved.
//

#import "PHTextView.h"

@interface PHTextView()<UITextViewDelegate>
{
    UILabel *PlaceholderLabel;
}
@end

@implementation PHTextView

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}


- (void)awakeFromNib {
   
    //加下面一句话的目的是，是为了调整光标的位置，让光标出现在UITextView的正中间
    self.textContainerInset = UIEdgeInsetsMake(8,0, 0, 0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];

    float left=5,top=2,hegiht=30;
    
    self.placeholderColor = [UIColor whiteColor];
    PlaceholderLabel=[[UILabel alloc] initWithFrame:CGRectMake(left, top
                                                               , CGRectGetWidth(self.frame)-2*left, hegiht)];
    PlaceholderLabel.font=self.placeholderFont?self.placeholderFont:self.font;
    PlaceholderLabel.textColor=self.placeholderColor;
    [self addSubview:PlaceholderLabel];
    PlaceholderLabel.text=self.placeholder;

}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)setPlaceholder:(NSString *)placeholder{
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        PlaceholderLabel.hidden=YES;
    }
    else
        PlaceholderLabel.text=placeholder;
       _placeholder=placeholder;
}

-(void)DidChange:(NSNotification*)noti{
    
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        PlaceholderLabel.hidden=YES;
    }
    if (self.text.length > 0) {
        PlaceholderLabel.hidden=YES;
    }
    else{
        PlaceholderLabel.hidden=NO;
    }
}
-(CGFloat)setHByText:(NSString *)text{
    if (text == nil || [text  isEqualToString:@""]) {
        PlaceholderLabel.alpha = 1;
        PlaceholderLabel.text = _placeholder;
        PlaceholderLabel.hidden = NO;
    }
    
    CGRect frame = self.frame;
    float height;
//    if ([text isEqual:@""]) {
//        
//        if (![self.text isEqualToString:@""]) {
//            
//            height = [ self heightForTextView:self WithText:[self.text substringToIndex:[self.text length] - 1]];
//            
//        }else{
//            height = [ self heightForTextView:self WithText:self.text];
//        }
//    }else{
//        
//       
//    }

     height = [self heightForTextView:self WithText:[NSString stringWithFormat:@"%@%@",self.text,text]];
    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = frame;
        
    } completion:nil];
    return height;
}
//计算评论框文字的高度
- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    //    float padding = 10.0;
    CGSize constraint = CGSizeMake(textView.contentSize.width, CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 20;
    return textHeight;
}

@end
