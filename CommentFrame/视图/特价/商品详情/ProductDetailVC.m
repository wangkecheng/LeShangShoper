
//
//  ProductDetailVC.m
//  CommentFrame
//
//  Created by warron on 2018/1/16.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "ProductDetailVC.h"
#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
#import <WebKit/WebKit.h>
@interface ProductDetailVC ()<WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewTopMargin;

@property (weak, nonatomic) IBOutlet UILabel *indicatorLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewH;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *specificationLbl;//规格
@property (weak, nonatomic) IBOutlet UILabel *usePlaceLbl;//使用位置
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;//编号
@property (weak, nonatomic) IBOutlet UILabel *factoryLbl;//工厂或者公司
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;//购物车
@property (weak, nonatomic) IBOutlet UIImageView *specialImg;//是否是特价
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@property (strong, nonatomic)CollectionModel * detailModel;

@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewH;

@end

@implementation ProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"商品详情";
    _webView.UIDelegate = self;
    _webView.userInteractionEnabled = NO ;
    _webView.navigationDelegate = self;
    if (_isNeedResetMargin) {
        _scrollContentViewTopMargin.constant = -10;
    }
    [self getPage];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    weakObj;
    self.finishLoginBlock = ^{//登录完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf getPage];
        });
    };
}
-(void)getPage{
    HDModel * m = [HDModel model];
    m.cid  = _model.cid;
    weakObj;
    [BaseServer postObjc:m path:@"/commodity/info" isShowHud:YES isShowSuccessHud:NO success:^(id result) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.detailModel = [CollectionModel yy_modelWithJSON:result[@"data"]];
        strongSelf.detailModel.imageUrls = result[@"data"][@"imageUrls"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf setViewData];
        });
    } failed:^(NSError *error) {
        
    }];
}
-(void)setViewData{
   
    _specialImg.alpha = 0;
    if ([_detailModel.bargain integerValue] == 2) {
          _specialImg.alpha = 1;
    }
	_titleLbl.text = _detailModel.name;
	NSMutableArray * imageUrls = [NSMutableArray array];
	for (NSString * str in _detailModel.imageUrls) {
		[imageUrls addObject:IMGURL(str)];
	}
	_detailModel.imageUrls = imageUrls;
	SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH,CGRectGetHeight(_scrollContentView.frame))  imageURLStringsGroup:_detailModel.imageUrls];
	cycleView.showPageControl = NO;
    [cycleView setPlaceholderImage:IMG(@"Icon")];
	cycleView.autoScroll = NO;
	[self.scrollContentView addSubview:cycleView];
    _indicatorLbl.text = [NSString stringWithFormat:@"1/%ld",_detailModel.imageUrls.count];
	weakObj;
	cycleView.clickItemOperationBlock = ^(NSInteger currentIndex) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		NSMutableArray* tmps = [NSMutableArray array];
		for (int i = 0;i< strongSelf.detailModel.imageUrls.count;i++) {//找出所有图片
			LWImageBrowserModel* broModel = [[LWImageBrowserModel alloc]  initWithplaceholder:IMG(@"Icon") thumbnailURL:strongSelf.detailModel.imageUrls[i] HDURL:strongSelf.detailModel.imageUrls[i] containerView:self.view
				positionInContainer:self.view.frame index:i];//
			[tmps addObject:broModel];
		}
        dispatch_async(dispatch_get_main_queue(), ^{
            LWImageBrowser* browser = [[LWImageBrowser alloc]
                                       initWithImageBrowserModels:tmps
                                       currentIndex:currentIndex];
            browser.isScalingToHide = NO;
            browser.isShowSaveImgBtn = NO;
            [browser show];
        });
	};
 
    cycleView.longTouchBlock = ^(NSString *imagePath) {//先下载图片然后保存
 
        WSAlertView *alertView = [WSAlertView instanceWithTitle:@"提示" content:@"是否保存到本地相册" attachInfo:imagePath leftBtnTitle:@"取消" rightBtnTitle:@"确定" leftBtnBlock:^(id attachInfo) {
           
            
        } rightBtnBlock:^(id attachInfo) {
               __strong typeof (weakSelf) strongSelf = weakSelf;
             [strongSelf saveImgModule:imagePath];//保存
        }];
        [alertView show];
    };
	cycleView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
		__strong typeof (weakSelf) strongSelf = weakSelf;
		strongSelf.indicatorLbl.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,strongSelf.detailModel.imageUrls.count];
	};
	_specificationLbl.text = _detailModel.spec;//规格
	_usePlaceLbl.text = _detailModel.typeName; //使用位置
	_numberLbl.text = [NSString stringWithFormat:@"编号：%@",_detailModel.iden];//编号
	_factoryLbl.text = _detailModel.merchantName;//工厂或者公司
	_priceLbl.text =  [NSString stringWithFormat:@"￥%0.2f",[_detailModel.price floatValue]];
	_specialImg.alpha = 0;
	if([_detailModel.bargain integerValue] == 2){
			_specialImg.alpha = 1;
	}
	[_collectBtn setTitle:@"加入收藏夹" forState:0];
	if([_detailModel.collect integerValue] == 2){
	    [_collectBtn setTitle:@"已收藏" forState:0];
	}
    NSMutableString * desStr = [[NSMutableString alloc]init];
    if (![_detailModel.des containsString:@"<"]) {
        [desStr appendString:@"<p class=\"one-p\" style=\"margin: 0px 0px 2em; padding: 2px; line-height: 2.2; font-family: &quot;Microsoft Yahei&quot;, Avenir, &quot;Segoe UI&quot;, &quot;Hiragino Sans GB&quot;, STHeiti, &quot;Microsoft Sans Serif&quot;, &quot;WenQuanYi Micro Hei&quot;, sans-serif; font-size: 18px;\">"];
        [desStr appendString:[DDFactory getString:_detailModel.des withDefault:@""]];
        [desStr appendString:@"</p>"];
        _scrollViewH.constant +=  [DDFactory autoHByText:_detailModel.des Font:[UIFont fontWithName:@"PingFang-SC-Medium" size:18] W:SCREENWIDTH];
    }else{
        [desStr appendString:[DDFactory getString:_detailModel.des withDefault:@""]];
        desStr = [NSString stringWithFormat:@"<html> \n"
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
                           "</html>",desStr];
    }
    //设置webView
    [_webView loadHTMLString:desStr baseURL:[NSURL URLWithString:POST_HOST]];
}

