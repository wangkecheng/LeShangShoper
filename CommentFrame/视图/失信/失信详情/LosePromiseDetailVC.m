
//
//  LosePromiseDetailVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/14.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "LosePromiseDetailVC.h"

@interface LosePromiseDetailVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoContentVY;//顶部视图的Y值

@property (weak, nonatomic) IBOutlet UILabel *paridseNumLbl;//点赞数
@property (weak, nonatomic) IBOutlet UIButton *paridseBtn;
@property (weak, nonatomic) IBOutlet UILabel *seeNumLbl;//查看数
@property (weak, nonatomic) IBOutlet UIWebView *webView;

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
	
     _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    [_headBtn sd_setImageWithURL:IMGURL(_model.headUrl) forState:0 placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
     _nameLbl.text = _model.name;
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_model.createAt integerValue]/1000];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    _timeLbl.text = [formatter stringFromDate:confromTimesp];
    
    [_webView loadHTMLString:_model.content baseURL:nil];
    [_paridseBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:30];
    _paridseNumLbl.text = _model.giveNumber;
    _seeNumLbl.text = [NSString stringFromInt:[_model.browseNumber integerValue] + 1];
    
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
