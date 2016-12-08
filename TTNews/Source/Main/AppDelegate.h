//
//  AppDelegate.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTTabBarController;

#define SHARE_APP  ((AppDelegate *)[UIApplication sharedApplication].delegate)


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TTTabBarController *tableBarContrller;

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, copy) NSString *guid;

- (void)initializeNetRequest;

@end

