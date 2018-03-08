//
//  PersonalCenterVC.m
//  CommentFrame
//
//  Created by warron on 2017/12/30.
//  Copyright © 2017年 warron. All rights reserved.
//


#import "WSLeftSlideManagerVC.h"
#import "PersonalCenterVC.h"
static CGFloat const LeftMarginGesture = 45.0f;//侧滑的标志距离
static CGFloat const MinScaleContentView = 0.8f;//主视图最小缩放
static CGFloat const MoveDistanceMenuView = 0;//左视图滑动距离
static CGFloat const MinScaleMenuView = 1.0f;//左视图最小缩放
static double const DurationAnimation = 0.3f;
static CGFloat const MinTrigerSpeed = 1000.0f;
@interface WSLeftSlideManagerVC ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *leftViewContainer;
@property (nonatomic, strong) UIView *mainTBCContainer;
@property (nonatomic, strong) UIView *gestureRecognizerView;
@property (nonatomic, strong) UIPanGestureRecognizer *edgePanGesture;

@property (strong, readwrite, nonatomic) IBInspectable UIColor *contentViewShadowColor;
@property (assign, readwrite, nonatomic) IBInspectable CGSize contentViewShadowOffset;
@property (assign, readwrite, nonatomic) IBInspectable CGFloat contentViewShadowOpacity;
@property (assign, readwrite, nonatomic) IBInspectable CGFloat contentViewShadowRadius;

@property (assign, nonatomic) CGFloat realContentViewVisibleWidth;

@property (assign, nonatomic) CGFloat contentViewScale;

@property (assign, nonatomic) BOOL menuHidden;
@property (assign, nonatomic) BOOL menuMoving;

@property (strong, nonatomic) NSArray *priorGestures;
@end

@implementation WSLeftSlideManagerVC

- (id)initWithMainVC:(HDMainTBC *)mainVC leftVC:(UIViewController *)leftVC{
    if(self = [super init]){
        _mainTBC = mainVC;
        _leftVC = leftVC;
        [self prepare];
    }
    return self;
}

- (void)prepare{
    _leftViewContainer = [[UIView alloc] init];
    _mainTBCContainer = [[UIView alloc] init];
    _gestureRecognizerView = [[UIView alloc] init];
    _gestureRecognizerView.hidden = YES;
    _gestureRecognizerView.backgroundColor = [UIColor clearColor];
    _contentViewShadowColor = [UIColor blackColor];
    _contentViewShadowOffset = CGSizeZero;
    _contentViewShadowOpacity = 0.4f;
    _contentViewShadowRadius = 5.0f;
    _contentViewVisibleWidth = 100;//侧滑后主视图的宽度
    _contentViewScale = 1.0f;
    _menuHidden = YES;
    _scaleContent = YES;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            _priorGestures = @[[UILongPressGestureRecognizer class], NSClassFromString(@"_UIPreviewGestureRecognizer"),NSClassFromString(@"_UIRevealGestureRecognizer")];
        } else {
            _priorGestures = @[[UILongPressGestureRecognizer class]];
        }
    } else {
        _priorGestures = @[[UILongPressGestureRecognizer class]];
    } 
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.realContentViewVisibleWidth = _scaleContent ? self.contentViewVisibleWidth/MinScaleContentView : 100;
    [self.view addSubview:_leftViewContainer];
    [self.view addSubview:_mainTBCContainer];
    
    _leftViewContainer.frame = self.view.bounds;
    _mainTBCContainer.frame = self.view.bounds;
    _gestureRecognizerView.frame = self.view.bounds;
    
    if (_leftVC) {
        [self addChildViewController:_leftVC];
        _leftVC.view.frame = self.view.bounds;
        _leftVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_leftViewContainer addSubview:_leftVC.view];
        [_leftVC didMoveToParentViewController:self];
    }
 
    NSAssert(_mainTBC, @"内容视图不能为空");
    _mainTBCContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addChildViewController:_mainTBC];
    _mainTBC.view.frame = self.view.bounds;
    [_mainTBCContainer addSubview:_mainTBC.view];
    [_mainTBC didMoveToParentViewController:self];
    
    
    _edgePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    _edgePanGesture.delegate = self;
    [_mainTBCContainer addGestureRecognizer:_edgePanGesture];
    
    [_mainTBCContainer addSubview:_gestureRecognizerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [_gestureRecognizerView addGestureRecognizer:tap];

    [self updateContentViewShadow]; 
	[[DDFactory factory]addObserver:self selector:@selector(showMenu) channel:LeftSildeAction];
}

