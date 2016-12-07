//
//  AppDelegate.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "AppDelegate.h"
#import "TTTabBarController.h"
#import "TTConst.h"
#import "TTNetworkSessionManager.H"
#import "MeTableViewController.h"
#import "TTNewsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupUserDefaults];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
//    TTNewsViewController *vc1 = [[TTNewsViewController alloc] init];
//    UINavigationController *navVC1 = [self addChildViewController:vc1
//                                                        withImage:[UIImage imageNamed:@"tabbar_news"]
//                                                    selectedImage:[UIImage imageNamed:@"tabbar_news_hl"]
//                                                       withTittle:@"新闻"];
//    
//    MeTableViewController *vc4 = [[MeTableViewController alloc] init];
//    UINavigationController *navVC4 = [self addChildViewController:vc4
//                                                        withImage:[UIImage imageNamed:@"tabbar_setting"] selectedImage:[UIImage imageNamed:@"tabbar_setting_hl"]
//                                                       withTittle:@"我的"];
//    
//    UITabBarController *barController = [[UITabBarController alloc] init];
//    barController.viewControllers = @[navVC1,navVC4];
    
    self.window.rootViewController = [[TTTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    [self initializeNetRequest];
    return YES;
}

- (UINavigationController * )addChildViewController:(UIViewController *)controller
                     withImage:(UIImage *)image
                 selectedImage:(UIImage *)selectImage
                    withTittle:(NSString *)tittle {
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:tittle image:image selectedImage:selectImage];
    controller.tabBarItem = item;
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    //    [nav.tabBarItem setImage:image];
    //    [nav.tabBarItem setSelectedImage:selectImage];
    controller.title = tittle;
    //    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
//    [self addChildViewController:nav];
    return nav;
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

@end
