//
//  TTCommentInputView.h
//  TTNews
//
//  Created by jiahui on 2017/1/18.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTCommentInputView;
@protocol TTCommentInputViewDelegate <NSObject>

@optional
- (void)commentViewSendButtonDidChecked:(TTCommentInputView *)commentView;
- (void)commentViewCheckNotLongin:(TTCommentInputView *)commentView;
- (void)commentViewSendCommentSuccess:(TTCommentInputView *)commentView;

@end


@interface TTCommentInputView : UIView

@property (nonatomic, weak) id<TTCommentInputViewDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *inputText;

@property (nonatomic, assign) BOOL isReply;///是否是回复评论

@property (nonatomic, strong) NSNumber *article_id;         /////文章id（回文章用）
@property (nonatomic, strong) NSNumber *commit_id;          ///评论id(回评论用)

+ (instancetype)commentView;
- (void)showCommentView;
- (void)dismessCommentView;
- (void)setTextViewPlaceholder:(NSString *)placeholderText;

@end
