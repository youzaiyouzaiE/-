//
//  TTCommentViewController.m
//  TTNews
//
//  Created by jiahui on 2016/12/18.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTCommentViewController.h"
#import "TTCommentTableViewCell.h"
#import "TTCommentsModel.h"
#import "UIImageView+WebCache.h"
#import "SDiOSVersion.h"
#import "TTAppData.h"
#import "TTLoginViewController.h"
#import "TTCommentViewController.h"
#import "TTRequestManager.h"
#import "TTNetworkSessionManager.h"
#import "TalkingData.h"
#import "TTCommentInputView.h"
#import "TTLoadMoerTableViewCell.h"
#import "TTCommentReplyListViewController.h"

static const CGFloat viewHeight = 44.0f;
static const NSInteger button_H = viewHeight - 16;

@interface TTCommentViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,TTCommentInputViewDelegate> {
    NSInteger _currentPage;
    NSInteger _allCommentsNum;////评论总数，包括后来添加的
    
    TTCommentInputView *_commentView;
    BOOL _hasMoreData;
    BOOL _isLoading;///防止请求中多次请求
}

@property (nonatomic, strong) NSMutableArray *arrayComments;
@property (nonatomic, strong) NSMutableArray *arrayLikeComments;///当前用户是否点赞
@property (nonatomic, strong) NSMutableArray *arrayLikesNum;//评论里对应的喜欢数
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TTCommentViewController

- (void)dealloc
{
    NSLog(@"%@ -> %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"chaKanPingLun"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationItem.title = @"评论";
    _arrayComments = [NSMutableArray array];
    _arrayLikeComments = [NSMutableArray array];
    _arrayLikesNum = [NSMutableArray array];
    _hasMoreData = YES;
    _allCommentsNum = _totalComments.integerValue;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTLoadMoerTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"loadMoreCell"];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-viewHeight+2);
    }];
    [self createBottomBarView];
}

- (void)naviBackAction {
    if (_totalComments.integerValue == _allCommentsNum) {
         NSLog(@"更新 bottom Bar");
    }
    [super naviBackAction];
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

- (void)loadMoreDataOrReset{////是否是刷新重置
    if (_isLoading) {
        return ;
    }
    _isLoading = YES;
    [[AFHTTPSessionManager manager] GET:TT_COMMENT_LIST_URL
                             parameters:@{@"article_id":_article_id,@"pag":@(_currentPage)}
                               progress:^(NSProgress * _Nonnull downloadProgress) {}
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    _isLoading = NO;
                                    NSArray *comments = responseObject[@"data"];
                                    for (NSDictionary *dic in comments) {
                                        TTCommentsModel *comment = [[TTCommentsModel alloc] initWithDictionary:dic];
                                        [_arrayComments addObject:comment];
                                        [_arrayLikeComments addObject:@(0)];
                                        [_arrayLikesNum addObject:comment.like_num];
                                    }
                                    if (_totalComments.integerValue > _arrayComments.count) {
                                        _hasMoreData = YES;
                                        _currentPage ++;
                                    } else
                                        _hasMoreData = NO;
                                    [_tableView reloadData];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [TTProgressHUD showMsg:@"服务器繁忙！请求出错"];
                                    _isLoading = NO;
                                }];
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayComments.count) {
        return 46;
    } else{
        TTCommentsModel *comment = _arrayComments[indexPath.row];
        return [TTCommentTableViewCell heightWithCommentContent:comment.content];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayComments.count + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayComments.count) {
        TTLoadMoerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
        if (_hasMoreData) {
            cell.activityView.hidden = NO;
            [cell.activityView startAnimating];
            cell.titleLabel.text = @"努力加载中…";
            [self loadMoreDataOrReset];
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
        TTCommentsModel *comment = _arrayComments[indexPath.row];
        [cell.imageViewPortrait sd_setImageWithURL:[NSURL URLWithString:comment.user_avatar]];
        cell.labelName.text = comment.user_nick;
        NSString *publishedDate = comment.created_at;
        if (publishedDate.length > 10) {
            publishedDate = [publishedDate substringWithRange:NSMakeRange(0, 10)];
        }
        cell.labeDate.text = publishedDate;
        [cell commentContentStr:comment.content];
        cell.isShowTopLike = NO;
        if ([comment.user_id.stringValue isEqualToString:[TTAppData shareInstance].currentUser.memberId]) {
            cell.canDeleteComment = YES;
        } else {
            cell.canDeleteComment = NO;
        }
        cell.commentID = comment.commentId;
        cell.isLike = [(NSNumber *)_arrayLikeComments[indexPath.row] boolValue];
        cell.likesNumber = _arrayLikesNum[indexPath.row];
        [cell setCommentReplyLabelNumber:comment.reply_num];
        cell.likeBlock = ^(UIButton *button){
             [self cellLikeActionAtIndexPath:indexPath];
        };
        cell.deleteBlock = ^(UIButton *button){
            [self cellDeleteActionAtIndexPath:indexPath];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayComments.count) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTCommentsModel *comment = _arrayComments[indexPath.row];
    TTCommentReplyListViewController *replyListVC = [[TTCommentReplyListViewController alloc] init];
    replyListVC.sourceComment = comment;
    [self.navigationController pushViewController:replyListVC animated:YES];
}

#pragma mark - Action perform
- (void)writeCommentAction:(UIButton *)button {
    if (!_commentView) {
        _commentView = [TTCommentInputView commentView];
        _commentView.delegate = self;
    }
    _commentView.article_id = _article_id;
    _commentView.isReply = NO;
    [_commentView showCommentView];
}

#pragma mark - Cell Action
- (void)cellLikeActionAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self)weakSelf = self;
    weakSelf.arrayLikeComments[indexPath.row ] = @(1);
    NSNumber *likes = weakSelf.arrayLikesNum[indexPath.row];
    weakSelf.arrayLikesNum[indexPath.row] = @(likes.integerValue+1);
}

- (void)cellDeleteActionAtIndexPath:(NSIndexPath *)indexPath {
     __weak __typeof(self)weakSelf = self;
    [weakSelf.arrayLikesNum removeObjectAtIndex:indexPath.row];
    [weakSelf.arrayLikeComments removeObjectAtIndex:indexPath.row];
    [weakSelf.arrayComments removeObjectAtIndex:indexPath.row];
    _allCommentsNum -= 1;
    [self .tableView reloadData];
}

#pragma mark - TTCommentInputViewDelegate
-(void)commentViewCheckNotLongin:(TTCommentInputView *)commentView; {
    [self presentLoginView];
}

- (void)commentViewSendCommentSuccess:(TTCommentInputView *)commentView withComment:(TTCommentsModel *)comment{
//    _hasMoreData = YES;
    [_arrayComments addObject:comment];
    _allCommentsNum += 1;
    [_arrayComments addObject:comment];
    [_arrayLikeComments addObject:@(0)];
    [_arrayLikesNum addObject:@(0)];
    [_tableView reloadData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
