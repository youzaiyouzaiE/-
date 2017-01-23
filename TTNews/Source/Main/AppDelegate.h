//
//  AppDelegate.h
//  TTNews
//
//  Created by jiahui on 2016/12/8.
//  Copyright © 2016年 TTNews. All rights reserved.
//


#import <UIKit/UIKit.h>

@class TTTabBarController;

#define SHARE_APP  ((AppDelegate *)[UIApplication sharedApplication].delegate)


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TTTabBarController *tableBarContrller;

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, copy) NSString *guid;///

- (void)initializeNetRequest;

@end

