

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
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation InteractionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.scrollEnabled  = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setMyInteractionModel:(InteractionModel *)myInteractionModel{
	_myInteractionModel = myInteractionModel;
	_deleteBtn.alpha = 1;
    [self initData:myInteractionModel];
}
-(void)setModel:(InteractionModel *)model{
	_model = model;
	_deleteBtn.alpha = 0;
    if ([_model.isUser integerValue] == 2) {
         _deleteBtn.alpha = 1;//是用户自己发布的 就不隐藏删除按钮
    }
	[self initData:model];
}
-(void)initData:(InteractionModel *)model{
	[_headerBtn sd_setImageWithURL:IMGURL(model.headUrl) forState:0 placeholderImage:IMG(@"icon_touxiang") options:SDWebImageAllowInvalidSSLCertificates];
	_nameLbl.text = [DDFactory getString:model.name     withDefault:@"未知用户"];
	_titLbl.text = [DDFactory getString:model.content  withDefault:@""];
	NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.createAt integerValue]/1000];
	NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
	
	_timeLbl.text = [NSString stringWithFormat:@"%@",confromTimespStr];
	[_commentBtn setTitle:[NSString stringWithFormat:@" %@",[DDFactory getString:model.commentNumber  withDefault:@"0"]] forState:0];
	[_pardiseBtn setTitle:[NSString stringWithFormat:@" %@",[DDFactory getString:model.giveNumber  withDefault:@"0"]] forState:0];
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
    _titLblH.constant =  0;
	if(model.needHideSeeAllBtn){//如果是需要隐藏 就隐藏
		_seeAllBtn.alpha = 0;
		_seeAllBtnH.constant = 0;
	}else{
		_seeAllBtn.alpha = 1;
		_seeAllBtnH.constant = 30;
	}
    if (_titLblH.constant < 60) {//如果小于 60  那么就用文字的高度
        _titLblH.constant = model.contentH;
    }
	if (model.isStatusSeeAll) {//是否需要查看全部，如果需要查看全部 那么现实文本实际高度
		_titLblH.constant = model.contentH;
	}else if(!model.needHideSeeAllBtn){//不需要隐藏查看全部按钮 表示这段文本有很多，需要有查看全部的按钮，但是此时不是显示全部
		_titLblH.constant = 60;
	}
	[_seeAllBtn setTitle:@"查看全部" forState:0];
	if (model.isStatusSeeAll) {//状态是 查看全部 那就收起
		[_seeAllBtn setTitle:@"收起" forState:0];
	}
	[_collectionView reloadData];
	[super layoutIfNeeded];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	InteractionModel * model = _model == nil? _myInteractionModel:_model;
	return model.imageUrls.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    InteractionModel *model = _model==nil? _myInteractionModel:_model;
    if (model.imageUrls.count == 1) {
        return CGSizeMake(SCREENWIDTH,model.singleImgH);
    }
    float wid = CGRectGetWidth(self.collectionView.bounds);
    return CGSizeMake((wid-3*5)/3, (wid-3*5)/3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UINib *nib = [UINib nibWithNibName:@"HWCollectionViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"HWCollectionViewCell"];
    HWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HWCollectionViewCell" forIndexPath:indexPath]; 
	
	InteractionModel * model = _model == nil? _myInteractionModel:_model;
	[cell setImgUrlStr:model.imageUrls[indexPath.row]];
    return cell;
}
//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 0);//分别为上、左、下、右
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
	InteractionModel * model = _model == nil? _myInteractionModel:_model;
    if(_seeBigImgBlock){
        _seeBigImgBlock(model,indexPath.row);
    }
}

- (IBAction)seeAllBtnAction:(id)sender {//点击时的状态
	InteractionModel * model = _model == nil? _myInteractionModel:_model;
    model.isStatusSeeAll = !model.isStatusSeeAll;//状态立刻改变
    model.cellH = [InteractionCell cellHByModel:model];
    [_seeAllBtn setTitle:@"收起" forState:0];
    if (model.isStatusSeeAll) {//状态是 查看全部 那就收起
       [_seeAllBtn setTitle:@"查看全部" forState:0];
    }
    if (_seeAllBlock) {
        _seeAllBlock(model);
    }
}

//-(void)bimImgAction:(UIButton *)btn{
//    if(_seeBigImgBlock){
//        _seeBigImgBlock(_model,btn.tag - Btn_Tag);
//    }
//}
- (IBAction)deleteAction:(id)sender {
	if (_deleteBlock) {
		InteractionModel * model = _model == nil? _myInteractionModel:_model;
		_deleteBlock(model);
	}
}

- (IBAction)commentAction:(id)sender {
	if (_commentBlock) {
		InteractionModel * model = _model == nil? _myInteractionModel:_model;
		_commentBlock(model);
	}
}

- (IBAction)pardiseAction:(id)sender {
	if (_pardiseBlock) {//l
			InteractionModel * model = _model == nil? _myInteractionModel:_model;
		_pardiseBlock(model);
	}
}

+(CGFloat)cellHByModel:(InteractionModel *)model{
	CGFloat H = 45 + 10 + 40;
    CGFloat titltH = [DDFactory autoHByText:model.content Font:[UIFont fontWithName:@"PingFang-SC-Medium" size:15] W:SCREENWIDTH - 24];
    model.contentH = titltH;
    if (titltH > 60) {//大于60 那么需要有个 查看全部的按钮
        model.needHideSeeAllBtn = NO;//不能隐藏查看全部按钮
        H += 30;//加上查看全部 按钮的高度
        if (model.isStatusSeeAll) {//如果是查看全部状态 就加的是文字真实高度
            H += titltH;
        }else{//否则就是文字的收起高度
            H += 60;
        }
    }else{//不大于60的情况下 加真实高度 并且隐藏查看全部按钮
         H += titltH;
         model.needHideSeeAllBtn = YES;//隐藏查看全部按钮
    }
	CGFloat margin = 5;
    if (model.imageUrls.count == 1) {
        if (model.imageUrls.count == 1) {
            CGSize size = [DDFactory getImageSizeWithURL:IMGURL([model.imageUrls lastObject])];
            CGFloat sizew = size.width * 1.0;
            CGFloat sizeh = size.height * 1.0;
            if (sizew <=0 || sizeh <=0 ){
                sizew = 1.0;
                sizeh = 2/3.0;
            }
            model.singleImgH = SCREENWIDTH *sizeh / sizew;
        }
        return  H += model.singleImgH + 5;
    }
	CGFloat w = (SCREENWIDTH   - 30 )/ 3.0;//图片高宽
	NSInteger imgCount = model.imageUrls.count;
	NSInteger rows = imgCount/3;//图片共几排

	if(imgCount%3!=0 &&imgCount!=0){
		rows += 1;//如果有余数 说名可能为 5 8 那么就要再加一排
	}
		H += rows * w + (rows + 1)*margin;//图片上 图片之间 最下排的图片的间隙 间隙数 比行数多 1
	return H;
}
@end
