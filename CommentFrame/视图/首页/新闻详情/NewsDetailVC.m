//  LosePromiseDetailVC.m
//  CommentFrame
//  Created by warron on 2018/1/14.
//  Copyright © 2018年 warron. All rights reserved.

#import "NewsDetailVC.h"
#import <WebKit/WebKit.h>
@interface NewsDetailVC ()<WKUIDelegate,WKNavigationDelegate>
 
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation NewsDetailVC
-(instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.title  = title;;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad]; 
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    HDModel *m = [HDModel model];
    m.did = _model.did;
    weakObj;
    [BaseServer postObjc:m path:@"/news/info" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
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
                               "</html>",result[@"data"][@"content"]];
            [strongSelf.webView loadHTMLString:htmls baseURL:[NSURL URLWithString:@"https://120.79.169.197:3000"]];
        });
    } failed:^(NSError *error) {
        
    }];
   
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
        
    }
}
// WKNavigationDelegate 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //修改字体大小 300%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'" completionHandler:nil];
    //修改字体颜色  #9098b8
    // [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#222222'" completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
