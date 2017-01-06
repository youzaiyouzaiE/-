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
#import "TTAppData.h"
#import <PgySDK/PgyManager.h>
//#import <PgyUpdate/PgyUpdateManager.h>
#import "TalkingData.h"
#import "TalkingDataSMS.h"
#import <CoreLocation/CoreLocation.h>

#define PGY_APP_ID   @"bc2f3e0f520c5299b0bdb3399e27bd4e"

@interface AppDelegate ()<WXApiDelegate,CLLocationManagerDelegate> {
    
    CLLocationManager *_locationManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableBarContrller = [TTTabBarController shareInstance];
    self.window.rootViewController = self.tableBarContrller;
    
    [self.window makeKeyAndVisible];
    [self initializeNetRequest];
    [self setupUserDefaults];
    [WXApi registerApp:@"wxc565f6c6475eef2b"];
    [self installTalkingData];
    return YES;
}



- (void)installTalkingData {
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData sessionStarted:@"7ED8D36E60D84EF5992DBB62CF9BA4D0" withChannelId:@"AppStore"];
    [TalkingDataSMS init:@"7ED8D36E60D84EF5992DBB62CF9BA4D0" withSecretId:@""];
}

//开始定位
-(void)startLocation{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10.0f;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        _locationManager.allowsBackgroundLocationUpdates = NO;
    }
    [_locationManager startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate
//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [_locationManager stopUpdatingLocation];
    NSLog(@"location ok");
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    //    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    //    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
    //        for (CLPlacemark * placemark in placemarks) {
    //            NSDictionary *test = [placemark addressDictionary];
    //            //  Country(国家)  State(城市)  SubLocality(区)
    //            NSLog(@"%@", [test objectForKey:@"State"]);
    //            NSString *cityName = [test objectForKey:@"State"];
    //            if (currentCityString == nil || currentCityString.length < 1) {
    //                [[NSNotificationCenter defaultCenter] postNotificationName:@"getLocationNotification" object:cityName];
    //                currentCityString = [cityName substringWithRange:NSMakeRange(0,2)];
    //                alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:FORMAT(@"当前定位到城市为%@,是否切换",cityName) delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //                [alertView show];
    //            } else {
    //                if(![[currentCityString substringWithRange:NSMakeRange(0,2)] isEqualToString:[cityName substringWithRange:NSMakeRange(0,2)]]) {
    //                    [alertView show];
    //                }
    //            }
    //        }
    //    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    switch([error code]) {
        case kCLErrorDenied:
            [self openGPSTips];
            break;
        case kCLErrorLocationUnknown:
            break;
        default:
            break;
    }
}

-(void)openGPSTips{
    UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:@"请到“设置->隐私->定位服务”中开启定位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alet show];
}

#pragma mark - netWork request
- (void)initializeNetRequest {
    [TTAppData shareInstance];
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
