//
//  TTCommentLikeListViewController.m
//  TTNews
//
//  Created by jiahui on 2017/1/25.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "TTCommentLikeListViewController.h"
#import "TTNetworkSessionManager.h"
#import "TTCommentLikeModel.h"
#import "TTLoadMoerTableViewCell.h"
#import "TTImagAndLabelCell.h"

@interface TTCommentLikeListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _currentPage;
    BOOL _hasMoreData;
    BOOL _isLoading;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayCommentLikeModel;

@end

@implementation TTCommentLikeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationItem.title = @"赞过的人";
    _currentPage = 0;
    _arrayCommentLikeModel = [NSMutableArray array];
    _hasMoreData = YES;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 58;
    [self.view addSubview:_tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTLoadMoerTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"loadMoreCell"];
    [self.tableView registerClass:[TTImagAndLabelCell class] forCellReuseIdentifier:@"imagAndLabelCell"];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(0);
    }];
    [self loadLikeUsers];
}

#pragma  mark  NetWork Request
- (void)loadLikeUsers {
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    [[AFHTTPSessionManager manager] GET:TT_COMMENT_REPLY_LIKE_LIST_UR
                             parameters:@{@"comment_id":_commentId, @"page":@(_currentPage)}//, @"page":@(_currentPage)}
                               progress:^(NSProgress * _Nonnull downloadProgress) {}
                                success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
                                    NSDictionary *metaDic = responseObject[@"meta"];
                                    NSDictionary *paginationDic = metaDic[@"pagination"];
                                    NSNumber *_totalLikesNumber = paginationDic[@"total"];
                                    
                                    NSArray *commentLikes = responseObject[@"data"];
                                    for (NSDictionary *dic in commentLikes) {
                                        TTCommentLikeModel *model = [[TTCommentLikeModel alloc] initWithDictionary:dic];
                                        [_arrayCommentLikeModel addObject:model];
                                    }
                                    if (_totalLikesNumber.integerValue > _arrayCommentLikeModel.count) {
                                        _hasMoreData =  YES;
                                    } else
                                        _hasMoreData = NO;
                                    [self.tableView reloadData];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [TTProgressHUD showMsg:@"服务器繁忙！请求出错"];
                                }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayCommentLikeModel.count + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, -2, self.tableView.frame.size.width, 3)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayCommentLikeModel.count) {
        TTLoadMoerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
        if (_hasMoreData) {
            cell.activityView.hidden = NO;
            [cell.activityView startAnimating];
            cell.titleLabel.text = @"努力加载中…";
            [self loadLikeUsers];
        } else {
            cell.activityView.hidden = YES;
            [cell.activityView stopAnimating];
            cell.titleLabel.text = @"没有更多评论";
        }
        return cell;
    } else {
        TTCommentLikeModel *model = _arrayCommentLikeModel[indexPath.row];
        TTImagAndLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imagAndLabelCell"];
        cell.titleString = model.user_nick;
        [cell setImageUrlString:model.user_avatar];
        return cell;
    }
}

@end
