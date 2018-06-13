//
//  InteracteHeaderView.h
//  CommentFrame
//
//  Created by 王帅 on 2018/6/13.
//  Copyright © 2018 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteracteHeaderView : UIView
 
-(void)refresh;
@property (nonatomic,copy)void(^toCommentInteractionVCBlock)(NSString *interactId);
@end
