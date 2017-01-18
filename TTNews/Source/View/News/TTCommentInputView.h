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
-(void)commentViewSendButtonDidChecked:(TTCommentInputView *)commentView;

@end


@interface TTCommentInputView : UIView

@property (nonatomic, weak) id<TTCommentInputViewDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *inputText;

+ (instancetype)commentView;
- (void)showCommentView;
- (void)dismessCommentView;

@end
