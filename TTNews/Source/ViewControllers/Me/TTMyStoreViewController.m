//
//  TTMyStoreViewController.m
//  TTNews
//
//  Created by jiahui on 2017/1/25.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "TTMyStoreViewController.h"
#import "SinglePictureNewsTableViewCell.h"
#import "TTDetailViewController.h"
#import "TTLoadMoerTableViewCell.h"
#import <MJRefresh.h>
#import "TTNetworkSessionManager.h"
#import "TTAppData.h"
#import "TTNewListPageInfoModel.h"

@interface TTMyStoreViewController ()<UITableViewDelegate,UITableViewDataSource> {
    TTNewListPageInfoModel *_pagInfo;
    NSInteger _currentPage;
    BOOL _hasMoreData;
    BOOL _isLoading;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayList;

@end

@implementation TTMyStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的收藏";
    [self addTabelView];
}

- (void)addTabelView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.rowHeight = [SinglePictureNewsTableViewCell height];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = COLOR_HexStr(@"EFEFEF");
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SinglePictureNewsTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"SinglePictureCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTLoadMoerTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"loadMoreCell"];
    [self loadData];
//    [self loadData];
}

- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData {
    _currentPage = 1;
    _hasMoreData = YES;///
    [self loadListForPage:_currentPage andIsRefresh:YES];
}

- (void)loadMoreData {
    _currentPage ++;
    [self loadListForPage:_currentPage andIsRefresh:NO];
}

- (void)loadListForPage:(NSInteger)page andIsRefresh:(BOOL)isRefresh {
    if (_isLoading) {
        return ;
    }
    _isLoading = YES;
    NSDictionary *parameterDic = @{@"page":@(page)};;
    __weak __typeof(self)weakSelf = self;
    [[AFHTTPSessionManager manager] GET:TT_STORE_LIST_URL([TTAppData shareInstance].currentUser.memberId)
                             parameters:parameterDic
                               progress:^(NSProgress * _Nonnull downloadProgress) {}
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    _isLoading = NO;
                                    if (isRefresh) {
                                        [_arrayList removeAllObjects];
                                    }
                                    NSDictionary *pageInfoDic = responseObject[@"meta"][@"pagination"];
                                    _pagInfo = [[TTNewListPageInfoModel alloc] initWithDictionary:pageInfoDic];
                                    NSArray *dataArray = responseObject[@"data"];
                                    for (NSDictionary *dic in dataArray) {
                                        TTNewListModel *model = [[TTNewListModel alloc] initWithDictionary:dic];
                                        [_arrayList addObject:model];
                                    }
                                    BOOL hasMoreData = NO;
                                    if (_arrayList.count < _pagInfo.total_pages.integerValue) {
                                        hasMoreData = YES;
                                    }
                                    [weakSelf updateMJViewStatusWithIsUpload:isRefresh footHaveMoreData:hasMoreData];
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    _isLoading = NO;
                                    [TTProgressHUD dismiss];
                                    [TTProgressHUD showMsg:@"服务器繁忙！请求出错"];
                                    [_tableView.mj_header endRefreshing];
                                }];
}

- (void)updateMJViewStatusWithIsUpload:(BOOL)isRefresh footHaveMoreData:(BOOL)haveData{
    if (isRefresh) {
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
    } else {
        if (haveData) {
            _hasMoreData = YES;
        } else {
            _hasMoreData = NO;
        }
        [_tableView reloadData];
    }
}

#pragma mark -- UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayList.count +1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayList.count) {
        return 46;
    } else
        return [SinglePictureNewsTableViewCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayList.count) {
        TTLoadMoerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
        if (_hasMoreData) {
            cell.activityView.hidden = NO;
            [cell.activityView startAnimating];
            cell.titleLabel.text = @"努力加载中…";
            [self loadMoreData];
        } else {
            cell.activityView.hidden = YES;
            [cell.activityView stopAnimating];
            cell.titleLabel.text = @"没有更多数据";
        }
        return cell;
    } else {
        SinglePictureNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SinglePictureCell"];
        TTNewListModel *listInfo = _arrayList[indexPath.row];
        cell.imageUrl = listInfo.cover_pic;
        cell.contentTittle = listInfo.title;
        NSString *publishedDate = listInfo.published_at;
        if (publishedDate.length > 10) {
            publishedDate = [publishedDate substringWithRange:NSMakeRange(0, 10)];
        }
        cell.dateLabel.text = publishedDate;
        [cell setSourceLabelText:listInfo.source];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arrayList.count) {
        return ;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTNewListModel *listInfo = _arrayList[indexPath.row];
    TTDetailViewController *detailVC = [[TTDetailViewController alloc] init];
    detailVC.detailModel = listInfo;
    detailVC.article_id = listInfo.articleInfo.article_id;
    [self.navigationController pushViewController:detailVC animated:YES];
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
