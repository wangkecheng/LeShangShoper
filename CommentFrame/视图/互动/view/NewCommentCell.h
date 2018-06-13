//
//  NewCommentCell.h
//  CommentFrame
//
//  Created by 王帅 on 2018/6/13.
//  Copyright © 2018 warron. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NewCommentModel : NSObject

@property (nonatomic,strong)NSString *interactId;
@end
@interface NewCommentCell : UITableViewCell
@property (nonatomic,strong)NewCommentModel * model;
@property (nonatomic,copy)void(^clickBlock)(NewCommentModel * model);
@end
