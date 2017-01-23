//
//  AppDelegate.m
//  TTNews
//
//  Created by jiahui on 2016/12/8.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "AppDelegate.h"
#import "TTTabBarController.h"
#import "TTNavigationController.h"
#import "TTConst.h"
#import "TTNetworkSessionManager.h"
#import "WXApi.h"
#import "TTAppData.h"
#import <PgySDK/PgyManager.h>
//#import <PgyUpdate/PgyUpdateManager.h>
#import "TalkingData.h"
#import "TalkingDataSMS.h"
#import <CoreLocation/CoreLocation.h>
#import "TTADPresentView.h"

#define PGY_APP_ID   @"bc2f3e0f520c5299b0bdb3399e27bd4e"

@interface AppDelegate ()<WXApiDelegate,CLLocationManagerDelegate> {
    
    CLLocationManager *_locationManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [TTAppData shareInstance];
    self.tableBarContrller = [TTTabBarController shareInstance];
    self.window.rootViewController = self.tableBarContrller;
    
    [self.window makeKeyAndVisible];
    [self initializeNetRequest];
    [self setupUserDefaults];
    [WXApi registerApp:@"wxc565f6c6475eef2b"];
    [self installTalkingData];
    [TTADPresentView showADImageView];
    [self requestADImage];
    
    return YES;
}

- (void)installTalkingData {
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData sessionStarted:@"7ED8D36E60D84EF5992DBB62CF9BA4D0" withChannelId:@"AppStore"];
    [TalkingDataSMS init:@"7ED8D36E60D84EF5992DBB62CF9BA4D0" withSecretId:@""];
}

- (void)setupUserDefaults {
    NSNumber *longinType = [[NSUserDefaults standardUserDefaults] objectForKey:k_UserLoginType];
    if (longinType.boolValue) {
        NSDictionary *userInfoDic =  [[NSUserDefaults standardUserDefaults] dictionaryForKey:k_UserInfoDic];
        TTUserInfoModel *userInfo = [[TTUserInfoModel alloc] initWithDictionary:userInfoDic];
        [TTAppData shareInstance].currentUser = userInfo;
        self.isLogin = YES;
    } else
        self.isLogin = NO;
}

#pragma mark - netWork request
- (void)initializeNetRequest {

    [[TTNetworkSessionManager shareManager] Get:INITIALIZE_URL
                                     Parameters:nil
                                        Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                            NSNumber *signalNum = responseObject[@"signal"];
                                            if (signalNum.integerValue == 1) {
                                                _guid = responseObject[@"data"][@"GUID"];
                                                
                                            }
                                        } Failure:^(NSError *error) {
                                            
                                        }];
}

- (void)requestADImage {
    [[TTNetworkSessionManager shareManager] Get:TT_APP_AD_IMAGE
                                     Parameters:nil
                                        Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                            NSArray *imageUrls = responseObject[@"data"];
                                            NSDictionary *imageURLDic = [imageUrls firstObject];
                                            NSString *URLStr = imageURLDic[@"path"];
//                                            NSString *URLStr =  @"http:/img.cmstest.skykiwichina.com/upload/image";
//                                            NSString *URLStr = @"";
                                            [self downloadAndSaveAdImageWithImageURL:URLStr];
                                        } Failure:^(NSError *error) {
                                            
                                        }];
}

- (void)downloadAndSaveAdImageWithImageURL:(NSString *)URLStr  {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *imageName = nil;
        if (![URLStr isEqualToString:@""] && URLStr.length > 1) {
              imageName = [URLStr lastPathComponent];
        }
        if (![TTAppData getADImageFilePath:imageName]) {
            if (imageName) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLStr]];
                UIImage *image = [UIImage imageWithData:data];
                NSString *documentPath = [TTAppData getADDocumentPath];
                NSString *imagePath = [documentPath stringByAppendingPathComponent:imageName];
                if ([UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES]) {// 保存成功
                    NSLog(@"保存成功");
                    // 如果有广告链接，将广告链接也保存下来
                }else{
                    NSLog(@"保存失败");
                }
            }
        }
    });
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url  {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 微信分享delegate WXApiDelegate
- (void)onReq:(BaseReq*)req
{
    
}

-(void) onResp:(BaseResp*)resp
{
    
}
@end
