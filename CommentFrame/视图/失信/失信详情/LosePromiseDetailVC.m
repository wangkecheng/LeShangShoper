
//
//  LosePromiseDetailVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/14.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "LosePromiseDetailVC.h"
#import <WebKit/WebKit.h>
@interface LosePromiseDetailVC ()<WKUIDelegate,WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoContentVY;//顶部视图的Y值

@property (weak, nonatomic) IBOutlet UILabel *paridseNumLbl;//点赞数
@property (weak, nonatomic) IBOutlet UIButton *paridseBtn;
@property (weak, nonatomic) IBOutlet UILabel *seeNumLbl;//查看数
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation LosePromiseDetailVC
-(instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.title  = title;;
    }
    return self; 
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _webView.navigationDelegate = self;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
	_webView.backgroundColor = [UIColor whiteColor];
	HDModel * m = [HDModel model];
    m.did = _model.did;
	weakObj;
	[BaseServer postObjc:m path:@"/dishonesty/info" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
		LosePromissAndNewsModel * model  = [LosePromissAndNewsModel yy_modelWithJSON:result[@"data"]];
		dispatch_async(dispatch_get_main_queue(), ^{
			__strong typeof (weakSelf) strongSelf  = weakSelf;
			[strongSelf setData:model];
		});
	} failed:^(NSError *error){
        
	}];
}

-(void)setData:(LosePromissAndNewsModel * )model{
	
	[_headBtn sd_setImageWithURL:IMGURL(model.headUrl) forState:0 placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
	_nameLbl.text = [DDFactory getString:model.name  withDefault:@"未知用户"];
	
	NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.createAt integerValue]/1000];
	NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
	_timeLbl.text = [formatter stringFromDate:confromTimesp];
	
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
                       "</html>",model.content];
	[_webView loadHTMLString:htmls baseURL:[NSURL URLWithString:@"https://120.79.169.197:3000"]];
	[_paridseBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:30];
	_paridseNumLbl.text = [DDFactory getString:model.giveNumber  withDefault:@"0"];
	_seeNumLbl.text = [NSString stringFromInt:[model.browseNumber integerValue] + 1];
}

- (IBAction)pardiseBtnAction:(id)sender {//点赞操作
    HDModel * m = [HDModel model];
    m.did = _model.did;
    weakObj;
    [BaseServer postObjc:m path:@"/dishonesty/give" isShowHud:YES isShowSuccessHud:YES success:^(id result) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.paridseNumLbl.text = [NSString stringFromInt:[strongSelf.paridseNumLbl.text integerValue] + 1];
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
//    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#222222'" completionHandler:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
