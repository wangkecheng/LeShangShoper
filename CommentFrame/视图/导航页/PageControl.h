//
//  PageControl.h
//  ProjectFirst
//
//  Created by  晏语科技 on 2017/1/18.
//  Copyright © 2017年 APICloud. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum:NSInteger{
    /**
     默认类型:圆形
     */
    Q_PageControlStyleDefaoult = 0,
    /**
     正方形
     */
    Q_PageControlStyleSquare,
    
}Q_PageControlStyle;

@interface PageControl : UIView

@property(nonatomic,assign) NSInteger Q_numberPags;

@property(nonatomic,assign) NSInteger Q_currentPag;

@property(nonatomic,strong) UIColor *Q_selectionColor;

@property(nonatomic,strong) UIColor *Q_backageColor;

@property(nonatomic,assign) Q_PageControlStyle Q_pageStyle;


- (id)initWithFrame:(CGRect)frame pageStyle:(Q_PageControlStyle)pageStyle;
@end
