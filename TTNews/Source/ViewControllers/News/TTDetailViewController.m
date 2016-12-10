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
#import "LXActivity.h"

@interface TTDetailViewController () <WKNavigationDelegate,LXActivityDelegate>


@property (nonatomic, strong) UIButton *ButtonShare;
@property (nonatomic, strong) WKWebView *webView;


@end

@implementation TTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(shareNews)];
    self.navigationItem.rightBarButtonItem = item;
    
    if([TTJudgeNetworking judge] == NO) {
        [SVProgressHUD showErrorWithStatus:@"无网络连接"];
//        [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark --private Method--收藏这条新闻
-(void)shareNews {
    NSArray *shareButtonTitleArray = @[@"微信",@"微信朋友圈",@"QQ",@"QQ空间"];//@[@"腾讯微博",@"微信",@"微信朋友圈",@"QQ",@"QQ空间",@"新浪微博",@"腾讯微博"];
    NSArray *shareButtonImageNameArray =@[@"sns_icon_22",@"sns_icon_23",@"sns_icon_24",@"sns_icon_6"];
    //    @[@"sns_icon_2",@"sns_icon_22",@"sns_icon_23",@"sns_icon_24",@"sns_icon_6",@"sns_icon_1",@"sns_icon_2"];
    
    LXActivity *lxActivity = [[LXActivity alloc] initWithTitle:@"分享到社交平台" delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:self.view];
}

#pragma mark - LXActivityDelegate

- (void)didClickOnImageIndex:(NSInteger )imageIndex {
    
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
