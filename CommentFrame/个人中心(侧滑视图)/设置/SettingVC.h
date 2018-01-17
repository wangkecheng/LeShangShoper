//
//  SettingVC.h
//  ChatDemo-UI3.0
//
//  Created by warron on 2017/8/2.
//  Copyright © 2017年 warron. All rights reserved.
//

#import "HDBaseTableVC.h"

@interface SettingVC : HDBaseTableVC

@property(nonatomic,copy)void(^reloadDataBlock)(void);
@end
