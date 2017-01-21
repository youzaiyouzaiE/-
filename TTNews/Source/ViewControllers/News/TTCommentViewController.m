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
#import "TTNetworkSessionManager.h"
#import "TalkingData.h"
#import "TTCommentInputView.h"
#import "TTLoadMoerTableViewCell.h"

@interface TTCommentViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,TTCommentInputViewDelegate> {
    NSInteger _currentPage;
    NSMutableArray *_arrayComments;
    
    TTCommentInputView *_commentView;
    BOOL _hasMoreData;
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
    if (!_commentView) {
        _commentView = [TTCommentInputView commentView];
        _commentView.delegate = self;
    }
    _commentView.article_id = _article_id;
    _commentView.isAnswer = YES;
    _commentView.selectedReplyID = comment.reply_to_id;
    [_commentView showCommentView];
}

- (void)showWriteComment {

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
