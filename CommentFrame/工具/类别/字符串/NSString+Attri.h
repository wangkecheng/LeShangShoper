//
//  NSString+Attri.h
//  ComFrameSlide
//
//  Created by warron on 2017/5/24.
//  Copyright © 2017年 warron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Attri)
/********************************************************************
 *  返回包含关键字的富文本编辑
 *
 *  @param lineSpacing 行高
 *  @param textcolor   字体颜色
 *  @param font        字体
 *  @param KeyColor    关键字字体颜色
 *  @param KeyFont     关键字字体
 *  @param KeyWords    关键字数组
 *
 *  @return
 ********************************************************************/
-(NSMutableAttributedString *)atrWithLineSpacing:(CGFloat)Spacing
                                           textColor:(UIColor *)textcolor
                                            textFont:(id)font
                                    withKeyTextColor:(UIColor *)KeyColor
                                             keyFont:(id)KeyFont

                                        keyWords:(NSArray *)KeyWords;

 
@end
