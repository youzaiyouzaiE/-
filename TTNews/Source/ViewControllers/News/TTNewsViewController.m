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
#import "SDiOSVersion.h"
#import "TTExposuresNewsViewController.h"
#import "TTNetworkSessionManager.h"


@interface TTNewsViewController()<UIScrollViewDelegate> {
    HMSegmentedControl *_topTitleView;
    NSMutableArray *_titleArray;
    
    UILabel *_messageLable;
    UITapGestureRecognizer *_tap;
}

@property (nonatomic, strong) NSMutableArray *arrayChannels;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray *arraySubControllers;/////所有栏目的子controller
@property (nonatomic, strong) NSMutableArray *arrayAddedControllers;////已经添加过的controller

@end

static NSString * const collectionCellID = @"ChannelCollectionCell";
static NSString * const collectionViewSectionHeaderID = @"ChannelCollectionHeader";

@implementation TTNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"爆料"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(offerNews)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
//    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
    self.title = @"天维新闻";
    _titleArray = [NSMutableArray arrayWithObject:@"头条"];
    _arraySubControllers = [NSMutableArray array];
    _arrayAddedControllers = [NSMutableArray array];
    _arrayChannels = [NSMutableArray array];
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
    [[AFHTTPSessionManager manager] GET:TT_NEWS_CHANNELS
                             parameters:nil
                               progress:^(NSProgress * _Nonnull downloadProgress) {}
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    if (_tap) {
                                        [self.view removeGestureRecognizer:_tap];
                                        [_messageLable removeFromSuperview];
                                    }
                                    [TTProgressHUD dismiss];
                                    for (NSDictionary *dic in responseObject) {
                                        TTChannelModel *channel = [[TTChannelModel alloc] initWithDictionary:dic];
                                        if (channel.id_Channel.integerValue == 1) {//NEWs
                                            for (TTChannelModel *newsSubCh in channel.children) {
                                                [_arrayChannels addObject:newsSubCh];
                                                [_titleArray addObject:newsSubCh.name];
                                            }
                                            break;
                                        }
//                                        [_arrayChannels addObject:channel];
//                                        [_titleArray addObject:channel.name];
                                    }
                                    [self setupTopContianerView];
                                    [self setupContentScrollView];
                                    [self setupChildController];
    }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [TTProgressHUD dismiss];
                                    [TTProgressHUD showMsg:@"服务器请求出错！"];
                                    [self showRefreshNetWorkMessage];
    }];
}

-(void)showRefreshNetWorkMessage {
    if (_tap) {
        [self.view removeGestureRecognizer:_tap];
        [_messageLable removeFromSuperview];
    }
    _messageLable = [[UILabel alloc] init];
    _messageLable.text = @"网络不给力，点击屏幕重试";
    _messageLable.textColor = [UIColor colorWithHexString:@"93939E"];
    _messageLable.font = FONT_Light_PF(16);
    _messageLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_messageLable];
    [_messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(280, 30));
    }];
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadNetWork)];
    [self.view addGestureRecognizer:_tap];
}

- (void)loadNetWork {
    [self newsChannelsRequest];
}

- (void)offerNews {
    
    TTExposuresNewsViewController *exposuresVC = [[TTExposuresNewsViewController alloc] init];
    [self.navigationController pushViewController:exposuresVC animated:YES];
    
//    TTCommentViewController *commentVC = [[TTCommentViewController alloc] init];
//    commentVC.article_id = [NSNumber numberWithInt:13];
//    [self.navigationController pushViewController:commentVC animated:YES];    
}

#pragma mark --private Method--初始化子控制器
- (void)setupChildController {
    for (NSInteger index = 0; index < _titleArray.count; index++) {
        TTNewsContentViewController *vc = [[TTNewsContentViewController alloc] init];
        if (index == 0) {
            vc.isFristNews = YES;
            [_contentScrollView addSubview:vc.view];
            [_arrayAddedControllers addObject:vc];
        } else
            vc.channel = _arrayChannels[index -1];
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(index * Screen_Width, 0, Screen_Width, _contentScrollView.height);
        [_arraySubControllers addObject:vc];
    }
}

- (void)setupTopContianerView {
    CGFloat height = 30.0f;
    CGFloat fontSize = 14.0f;
//    DeviceSize size = [SDiOSVersion deviceSize];
//    if ( size == Screen4Dot7inch) {
//        height = 30.0f;
//        fontSize = 14.0f;
//    } else if (size == Screen4inch) {
//        height = 30.0f;
//        fontSize = 14.0f;
//    } else if (size == Screen5Dot5inch) {
//        height = 35.0f;
//        fontSize = 15.0f;
//    }
    _topTitleView = [[HMSegmentedControl alloc] initWithSectionTitles:_titleArray];
    _topTitleView.selectionStyle = HMSegmentedControlSelectionStyleArrow;
    _topTitleView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    _topTitleView.verticalDividerEnabled = NO;
    _topTitleView.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"],NSFontAttributeName:FONT_Regular_PF(fontSize)};
    _topTitleView.selectedTitleTextAttributes = @{NSForegroundColorAttributeName :[UIColor colorWithHexString:@"E22A1E"],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:fontSize + 4]};
    _topTitleView.selectionIndicatorColor = NORMAL_COLOR;
    _topTitleView.selectionIndicatorHeight = 2.0;
    _topTitleView.borderType = HMSegmentedControlBorderTypeBottom;
    _topTitleView.borderColor = [UIColor colorWithHexString:@"dadadf"];
    [_topTitleView addTarget:self action:@selector(switchSection:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_topTitleView];
    [_topTitleView setFrame:CGRectMake(0, 0, Screen_Width, height)];
}


- (void)switchSection:(HMSegmentedControl *)segment {
    TTNewsContentViewController *vc = _arraySubControllers[segment.selectedSegmentIndex];
    if (![_arrayAddedControllers containsObject:vc]) {
        [_contentScrollView addSubview:vc.view];
        [_arrayAddedControllers addObject:vc];
    }
    [self.contentScrollView setContentOffset:CGPointMake(_contentScrollView.width * segment.selectedSegmentIndex, 0) animated:YES];
}

#pragma mark --private Method--初始化相信新闻内容的scrollView
- (void)setupContentScrollView {
    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.frame = CGRectMake(0, _topTitleView.height, self.view.width, self.view.height - _topTitleView.height);
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width * _titleArray.count, 0);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate = self;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentScrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _contentScrollView) {
        NSInteger index = scrollView.contentOffset.x/_contentScrollView.frame.size.width;
        TTNewsContentViewController *vc = _arraySubControllers[index];
        if (![_arrayAddedControllers containsObject:vc]) {
            [_contentScrollView addSubview:vc.view];
            [_arrayAddedControllers addObject:vc];
        }
        [_topTitleView setSelectedSegmentIndex:index animated:YES];
    }
}

@end

