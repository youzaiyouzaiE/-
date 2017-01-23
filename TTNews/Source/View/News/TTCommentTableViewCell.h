//
//  TTCommentTableViewCell.h
//  TTNews
//
//  Created by jiahui on 2016/12/18.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTCommentTableViewCell : UITableViewCell


@property (nonatomic, strong) UIImageView *imageViewPortrait;
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labeDate;
@property (nonatomic, copy, readonly) NSString *commentStr;
@property (nonatomic, copy) NSString *commentID;

@property (nonatomic, assign) BOOL isShowTopLike;
@property (nonatomic, assign) BOOL canDeleteComment;
@property (nonatomic, assign) BOOL isLike;

- (void)setLikesNumber:(NSNumber *)likeNumber;
- (void)commentContentStr:(NSString *)commentStr;

+ (CGFloat)heightWithCommentContent:(NSString *)content;

@end
