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
@property (nonatomic, assign) BOOL isAnswer;

@property (nonatomic, strong) NSNumber *article_id;
@property (nonatomic, strong) NSNumber *selectedReplyID;

+ (instancetype)commentView;
- (void)showCommentView;
- (void)dismessCommentView;
- (void)setTextViewPlaceholder:(NSString *)placeholderText;

@end
