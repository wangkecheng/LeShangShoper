//
//  LaunchAdModel.m
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  广告数据模型
#import "LaunchAdModel.h"

@implementation LaunchAdModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        self.content = IMGURL(dict[@"imageUrl"]).absoluteString;
        self.openUrl = IMGURL(dict[@"url"]).absoluteString;
        self.duration = 3; 
        self.contentSize = [NSString stringWithFormat:@"%lf*%lf",SCREENWIDTH,SCREENHEIGHT];
    }
    return self;
}
-(CGFloat)width
{
    return [[[self.contentSize componentsSeparatedByString:@"*"] firstObject] floatValue];
}
-(CGFloat)height
{
    return [[[self.contentSize componentsSeparatedByString:@"*"] lastObject] floatValue];
}
@end
