//
//  DetailViewController.m
//  TTNews
//
//  Created by jiahui on 16/3/29.
//  Copyright © 2016年 Home. All rights reserved.
//

#import "TTDetailViewController.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>
#import "TTJudgeNetworking.h"
#import <DKNightVersion.h>
#import <WebKit/WebKit.h>
#import "JHShareSheetView.h"
#import "WXApi.h"

#import "TTLoginViewController.h"

//#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"

#define WECHAT_SCENE            0
#define WECHATTIME_SCENT        1
#define QQ_SCENE                2
#define QQZONE_SCENE            3
#define WEIBO_SCENE             4
#define TENCENTWEIBO_SCENE      5

@interface TTDetailViewController () <WKNavigationDelegate,JHShareSheetViewDelegate> {
    
    JHShareSheetView *_sheetView;
    NSInteger _selectedIndex;
}


@property (nonatomic, strong) UIButton *ButtonShare;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;


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
    }
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x343434, 0xfafafa);
    self.view.backgroundColor = [UIColor yellowColor];
    [self setupWebView];
    
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
    
    [self.bridge registerHandler:@"presentLoginView" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self presentLoginView];
    }];
    

    
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
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:<#(NSURLRequestCachePolicy)#> timeoutInterval:<#(NSTimeInterval)#>];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
    
    
    /////test
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [_webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        NSLog(@"%f", self.webView.estimatedProgress);
        // estimatedProgress is a value from 0.0 to 1.0
        // Update your UI here accordingly
//        [self.progressView setAlpha:1.0f];
//        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
        
//        if(self.webView.estimatedProgress >= 1.0f) {
//            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                [self.progressView setAlpha:0.0f];
//            } completion:^(BOOL finished) {
//                [self.progressView setProgress:0.0f animated:NO];
//            }];
//        }
    }
    else {
        // Make sure to call the superclass's implementation in the else block in case it is also implementing KVO
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    if ([self isViewLoaded]) {
        [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    
    // if you have set either WKWebView delegate also set these to nil here
    [self.webView setNavigationDelegate:nil];
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

#pragma mark - longin View
- (void)presentLoginView {
    TTLoginViewController *loginVC = [[TTLoginViewController alloc] init];
    loginVC.isPresentInto = YES;
    loginVC.loginBlock = ^(NSNumber *uid, NSString *token) {
        
    };
    UINavigationController *navitagtionVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navitagtionVC animated:YES completion:^{
        
    }];
}

#pragma mark - Action perform
-(void)shareNews {
        [_bridge callHandler:@"getUserLoginInfo" data:@{ @"uid":@"123456789",@"uname":@"youzaiyouzai",@"seckey":@"k_MD5_encode"}];
//    NSArray *titleArray = @[@"微信",@"微信朋友圈",@"QQ好友",@"QQ空间"];//@[@"腾讯微博",@"微信",@"微信朋友圈",@"QQ",@"QQ空间",@"新浪微博",@"腾讯微博"];
//    NSArray *imageNameArray =@[@"sns_icon_22",@"sns_icon_23",@"sns_icon_24",@"sns_icon_6"];
//    //    @[@"sns_icon_2",@"sns_icon_22",@"sns_icon_23",@"sns_icon_24",@"sns_icon_6",@"sns_icon_1",@"sns_icon_2"];
//    if (!_sheetView) {
//        _sheetView = [JHShareSheetView sheetViewGreatWithTitles:titleArray shareImagesName:imageNameArray delegate:self];
//    }
//    [_sheetView show];
}

#pragma mark - JHShareSheetViewDelegate
- (void)sheetViewdidSelectItemAtIndex:(NSInteger)index {
    if (index == WECHAT_SCENE) {
//        if ([self checkAppActionInsall:index]) {
            [self sendLinkContentWihtScene:WXSceneSession];
//        }
    } else if (index == WECHATTIME_SCENT) {
//        if ([self checkAppActionInsall:index]) {
            [self sendLinkContentWihtScene:WXSceneTimeline];
//        }
    }
}

- (BOOL)checkAppActionInsall:(NSInteger) index {
    if (index == WECHAT_SCENE || index == WECHATTIME_SCENT) {
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
            return YES;
        }
        else {
            [self showMindAlertView];
            return NO;
        }
    }
//    [self showMindAlertView];
    return NO;
}

- (void)showMindAlertView {
    UIAlertView *installAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未找到微信应用，请先安装微信" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [installAlert show];
    //弹出alreat 跳到安装面 - 》微信
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
}

#pragma mark - WXApiDelegate
-(void) sendLinkContentWihtScene:(int)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _shareTitle;
//    message.description = MESSAGECONTENT;
    [message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = _url;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}
@end
