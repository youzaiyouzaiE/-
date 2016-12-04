//
//  NewsViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "NewsViewController.h"
#import "TTNewsContentViewController.h"
#import "TTTopChannelContianerView.h"
#import "TTChannelModel.h"
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
    _titleArray = [NSMutableArray arrayWithObject:@"头条"];
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
- (void)setupChildController {
    for (NSInteger index = 0; index < _titleArray.count; index++) {
        TTNewsContentViewController *vc = [[TTNewsContentViewController alloc] init];
        if (index == 0) {
            vc.isFristNews = YES;
        } else
            vc.channel = _arrayChannels[index -1];
        
        [self addChildViewController:vc];
        [_contentScrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(index * Screen_Width, 0, Screen_Width, _contentScrollView.height);
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
    _contentScrollView.delegate = self;
    [self.view addSubview:_contentScrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _contentScrollView) {
        NSInteger index = scrollView.contentOffset.x/_contentScrollView.frame.size.width;
        [_titleView selectChannelButtonWithIndex:index];
    }
}

#pragma mark --TTTopChannelContianerViewDelegate
- (void)topChannelView:(TTTopChannelContianerView *)chnnelView addActionWithButton:(UIButton *)button {
    
}

- (void)topChannelView:(TTTopChannelContianerView *)chnnelView chooseChannelWithIndex:(NSInteger)index {
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.frame.size.width * index, 0) animated:YES];
}


@end

