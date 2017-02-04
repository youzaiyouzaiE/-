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
#import "SDiOSVersion.h"
#import "TTLoginViewController.h"
#import "TTCommentViewController.h"
#import "TTRequestManager.h"
#import "TTAppData.h"
#import "M13ProgressViewBar.h"
#import "TalkingData.h"
#import "TTCommentInputView.h"
#import "TTNetworkSessionManager.h"
#import "TTBottomBarView.h"

typedef NS_ENUM(NSUInteger, TTShareScene) {
    TTShareSceneWeChat_Scene,  
    TTShareSceneWeChat_TimeScene,
    TTShareSceneQQ_Scene,
    TTShareSceneQQ_Zone,
};


@interface TTDetailViewController () <WKNavigationDelegate,JHShareSheetViewDelegate,UIGestureRecognizerDelegate,TTCommentInputViewDelegate,TTBottomBarViewDelegate> {
    
    JHShareSheetView *_sheetView;
    NSInteger _selectedIndex;
    M13ProgressView *_progressView;
    TTBottomBarView *_bottomView;
    /////写评论
    TTCommentInputView *_commentView;
    NSInteger _totalComments;
}


@property (nonatomic, strong) UIButton *ButtonShare;
@property (nonatomic, strong) WKWebView *webView;


@end

@implementation TTDetailViewController

- (void)dealloc {
    if ([self isViewLoaded]) {
        [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    [self.webView setNavigationDelegate:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshCurrentArticleDetailModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fontSelectImage"]
//                                                              style:UIBarButtonItemStylePlain
//                                                             target:self
//                                                             action:@selector(selectFontSizeAction)];
//    self.navigationItem.rightBarButtonItem = item;
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x343434, 0xfafafa);
    [self setupView];
    [self setupProgressView];
    if (_article_id && (_article_id.integerValue > 0)) {
        _totalComments = [_detailModel.comment_num integerValue];
        [self setupBottomView];
    } else {
        [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
    }
    [self checkTheArticleIsStored];
}

- (void)setupProgressView {
    _progressView = [[M13ProgressViewBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width + 50, 5)];
    _progressView.primaryColor = COLOR_NORMAL;
    _progressView.secondaryColor = [UIColor lightGrayColor];
    [self.view addSubview:_progressView];
    [self.view bringSubviewToFront:_progressView];
}

- (void)setupView {
    _webView = [[WKWebView alloc] init];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-44);
    }];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_detailModel.url]]];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        NSLog(@"%f", self.webView.estimatedProgress);
        [_progressView setAlpha:1.0f];
        [_progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [_progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [_progressView setProgress:0.0f animated:NO];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setupBottomView {
    _bottomView = [[TTBottomBarView alloc] init];
    _bottomView.delegate = self;
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([TTBottomBarView height]);
    }];
}

#pragma mark - NetWork
- (void)refreshCurrentArticleDetailModel {
    [[TTNetworkSessionManager shareManager] Get:TT_ARTICLE_DETAIL_URL(_article_id)
                                     Parameters:nil
                                        Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                            NSDictionary *infoDic = responseObject[@"data"];
                                            TTNewListModel *refreshModel = [[TTNewListModel alloc] initWithDictionary:infoDic];
                                            _detailModel = refreshModel;
                                            [_bottomView setCommentNumber:[refreshModel.comment_num stringValue]];
                                        }
                                        Failure:^(NSError *error) {
                                        }];
}

- (void)checkTheArticleIsStored {
    if (!SHARE_APP.isLogin) {
        return ;
    }
    [[TTNetworkSessionManager shareManager] Get:TT_STORE_ATRICLE_URL([TTAppData shareInstance].currentUser.memberId,_article_id)
                                     Parameters:nil
                                        Success:^(NSURLSessionDataTask *task, NSArray *responseObject) {
                                            BOOL isChecked = [[responseObject firstObject] boolValue];
                                            _bottomView.isStored = isChecked;
                                        }
                                        Failure:^(NSError *error) {
                                        }];
}

