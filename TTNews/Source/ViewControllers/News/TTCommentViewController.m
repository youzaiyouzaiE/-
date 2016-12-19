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


@interface TTCommentViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSInteger _currentPage;
    
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TTCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentPage = 0;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MJ
- (void)loadMoreData {
    _currentPage ++;
//    [self loadListForPage:_currentPage andIsRefresh:NO];
}

- (void)loadLifeInfoDataWithDic:(NSDictionary *)dic {
//    [[TTNetworkSessionManager shareManager] Get:TT_FRIST_LIFE_CITY
//                                     Parameters:nil
//                                        Success:^(NSURLSessionDataTask *task, id responseObject) {
//                                            _labelLife.text = [NSString stringWithFormat:@"%@    %@: %@   ",responseObject[@"date"],responseObject[@"city"],responseObject[@"tmp"]];
//                                            _labelRate.text = responseObject[@"rate"];
//                                            
//                                        } Failure:^(NSError *error) {
//                                            NSLog(@"error %@",error.description);
//                                            [TTProgressHUD showMsg:@"服务器繁忙！请求出错"];
//                                        }];
    
    [[AFHTTPSessionManager manager] GET:TT_COMMENT_LIST
                             parameters:dic
                               progress:^(NSProgress * _Nonnull downloadProgress) {}
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    [TTProgressHUD dismiss];
//                                    if (isRefresh) {
//                                        [_arrayList removeAllObjects];
//                                    }
//                                    NSDictionary *pageInfoDic = responseObject[@"meta"][@"pagination"];
//                                    _pagInfo = [[TTNewListPageInfoModel alloc] initWithDictionary:pageInfoDic];
//                                    NSArray *dataArray = responseObject[@"data"];
//                                    if (dataArray.count < 1) {
//                                        [weakSelf updateMJViewStatusWithIsUpload:isRefresh footHaveMoreData:NO];
//                                    } else {
//                                        for (NSDictionary *dic in dataArray) {
//                                            TTNewListModel *model = [[TTNewListModel alloc] initWithDictionary:dic];
//                                            [_arrayList addObject:model];
//                                        }
//                                        [weakSelf updateMJViewStatusWithIsUpload:isRefresh footHaveMoreData:YES];
//                                    }
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [TTProgressHUD dismiss];
                                    [TTProgressHUD showMsg:@"服务器繁忙！请求出错"];
                                    [_tableView.mj_header endRefreshing];
                                    self.tableView.mj_footer.hidden = YES;
                                }];

}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifierString = @"commentCell";
    TTCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
    if (!cell) {
        cell = [[TTCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
    }
    
    
    return cell;
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
