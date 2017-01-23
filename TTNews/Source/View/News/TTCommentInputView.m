//
//  TTCommentInputView.m
//  TTNews
//
//  Created by jiahui on 2017/1/18.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "TTCommentInputView.h"
#import "UITextView+Placeholder.h"
#import "TTAppData.h"
#import "TTNetworkSessionManager.h"

static const NSInteger bottomViewH = 135;
//static const NSInteger textView_H = 78;

@interface TTCommentInputView () <UIGestureRecognizerDelegate,UITextViewDelegate> {
    
    UIView *_bottomContentView;
    UITextView *_textView;
    UITapGestureRecognizer *_tapGesture;
    
    UIButton *_sendBtn;
    
    BOOL _isChecked;
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
    
    _textView = [[UITextView alloc] init];
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 5.0f;
    _textView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    _textView.placeholder = @"输入评论内容：";
    _textView.font = FONT_Regular_PF(16);
    _textView.delegate = self;
    [_bottomContentView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(78);
    }];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 5.0f;
    [_sendBtn setTitle:@"发表" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendBtn.titleLabel.font = FONT_Regular_PF(14);
    [_sendBtn setBackgroundImage:[UIImage imageWithColor:COLOR_HexStr(@"#0076FF")] forState:UIControlStateNormal];
    [_sendBtn setBackgroundImage:[UIImage imageWithColor:COLOR_DISABLED] forState:UIControlStateDisabled];
    [_sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomContentView addSubview:_sendBtn];
    _sendBtn.enabled = NO;
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_textView.mas_bottom).offset(10);
        make.right.mas_equalTo (-15);
        make.size.mas_equalTo(CGSizeMake(45, 22));
    }];
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"checkbox_bg"] forState:UIControlStateNormal];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"checkbox_click"] forState:UIControlStateSelected];
    [checkButton addTarget:self action:@selector(checkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomContentView addSubview:checkButton];
    [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_sendBtn.mas_top);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UILabel *signLabel = [[UILabel alloc] init];
    signLabel.text = @"匿名";
    signLabel.font = FONT_Light_PF(14);
    signLabel.textColor = COLOR_DISABLED;
    [_bottomContentView addSubview:signLabel];
    [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(checkButton.mas_top).offset(-2);
        make.left.mas_equalTo(checkButton.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(30, 24));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setTextViewPlaceholder:(NSString *)placeholderText {
    _textView.placeholder = placeholderText;
}

- (void)setIsReply:(BOOL)isReply {
    _isReply = isReply;
    if (isReply) {
        _textView.placeholder = @"回复评论：";
        [_sendBtn setTitle:@"回复" forState:UIControlStateNormal];
    }
}

- (void)showCommentView {
    self.hidden = NO;
    [_textView becomeFirstResponder];
}

- (void)dismessCommentView {
    [_textView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _bottomContentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, bottomViewH);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - keyboard
- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^{
        _bottomContentView.frame = CGRectMake(0, self.frame.size.height - bottomViewH - keyboardSize.height, self.frame.size.width, bottomViewH);
    } completion:^(BOOL finished) {
        
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


- (void)checkButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    _isChecked = button.selected;
}

- (void)sendAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(commentViewSendButtonDidChecked:)]) {
        [_delegate commentViewSendButtonDidChecked:self];
        return ;
    }
    
    if (SHARE_APP.isLogin) {///已经登录
        [self sendComment];
    } else {
        if ([_delegate respondsToSelector:@selector(commentViewCheckNotLongin:)]) {
            [_delegate commentViewCheckNotLongin:self];
            [self dismessCommentView];
        } else
            [TTProgressHUD showMsg:@"请登录后再试！"];
    }
}

#pragma mark – UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location == 0 && [text isEqualToString:@""]) {
        _sendBtn.enabled = NO;
    } else
        _sendBtn.enabled = YES;
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _inputText = textView.text;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma makr - netWorkRequest
- (void)sendComment {
    [TTProgressHUD show];
    NSDictionary *dic = @{@"content":_textView.text ,
                          @"user_id":[TTAppData shareInstance].currentUser.memberId ,
                          @"user_nick" : [TTAppData shareInstance].currentUser.nickname ,
                          @"user_avatar":[[TTAppData shareInstance] currentUserIconURLString]};
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString *url = TT_COMMENT_SEND_URL;
    if (_isReply) {
        [parameterDic setObject:_commit_id forKey:@"comment_id"];
        url = TT_COMMENT_REPLY_URL;
    } else {
        [parameterDic setObject:_article_id forKey:@"article_id"];
    }
    [[AFHTTPSessionManager manager] POST:url
                              parameters:parameterDic
                                progress:^(NSProgress * _Nonnull uploadProgress) {
                                    
                                }
                                 success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
                                     [TTProgressHUD dismiss];
                                     [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                                     _textView.text = nil;
                                     _sendBtn.enabled = NO;
                                     [self performSelector:@selector(dismessCommentView) withObject:nil afterDelay:0.5];
                                     [self performSelector:@selector(dismissSvprogressHud) withObject:nil afterDelay:0.5];
                                     if ([_delegate respondsToSelector:@selector(commentViewSendCommentSuccess: withComment:)]) {
                                         TTCommentsModel *responseComment = [[TTCommentsModel alloc] initWithDictionary:responseObject[@"comment"]];
                                         [_delegate commentViewSendCommentSuccess:self withComment:responseComment];
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     [TTProgressHUD dismiss];
                                     [TTProgressHUD showMsg:@"服务器请求出错，请稍后重试！"];
                                     //                                     [self dismissWriterView];
                                 }];
}

- (void)dismissSvprogressHud {
    [SVProgressHUD dismiss];
}

@end