- (void)storeTheArticle:(BOOL)store {
    NSInteger storeType = 0;
    if (store) {
        storeType = 1;
    }
    NSDictionary *parameterDic = @{@"article_id":_article_id,@"user_id":[TTAppData shareInstance].currentUser.memberId,@"action":@(storeType)};
    [[AFHTTPSessionManager manager] POST:TT_STORE_FAVORITES_URL
                              parameters:parameterDic
                                progress:^(NSProgress * _Nonnull uploadProgress) {
                                    
                                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
                                    if (store) {
                                        [TTProgressHUD showMsg:@"收藏成功！"];
                                    } else
                                        [TTProgressHUD showMsg:@"已取消收藏！"];
                                    _bottomView.isStored = store;
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     [TTProgressHUD dismiss];
                                     [TTProgressHUD showMsg:@"服务器请求出错，请稍后重试！"];
                                     _bottomView.isStored = NO;
                                 }];
}

#pragma mark - longin View
- (void)presentLoginView {
    TTLoginViewController *loginVC = [[TTLoginViewController alloc] init];
    loginVC.isPresentInto = YES;
    loginVC.loginBlock = ^(NSNumber *uid, NSString *token) {
        
    };
    UINavigationController *navitagtionVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navitagtionVC animated:YES completion:^{
        [_commentView dismessCommentView];
    }];
}

#pragma mark - Action perform
- (void)selectFontSizeAction {
    
}

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

#pragma mark – TTBottomBarViewDelegate
- (void)writeButtonClicked:(TTBottomBarView *)bottomView {
    if (!_commentView) {
        _commentView = [TTCommentInputView commentView];
        _commentView.delegate = self;
    }
    _commentView.article_id = _article_id;
    [_commentView showCommentView];
}

- (void)checkCommentsButtonClicked:(TTBottomBarView *)bottomView {
    if (_totalComments < 1) {
        [TTProgressHUD showMsg:@"没有更多评论"];
        return ;
    }
    TTCommentViewController *commentVC = [[TTCommentViewController alloc] init];
    commentVC.article_id = _article_id;
    commentVC.totalComments = _detailModel.comment_num;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)storeButtonClicked:(TTBottomBarView *)bottomView isStore:(BOOL)isStore {
    if (!SHARE_APP.isLogin) {
        [TTProgressHUD showMsg:@"登录后才能收藏文章"];
        bottomView.isStored = NO;
        return ;
    }
    [self storeTheArticle:isStore];
}

- (void)shareButtonClicked:(TTBottomBarView *)bottomView {
    [self shareNews];
}

#pragma mark - TTCommentInputViewDelegate
-(void)commentViewCheckNotLongin:(TTCommentInputView *)commentView; {
    [self presentLoginView];
}

- (void)commentViewSendCommentSuccess:(TTCommentInputView *)commentView {
    _totalComments += 1;
    [_bottomView setCommentNumber:FORMAT(@"%@",@(_totalComments))];
}

#pragma mark - JHShareSheetViewDelegate
- (void)sheetViewdidSelectItemAtIndex:(NSInteger)index {
    if (index == TTShareSceneWeChat_Scene) {
        if ([self checkAppActionInsall:index]) {
            [self sendLinkContentWihtScene:WXSceneSession];
            [TalkingData trackEvent:@"WeChat_share_SceneSession"];
        }
    } else if (index == TTShareSceneWeChat_TimeScene) {
        if ([self checkAppActionInsall:index]) {
            [self sendLinkContentWihtScene:WXSceneTimeline];
            [TalkingData trackEvent:@"WeChat_share_Timeline"];
        }
    }
}

- (BOOL)checkAppActionInsall:(NSInteger) index {
    if (index == TTShareSceneWeChat_Scene || index == TTShareSceneWeChat_TimeScene) {
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
            return YES;
        } else {
            [self showMindAlertView:@"未找到微信应用，请先安装微信"];
            return NO;
        }
    }
    return NO;
}

- (void)showMindAlertView:(NSString *)meg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:meg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];    //弹出alreat 跳到安装面 - 》微信
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WXApiDelegate
-(void) sendLinkContentWihtScene:(int)scene{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _detailModel.title;
    [message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = _detailModel.url;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}
@end
