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


#define WECHAT_SCENE            0
#define WECHATTIME_SCENT        1
#define QQ_SCENE                2
#define QQZONE_SCENE            3
#define WEIBO_SCENE             4
#define TENCENTWEIBO_SCENE      5

@interface TTDetailViewController () <WKNavigationDelegate,JHShareSheetViewDelegate,UIGestureRecognizerDelegate> {
    
    JHShareSheetView *_sheetView;
    NSInteger _selectedIndex;
    
    UIView *_bottomView;
    
    /////写评论
    UIView *_coverView;
    UIView *_writerView;
    UITextView *_textView;
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
    }
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x343434, 0xfafafa);
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self setupView];
    [self setupBottomView];
    [self createWriteCommentsView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setupView {
    _webView = [[WKWebView alloc] init];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-44);
    }];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
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

#define itemButt_W         40

- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [writeButton addTarget:self action:@selector(writeComment:) forControlEvents:UIControlEventTouchUpInside];
    [writeButton setTitle:@"发表评论" forState:UIControlStateNormal];
    [writeButton setTitleColor:[UIColor colorWithHexString:@"E5E5E5"] forState:UIControlStateNormal];
    writeButton.backgroundColor = [UIColor whiteColor];
    writeButton.layer.masksToBounds = YES;
    writeButton.layer.borderColor = [UIColor colorWithHexString:@"E5E5E5"].CGColor;
    writeButton.layer.cornerRadius = 3;
    writeButton.layer.borderWidth = 0.5;
    [bottomView addSubview:writeButton];
    [writeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(Screen_Width*2/3 - 15);
    }];
    
    CGFloat buttonMarger =  (Screen_Width/3 - (itemButt_W * 2))/3;
    
    UIButton *checkCommentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    checkCommentsBtn.backgroundColor = [UIColor yellowColor];
    [checkCommentsBtn setTitle:@"评论" forState:UIControlStateNormal];
    [checkCommentsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkCommentsBtn addTarget:self action:@selector(checkComments:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:checkCommentsBtn];
    [checkCommentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(writeButton.mas_right).offset(buttonMarger);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.height.mas_equalTo(itemButt_W);
        make.width.mas_equalTo(itemButt_W);
    }];
    
    UIButton *storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    storeBtn.backgroundColor = [UIColor redColor];
    [storeBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [storeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [storeBtn addTarget:self action:@selector(storeAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:storeBtn];
    [storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomView.mas_right).offset(-buttonMarger);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.height.mas_equalTo(itemButt_W);
        make.width.mas_equalTo(itemButt_W);
    }];
}

#define  TEXTVIEW_H     90
- (void)createWriteCommentsView {
    
//    CGFloat textViewH = 90;
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _coverView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    tapGesture.delegate = self;
    [_coverView addGestureRecognizer:tapGesture];
    
    _writerView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, TEXTVIEW_H + 60 + 10)];
    _writerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    _writerView.alpha = 1;
    [_coverView addSubview:_writerView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_writerView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (10);
        make.left.mas_equalTo (15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    UILabel *writerLabel = [[UILabel alloc] init];
    writerLabel.textAlignment = NSTextAlignmentCenter;
    writerLabel.font = [UIFont systemFontOfSize:18];
    writerLabel.text = @"写跟帖";
    [_writerView addSubview:writerLabel];
    [writerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (10);
        make.centerX.mas_equalTo (_writerView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [_writerView addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (10);
        make.right.mas_equalTo (-15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    _textView.font = [UIFont systemFontOfSize:16];
     [_writerView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(_writerView.mas_bottom).offset(-15);
    }];
}

- (void)showWriteView {
    _coverView.hidden = NO;
     [_textView becomeFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        _writerView.frame = CGRectMake(0, Screen_Height - TEXTVIEW_H - 60 - 10 - 250 , Screen_Width, TEXTVIEW_H + 60 + 10);
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissWriterView {
    [_textView resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        _writerView.frame = CGRectMake(0, Screen_Height, Screen_Width, TEXTVIEW_H + 60 + 10);
    } completion:^(BOOL finished) {
        _coverView.hidden = YES;
    }];
}

- (void)dealloc {
    if ([self isViewLoaded]) {
        [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    [self.webView setNavigationDelegate:nil];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:_writerView];
    if (point.y > 0) {
        return NO;
    } else
        return YES;
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
//        [_bridge callHandler:@"getUserLoginInfo" data:@{ @"uid":@"123456789",@"uname":@"youzaiyouzai",@"seckey":@"k_MD5_encode"}];
    NSArray *titleArray = @[@"微信",@"微信朋友圈",@"QQ好友",@"QQ空间"];//@[@"腾讯微博",@"微信",@"微信朋友圈",@"QQ",@"QQ空间",@"新浪微博",@"腾讯微博"];
    NSArray *imageNameArray =@[@"sns_icon_22",@"sns_icon_23",@"sns_icon_24",@"sns_icon_6"];
    //    @[@"sns_icon_2",@"sns_icon_22",@"sns_icon_23",@"sns_icon_24",@"sns_icon_6",@"sns_icon_1",@"sns_icon_2"];
    if (!_sheetView) {
        _sheetView = [JHShareSheetView sheetViewGreatWithTitles:titleArray shareImagesName:imageNameArray delegate:self];
    }
    [_sheetView show];
}

- (void)writeComment:(UIButton *)sender {
    [self showWriteView];
}

- (void)checkComments:(UIButton *)sender {
    
}

- (void)storeAction:(UIButton *)sender {
    
}

- (void)tapGestureAction {
    [self dismissWriterView];
}

- (void)cancelAction:(UIButton *)button {
    [self dismissWriterView];
}

- (void)sendAction:(UIButton *)button {
    
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
