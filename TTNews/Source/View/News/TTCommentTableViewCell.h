//
//  TTCommentTableViewCell.h
//  TTNews
//
//  Created by jiahui on 2016/12/18.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TTCommentDeleteBlock)(UIButton *);
typedef void (^TTCommentLikeBlock)(UIButton *);

@interface TTCommentTableViewCell : UITableViewCell


@property (nonatomic, strong) UIImageView *imageViewPortrait;/////图像
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labeDate;
@property (nonatomic, copy, readonly) NSString *commentStr;
@property (nonatomic, strong) NSNumber *commentID;
@property (nonatomic, assign) BOOL isShowTopLike;
@property (nonatomic, assign) BOOL canDeleteComment;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, copy) TTCommentLikeBlock likeBlock;
@property (nonatomic, copy) TTCommentDeleteBlock deleteBlock;
@property (nonatomic, strong) NSNumber *likesNumber;


- (void)commentContentStr:(NSString *)commentStr;
- (void)setCommentReplyLabelNumber:(NSNumber *)number;

+ (CGFloat)heightWithCommentContent:(NSString *)content;

@end
