//
//  NewsViewController.m
//  TTNews
//
//  Created by jiaHui on 16/3/24.
//  Copyright © 2016年 Home. All rights reserved.
//

#import "TTNewsViewController.h"
#import "TTNewsContentViewController.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "TTChannelModel.h"
#import "AFNetworking.h"

@interface TTNewsViewController()<UIScrollViewDelegate> {
    HMSegmentedControl *_topTitleView;
    NSMutableArray *_titleArray;
}

@property (nonatomic, strong) NSMutableArray *arrayChannels;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

static NSString * const collectionCellID = @"ChannelCollectionCell";
static NSString * const collectionViewSectionHeaderID = @"ChannelCollectionHeader";

@implementation TTNewsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
    _titleArray = [NSMutableArray arrayWithObject:@"头条"];
    [self newsChannelsRequest];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
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

- (void)setupTopContianerView {
    _topTitleView = [[HMSegmentedControl alloc] initWithSectionTitles:_titleArray];
    _topTitleView.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _topTitleView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _topTitleView.verticalDividerEnabled = NO;
    _topTitleView.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15]};
    _topTitleView.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"fa5054"]};
    _topTitleView.selectionIndicatorColor = [UIColor colorWithHexString:@"fa5054"];
    _topTitleView.selectionIndicatorHeight = 2.0;
    _topTitleView.borderType = HMSegmentedControlBorderTypeBottom;
    _topTitleView.borderColor = [UIColor colorWithHexString:@"dadadf"];
    [_topTitleView addTarget:self action:@selector(switchSection:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_topTitleView];
    [_topTitleView setFrame:CGRectMake(0, 0, Screen_Width, 30)];
}

- (void)switchSection:(HMSegmentedControl *)segment {
    [self.contentScrollView setContentOffset:CGPointMake(_contentScrollView.width * segment.selectedSegmentIndex, 0) animated:YES];
}

#pragma mark --private Method--初始化相信新闻内容的scrollView
- (void)setupContentScrollView {
    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.frame = CGRectMake(0, _topTitleView.height, self.view.width, self.view.height - _topTitleView.height);
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width * _titleArray.count, 0);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate = self;
    [self.view addSubview:_contentScrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _contentScrollView) {
        NSInteger index = scrollView.contentOffset.x/_contentScrollView.frame.size.width;
        [_topTitleView setSelectedSegmentIndex:index animated:YES];
    }
}

@end

