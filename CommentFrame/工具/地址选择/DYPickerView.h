//
//  DYPickerView.h
//  地址选择
//
//  Created by warron on 2016/10/25.
//  Copyright © 2016年 warron. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface SelectInfoModel : NSObject//选择后的信息模型
+(SelectInfoModel *)modelByProvenceName:(NSString *)provenceName cityName:(NSString *)cityName countyName:(NSString *)countyName;
@property (nonatomic,strong)NSString *provenceName;
@property (nonatomic,strong)NSString *cityName;
@property (nonatomic,strong)NSString *countyName;
@end


@interface DYPickerView : UIView

-(instancetype)initWithSheetH:(CGFloat)sheetH cancelBlock:(void(^)(void))cancelBlock okBlock:(void(^)(SelectInfoModel *model))okBlock;
-(void)show;//显示sheet框
-(void)dissmiss;//移除sheet框
@end