- (void)pushVC:(UIViewController *)VC{
	HDMainNavC *nav;
    if ([_mainTBC isKindOfClass:[UINavigationController class]]) {
		nav = (HDMainNavC *)_mainTBC;
	}else if ([_mainTBC isKindOfClass:[HDMainTBC class]]){
		nav = _mainTBC.viewControllers[_mainTBC.selectedIndex];
	}
	if (nav) {
		[nav pushVC:VC isHideBack:YES animated:YES];
        [self hideMenu];
	}
}
- (void)hideMenu{
    if(!_menuHidden || self.menuMoving){
        [self showMenu:NO];
    }
}
- (void)showMenu{
    if(_menuHidden){
        [self showMenu:YES];
    }
}

#pragma custom selector
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)recongnizer{
    if(!_menuHidden){
        [self hideMenu];
    }
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer{
	return;//不能滑动打开侧滑视图
	CGPoint point = [recognizer translationInView:self.view];
    CGFloat velocityX = [recognizer velocityInView:self.view].x;
    if (velocityX > MinTrigerSpeed) {
        [self showMenu:YES];
    } else if (velocityX < -MinTrigerSpeed) {
        [self showMenu:NO];
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _menuMoving= YES;
        [self updateContentViewShadow];
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
    
        CGFloat menuVisibleWidth = self.view.bounds.size.width-self.realContentViewVisibleWidth;
        if (_scaleContent) {
            CGFloat delta = _menuHidden ? point.x/menuVisibleWidth : (menuVisibleWidth+point.x)/menuVisibleWidth;
            CGFloat scale = 1-(1-MinScaleContentView)*delta;
            CGFloat menuScale = MinScaleMenuView + (1-MinScaleMenuView)*delta;
            if(_menuHidden){
                //以内容视图最小缩放为界限
                if(scale < MinScaleContentView){//A
                    _mainTBCContainer.transform = CGAffineTransformMakeTranslation(menuVisibleWidth, 0);
                    _mainTBCContainer.transform = CGAffineTransformScale(_mainTBCContainer.transform,MinScaleContentView,MinScaleContentView);
                    _contentViewScale = MinScaleContentView;
                    _leftViewContainer.transform = CGAffineTransformMakeScale(1, 1);
                    _leftViewContainer.transform = CGAffineTransformTranslate(_leftViewContainer.transform, 0, 0);
                    
                }else{//大于最小界限又分大于等于1和小于1两种情况
                   
                    if(scale < 1){//B
                        _mainTBCContainer.transform = CGAffineTransformMakeTranslation(point.x, 0);
                        _mainTBCContainer.transform = CGAffineTransformScale(_mainTBCContainer.transform,scale, scale);
                        _contentViewScale = scale;
                        _leftViewContainer.transform = CGAffineTransformMakeScale(menuScale, menuScale);
                        _leftViewContainer.transform = CGAffineTransformTranslate(_leftViewContainer.transform, -MoveDistanceMenuView *(1-delta), 0);
                    }else{//C
                        _mainTBCContainer.transform = CGAffineTransformMakeTranslation(0, 0);
                        _mainTBCContainer.transform = CGAffineTransformScale(_mainTBCContainer.transform,1, 1);
                        _contentViewScale = 1;
                        _leftViewContainer.transform = CGAffineTransformMakeScale(MinScaleMenuView, MinScaleMenuView);
                        _leftViewContainer.transform = CGAffineTransformTranslate(_leftViewContainer.transform, -MoveDistanceMenuView, 0);
                    }

                }
                
            }else{
                
                if(scale > 1){//D
                    _mainTBCContainer.transform = CGAffineTransformMakeTranslation(0, 0);
                    _mainTBCContainer.transform = CGAffineTransformScale(_mainTBCContainer.transform,1,1);
                    _contentViewScale = 1;
                    _leftViewContainer.transform = CGAffineTransformMakeScale(MinScaleMenuView, MinScaleMenuView);
                    _leftViewContainer.transform = CGAffineTransformTranslate(_leftViewContainer.transform, -MoveDistanceMenuView, 0);
                }else{
                    if(scale>MinScaleContentView){//E
                        _mainTBCContainer.transform = CGAffineTransformMakeTranslation(point.x+menuVisibleWidth, 0);
                        _mainTBCContainer.transform = CGAffineTransformScale(_mainTBCContainer.transform,scale, scale);
                        _contentViewScale = scale;
                        _leftViewContainer.transform = CGAffineTransformMakeScale(menuScale, menuScale);
                        _leftViewContainer.transform = CGAffineTransformTranslate(_leftViewContainer.transform, -MoveDistanceMenuView * (1-delta), 0);
                    }else{//F
                        _mainTBCContainer.transform =CGAffineTransformMakeTranslation(self.view.bounds.size.width-self.realContentViewVisibleWidth, 0);
                        _mainTBCContainer.transform = CGAffineTransformScale(_mainTBCContainer.transform,MinScaleContentView, MinScaleContentView);
                        _contentViewScale = MinScaleContentView;
                        _leftViewContainer.transform = CGAffineTransformMakeScale(1, 1);
                        _leftViewContainer.transform = CGAffineTransformTranslate(_leftViewContainer.transform, 0, 0);
                    }
                }
            }
        } else {
            CGRect frame = _mainTBCContainer.frame;
            CGFloat originX = frame.origin.x + point.x;
            if (originX > menuVisibleWidth){
                frame.origin.x = menuVisibleWidth;
            } else if(originX < 0) {
                frame.origin.x = 0;
            } else {
                frame.origin.x += point.x;
            }
            _leftViewContainer.transform = CGAffineTransformMakeTranslation((1 - frame.origin.x / menuVisibleWidth) * (-menuVisibleWidth / 3), 0);
            _mainTBCContainer.frame = frame;
            [recognizer setTranslation:CGPointZero inView:self.view];
        }
        
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        [self showMenu: _scaleContent ? (_contentViewScale < 1 - (1 - MinScaleContentView) / 2) : _mainTBCContainer.frame.origin.x > (self.view.bounds.size.width - self.realContentViewVisibleWidth) / 2];
        _menuMoving= NO;
    } else if(recognizer.state == UIGestureRecognizerStateFailed || recognizer.state == UIGestureRecognizerStateCancelled) {
        [self hideMenu];
        _menuMoving= NO;
    }
}
- (void)showMenu:(BOOL)show{
	if (_leftVC.didLeftSildeAction) {
		_leftVC.didLeftSildeAction();//回调使用
	}
    if (_scaleContent) {
        NSTimeInterval duration  = show ? (_contentViewScale-MinScaleContentView)/(1-MinScaleContentView)*DurationAnimation : (1 - (_contentViewScale-MinScaleContentView)/(1-MinScaleContentView))*DurationAnimation;
        
        [UIView animateWithDuration:duration animations:^{
            if(show){
                _mainTBCContainer.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width-self.realContentViewVisibleWidth, 0);
                _mainTBCContainer.transform = CGAffineTransformScale(_mainTBCContainer.transform,MinScaleContentView, MinScaleContentView);
                _leftViewContainer.transform = CGAffineTransformIdentity;
                _contentViewScale = MinScaleContentView;
            }else{
                _mainTBCContainer.transform = CGAffineTransformIdentity;
                _contentViewScale = 1;
                _leftViewContainer.transform = CGAffineTransformMakeScale(MinScaleMenuView, MinScaleMenuView);
                _leftViewContainer.transform = CGAffineTransformTranslate(_leftViewContainer.transform, -MoveDistanceMenuView, 0);
            }
        } completion:^(BOOL finished) {
            _menuHidden = !show;
            _gestureRecognizerView.hidden = !show;
        }];
    } else {
        CGFloat menuWidth = self.view.bounds.size.width - self.realContentViewVisibleWidth;
        NSTimeInterval duration = (show ? (menuWidth - _mainTBCContainer.frame.origin.x) / menuWidth : _mainTBCContainer.frame.origin.x / menuWidth) * DurationAnimation;
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = _mainTBCContainer.frame;
            frame.origin.x =  show ? self.view.bounds.size.width - self.realContentViewVisibleWidth : 0;
            _mainTBCContainer.frame = frame;
            _leftViewContainer.transform = show ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(-menuWidth / 3, 0);
        } completion:^(BOOL finished) {
            _menuHidden = !show;
            _gestureRecognizerView.hidden = !show;
        }];
    }
}

