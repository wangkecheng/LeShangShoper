//  CommentFrame
//
//  Created by warron on 2018/1/10.
//  Copyright © 2018年 warron. All rights reserved.
//

#import "CatalugeListHeaderView.h"

@implementation CatalugeListHeaderView

+(CatalugeListHeaderView *)instanceByFrame:(CGRect)frame{
	CatalugeListHeaderView * view = [DDFactory getXibObjc:@"CatalugeListHeaderView"];
	view.frame = frame;
	return view;
}
@end
