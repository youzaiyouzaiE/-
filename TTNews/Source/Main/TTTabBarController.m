//
//  TTTabBarController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/25.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTTabBarController.h"
#import "TTNavigationController.h"

#import "TTNewsViewController.h"
#import "PictureViewController.h"
#import "VideoViewController.h"
#import "MeTableViewController.h"


@interface TTTabBarController ()<UITabBarControllerDelegate>


@end

@implementation TTTabBarController

+ (instancetype)shareInstance {
    static TTTabBarController *shareInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[TTTabBarController alloc] init];
    });
    return shareInstance;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setTintColor:COLOR_NORMAL];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
//    self.delegate = self;
    [self setupViewControllers];
}

- (void)setupViewControllers {
    TTNewsViewController *news = [[TTNewsViewController alloc] init];
    TTNavigationController *firstNavigationController = [[TTNavigationController alloc]
                                                         initWithRootViewController:news];
    
    MeTableViewController *meVC = [[MeTableViewController alloc] init];
    TTNavigationController *secondNavigationController = [[TTNavigationController alloc]
                                                          initWithRootViewController:meVC];
    [self customizeTabBarForController];
    [self setViewControllers:@[firstNavigationController, secondNavigationController]];
}


- (void)customizeTabBarForController {
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"新闻",
                            CYLTabBarItemImage : @"tabbar_news",
                            CYLTabBarItemSelectedImage : @"tabbar_news_hl",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"我",
                            CYLTabBarItemImage : @"tabbar_setting",
                            CYLTabBarItemSelectedImage : @"tabbar_setting_hl",
                            };
    
    NSArray *tabBarItemsAttributes = @[ dict1, dict2 ];
    self.tabBarItemsAttributes = tabBarItemsAttributes;
}

//- (BOOL)hidesBottomBarWhenPushed
//{
//    return (self.navigationController.topViewController == self);
//}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    
}

-(void)dealloc {
    
}

@end
