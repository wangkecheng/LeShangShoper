      
//
//  DDFactory.m
//  HelloDingDang
//
//  Created by  晏语科技 on 2016/11/29.
//  Copyright © 2016年 重庆晏语科技. All rights reserved.
//

#import "DDFactory.h"
#import <sys/utsname.h>
#include<sys/types.h>
#import <sys/utsname.h>
#include<sys/sysctl.h>
@implementation DDFactory

+(instancetype)factory{
    
    static  DDFactory *factory  = nil;
    static dispatch_once_t once;
    if (!factory) {
        dispatch_once(&once, ^{
            factory = [[DDFactory alloc]initPrivate];
         
        });
    }
    return factory;
}


-(instancetype)init{
    //不允许用init方法
    @throw [NSException exceptionWithName:@"Singleton" reason:@"FirstVC is a Singleton, please Use shareView to create" userInfo:nil];
}

-(instancetype)initPrivate{
    
    return  self = [super init];
}

+(NSArray *)createClassByPlistName:(NSString *)plistName{
    
    NSString *itemVCPath = [[NSBundle mainBundle]pathForResource:plistName ofType:@"plist"];
    
    NSArray * array = [[NSArray alloc]initWithContentsOfFile:itemVCPath];
    
    
    NSMutableArray * arrItemVC = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSDictionary  *dict, NSUInteger idx, BOOL *  stop) {
        //每一个视图有类名，标题， 将其放在字典中
        NSMutableDictionary * dictItem = [NSMutableDictionary dictionary];
        
        NSString *className = dict[ClassName];
        Class classControl = NSClassFromString(className);
        UIViewController *basePagerVC = [[classControl alloc]init];
        basePagerVC.title = dict[TitleVC];
        
        //将视图放在字典中
        [dictItem setObject:basePagerVC forKey:ClassName];
        
        //将标题放在字典中
        [dictItem setObject:dict[TitleVC] forKey:TitleVC];
        
        //将图片放在字典中
        if ([[dict allKeys]containsObject:Image]) {
            
            [dictItem setObject:dict[Image] forKey:Image];
            
        }
        //将图片放在字典中
        if ([[dict allKeys]containsObject:SelectImage]) {
            
            [dictItem setObject:dict[SelectImage] forKey:SelectImage];
            
        }
        //将附加信息放在字典中
        if ([[dict allKeys]containsObject:AttachInfo]) {
            
            [dictItem setObject:dict[AttachInfo] forKey:AttachInfo];
            
        }
        [arrItemVC addObject:dictItem];
    }];
    return  [arrItemVC copy];
}

#pragma mark - 发送广播给一个频道
- (void) broadcast:(NSObject *) data channel: (NSString *)channel {
    
    if(_observerData == nil) {
        _observerData = [[NSMutableDictionary alloc]init];
    }
    
    if(data != nil) {
        [_observerData setObject: data forKey:channel];
    }
    else {
        [_observerData removeObjectForKey:channel];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:channel object:data];
}

#pragma mark - 安装一个频道广播接收器
- (void) addObserver:(id)observer selector:(SEL)aSelector channel: (NSString *)channel {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:channel object:nil];
    if(_observerData != nil) {
        id data = [_observerData objectForKey:channel];
        if(data != nil) {
            NSNotification *notification = [[NSNotification alloc] initWithName:channel object:data userInfo:nil];
            [observer performSelector:aSelector withObject: notification];
        }
    }
}

#pragma mark - 移除收音机
- (void) removeObserver:(id)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

#pragma mark - 移除接收频道
- (void)removeChannel:(NSString *)channel{
    if (_observerData!= nil)
        [_observerData removeObjectForKey:channel];
}

// 颜色转换为背景图片 注意 四个取值， 会影响最终颜色
+(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIViewController *)appRootViewController{
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *topVC = appRootVC;
    
    while (topVC.presentedViewController) {
        
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

+(void)checkNetWorkingState{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    NSOperationQueue *operationQueue       = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                NSLog(@"有网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                NSLog(@"无网络");
                break;
        }
    }];
    // 开始监听
    [manager.reachabilityManager startMonitoring];
}
+ (NSDictionary *) reverseDict:(NSDictionary *)dict {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	if([dict isKindOfClass:[NSDictionary class]]){
		for (NSString *key in [dict allKeys]) {
			id value = [dict objectForKey:key];
			if ([value isKindOfClass:[NSString class]]) {
				[dic setObject:[NSString stringWithFormat:@"%@",value] forKey:key];
			}
			if ([value isKindOfClass:[NSNumber class]]) {
				[dic setObject:[NSString stringWithFormat:@"%@",value] forKey:key];
			}
			
			if ([value isKindOfClass:[NSDictionary class]]) {
				NSDictionary *eleDict = [self reverseDict:value];
				[dic setObject:eleDict  forKey:key];
			}
			if ([value isKindOfClass:[NSArray class]]) {
				
				NSMutableArray  *arr = [[NSMutableArray alloc]init];
				for (NSDictionary *dictT in value) {
					if([dictT isKindOfClass:[NSDictionary class]]) {
						[arr addObject:[self reverseDict:dictT]];
					}
					else if ([dictT isKindOfClass:[NSString class]]){
						[arr addObject:dictT];
					}
				}
				[dic setObject:arr forKey:key];
			}
		}
	} 
    return [dic copy];
}
+ (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    return imageData;
}

//去除searhBarBack的背景色
+(void)removeSearhBarBack:(UISearchBar *)searchBar{
    for (UIView *view in searchBar.subviews) {
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
            }
        }
        //7.0以前
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
    }
}

