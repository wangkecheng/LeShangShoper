//
//  UIViewController+LBGideView.m
//  lubanlianmeng
//
//  Created by warron on 2016/10/11.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "GuideVC.h"
#import "PageControl.h"
#import <objc/runtime.h>
#import "HomeHeaderModel.h"
#define CollectionView_Tag 15
#define RemoveBtn_tag 16
#define Control_tag 17

#define FIRST_IN_KEY @"FIRST_IN_KEY"

@interface KSGuidViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, strong) UIImageView* imageView;
@end
@implementation KSGuidViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}
- (void)setImageName:(NSString *)imageName{
    if (_imageName != imageName) {
        _imageName = [imageName copy];
    }
    _imageView.image = [UIImage imageNamed:imageName];
}
@end


@interface GuideVC()

@property(nonatomic,strong)NSMutableArray * arrImgModel;
@property (nonatomic,copy)GuideBlock guideBlock;
@end
/*******以上是KSGuidViewCell,以下才是UIViewController+LBGuideView********/
@implementation GuideVC

+(instancetype)loadWithBlock:(GuideBlock)guideBlock{
    
    GuideVC *VC =  [[GuideVC alloc]init];
    VC.guideBlock =  guideBlock;
    return VC;
}

+ (BOOL)hadLoaded{ 
    NSString* versoin = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString* versionCache = [[NSUserDefaults standardUserDefaults] objectForKey:FIRST_IN_KEY];
    //启动时候首先判断是不是第一次
    if ([versoin isEqualToString:versionCache]){//表示加载过一次了
       
        return YES;
    }
    return NO;//没有加载过
}

-(void)viewDidLoad{
    [super viewDidLoad];
    HDModel * m = [HDModel model];
    m.type = @"1";
    weakObj;
    _arrImgModel = [NSMutableArray array];
    [BaseServer postObjc:m path:@"/advert/home/list" isShowHud:NO isShowSuccessHud:NO success:^(id result) {
        
        NSArray *arr =  [NSArray yy_modelArrayWithClass:[HomeHeaderModel class] json:result[@"data"]];
        [weakSelf.arrImgModel removeAllObjects];
        for (HomeHeaderModel *model in arr) {
            [weakSelf.arrImgModel addObject:IMGURL(model.imageUrl)];
        }
        if(arr.count == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf removeGuidView];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
              [weakSelf setupSubViews];
        });
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf removeGuidView];
        });
    }]; 
}
 
#pragma mark 初始化视图
- (void)setupSubViews{
    
    //界面样式
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView* collectionView = [[UICollectionView alloc]
                                        initWithFrame:self.view.bounds
                                        collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[KSGuidViewCell class] forCellWithReuseIdentifier:@"KSGuidViewCell"];
    
    collectionView.tag = CollectionView_Tag;
    [self.view addSubview:collectionView];
    
    [self.view addSubview:self.removeBtn];
    
    PageControl *pageControl= [[PageControl alloc] initWithFrame:CGRectMake(0,0,_arrImgModel.count*15,30) pageStyle:Q_PageControlStyleDefaoult];
    pageControl.center = CGPointMake(self.view.bounds.size.width/2,CGRectGetMaxY(self.view.frame) - CGRectGetHeight(pageControl.frame)/2.0 - 30);
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.Q_backageColor = [UIColor lightGrayColor];
    pageControl.Q_selectionColor = UIColorFromRGB(251, 205, 32);
    pageControl.Q_numberPags = _arrImgModel.count;
    pageControl.tag = Control_tag;
    pageControl.alpha = 0;
    [self.view addSubview:pageControl];
    [self creatSkipBtn];
}
-(void)creatSkipBtn{
    //移除按钮样式
    UIButton* skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    skipBtn.alpha = 0;
    [skipBtn addTarget:self action:@selector(removeGuidView) forControlEvents:UIControlEventTouchUpInside];
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [skipBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    skipBtn.backgroundColor = [UIColor whiteColor];
    skipBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    skipBtn.frame = CGRectMake(SCREENWIDTH - 75 - 20, 50, 75, 30);
    skipBtn.layer.cornerRadius = 30/2.0;
    [self.view addSubview:skipBtn];
}
#pragma mark 这里是退出的按钮
- (UIButton*)removeBtn{
    //移除按钮样式
    UIButton* removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeBtn addTarget:self action:@selector(removeGuidView) forControlEvents:UIControlEventTouchUpInside];
    removeBtn.hidden = (self.arrImgModel.count != 1);
    removeBtn.tag = RemoveBtn_tag;      //注意这里的tag
    removeBtn.alpha = 0;
    //***********************这里面可以自定义*******************************//
    CGFloat btnW = 128;
    CGFloat btnH = 35;
    CGFloat btnX = CGRectGetMidX(self.view.frame) - btnW / 2;
    CGFloat btnY = CGRectGetMaxY(self.view.frame) * 0.8;
    CGFloat maxYToBottom = CGRectGetMaxY(self.view.frame) - btnY;
    if (btnH > maxYToBottom) {
        btnH = maxYToBottom - 10;//做一个适配
    }
    removeBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    removeBtn.layer.cornerRadius = btnH/4.0;
    removeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    removeBtn.layer.borderWidth = 1.0;
    
    [removeBtn setTitle:@"点击进入" forState:UIControlStateNormal];
    [removeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    removeBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    //********************自定义结束**********************************//
    return removeBtn;
}

#pragma mark-
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrImgModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KSGuidViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KSGuidViewCell" forIndexPath:indexPath];
//    cell.imageName = self.arrHomeHeaderModel[indexPath.row];
    [cell.imageView sd_setImageWithURL:IMGURL(self.arrImgModel[indexPath.row]) placeholderImage:IMG(@"Icon") options:SDWebImageAllowInvalidSSLCertificates];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSUInteger index = scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
    [self.view viewWithTag:RemoveBtn_tag].hidden = (index != self.arrImgModel.count - 1);
   
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[PageControl class]]) {
            PageControl *pageControl = (PageControl *)view;
            pageControl.Q_currentPag = index;
        }
    }
    if (index == self.arrImgModel.count - 1){
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeGuidView)];
        [self.view addGestureRecognizer:tap];
    }else if(self.view.gestureRecognizers.count>0){
        [self.view removeGestureRecognizer:[self.view.gestureRecognizers firstObject]];
    }
}

- (void)removeGuidView{
    
    NSString* versoin = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [[NSUserDefaults standardUserDefaults] setObject:versoin forKey:FIRST_IN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[self.view viewWithTag:Control_tag] removeFromSuperview];
    [[self.view viewWithTag:RemoveBtn_tag] removeFromSuperview];
    [[self.view viewWithTag:CollectionView_Tag] removeFromSuperview];
    if (_guideBlock) {
        _guideBlock(YES);
    }
}


@end
