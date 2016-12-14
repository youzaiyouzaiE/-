//
//  AppDelegate.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "AppDelegate.h"
#import "TTTabBarController.h"
#import "TTNavigationController.h"
#import "TTConst.h"
#import "TTNetworkSessionManager.h"
#import "WXApi.h"


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [self setupUserDefaults];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableBarContrller = [TTTabBarController shareInstance];
    self.window.rootViewController = self.tableBarContrller;
    
    [self.window makeKeyAndVisible];
    [self initializeNetRequest];
    
    [WXApi registerApp:@"wxc565f6c6475eef2b"];
    return YES;
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

-(void)setupUserDefaults {
    
    BOOL isShakeCanChangeSkin = [[NSUserDefaults standardUserDefaults] boolForKey:IsShakeCanChangeSkinKey];
    if (!isShakeCanChangeSkin) {
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:IsShakeCanChangeSkinKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    BOOL isDownLoadNoImageIn3G = [[NSUserDefaults standardUserDefaults] boolForKey:IsDownLoadNoImageIn3GKey];
    if (!isDownLoadNoImageIn3G) {
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:IsDownLoadNoImageIn3GKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:UserNameKey];
    if (userName == nil || userName.length < 1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"注册/登录" forKey:UserNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        _isLogin = YES;
    }
    if ( !_isLogin) {
        [[NSUserDefaults standardUserDefaults] setObject:@"登录推荐更精准" forKey:UserSignatureKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
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
