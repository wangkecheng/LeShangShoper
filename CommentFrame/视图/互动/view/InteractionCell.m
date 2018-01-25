

//
//  InteractionCell.m
//  CommentFrame
//
//  Created by warron on 2018/1/5.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "InteractionCell.h"
#import "HWCollectionViewCell.h"
static int Btn_Tag = 100;
@interface InteractionCell()<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,
UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UILabel *titLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titLblH;

//@property (weak, nonatomic) IBOutlet UIView *imgsContaintView;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *seeAllBtn;//查看全部
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seeAllBtnH;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *pardiseBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation InteractionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.scrollEnabled  = NO;
    _flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 0, 0);
    _flowLayout.minimumInteritemSpacing = 3;//同一行
    _flowLayout.minimumLineSpacing = 3;//同一列
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(InteractionModel *)model{
	_model = model;
	[_headerBtn sd_setImageWithURL:IMGURL(model.headUrl) forState:0 placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
	_nameLbl.text = model.name;
	_titLbl.text = model.content;
	
	NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.createAt integerValue]];
	NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"yy-HH-dd hh:mm:ss"];
	NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
	
	_timeLbl.text = [NSString stringWithFormat:@"%@",confromTimespStr];
	[_commentBtn setTitle:[NSString stringWithFormat:@" %@",model.commentNumber] forState:0];
	[_pardiseBtn setTitle:[NSString stringWithFormat:@" %@",model.giveNumber] forState:0]; 
//    CGFloat w = CGRectGetWidth(self.contentView.frame) - 10;//默认一张的时候
//    CGFloat h = w;//一张的时候
//	if (imgStrArr.count == 2) {
//		w = CGRectGetWidth(self.contentView.frame) / 2.0 - 15;
//	}
//	if (imgStrArr.count > 2) {
//		w = CGRectGetWidth(self.contentView.frame) / 3.0 - 20;
//	}
//    CGFloat margin = 5;
//    w = (CGRectGetWidth(self.contentView.frame)  - 4*margin ) / 3.0;
//    h = w;
//    [_imgsContaintView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    NSInteger imgCount =  model.imageUrls.count;
//    UIButton * lastBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    for (int i = 0;i<imgCount;i++ ) {
//        NSString *imgUrl = _model.imageUrls[i];
//        CGFloat x =  CGRectGetMaxX(lastBtn.frame) + margin;
//        CGFloat y = CGRectGetMinY(lastBtn.frame);
//        if(i%3 == 0 ){
//            x = margin;
//            y = CGRectGetMaxY(lastBtn.frame) + margin;
//        }
//        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, w, h)];
//        btn.tag = i + Btn_Tag;
//        btn.layer.cornerRadius = 10;
//        btn.layer.masksToBounds = YES;
//        [btn addTarget:self action:@selector(bimImgAction:) forControlEvents:UIControlEventTouchUpInside];
//         [btn sd_setImageWithURL:IMGURL(imgUrl) forState:0 placeholderImage:IMG(@"Icon") options:SDWebImageAllowInvalidSSLCertificates];
//
//        [_imgsContaintView addSubview:btn];
//        lastBtn = btn;
//    }
    //查看全部 按钮部分
    if(_model.needHideSeeAllBtn){//如果是需要隐藏 就隐藏
        _seeAllBtn.alpha = 0;
        _seeAllBtnH.constant = 0;
    }else{
        _seeAllBtn.alpha = 1;
        _seeAllBtnH.constant = 30;
    }
    if (_model.isStatusSeeAll) {//是否需要查看全部，如果需要查看全部 那么现实文本实际高度
        _titLblH.constant = [DDFactory autoHByText:model.content Font:15 W:SCREENWIDTH - 10];
    }else if(!_model.needHideSeeAllBtn){//不需要隐藏查看全部按钮 表示这段文本有很多，需要有查看全部的按钮，但是此时不是显示全部
        _titLblH.constant = 60;
    }
    [_seeAllBtn setTitle:@"查看全部" forState:0];
    if (_model.isStatusSeeAll) {//状态是 查看全部 那就收起
        [_seeAllBtn setTitle:@"收起" forState:0];
    }
    [_collectionView reloadData];
    [self layoutIfNeeded];
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _model.imageUrls.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat w = (CGRectGetWidth(collectionView.frame) - 20) / 3.0;
    return CGSizeMake(w,w);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UINib *nib = [UINib nibWithNibName:@"HWCollectionViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"HWCollectionViewCell"];
    HWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HWCollectionViewCell" forIndexPath:indexPath];
    [cell setImgUrlStr:_model.imageUrls[indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(_seeBigImgBlock){
        _seeBigImgBlock(_model,indexPath.row);
    }
}

- (IBAction)seeAllBtnAction:(id)sender {//点击时的状态
    _model.isStatusSeeAll = !_model.isStatusSeeAll;//状态立刻改变
    [_seeAllBtn setTitle:@"收起" forState:0];
    if (_model.isStatusSeeAll) {//状态是 查看全部 那就收起
       [_seeAllBtn setTitle:@"查看全部" forState:0];
    }
    if (_seeAllBlock) {
        _seeAllBlock(_model);
    }
}

//-(void)bimImgAction:(UIButton *)btn{
//    if(_seeBigImgBlock){
//        _seeBigImgBlock(_model,btn.tag - Btn_Tag);
//    }
//}

- (IBAction)commentAction:(id)sender {
	if (_commentBlock) {
		_commentBlock(_model);
	}
}

- (IBAction)pardiseAction:(id)sender {
	if (_pardiseBlock) {
		_pardiseBlock(_model);
	}
}

+(CGFloat)cellHByModel:(InteractionModel *)model{
	CGFloat H = 100;
    CGFloat titltH = [DDFactory autoHByText:model.content Font:15 W:SCREENWIDTH - 10];
 
    if (titltH > 60) {//大于60 那么需要有个 查看全部的按钮
        model.needHideSeeAllBtn = NO;//不能隐藏查看全部按钮
        H += 30;//加上查看全部 按钮的高度
        if (model.isStatusSeeAll) {//如果是查看全部状态 就加的是文字真实高度
            H += titltH;
        }else{//否则就是文字的收起高度
            H += 60;
        }
    }else{//不大于40的情况下 加真实高度 并且隐藏查看全部按钮
         H += titltH;
         model.needHideSeeAllBtn = YES;//隐藏查看全部按钮
    }
   
	CGFloat margin = 5;
	CGFloat w = (SCREENWIDTH   - 4*margin )/ 3.0;//图片高宽
	NSInteger imgCount = model.imageUrls.count;
	NSInteger rows = imgCount/3;//图片共几排

	if(imgCount%3!=0 &&imgCount!=0){
		rows += 1;//如果有余数 说名可能为 5 8 那么就要再加一排
	}
		H += rows * w + (rows + 1)*margin;//图片上 图片之间 最下排的图片的间隙 间隙数 比行数多 1
	return H;
}
@end