#pragma method assist
- (void)updateContentViewShadow {
    CALayer *layer = _mainTBCContainer.layer;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:layer.bounds];
    layer.shadowPath = path.CGPath;
    layer.shadowColor = _contentViewShadowColor.CGColor;
    layer.shadowOffset = _contentViewShadowOffset;
    layer.shadowOpacity = _contentViewShadowOpacity;
    layer.shadowRadius = _contentViewShadowRadius;
}

#pragma gesture delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (_menuHidden){
        if (point.x <= LeftMarginGesture){
            UINavigationController *nav = nil;
            if ([_mainTBC isKindOfClass:[UINavigationController class]] ) {
                nav = (UINavigationController *)_mainTBC;
            }
			else if ([_mainTBC isKindOfClass:[HDMainTBC class]]){
				nav = _mainTBC.viewControllers[_mainTBC.selectedIndex];
			}
            if (nav) {
                if (nav.childViewControllers.count < 2) {
                    return YES;
                }
            } else {
                return YES;
            }
        }
    }else{
        return YES;
    }
    return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if(gestureRecognizer == _edgePanGesture){
        return YES;
    }
    return  NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == _edgePanGesture) {
        __block bool prior = NO;
        [_priorGestures enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([otherGestureRecognizer isKindOfClass:obj]) {
                prior = YES;
                *stop = YES;
            }
        }];
        return prior;
    }
    return NO;
}

- (BOOL)shouldAutorotate {
    return _allowRotate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
