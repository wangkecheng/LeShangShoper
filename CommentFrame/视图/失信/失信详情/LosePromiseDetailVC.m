
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

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title  = @"失信详情";
    _webView.delegate = self;
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
