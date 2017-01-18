//
//  TTCommentInputView.m
//  TTNews
//
//  Created by jiahui on 2017/1/18.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "TTCommentInputView.h"
#import "UITextView+Placeholder.h"

static const NSInteger bottomViewH = 200;
//static const NSInteger textView_H = 90;

@interface TTCommentInputView () <UIGestureRecognizerDelegate,UITextViewDelegate> {
    
    UIView *_bottomContentView;
    UITextView *_textView;
    UITapGestureRecognizer *_tapGesture;
    
    UIButton *_sendBtn;
}

@end

@implementation TTCommentInputView

+ (instancetype)commentView {
    TTCommentInputView *view = [[TTCommentInputView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    view.hidden = YES;
    [[UIApplication sharedApplication].delegate.window addSubview:view];
    return view;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        [self installCommpents];
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

- (void)installCommpents {
    _bottomContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, bottomViewH)];
    _bottomContentView.backgroundColor = [UIColor whiteColor];
    _bottomContentView.alpha = 1;
    [self addSubview:_bottomContentView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomContentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (10);
        make.left.mas_equalTo (15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    UILabel *writerLabel = [[UILabel alloc] init];
    writerLabel.textAlignment = NSTextAlignmentCenter;
    writerLabel.font = [UIFont systemFontOfSize:18];
    writerLabel.text = @"写跟帖";
    [_bottomContentView addSubview:writerLabel];
    [writerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (10);
        make.centerX.mas_equalTo (_bottomContentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
     _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomContentView addSubview:_sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (10);
        make.right.mas_equalTo (-15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    _textView.placeholder = @"发表下你的看法吧";
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.delegate = self;
    [_bottomContentView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(_bottomContentView.mas_bottom).offset(-15);
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint tapPoit = [gestureRecognizer locationInView:_bottomContentView];
    if (tapPoit.y > 0) {
        return NO;
    } else {
        [self dismessCommentView];
    }
    return NO;
}

- (void)showCommentView {
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _bottomContentView.frame = CGRectMake(0, self.frame.size.height - bottomViewH, self.frame.size.width, bottomViewH);
    } completion:^(BOOL finished) {
        [_textView becomeFirstResponder];
    }];
}

- (void)dismessCommentView {
    [UIView animateWithDuration:0.3 animations:^{
        _bottomContentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, bottomViewH);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)cancelAction:(UIButton *)button {
    [self dismessCommentView];
}

- (void)sendAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(commentViewSendButtonDidChecked:)]) {
        [_delegate commentViewSendButtonDidChecked:self];
    }
}

#pragma mark – UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _inputText = textView.text;
}

@end
