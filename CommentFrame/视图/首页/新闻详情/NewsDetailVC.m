//  LosePromiseDetailVC.m
//  CommentFrame
//  Created by warron on 2018/1/14.
//  Copyright © 2018年 warron. All rights reserved.

#import "NewsDetailVC.h"
#import <WebKit/WebKit.h>
@interface NewsDetailVC ()<WKNavigationDelegate,WKUIDelegate>
 
@property (strong, nonatomic)  WKWebView *webView;
    @property (strong, nonatomic) NSString * htmlStr;
@end

@implementation NewsDetailVC
-(instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        
        self.title  = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    CGFloat barH = 64;
    if ([[NSString getCurrentDeviceModel] containsString:@"x"]) {
        barH += 22;
    } 
    wkWebConfig.userContentController = wkUController;
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - barH) configuration:wkWebConfig];
    _webView.navigationDelegate  = self;
    _webView.UIDelegate = self;
    [_webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'" completionHandler:nil];
    [self.view addSubview:_webView];
    NSString *titleStr = _model.title;
    if(titleStr.length > 10){
        titleStr =  [NSString stringWithFormat:@"%@...",[titleStr substringToIndex:10]];
    }
    self.title = titleStr;
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
                               "body {font-size:12px;}\n"
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
            strongSelf.htmlStr = result[@"data"][@"content"];
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
// WKNavigationDelegate 页面加载完成之后调用 player.html
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //修改字体大小 300%
    if([_htmlStr containsString:@"player.html"]){
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'" completionHandler:nil];
    }else{
       [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'" completionHandler:nil];
    }
    //修改字体颜色  #9098b8
    // [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#222222'" completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
