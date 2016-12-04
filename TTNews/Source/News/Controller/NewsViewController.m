//
//  NewsViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "NewsViewController.h"
#import <SVProgressHUD.h>
#import <SDImageCache.h>
#import "TTNewsContentViewController.h"
#import "TTTopChannelContianerView.h"
#import "ChannelsSectionHeaderView.h"
#import "TTNormalNews.h"
#import <DKNightVersion.h>
#import "TTNetworkSessionManager.h"
#import "TTChannelModel.h"
//#import <AFNetworking/AFNetworking.h>
#import "AFNetworking.h"

@interface NewsViewController()<UIScrollViewDelegate,TTTopChannelContianerViewDelegate> {
    TTTopChannelContianerView *_titleView;
    NSMutableArray *_titleArray;
}

@property (nonatomic, strong) NSMutableArray *arrayChannels;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

static NSString * const collectionCellID = @"ChannelCollectionCell";
static NSString * const collectionViewSectionHeaderID = @"ChannelCollectionHeader";

@implementation NewsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
    _arrayChannels = [NSMutableArray array];
//    _titleArray = [NSMutableArray arrayWithObject:@"头条"];
    _titleArray = [NSMutableArray array];
//    [self setupCollectionView];
    [self newsChannelsRequest];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)newsChannelsRequest {
    [TTProgressHUD show];
    [[AFHTTPSessionManager manager] GET:TT_NEWS_CHANNELS
                             parameters:nil
                               progress:^(NSProgress * _Nonnull downloadProgress) {}
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    [TTProgressHUD dismiss];
                                    for (NSDictionary *dic in responseObject) {
                                        TTChannelModel *channel = [[TTChannelModel alloc] initWithDictionary:dic];
                                        [_arrayChannels addObject:channel];
                                        [_titleArray addObject:channel.name];
                                    }
                                    [self setupTopContianerView];
                                    [self setupContentScrollView];
                                    [self setupChildController];
    }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [TTProgressHUD dismiss];
                                    [TTProgressHUD showMsg:@"服务器繁忙！请求出错"];
    }];
}

#pragma mark --private Method--初始化子控制器
-(void)setupChildController {
    NSInteger index = 0;
    for (TTChannelModel *channel in _titleArray) {
        TTNewsContentViewController *vc = [[TTNewsContentViewController alloc] init];
        vc.channel = channel;
        if (index == 0) {
            vc.hasCycleImage = YES;
        }
        [self addChildViewController:vc];
        [_contentScrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(index * Screen_Width, 0, Screen_Width, _contentScrollView.height);
        index ++;
    }
}

- (void)setupTopContianerView{
    _titleView = [[TTTopChannelContianerView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 30)];
    _titleView.channelNameArray = _titleArray;
    _titleView.delegate = self;
    [self.view addSubview:_titleView];
}

#pragma mark --private Method--初始化相信新闻内容的scrollView
- (void)setupContentScrollView {
    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.frame = CGRectMake(0, _titleView.height, self.view.width, self.view.height - _titleView.height);
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width * _titleArray.count, 0);
    _contentScrollView.pagingEnabled = YES;
//    _contentScrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_contentScrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        [_titleView selectChannelButtonWithIndex:index];
    }
}

#pragma mark --UICollectionViewDataSource-- 返回每个UICollectionViewCell发Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat kDeviceWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kMargin = 10;
    return CGSizeMake((kDeviceWidth - 5*kMargin)/4, 40);
}

#pragma mark --TTTopChannelContianerViewDelegate
- (void)topChannelView:(TTTopChannelContianerView *)chnnelView addActionWithButton:(UIButton *)button {
    
}

- (void)topChannelView:(TTTopChannelContianerView *)chnnelView chooseChannelWithIndex:(NSInteger)index {
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.frame.size.width * index, 0) animated:YES];
}


@end