+(NSURL *)getImgUrl:(NSString *)imgStr{
    if ([imgStr isKindOfClass:[NSURL class]]) {
        NSURL *imgUrl = (NSURL *)imgStr;
        imgStr = imgUrl.absoluteString;
        if (([imgStr rangeOfString:@"http"].location == NSNotFound)){
            return [NSURL URLWithString:[POST_HOST stringByAppendingString:imgStr]];// 这里需要自己改 @""
        }
        return [NSURL URLWithString:imgStr];
    }
    if (([imgStr rangeOfString:@"http"].location == NSNotFound)){
        if (imgStr==nil) {
            imgStr = @"";
        }
        NSString  *newUrlString = [[NSString stringWithFormat:@"%@%@",POST_HOST,imgStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL * url = [NSURL URLWithString:newUrlString];
        return url;// 这里需要自己改 @""
    }
    return [NSURL URLWithString:imgStr] ;
}

+ (NSString*)getCurrentDeviceModel{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    //iPhone系列
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    
    //iPod系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceModel isEqualToString:@"iPod7,1"])      return @"iPod Touch 7G";
    
    //iPad系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad mini 2";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad mini 2";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad mini 4";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad mini 4";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4G";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4G";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4G";
    if ([deviceModel isEqualToString:@"iPad6,11"])      return @"iPad 5G";
    if ([deviceModel isEqualToString:@"iPad6,12"])      return @"iPad 5G";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad7,1"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad7,2"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad7,3"])      return @"iPad Pro";
    if ([deviceModel isEqualToString:@"iPad7,4"])      return @"iPad Pro";
    if ([[deviceModel uppercaseString] containsString:@"X"] && ![[deviceModel uppercaseString] containsString:@"86_64"]&& ![[deviceModel uppercaseString] containsString:@"i386"])      return @"IPX";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"IPX";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"IPX";
    
//    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
//    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
    
}
+ (NSString *)getString:(NSString *)string withDefault:(NSString *)defaultString{
	
	NSString * temStr;
	if (![string isKindOfClass:[NSString class]]) {
		temStr =  [DDFactory toString:string];
	}else{
		temStr = string;
	}
	if([DDFactory isEmptyWithString:temStr]
	   ){
		//为空，返回默认数据
		return defaultString;
	}else{
		//不为空，直接返回数据
		return temStr;
	}
}
+ (NSString *)toString:(id)anyObject{
	return [NSString stringWithFormat:@"%@",anyObject];
}
/*
 *功能说明：
 *    判断字符串为空
 *参数说明：
 *string : 需要判断的字符串
 */
+ (BOOL)isEmptyWithString:(NSString *)string{
	NSString * temStr;
	if (![string isKindOfClass:[NSString class]]) {
		temStr =  [DDFactory toString:string];
	}else{
		temStr = string;
	}
	return ((temStr == nil)
			||([temStr isEqual:[NSNull null]])
			||([temStr isEqualToString:@"<null>"])
			||([temStr isEqualToString:@"(null)"])
			||([temStr isEqualToString:@" "])
			||([temStr isEqualToString:@""])
			||([temStr isEqualToString:@""])
			||([temStr isEqualToString:@"(\n)"])
			||([temStr isEqualToString:@"yanyu"])
			);
}
+(id)getXibObjc:(NSString *)xibName{
	
	return [[NSBundle mainBundle]loadNibNamed:xibName owner:nil options:nil][0];
}
+ (UIViewController *)getVCById:(NSString *)Id{
	
	return [self getVCById:Id storyboardName:Id];
}
+ (id)getVCById:(NSString *)Id storyboardName:(NSString *)name {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
	UIViewController *VC = [storyboard instantiateViewControllerWithIdentifier:Id];
	return VC;
}
+(UIImage *)circleImage:(UIImage *)image size:(CGSize)size{
	//创建视图上下文
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	//绘制按钮头像范围
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat iconX = 0;
	CGFloat iconY = 0;
	CGFloat iconW = size.width;
	CGFloat iconH = size.height;
	CGContextAddEllipseInRect(context, CGRectMake(iconX, iconY, iconW, iconH));
	
	//剪切可视范围
	CGContextClip(context);
	
	//绘制头像
	[image drawInRect:CGRectMake(iconX, iconY, iconW, iconH)];
	
	//取出整个图片上下文的图片
	image =  UIGraphicsGetImageFromCurrentImageContext();
	return image;
}

//高度不变获取宽度
+(CGFloat)autoWByText:(NSString *)text Font:(CGFloat)font fontSize:(NSInteger)size H:(CGFloat)H{
	if (text.length == 0  ) {
		return  0;
	}
	CGRect rect=  [text boundingRectWithSize:CGSizeMake(MAXFLOAT, H) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
	return rect.size.width;
}

+(CGFloat)autoHByText:(NSString *)text Font:(UIFont *)font fontSize:(NSInteger)size W:(CGFloat)W{
	if (text.length == 0  )  {
		return  0;
	}
	NSStringDrawingOptions opts =NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
	NSMutableParagraphStyle*style = [[NSMutableParagraphStyle alloc]init];
	[style setLineBreakMode:NSLineBreakByWordWrapping];
    NSMutableDictionary * attribute = [NSMutableDictionary dictionary];
    
    if(!font){
       [attribute  setObject:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
       [attribute  setObject:style forKey:NSParagraphStyleAttributeName];
    }else{
     [attribute addEntriesFromDictionary:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style}];
    }
 
	CGRect rect=  [text boundingRectWithSize:CGSizeMake(W,MAXFLOAT) options: opts attributes:attribute context:nil];
	return rect.size.height;
}
/**
 *  根据图片url获取图片尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8])|(173)|(177))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
@end

