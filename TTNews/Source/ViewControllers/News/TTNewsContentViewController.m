//
//  TTNewsContentViewController.m
//  TTNews
//
//  Created by jiahui on 2016/12/4.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTNewsContentViewController.h"
#import "SDCycleScrollView.h"
#import "SinglePictureNewsTableViewCell.h"
#import <MJRefresh.h>
#import "AFNetworking.h"
#import "TTNewListModel.h"
#import "TTNewListPageInfoModel.h"
#import "TTDetailViewController.h"
#import "TTNetworkSessionManager.h"


@interface TTNewsContentViewController () <SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    SDCycleScrollView *_cycleScrollView;
    NSInteger _currentPage;
    TTNewListPageInfoModel *_pagInfo;
    
    NSMutableArray *_arrayList;
    UIView *_headerView;
    UILabel *_labelLife;
    UILabel *_labelRate;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayCycleImages;

@end

@implementation TTNewsContentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrayList = [NSMutableArray array];
    _currentPage = 1;
    if (_isFristNews) {
        [self addCycleScrollView];
        _arrayCycleImages = [NSMutableArray array];
    }
    [self addTabelView];
}

- (void)addCycleScrollView {
    _headerView = [[UIView alloc] init];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero
                                                           delegate:self
                                                   placeholderImage:[UIImage imageNamed:@"night_photoset_list_cell_icon"]];
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    _cycleScrollView.autoScrollTimeInterval = 4;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    [_headerView addSubview:_cycleScrollView];
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(Screen_Height/4);
    }];
    
    _labelRate = [[UILabel alloc] init];
    _labelRate.font = [UIFont systemFontOfSize:15];
    _labelRate.textAlignment = NSTextAlignmentRight;
//    _labelRate.backgroundColor = [UIColor yellowColor];
    [_headerView addSubview:_labelRate];
    [_labelRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cycleScrollView.mas_bottom);
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(22);
    }];
    
    _labelLife = [[UILabel alloc] init];
    _labelLife.font = [UIFont systemFontOfSize:15];
    _labelLife.text = @"获取城市失败，请稍后再试";
    [_headerView addSubview:_labelLife];
    [_labelLife mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cycleScrollView.mas_bottom);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(_labelRate.mas_left);
        make.height.mas_equalTo(22);
    }];
    


    
}

-(void)addTabelView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = [SinglePictureNewsTableViewCell height];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SinglePictureNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"SinglePictureCell"];
    [self setupRefresh];
}

-(void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadData {
    [self loadListForPage:_currentPage andIsRefresh:YES];
    if (_isFristNews) {
        [self loadCycleImages];
        [self loadLifeInfoDataWithDic:@{@"lng":@"38.983424" , @"lat" :@"116.5320"}];
    }
}

- (void)loadMoreData {
    _currentPage ++;
    [self loadListForPage:_currentPage andIsRefresh:NO];
}

#pragma mark - netWork
- (void)loadCycleImages {
    [TTProgressHUD show];
    [[AFHTTPSessionManager manager] GET:TT_FRIST_CYCLE_LIST
                             parameters:nil
                               progress:^(NSProgress * _Nonnull downloadProgress) { }
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    [TTProgressHUD dismiss];
                                    [_arrayCycleImages removeAllObjects];
                                    for (NSDictionary *imageDic in responseObject[@"data"]) {
                                        [_arrayCycleImages addObject:imageDic[@"path"]];
                                    }
                                    _cycleScrollView.imageURLStringsGroup = _arrayCycleImages;
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [TTProgressHUD dismiss];
                                    [TTProgressHUD showMsg:@"服务器繁忙！请求出错"];
                                }];
}

- (void)loadLifeInfoDataWithDic:(NSDictionary *)dic {
    [[TTNetworkSessionManager shareManager] Get:TT_FRIST_LIFE_CITY
                                     Parameters:nil
                                        Success:^(NSURLSessionDataTask *task, id responseObject) {
        _labelLife.text = [NSString stringWithFormat:@"%@    %@: %@   ",responseObject[@"date"],responseObject[@"city"],responseObject[@"tmp"]];
        _labelRate.text = responseObject[@"rate"];

    } Failure:^(NSError *error) {
        NSLog(@"error %@",error.description);
        [TTProgressHUD showMsg:@"服务器繁忙！请求出错"];
    }];
}

- (void)loadListForPage:(NSInteger)page andIsRefresh:(BOOL)isRefresh {
    [TTProgressHUD show];
    NSDictionary *parameterDic = nil;
    NSString *urlStr = TT_OTHER_News_LIST;
    if (_isFristNews) {
        urlStr = TT_FRIST_NEWS_List;
        parameterDic = @{@"page":@(page)};
    }
    __weak __typeof(self)weakSelf = self;
    [[AFHTTPSessionManager manager] GET:urlStr
                             parameters:parameterDic
                               progress:^(NSProgress * _Nonnull downloadProgress) {}
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    [TTProgressHUD dismiss];
                                    if (isRefresh) {
                                        [_arrayList removeAllObjects];
                                    }
                                    NSDictionary *pageInfoDic = responseObject[@"meta"][@"pagination"];
                                    _pagInfo = [[TTNewListPageInfoModel alloc] initWithDictionary:pageInfoDic];
                                    NSArray *dataArray = responseObject[@"data"];
                                    if (dataArray.count < 1) {
                                        [weakSelf updateMJViewStatusWithIsUpload:isRefresh footHaveMoreData:NO];
                                    } else {
                                        for (NSDictionary *dic in dataArray) {
                                            TTNewListModel *model = [[TTNewListModel alloc] initWithDictionary:dic];
                                            [_arrayList addObject:model];
                                        }
                                        [weakSelf updateMJViewStatusWithIsUpload:isRefresh footHaveMoreData:YES];
                                    }
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [TTProgressHUD dismiss];
                                    [TTProgressHUD showMsg:@"服务器繁忙！请求出错"];
                                    [_tableView.mj_header endRefreshing];
                                    self.tableView.mj_footer.hidden = YES;
                                }];
}

- (void)updateMJViewStatusWithIsUpload:(BOOL)isRefresh footHaveMoreData:(BOOL)haveData{
    if (isRefresh) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden = NO;
    } else {
        if (haveData) {
            [_tableView.mj_footer resetNoMoreData];
        } else
            [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [_tableView reloadData];
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
}

#pragma mark -- UITableView 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_isFristNews) {
        return Screen_Height/4 + 23;
    } else
        return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SinglePictureNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SinglePictureCell"];
    TTNewListModel *listInfo = _arrayList[indexPath.row];
    cell.imageUrl = listInfo.cover_pic;
    cell.contentTittle = listInfo.title;
    NSString *publishedDate = listInfo.published_at;
    if (publishedDate.length > 10) {
        publishedDate = [publishedDate substringWithRange:NSMakeRange(0, 10)];
    }
    cell.dateLabel.text = publishedDate;
    cell.sourceLabel.text = listInfo.source;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTNewListModel *listInfo = _arrayList[indexPath.row];
    TTDetailViewController *detailVC = [[TTDetailViewController alloc] init];
    detailVC.url = listInfo.url;
    detailVC.shareTitle = listInfo.title;
    detailVC.article_id = listInfo.articleInfo.article_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
