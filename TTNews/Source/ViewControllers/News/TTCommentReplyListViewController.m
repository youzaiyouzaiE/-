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
#import "TTNetworkSessionManager.h"
#import "TTLikesIconCell.h"
#import "TTCommentLikeListViewController.h"

static const CGFloat viewHeight = 44.0f;
static const NSInteger button_H = viewHeight - 16;

@interface TTCommentReplyListViewController () <UITableViewDelegate,UITableViewDataSource,TTCommentInputViewDelegate>{
    NSInteger _currentPage;
    NSInteger _totalReplyComments;
    
    TTCommentInputView *_writeCommentView;
    
    BOOL _canLoadMoreData;////用于判断刷新状态
    BOOL _isLoading;///防止请求中多次请求
    
    NSMutableArray *_arrayCommentLikesURL;
    NSNumber* _totalLikesNumber;
}

@property (nonatomic, strong) NSMutableArray *arrayReplyComments;
@property (nonatomic, strong) NSMutableArray *arrayLikeComments;///当前用户是否点赞
@property (nonatomic, strong) NSMutableArray *arrayLikesNum;//评论里对应的喜欢数
//@property (nonatomic, strong) NSMutableArray *arrayCommentLikeModel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TTCommentReplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    _currentPage = 0;
    _arrayReplyComments = [NSMutableArray array];
    _arrayLikeComments = [NSMutableArray array];
    _arrayLikesNum = [NSMutableArray array];
    _arrayCommentLikesURL = [NSMutableArray array];
    
    [_arrayLikeComments addObject:@(0)];
    [_arrayLikesNum addObject:_sourceComment.like_num];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-viewHeight);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTLoadMoerTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"loadMoreCell"];
    [self.tableView registerClass:[TTCommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
    [self.tableView registerClass:[TTLikesIconCell class] forCellReuseIdentifier:@"iconImageCell"];
    [self createBottomBarView];
    _totalReplyComments = _sourceComment.reply_num.integerValue;
    if (_totalReplyComments > 0) {
        _canLoadMoreData = YES;
        [self loadMoreReplyComments];
    }
    [self loadLikeUsers];
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
    [writeButton setTitle:@"回复评论" forState:UIControlStateNormal];
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

#pragma  mark  NetWork Request
- (void)loadLikeUsers {
    [[AFHTTPSessionManager manager] GET:TT_COMMENT_REPLY_LIKE_LIST_URL 
                             parameters:@{@"comment_id":_sourceComment.commentId, @"page":@(0)}//, @"page":@(_currentPage)}
                               progress:^(NSProgress * _Nonnull downloadProgress) {}
                                success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
                                    NSDictionary *metaDic = responseObject[@"meta"];
                                    NSDictionary *paginationDic = metaDic[@"pagination"];
                                    _totalLikesNumber = paginationDic[@"total"];
                                    
                                    NSArray *commentLikes = responseObject[@"data"];
                                    for (NSDictionary *dic in commentLikes) {
                                        [_arrayCommentLikesURL addObject:dic[@"user_avatar"]];
                                    }
                                    if (_arrayCommentLikesURL.count > 0) {
                                        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//                                        [_tableView reloadData];
                                    }
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [TTProgressHUD showMsg:@"服务器繁忙！请求出错"];
                                }];
}

- (void)loadMoreReplyComments {
    if (_isLoading) {
        return ;
    }
    _isLoading = YES;
    [[AFHTTPSessionManager manager] GET:TT_COMMENT_REPLY_LIST_URL
                             parameters:@{@"comment_id":_sourceComment.commentId, @"page":@(_currentPage)}//, @"page":@(_currentPage)}
                               progress:^(NSProgress * _Nonnull downloadProgress) {}
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    NSArray *comments = responseObject[@"data"];
                                    for (NSDictionary *dic in comments) {
                                        TTCommentsModel *comment = [[TTCommentsModel alloc] initWithDictionary:dic];
                                        
                                        [_arrayReplyComments addObject:comment];
                                        [_arrayLikeComments addObject:@(0)];
                                        [_arrayLikesNum addObject:comment.like_num];
                                    }
                                    if (_totalReplyComments > _arrayReplyComments.count) {
                                        _canLoadMoreData = YES;
                                        _currentPage ++;
                                    } else {
                                        _canLoadMoreData = NO;
                                    }
                                    [_tableView reloadData];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [TTProgressHUD showMsg:@"服务器繁忙！请求出错"];
                                }];
}

#pragma mark - Action perform
- (void)writeCommentAction:(UIButton *)button {
    if (!_writeCommentView) {
        _writeCommentView = [TTCommentInputView commentView];
        _writeCommentView.delegate = self;
    }
    _writeCommentView.isReply = YES;
    _writeCommentView.commit_id = _sourceComment.commentId;
    [_writeCommentView showCommentView];
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return [TTLikesIconCell height];
        }
        return [TTCommentTableViewCell heightWithCommentContent:_sourceComment.content];
    } else {
        if (indexPath.row == _arrayReplyComments.count) {
            return 46;
        } else {
            TTCommentsModel *comment = _arrayReplyComments[indexPath.row];
            return [TTCommentTableViewCell heightWithCommentContent:comment.content];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        return [self tableViewSectionHeaderView];
    }
}

