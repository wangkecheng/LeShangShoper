//
//  DYPickerView.m
//  地址选择
//
//  Created by warron on 2016/10/25.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "DYPickerView.h"
#import "DYProvenceModel.h"
#import "AppDelegate.h"
@interface DYPickerView() <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIView    *coverView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, copy) void(^cancelBlock)(void);
@property (nonatomic, copy) void(^okBlock)(SelectInfoModel *model);
@property (nonatomic,retain) NSMutableArray *provinceArray;//存储所有的省的名称
@property (nonatomic,retain) NSArray *cityArray;//存储对应省份下的所有城市名
@property (nonatomic,retain) NSArray *countyArray;//存储所有的县区名

@property (nonatomic,strong)UIView *sheetContentView;
@property (nonatomic, strong) UIPickerView *pickerView;


@end

@implementation SelectInfoModel
+(SelectInfoModel *)modelByProvenceName:(NSString *)provenceName cityName:(NSString *)cityName countyName:(NSString *)countyName{
    SelectInfoModel * model = [[SelectInfoModel alloc]init];
    model.provenceName = provenceName;
    model.cityName = cityName;
    model.countyName = countyName;
    return model;
}
@end

@implementation DYPickerView
-(instancetype)initWithFrame:(CGRect)frame{
    [NSException exceptionWithName:@"You can't use initWithFrame to create PickerView" reason:@"Using \"initWithFrame:cancelBlock:okBlock:\" which contanins blocks" userInfo:nil];
    return nil;
}
#pragma mark - 界面初始化
/**
 *  初始化
 *@param frame frame
 *@param cacelBlock 取消block
 *@param okBlock 确定block
 *  @return self
 */
-(instancetype)initWithSheetH:(CGFloat)sheetH cancelBlock:(void(^)(void))cancelBlock okBlock:(void(^)(SelectInfoModel *model))okBlock{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        /**
         *  初始化界面
         */
        _sheetContentView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - sheetH, [UIScreen mainScreen].bounds.size.width, sheetH)];
        _sheetContentView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height+sheetH/2.0);
        
        [self addSubview: self.coverView];
        [self addSubview:_sheetContentView];
        [_sheetContentView addSubview: self.toolbar];
        [_sheetContentView addSubview: self.pickerView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_toolbar.frame)-1,CGRectGetWidth(_toolbar.frame), 1)];
        line.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        [_sheetContentView addSubview:line];
        
    
        
       
        [self initData];//初始化
        _cancelBlock = cancelBlock;
        _okBlock = okBlock;
      
    }
    return self;
}

-(void)initData{
    // 加载数据
    // 从MainBundle中加载文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    _provinceArray = [NSMutableArray array];
    for (NSDictionary *dictProvences in array) {
        DYProvenceModel *provencesModel = [[DYProvenceModel alloc]initWithDict:dictProvences];
        [_provinceArray addObject:provencesModel];
    }
    DYProvenceModel *provencesModel = [_provinceArray firstObject];
    _cityArray = provencesModel.arrCtiys;
    _countyArray = nil;
  
}

//初始化 或者重置
-(void)reset{
    [self initData];
    [self.pickerView reloadAllComponents];
    
    for (int i = 0 ; i < self.pickerView.numberOfComponents; i++) {
        [self.pickerView selectRow:0 inComponent:i animated:YES];//选中第一行的 初始化位选择之前的状态
    }
}
#pragma mark - 懒加载
-(UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.frame = [UIScreen mainScreen].bounds;
        _coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.33];
        [_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)]];
          _coverView.alpha = 0;
    }
    return _coverView;
}


//弹出视图的工具条
- (UIToolbar *)toolbar{
    
    if (_toolbar == nil) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
        [_toolbar setBarTintColor:[UIColor whiteColor]];
        [_toolbar setBackgroundColor:[UIColor whiteColor]];
        
         UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"   取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        [cancel setTintColor:[UIColor blackColor]];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *certain = [[UIBarButtonItem alloc] initWithTitle:@"完成   " style:UIBarButtonItemStylePlain target:self action:@selector(certain)];
        [certain setTintColor:[UIColor blackColor]];
        _toolbar.items = @[cancel,flexibleSpace,certain];
    }
    return _toolbar;
}

// 点击了取消
- (void)cancel{
     [self dissmiss];//关闭
     [self reset];//重新设置位置
    if (_cancelBlock) {
        _cancelBlock();
    }
}

// 点击了确定
- (void)certain{
    [self dissmiss];//关闭
    [self reset];//重新设置位置
    if (_okBlock) { // 获取当前选中的信息
        _okBlock([self getCurrentSelectedInfo]);
    }
}

