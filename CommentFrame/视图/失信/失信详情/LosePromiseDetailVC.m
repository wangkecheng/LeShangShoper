
//
//  LosePromiseDetailVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/14.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "LosePromiseDetailVC.h"

@interface LosePromiseDetailVC ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LosePromiseDetailVC
-(instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title  = title;;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
    _webView.delegate = self;
    [_webView loadHTMLString:_model.content baseURL:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
