//
//  SearchManufacturersHeaderView.h
//  CommentFrame
//
//  Created by warron on 2018/1/14.
//  Copyright © 2018年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchManufacturersHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *serachCountLbl;
+(SearchManufacturersHeaderView * )instanceByFrame:(CGRect)frame;
@end