-(void)saveImgModule:(NSString *)imagePath{//保存图片
    weakObj;
    
    for ( int i = 0; i <weakSelf.detailModel.imageUrls.count; i++) {
        NSURL * imgUrl = weakSelf.detailModel.imageUrls[i];
        if ([imgUrl.absoluteString isEqualToString:imagePath]) {
            if ([imagePath containsString:@"http"]) {
                UIImageView *gtp = [[UIImageView alloc] init];
                [gtp sd_setImageWithURL:imgUrl placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                    [[WSPHPhotoLibrary library]saveImage:image assetCollectionName:@"新易陶" sucessBlock:^(NSString *str, PHAsset *obj) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存成功" message:@"请前往\''新易陶'\'相册查看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        });
                    } faildBlock:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        });
                    }];
                }];
            }
            break;
        }
    }
}
- (IBAction)addToCartAction:(UIButton *)sender {//加入收藏夹
	_collectBtn.userInteractionEnabled = NO;
    if ([CacheTool isToLoginVC:self]) {
        return;//方法内部做判断
    }
	HDModel *m = [HDModel model];
	m.cid = _model.cid;
	weakObj;
	if ([_model.collect integerValue] == 1) {
		_model.collect = @"2";
		[BaseServer postObjc:m path:@"/commodity/collect" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
			__strong typeof (weakSelf) strongSelf  = weakSelf;
			dispatch_async(dispatch_get_main_queue(), ^{
				[strongSelf.collectBtn setTitle:@"已收藏" forState:0];
					strongSelf.collectBtn.userInteractionEnabled = YES;
				if (strongSelf.collectActionBlock) {//如果是从收藏夹进入这个页面 这里为真
					strongSelf.collectActionBlock(strongSelf.model, YES);//加入收藏操作
				}
                [strongSelf.view makeToast:@"收藏成功"];
			});
		} failed:^(NSError *error) {
			__strong typeof (weakSelf) strongSelf  = weakSelf;
				strongSelf.collectBtn.userInteractionEnabled = YES;
		}];
		return;
	}
	_model.collect = @"1";
	[BaseServer postObjc:m path:@"/commodity/collect/remove" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
		__strong typeof (weakSelf) strongSelf  = weakSelf;//取消收藏 
        [strongSelf.view makeToast:@"取消成功"];
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[strongSelf.collectBtn setTitle:@"加入收藏夹" forState:0];
			strongSelf.collectBtn.userInteractionEnabled = YES;
			if (strongSelf.collectActionBlock) {//如果是从收藏夹或者目录点击系列中的cell进入这个页面 这里为真
				strongSelf.collectActionBlock(strongSelf.model, NO);//取消收藏操作
			}
		});
	} failed:^(NSError *error) {
		__strong typeof (weakSelf) strongSelf  = weakSelf;
			strongSelf.collectBtn.userInteractionEnabled = YES;
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
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'" completionHandler:nil];
    
    //修改字体颜色  #9098b8
    //    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#222222'" completionHandler:nil];
    
    __block CGFloat webViewHeight;
    weakObj; //  document.body.scrollHeigh
    [webView evaluateJavaScript:@"document.body.scrollHeight"
              completionHandler:^(id result, NSError *_Nullable error) {
                  //获取页面高度，并重置webview的frame
                  webViewHeight = [result doubleValue];
                  dispatch_async(dispatch_get_main_queue(), ^{
                      __strong typeof (weakSelf) strongSelf = weakSelf;
                      strongSelf.scrollViewH.constant += webViewHeight;
                      strongSelf.webViewH.constant = webViewHeight;
                  });
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
