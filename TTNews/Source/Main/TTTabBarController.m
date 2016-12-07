//
//  TTTabBarController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/25.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTTabBarController.h"
#import "TTNewsViewController.h"
#import "PictureViewController.h"
#import "VideoViewController.h"
#import "MeTableViewController.h"
#import "TTConst.h"
#import <DKNightVersion.h>
#import <SDImageCache.h>

@interface TTTabBarController ()<MeTableViewControllerDelegate>
{
    MeTableViewController *_MeController;
}
@property (nonatomic, assign) BOOL isShakeCanChangeSkin;

@end

@implementation TTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TTNewsViewController *vc1 = [[TTNewsViewController alloc] init];
    [self addChildViewController:vc1
                       withImage:[UIImage imageNamed:@"tabbar_news"]
                   selectedImage:[UIImage imageNamed:@"tabbar_news_hl"]
                      withTittle:@"新闻"];
    
//    PictureViewController *vc2 = [[PictureViewController alloc] init];
//    [self addChildViewController:vc2 withImage:[UIImage imageNamed:@"tabbar_picture"] selectedImage:[UIImage imageNamed:@"tabbar_picture_hl"] withTittle:@"图片"];
//    
//    VideoViewController *vc3 = [[VideoViewController alloc] init];
//    [self addChildViewController:vc3 withImage:[UIImage imageNamed:@"tabbar_video"] selectedImage:[UIImage imageNamed:@"tabbar_video_hl"] withTittle:@"视频"];
    
    MeTableViewController *vc4 = [[MeTableViewController alloc] init];
    _MeController = vc4;
    [self addChildViewController:vc4 withImage:[UIImage imageNamed:@"tabbar_setting"] selectedImage:[UIImage imageNamed:@"tabbar_setting_hl"] withTittle:@"我的"];
    vc4.delegate = self;
    [self setupBasic];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)setupBasic {
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        self.tabBar.barTintColor = [UIColor whiteColor];
    } else {
        self.tabBar.barTintColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
    }
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    self.isShakeCanChangeSkin = [[NSUserDefaults standardUserDefaults] boolForKey:IsShakeCanChangeSkinKey];
}

- (void)addChildViewController:(UIViewController *)controller
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
    [self addChildViewController:nav];
}

-(void)shakeCanChangeSkin:(BOOL)status {
    self.isShakeCanChangeSkin = status;
}

-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearDisk];
}

-(void)dealloc {
    
}

@end
