//
//  TTCommentInputView.h
//  TTNews
//
//  Created by jiahui on 2017/1/18.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTCommentsModel.h"

@class TTCommentInputView;
@protocol TTCommentInputViewDelegate <NSObject>

@optional
- (void)commentViewSendButtonDidChecked:(TTCommentInputView *)commentView;
- (void)commentViewCheckNotLongin:(TTCommentInputView *)commentView;
- (void)commentViewSendCommentSuccess:(TTCommentInputView *)commentView withComment:(TTCommentsModel *)comment;

@end


@interface TTCommentInputView : UIView

@property (nonatomic, weak) id<TTCommentInputViewDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *inputText;

@property (nonatomic, assign) BOOL isReply;///是否是回复评论

@property (nonatomic, strong) NSNumber *article_id;         ///回复文章id（回文章用）
@property (nonatomic, strong) NSNumber *commit_id;          ///回复评论的id(回评论用)
@property (nonatomic, copy) NSString *reply;                ///回复评论的作者nik

+ (instancetype)commentView;
- (void)showCommentView;
- (void)dismessCommentView;
- (void)setTextViewPlaceholder:(NSString *)placeholderText;

@end