- (UIView *)tableViewSectionHeaderView {
    if (_totalReplyComments < 1) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"全部评论";
    titleLabel.font = FONT_Regular_PF(16);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    CGFloat height = [titleLabel.text stringHeightWithFont:titleLabel.font andInZoneWidth:MAXFLOAT];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(height);
    }];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (_totalReplyComments < 1) {
            return 1;
        }
        return 18 + 23 + 18;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_arrayCommentLikesURL.count > 0) {
            return 2;
        }
        return 1;
    } else
        return _arrayReplyComments.count + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section  == 1) {
        return [[UIView alloc] init];
    }
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayReplyComments.count && indexPath.section == 1) {///最后的加载提示
        TTLoadMoerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
        if (_canLoadMoreData) {
            cell.activityView.hidden = NO;
            [cell.activityView startAnimating];
            cell.titleLabel.text = @"努力加载中…";
            [self loadMoreReplyComments];
        } else {
            cell.activityView.hidden = YES;
            [cell.activityView stopAnimating];
            cell.titleLabel.text = @"没有更多评论";
        }
        return cell;
    } else {
        if (indexPath.section == 0 && indexPath.row == 1) {
            TTLikesIconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconImageCell"];
            [cell setLikeIconsWithURLArray:_arrayCommentLikesURL];
            [cell setLikesNumber:_totalLikesNumber];
            return cell;
        }
        NSString *identifierString = @"commentCell";
        TTCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
        TTCommentsModel *comment = nil;
        if (indexPath.section == 0) {
            comment = _sourceComment;
            cell.isShowTopLike = YES;
            cell.isLike = [(NSNumber *)_arrayLikeComments[indexPath.row] boolValue];
            cell.likesNumber = _arrayLikesNum[0];
        } else {
            comment = _arrayReplyComments[indexPath.row];
            cell.isShowTopLike = NO;
            cell.isLike = [(NSNumber *)_arrayLikeComments[indexPath.row + 1] boolValue];
            cell.likesNumber = _arrayLikesNum[indexPath.row + 1];
        }
        [cell.imageViewPortrait sd_setImageWithURL:[NSURL URLWithString:comment.user_avatar]];
        cell.labelName.text = comment.user_nick;
        NSString *publishedDate = comment.created_at;
        if (publishedDate.length > 13) {
            publishedDate = [publishedDate substringWithRange:NSMakeRange(5, publishedDate.length - 8)];
        }
        cell.labeDate.text = publishedDate;
        [cell commentContentStr:comment.content];
        if ([comment.user_id.stringValue isEqualToString:[TTAppData shareInstance].currentUser.memberId] && indexPath.section != 0) {
            cell.canDeleteComment = YES;
        } else {
            cell.canDeleteComment = NO;
        }
        cell.commentID = comment.commentId;
//        [cell setCommentReplyLabelNumber:comment.reply_num];
        cell.likeBlock = ^(UIButton *btn){
            [self cellLikeActionAtIndexPath:indexPath];
        };
        cell.deleteBlock = ^(UIButton *button){
            [self cellDeleteActionAtIndexPath:indexPath];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == _arrayReplyComments.count && indexPath.section == 1) {
        return ;
    }
     if (indexPath.section == 0 && indexPath.row == 1){
         TTCommentLikeListViewController *likesVC = [[TTCommentLikeListViewController alloc] init];
         likesVC.commentId = _sourceComment.commentId;
         [self.navigationController pushViewController:likesVC animated:YES];
         return ;
    }
    TTCommentsModel *comment = nil;
    if (indexPath.section == 0) {
        comment = _sourceComment;
    }
        comment = _arrayReplyComments[indexPath.row];
    TTCommentInputView  *commentView = [TTCommentInputView commentView];
    commentView.delegate = self;
    commentView.isReply = YES;
    commentView.commit_id = comment.commentId;
    [commentView showCommentView];
}

#pragma mark - Cell Action 
- (void)cellLikeActionAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self)weakSelf = self;
    NSInteger index = 0;
    if (indexPath.section != 0) {
        index = indexPath.row + 1;
    }
    weakSelf.arrayLikeComments[index] = @(1);
    NSNumber *likes = weakSelf.arrayLikesNum[index];
    weakSelf.arrayLikesNum[index] = @(likes.integerValue+1);
    if (indexPath.section == 0) {
        [self loadLikeUsers];
    }
}

- (void)cellDeleteActionAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self)weakSelf = self;
    NSInteger index = 0;
    if (indexPath.section != 0) {
        index = indexPath.row + 1;
    }
    [weakSelf.arrayLikesNum removeObjectAtIndex:index];
    [weakSelf.arrayLikeComments removeObjectAtIndex:index];
    [weakSelf.arrayReplyComments removeObjectAtIndex:indexPath.row];
    _totalReplyComments -= 1;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - TTCommentInputViewDelegate
-(void)commentViewCheckNotLongin:(TTCommentInputView *)commentView; {
    [self presentLoginView];
}

- (void)commentViewSendCommentSuccess:(TTCommentInputView *)commentView withComment:(TTCommentsModel *)comment{
    _totalReplyComments += 1;
    [_arrayReplyComments insertObject:comment atIndex:0];
    [_arrayLikeComments insertObject:@(0) atIndex:0];
    [_arrayLikesNum insertObject:@(0) atIndex:0];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
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
