//
//  TTCommentViewController.m
//  TTNews
//
//  Created by jiahui on 2016/12/18.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTCommentViewController.h"
#import <MJRefresh.h>
#import "TTCommentTableViewCell.h"
#import "AFNetworking.h"
#import "TTCommentsModel.h"
#import "UIImageView+WebCache.h"
#import "SDiOSVersion.h"
#import "TTAppData.h"
#import "TTLoginViewController.h"
#import "TTCommentViewController.h"
#import "TTRequestManager.h"
#import <AFNetworking/AFNetworking.h>
#import "TalkingData.h"

@interface TTCommentViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate> {
    NSInteger _currentPage;
    NSMutableArray *_arrayComments;
    
    /////写评论
    UIView *_coverView;
    UIView *_writerView;
    UITextView *_textView;
    NSNumber *_selectedReplyID;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TTCommentViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"chaKanPingLun"];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"chaKanPingLun"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentPage = 0;
    _arrayComments = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    if (_article_id) {
         [self loadLifeInfoDataWithDic:@{@"article_id":_article_id}];
    } else
        [TTProgressHUD showMsg:@"没有评论！"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MJ
- (void)loadMoreData {
    _currentPage ++;
//    [self loadListForPage:_currentPage ];
}

- (void)loadLifeInfoDataWithDic:(NSDictionary *)dic {
    [TTProgressHUD show];
    [[AFHTTPSessionManager manager] GET:TT_COMMENT_URL
                             parameters:dic
                               progress:^(NSProgress * _Nonnull downloadProgress) {}
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    [TTProgressHUD dismiss];
                                    NSArray *comments = responseObject[@"data"];
                                    for (NSDictionary *dic in comments) {
                                        TTCommentsModel *comment = [[TTCommentsModel alloc] initWithDictionary:dic];
                                        [_arrayComments addObject:comment];
                                    }
                                    [_tableView reloadData];
                                    if (_totalComments.integerValue > _arrayComments.count) {
                                        [self updateMJViewWithFootHaveMoreData:YES];
                                    } else
                                        [self updateMJViewWithFootHaveMoreData:NO];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [TTProgressHUD dismiss];
                                    [TTProgressHUD showMsg:@"服务器繁忙！请求出错"];
                                    [_tableView.mj_header endRefreshing];
                                    self.tableView.mj_footer.hidden = YES;
                                }];
}

- (void)updateMJViewWithFootHaveMoreData:(BOOL)haveData {
        if (haveData) {
            [_tableView.mj_footer resetNoMoreData];
        } else
            [_tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTCommentsModel *comment = _arrayComments[indexPath.row];
     NSString *replyNick = comment.parent[@"user_nick"];
    return [TTCommentTableViewCell heightWithCommentContent:comment.content replyNickName:replyNick];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayComments.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifierString = @"commentCell";
    TTCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
    if (!cell) {
        cell = [[TTCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
    }
    TTCommentsModel *comment = _arrayComments[indexPath.row];
    [cell.imageViewPortrait sd_setImageWithURL:[NSURL URLWithString:comment.user_avatar]];
    cell.labelName.text = comment.user_nick;
    cell.labeDate.text = comment.created_at;
    NSString *replyNick = comment.parent[@"user_nick"];
    [cell commentContentStr:comment.content replyNickName:replyNick];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTCommentsModel *comment = _arrayComments[indexPath.row];
    _selectedReplyID = comment.reply_to_id;
    if (!_coverView) {
        [self createWriteCommentsView];
    }
    [self showWriteView];
}

#define  TEXTVIEW_H     90
- (void)createWriteCommentsView {
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _coverView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    tapGesture.delegate = self;
    [_coverView addGestureRecognizer:tapGesture];
    
    _writerView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, TEXTVIEW_H + 60 + 10)];
    _writerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    _writerView.alpha = 1;
    [_coverView addSubview:_writerView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_writerView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (10);
        make.left.mas_equalTo (15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    UILabel *writerLabel = [[UILabel alloc] init];
    writerLabel.textAlignment = NSTextAlignmentCenter;
    writerLabel.font = [UIFont systemFontOfSize:18];
    writerLabel.text = @"写跟帖";
    [_writerView addSubview:writerLabel];
    [writerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (10);
        make.centerX.mas_equalTo (_writerView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [_writerView addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (10);
        make.right.mas_equalTo (-15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    _textView.font = [UIFont systemFontOfSize:16];
    [_writerView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(_writerView.mas_bottom).offset(-15);
    }];
}

- (void)showWriteView {
    _coverView.hidden = NO;
    [_textView becomeFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        DeviceSize size = [SDiOSVersion deviceSize];
        if ( size == Screen5Dot5inch) {
            _writerView.frame = CGRectMake(0, Screen_Height - TEXTVIEW_H - 60 - 30 - 250 , Screen_Width, TEXTVIEW_H + 60 + 10);
        } else
            _writerView.frame = CGRectMake(0, Screen_Height - TEXTVIEW_H - 60 - 10 - 250 , Screen_Width, TEXTVIEW_H + 60 + 10);
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissWriterView {
    [_textView resignFirstResponder];
    [UIView animateWithDuration:0.35 animations:^{
        _writerView.frame = CGRectMake(0, Screen_Height, Screen_Width, TEXTVIEW_H + 60 + 10);
    } completion:^(BOOL finished) {
        _coverView.hidden = YES;
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:_writerView];
    if (point.y > 0) {
        return NO;
    } else
        return YES;
}

#pragma mark - Action
- (void)tapGestureAction {
    [self dismissWriterView];
}

- (void)cancelAction:(UIButton *)button {
    [self dismissWriterView];
}

- (void)sendAction:(UIButton *)button {
    if (SHARE_APP.isLogin) {
        [self sendComment];
    } else {
        [self presentLoginView];
    }
}

- (void)sendComment {
     [TalkingData trackEvent:@"评论列表发评论"];
    if (_textView.text.length < 1) {
        [TTProgressHUD showMsg:@"没有评论内容"];
        return;
    }
    [TTProgressHUD show];
    NSDictionary *parameterDic = @{@"article_id" : _article_id ,
                                   @"content":_textView.text ,
                                   @"user_id":[TTAppData shareInstance].currentUser.memberId ,
                                   @"user_nick" : [TTAppData shareInstance].currentUser.nickname ,
                                   @"user_avatar":[[TTAppData shareInstance] currentUserIconURLString],
                                   @"reply_to_id" : _selectedReplyID,
                                   };
    [[AFHTTPSessionManager manager] POST:TT_COMMENT_URL
                              parameters:parameterDic
                                progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                     [TTProgressHUD dismiss];
                                     [SVProgressHUD showSuccessWithStatus:nil];
                                     [self dismissWriterView];
                                     _textView.text = nil;
                                    [self performSelector:@selector(dismissSvprogressHud) withObject:nil afterDelay:0.5];
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     [TTProgressHUD dismiss];
                                    [TTProgressHUD showMsg:@"服务器请求出错，请稍后重试！"];
                                     [self dismissWriterView];
                                 }];
    //
}

- (void)dismissSvprogressHud{
    [SVProgressHUD dismiss];
    
}

#pragma mark - longin View
- (void)presentLoginView {
    [self dismissWriterView];
    TTLoginViewController *loginVC = [[TTLoginViewController alloc] init];
    loginVC.isPresentInto = YES;
    loginVC.loginBlock = ^(NSNumber *uid, NSString *token) {
        
    };
    UINavigationController *navitagtionVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navitagtionVC animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
