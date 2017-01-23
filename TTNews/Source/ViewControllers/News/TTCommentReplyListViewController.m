//
//  TTCommentReplyListViewController.m
//  TTNews
//
//  Created by jiahui on 2017/1/23.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "TTCommentReplyListViewController.h"
#import "TTCommentTableViewCell.h"
#import "TTCommentInputView.h"
#import "TTLoadMoerTableViewCell.h"
#import "TTAppData.h"
#import "UIImageView+WebCache.h"
#import "TTLoginViewController.h"
#import "NSString+Size.h"

static const CGFloat viewHeight = 44.0f;
static const NSInteger button_H = viewHeight - 16;

@interface TTCommentReplyListViewController () <UITableViewDelegate,UITableViewDataSource,TTCommentInputViewDelegate>{
    NSInteger _currentPage;
    NSMutableArray *_arrayReplyComments;
    
    BOOL _hasMoreData;
    TTCommentInputView *_commentView;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TTCommentReplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论";
    _currentPage = 0;
    _arrayReplyComments = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTLoadMoerTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"loadMoreCell"];
}

- (void)createBottomBarView {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF"];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(viewHeight);
    }];
    
    UIButton *writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [writeButton addTarget:self action:@selector(writeCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    [writeButton setTitle:@"发表评论" forState:UIControlStateNormal];
    writeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    writeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    writeButton.titleLabel.font = FONT_Regular_PF(15);
    [writeButton setTitleColor:[UIColor colorWithHexString:@"E5E5E5"] forState:UIControlStateNormal];
    writeButton.backgroundColor = [UIColor whiteColor];
    writeButton.layer.masksToBounds = YES;
    writeButton.layer.borderColor = [UIColor colorWithHexString:@"E5E5E5"].CGColor;
    writeButton.layer.cornerRadius = 5;
    writeButton.layer.borderWidth = 0.5;
    [bottomView addSubview:writeButton];
    [writeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.left.mas_equalTo(9);
        make.right.mas_equalTo(-9);
        make.height.mas_equalTo(button_H);
    }];
}

- (void)loadMoreData {
//    if (_article_id) {
//        [TTProgressHUD show];
//        [[AFHTTPSessionManager manager] GET:TT_COMMENT_LIST_URL
//                                 parameters:@{@"article_id":_article_id}
//                                   progress:^(NSProgress * _Nonnull downloadProgress) {}
//                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                                        [TTProgressHUD dismiss];
//                                        NSArray *comments = responseObject[@"data"];
//                                        for (NSDictionary *dic in comments) {
//                                            TTCommentsModel *comment = [[TTCommentsModel alloc] initWithDictionary:dic];
//                                            [_arrayComments addObject:comment];
//                                        }
//                                        if (_totalComments.integerValue > _arrayComments.count) {
//                                            _hasMoreData = YES;
//                                            _currentPage ++;
//                                        } else
//                                            _hasMoreData = NO;
//                                        [_tableView reloadData];
//                                    }
//                                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                                        [TTProgressHUD dismiss];
//                                        [TTProgressHUD showMsg:@"服务器繁忙！请求出错"];
//                                        [_tableView.mj_header endRefreshing];
//                                        self.tableView.mj_footer.hidden = YES;
//                                    }];
//    }
}

#pragma mark - Action perform
- (void)writeCommentAction:(UIButton *)button {
    if (!_commentView) {
        _commentView = [TTCommentInputView commentView];
        _commentView.delegate = self;
    }
//    _commentView.article_id = _article_id;
    _commentView.isReply = YES;
    [_commentView showCommentView];
}


#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        NSString *replyNick = _sourceComment.parent[@"user_nick"];
        return [TTCommentTableViewCell heightWithCommentContent:_sourceComment.content replyNickName:nil];
    } else {
        if (indexPath.row == _arrayReplyComments.count) {
            return 46;
        } else {
            TTCommentsModel *comment = _arrayReplyComments[indexPath.row];
//            NSString *replyNick = comment.parent[@"user_nick"];
            return [TTCommentTableViewCell heightWithCommentContent:comment.content replyNickName:nil];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"全部评论";
        titleLabel.font = FONT_Regular_PF(16);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        CGFloat height = [titleLabel.text stringHeightWithFont:titleLabel.font andInZoneWidth:MAXFLOAT];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(height);
        }];
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 18 + 22 + 18;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else
        return _arrayReplyComments.count + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayReplyComments.count) {
        TTLoadMoerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
        if (_hasMoreData) {
            cell.activityView.hidden = NO;
            [cell.activityView startAnimating];
            cell.titleLabel.text = @"努力加载中…";
            [self loadMoreData];
        } else {
            cell.activityView.hidden = YES;
            [cell.activityView stopAnimating];
            cell.titleLabel.text = @"没有更多评论";
        }
        return cell;
    } else {
        NSString *identifierString = @"commentCell";
        TTCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
        if (!cell) {
            cell = [[TTCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
        }
        TTCommentsModel *comment = _arrayReplyComments[indexPath.row];
        [cell.imageViewPortrait sd_setImageWithURL:[NSURL URLWithString:comment.user_avatar]];
        cell.labelName.text = comment.user_nick;
        NSString *publishedDate = comment.created_at;
        if (publishedDate.length > 10) {
            publishedDate = [publishedDate substringWithRange:NSMakeRange(0, 10)];
        }
        cell.labeDate.text = publishedDate;
//        NSString *replyNick = comment.parent[@"user_nick"];
        [cell commentContentStr:comment.content replyNickName:nil];
        cell.isShowTopLike = NO;
        TTUserInfoModel *currentUser = [TTAppData shareInstance].currentUser;
        if ([comment.user_id.stringValue isEqualToString:currentUser.memberId]) {
            cell.canDeleteComment = YES;
        } else {
            cell.canDeleteComment = NO;
        }
        [cell setLikesNumber:comment.like_num];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayReplyComments.count) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TTCommentsModel *comment = _arrayReplyComments[indexPath.row];
    if (!_commentView) {
        _commentView = [TTCommentInputView commentView];
        _commentView.delegate = self;
    }
    _commentView.isReply = YES;
    _commentView.selectedReplyID = comment.reply_to_id;
    [_commentView showCommentView];
}

#pragma mark - TTCommentInputViewDelegate
-(void)commentViewCheckNotLongin:(TTCommentInputView *)commentView; {
    [self presentLoginView];
}

- (void)commentViewSendCommentSuccess:(TTCommentInputView *)commentView {
    //    [];
}

#pragma mark - longin View
- (void)presentLoginView {
    TTLoginViewController *loginVC = [[TTLoginViewController alloc] init];
    loginVC.isPresentInto = YES;
    loginVC.loginBlock = ^(NSNumber *uid, NSString *token) {
        
    };
    UINavigationController *navitagtionVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navitagtionVC animated:YES completion:nil];
}


@end
