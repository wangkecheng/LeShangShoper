//
//  PageControl.m
//  ProjectFirst
//
//  Created by  晏语科技 on 2017/1/18.
//  Copyright © 2017年 APICloud. All rights reserved.
//

#import "PageControl.h"
#define arcColor (arc4random() % 255/256.0)
@implementation PageControl

- (id)initWithFrame:(CGRect)frame pageStyle:(Q_PageControlStyle)pageStyle
{
    if(self = [super initWithFrame:frame])
    {
        
        /**
         *  默认设置
         */
        _Q_backageColor = [UIColor darkTextColor];
        _Q_selectionColor = [UIColor whiteColor];
        _Q_pageStyle = pageStyle;
        _Q_currentPag = 0;
        
    }
    return self;
}
/**
 *  设置MyPageView
 *
 *  @param Q_numberPags
 */
- (void)setQ_numberPags:(NSInteger)Q_numberPags{
    if(_Q_numberPags != Q_numberPags){
        _Q_numberPags = Q_numberPags;
        
        CGFloat marger = 10;
        NSLog(@"%f--",self.frame.size.width);
        CGFloat width = self.frame.size.width - (Q_numberPags- 1) * marger;
        CGFloat pointWidth = width/Q_numberPags;
        
        for(int i=0;i<Q_numberPags;i++)
        {
            
            
            UIView *aView = [[UIView alloc] init];
            aView.frame = CGRectMake((marger + pointWidth) * i, 0, pointWidth, pointWidth);
            aView.backgroundColor = _Q_backageColor;
            aView.layer.borderWidth = 0.2;
            aView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
            switch (_Q_pageStyle){
                case Q_PageControlStyleDefaoult:
                    aView.layer.cornerRadius = pointWidth/2;
                    aView.layer.masksToBounds = YES;
                    break;
                case Q_PageControlStyleSquare:
                    break;
                    
                default:
                    break;
            }
            [self addSubview:aView];
            /**
             *  设置cuurrentPag
             */
            if(i == 0)
            {
                if(_Q_selectionColor)
                {
                    aView.backgroundColor = _Q_selectionColor;
                }
                else
                {
                    aView.backgroundColor = [UIColor whiteColor];
                }
                
            }
            
        }
        
        
    }
    
}
/**
 *  当前的currentPag
 *
 *  @param Q_currentPag
 */
- (void)setQ_currentPag:(NSInteger)Q_currentPag
{
    
    if(_Q_currentPag != Q_currentPag)
    {
        _Q_currentPag = Q_currentPag;
        if(self.subviews.count)
        {
            for(UIView *dImg in self.subviews)
            {
                dImg.backgroundColor = _Q_backageColor;
                dImg.layer.borderColor = [UIColor grayColor].CGColor;
            }
            UIView *eImg = self.subviews[_Q_currentPag];
            eImg.backgroundColor = _Q_selectionColor;
            eImg.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
}
/**
 *  设置pag选中时的color
 *
 *  @param Q_selectionColor <#Q_selectionColor description#>
 */
- (void)setQ_selectionColor:(UIColor *)Q_selectionColor{
    
    if(_Q_selectionColor != Q_selectionColor){
        _Q_selectionColor = Q_selectionColor;
        if(self.subviews.count){
            UIView *aimg = self.subviews[_Q_currentPag];
            aimg.backgroundColor = _Q_selectionColor;
        }
    }
    
}

/**
 *  设置pag的backColor
 *
 *  @param backgroundColor <#backgroundColor description#>
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    
    _Q_backageColor = backgroundColor;
    if(self.subviews.count != 0)
    {
        for(UIView *aimg in self.subviews)
        {
            aimg.backgroundColor = _Q_backageColor;
        }
        UIView *bImg = self.subviews[_Q_currentPag];
        bImg.backgroundColor = _Q_selectionColor;
    }
    
}

@end
