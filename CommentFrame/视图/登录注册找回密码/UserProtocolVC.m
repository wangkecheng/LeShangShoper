
//
//  UserProtocolVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/27.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "UserProtocolVC.h"

#define  ProtocolTypePrivacyContent @""
@interface UserProtocolVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,assign) ProtocolType type;
@end

@implementation UserProtocolVC
- (instancetype)initWithType:(ProtocolType)type{
	self = [super init];
	if (self) {
		_type = type;
	}
	return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    weakObj;
	if (_type == ProtocolTypeUse) {
		self.title = @"新易陶用户使用协议";
        [BaseServer postObjc:nil path:@"/user/agree" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf setContent:result[@"data"][@"agree"]];
            });
        } failed:^(NSError *error) {
            
        }];
    }else{
           self.title = @"法律声明及隐私权政策"; 
        NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                           "<head> \n"
                           "<style type=\"text/css\"> \n"
                           "body {font-size:15px;}\n"
                           "</style> \n"
                           "</head> \n"
                           "<body>"
                           "<script type='text/javascript'>"
                           "window.onload = function(){\n"
                           "var $img = document.getElementsByTagName('img');\n"
                           "for(var p in  $img){\n"
                           " $img[p].style.width = '100%%';\n"
                           "$img[p].style.height ='auto'\n"
                           "}\n"
                           "}"
                           "</script>%@"
                           "</body>"
                           "</html>",ProtocolTypePrivacyContent];
        [self setContent:htmls];
    }
}

-(void)setContent:(NSString *)str{
   
      [self.webView loadHTMLString:str baseURL:[NSURL URLWithString:@"https://120.79.169.197:3000"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