-(void)show{//显示sheet框
    
     UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];//将其自身添加到_window上去
    __weak typeof (self) weakSelf = self;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.coverView.alpha = 1.0;
        strongSelf.sheetContentView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height-125);
    } completion:^(BOOL finished) {
        if (finished) {

        }
    }];
}

-(void)dissmiss{//移除sheet框
     __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.sheetContentView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height+125);
        strongSelf.coverView.alpha = 0.0;
    }completion:^(BOOL finished) {
         __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf removeFromSuperview];//记得每次都要从父视图移除，这样子可以节约一部分的资源
    }];
}

//创建pickerView
- (UIPickerView *)pickerView{
    if (_pickerView == nil) {
        //初始化一个pickerView
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolbar.frame), [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.sheetContentView.frame) - CGRectGetMaxY(self.toolbar.frame))];
        //设置背景色
        _pickerView.backgroundColor = [UIColor whiteColor];
       
//        UIView *layer = [[UIView alloc]init];
//        layer.backgroundColor = [UIColor blackColor];
//        layer.frame = CGRectMake(0, 0, CGRectGetWidth(_pickerView.frame ), 1);
//        [_pickerView addSubview:layer];
        
        //设置代理
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator =YES;
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource和UIPickerViewDelegate
// 设置列的返回数量
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
 
//设置列里边组件的个数 component:组件
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //如果是第一列
    if (component == 0){
        //返回省的个数
        return self.provinceArray.count;
    }
    //如果是第二列
    else if (component == 1){
      
        return self.cityArray.count;
    }
    else{
        //返回县区的个数
        return self.countyArray.count;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:18]];
        customLabel.textColor = [UIColor blackColor];
    }
     NSString *title;
  
    if (component == 0) {
        // 设置第0列的标题信息
        DYProvenceModel * provencesModel  = [self.provinceArray objectAtIndex:row];
        title = provencesModel.name;
    } else if (component == 1) {
        // 设置第1列的标题信息
        DYCityModel * cityModel = [self.cityArray objectAtIndex:row];
       title = cityModel.name;
    } else {
        // 设置第2列的标题信息
        DYCountyModel * distractModel = [self.countyArray objectAtIndex:row];
        title = distractModel.name;
    }
    customLabel.text = title;
    return customLabel;
}
//返回组件的标题

//选择器选择的方法  row：被选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //选择第0列执行的方法
    if (component == 0) {
        [pickerView selectedRowInComponent:0];
        
        /**
         *  选中第0列时需要刷新第1列和第二列的数据
         */
        DYProvenceModel * provencesModel = [self.provinceArray objectAtIndex:row];
        _cityArray = provencesModel.arrCtiys;
        [pickerView reloadComponent:1];
      
        DYCityModel * cityModel = [provencesModel.arrCtiys firstObject];
        _countyArray = nil;
        if ([cityModel isKindOfClass:[DYCityModel class]]) {
            _countyArray = cityModel.arrCountry;
        }
         [pickerView reloadComponent:2];
    } else if (component == 1) {
        [pickerView selectedRowInComponent:1];
        
        /**
         *  选中第一列时需要刷新第二列的数据信息
         */
         DYCityModel * cityModel = [self.cityArray objectAtIndex:row];
         _countyArray = nil;//这里加了个判断 所以得先把这里置空
        if ([cityModel isKindOfClass:[DYCityModel class]]) {//防止为空的时候报错
             _countyArray = cityModel.arrCountry;
        }
        [pickerView reloadComponent:2];
    } else if (component == 2) {
        [pickerView selectedRowInComponent:2];
    }
    
}

- (SelectInfoModel *)getCurrentSelectedInfo{
    
    // 获取当前选中的信息
    NSInteger proviceIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger cityIndex = [self.pickerView selectedRowInComponent:1];
    NSInteger countryIndex = [self.pickerView selectedRowInComponent:2];
    
    DYProvenceModel * provenceModel = _provinceArray[proviceIndex];
    
    DYCityModel *cityModel = _cityArray.count != 0 ? _cityArray[cityIndex] : @"";
    
    DYCountyModel *countyModel = _countyArray.count != 0 ? _countyArray[countryIndex] : @"";
    NSString * countyName = @"";
    if ([countyModel isKindOfClass:[DYCityModel class]]) {
        countyName = countyModel.name;
    }
    return [SelectInfoModel modelByProvenceName:provenceModel.name cityName:cityModel.name countyName:countyName];
}
 
@end
