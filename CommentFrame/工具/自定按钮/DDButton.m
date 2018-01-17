//
//  LBButton.m
//  按钮图片文字
//
//  Created by warron on 2016/10/30.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "DDButton.h"

@interface DDButton()
@property (nonatomic,assign)CGFloat titleX;
@property (nonatomic,assign)CGFloat titleY;
@property (nonatomic,assign)CGFloat titleW;
@property (nonatomic,assign)CGFloat titleH;
@property (nonatomic,assign)CGFloat imageX;
@property (nonatomic,assign)CGFloat imageY;
@property (nonatomic,assign)CGFloat imageW;
@property (nonatomic,assign)CGFloat imageH;

@end
@implementation DDButton

//直接设置标题 图片 x 和 w 图片和标题在水平线上
-(instancetype)initWithHorizontal:(CGRect)frame titleX:(CGFloat)titleX  titleW:(CGFloat)titleW imageX:(CGFloat)imageX imageW:(CGFloat)imageW{
    if (self = [super  initWithFrame:frame]) {
        //此时说明 标题和图片的Y值为零 高度为按钮高度
        _imageY = 0;
        _titleY = 0;
        _titleH = frame.size.height;
        _imageH = frame.size.height;
           [self setTitleX:titleX titleY:_titleY titleW:titleW titleH:_titleH imageX:imageX imageY:_imageY imageW:imageW imageH:_imageH];
    }
    return self;
}
//直接设置标题 图片 x 和 w 图片和标题在垂直线上
-(instancetype)initWithVertical:(CGRect)frame titleY:(CGFloat)titleY  titleH:(CGFloat)titleH imageY:(CGFloat)imageY imageH:(CGFloat)imageH{

    if (self = [super  initWithFrame:frame]) {
        //此时说明 标题和图片的X值为零 宽度度为按钮高度
        _titleX = _imageX = 0;
        _titleW = _imageW = frame.size.width;
          [self setTitleX:_titleX titleY:titleY titleW:_titleW titleH:titleH imageX:_imageX imageY:imageY imageW:_imageW imageH:imageH];
    }
    return self;
}

//直接设置全部属性
-(instancetype)initWithFrame:(CGRect)frame titleX:(CGFloat)titleX titleY:(CGFloat)titleY titleW:(CGFloat)titleW titleH:(CGFloat)titleH imageX:(CGFloat)imageX imageY:(CGFloat)imageY imageW:(CGFloat)imageW imageH:(CGFloat)imageH{
    
    if(self = [super initWithFrame:frame]) {
        
        [self setTitleX:titleX titleY:titleY titleW:titleW titleH:titleH imageX:imageX imageY:imageY imageW:imageW imageH:imageH];
    }
    return  self;
}
-(void)setTitleX:(CGFloat)titleX titleY:(CGFloat)titleY titleW:(CGFloat)titleW titleH:(CGFloat)titleH imageX:(CGFloat)imageX imageY:(CGFloat)imageY imageW:(CGFloat)imageW imageH:(CGFloat)imageH{
     //标题 图片坐标
         _titleX = titleX;
         _titleY = titleY;
         _titleW = titleW;
         _titleH = titleH;
    
         _imageX = imageX;
         _imageY = imageY;
         _imageW = imageW;
         _imageH = imageH;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    //返回标题位置
    return  CGRectMake(_titleX, _titleY, _titleW, _titleH);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    //返回图片位置
    return  CGRectMake(_imageX, _imageY, _imageW, _imageH);
}

@end
