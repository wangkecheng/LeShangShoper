
//
//  NewsHeaderView.m
//  CommentFrame
//
//  Created by warron on 2018/1/2.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "NewsHeaderView.h"
@interface NewsHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTItViewH;
@property (weak, nonatomic) IBOutlet UIView *subTitView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateH;

@end
@implementation NewsHeaderView
+(instancetype)headerViewWithFrame:(CGRect)frame{
	NewsHeaderView *view = [DDFactory getXibObjc:@"NewsHeaderView"];
	view.frame  = frame;
    [view setTime];
    view.timeLbl.alpha = 0;
    view.dateH.constant = 0;//暂时不显示时间
	return view;
}
-(void)setTime{
    NSDateComponents *components = [NSDate componentsByDate:[NSDate date]];
    _timeLbl.text = [NSString stringWithFormat:@"%ld月%ld日 %@ %ld:%ld",components.month,components.day,components.hour>12?@"下午":@"上午",components.hour,components.minute];
}
-(void)setTime:(NSString *)time isShowSubTit:(BOOL)isShowSubTit{
  
    _timeLbl.text = time;
      _subTItViewH.constant = 0;
    if (isShowSubTit) {
       _subTItViewH.constant = 30;
    }
    for (UIView *view in self.subviews) {
        view.alpha = 0;
        if (isShowSubTit) {
             view.alpha = 1;
        }
    }
}
@end
