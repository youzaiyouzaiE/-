//
//  DetailViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/29.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTDetailViewController.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>
#import "TTJudgeNetworking.h"
#import <DKNightVersion.h>
#import <WebKit/WebKit.h>

@interface TTDetailViewController () <WKNavigationDelegate>


@property (nonatomic, strong) UIButton *ButtonShare;
@property (nonatomic, strong) WKWebView *webView;


@end

@implementation TTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([TTJudgeNetworking judge] == NO) {
        [SVProgressHUD showErrorWithStatus:@"无网络连接"];
//        [self.navigationControlle r popViewControllerAnimated:YES];
    }
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x343434, 0xfafafa);
    
    self.view.backgroundColor = [UIColor yellowColor];
    [self setupWebView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setupWebView {
    _webView = [[WKWebView alloc] init];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
//    _webView.frame = self.view.bounds;
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

-(void)setupNaigationBar {
    _ButtonShare = [UIButton buttonWithType:UIButtonTypeCustom];
    _ButtonShare.frame =CGRectMake(0, 0, 30, 30);
//    [_ButtonShare setImage:[UIImage imageNamed:@"navigationBarItem_favorite_normal"] forState:UIControlStateNormal];
    [_ButtonShare setTitle:@"分享" forState:UIControlStateNormal];
    [_ButtonShare addTarget:self action:@selector(shareNews) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_ButtonShare];
}

#pragma mark --private Method--收藏这条新闻
-(void)shareNews {
    
}
//#pragma mark --private Method--初始化toolBar
//- (void)setupToolBars{
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolbar_back_icon"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
//    backItem.enabled = NO;
//    self.backItem = backItem;
//    
//    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolbar_forward_icon"] imageWithRenderingMode:UIImageRenderingModeAutomatic]  style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
//    forwardItem.enabled = NO;
//    self.forwardItem = forwardItem;
//    
//    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
//    self.refreshItem = refreshItem;
//    
//    self.toolbarItems = @[backItem,forwardItem,flexibleItem,refreshItem];
//    backItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
//    forwardItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
//    refreshItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
//    self.navigationController.toolbar.dk_tintColorPicker =  DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
//}



@end
