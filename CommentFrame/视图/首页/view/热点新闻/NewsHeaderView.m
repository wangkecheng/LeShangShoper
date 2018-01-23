
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

@end
@implementation NewsHeaderView
+(instancetype)headerViewWithFrame:(CGRect)frame{
	NewsHeaderView *view = [DDFactory getXibObjc:@"NewsHeaderView"];
	view.frame  = frame;
    [view setTime];
	return view;
}
-(void)setTime{
    NSDateComponents *components = [NSDate componentsByDate:[NSDate date]];
    _timeLbl.text = [NSString stringWithFormat:@"%ld月%ld日 %@ %ld:%ld",components.month,components.day,components.hour>12?@"下午":@"上午",components.hour,components.minute];
}
@end
