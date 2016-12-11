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

#import "JHShareSheetView.h"

@interface TTDetailViewController () <WKNavigationDelegate,JHShareSheetViewDelegate> {
    JHShareSheetView *_sheetView;
}


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

#pragma mark - WKNavigationDelegate 
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
     [SVProgressHUD dismiss];
}

#pragma mark - Action perform
-(void)shareNews {
    NSArray *titleArray = @[@"微信",@"微信朋友圈",@"QQ好友",@"QQ空间"];//@[@"腾讯微博",@"微信",@"微信朋友圈",@"QQ",@"QQ空间",@"新浪微博",@"腾讯微博"];
    NSArray *imageNameArray =@[@"sns_icon_22",@"sns_icon_23",@"sns_icon_24",@"sns_icon_6"];
    //    @[@"sns_icon_2",@"sns_icon_22",@"sns_icon_23",@"sns_icon_24",@"sns_icon_6",@"sns_icon_1",@"sns_icon_2"];
    if (!_sheetView) {
        _sheetView = [JHShareSheetView sheetViewGreatWithTitles:titleArray shareImagesName:imageNameArray delegate:self];
    }
    [_sheetView show];
}

#pragma mark - JHShareSheetViewDelegate
- (void)sheetViewdidSelectItemAtIndex:(NSInteger)index {
    
}




@end
