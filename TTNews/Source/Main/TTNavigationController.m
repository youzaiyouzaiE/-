//
//  TTNavigationController.m
//  TTNews
//
//  Created by jiahui on 2016/12/8.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTNavigationController.h"
#import <CYLTabBarController.h>

@interface TTNavigationController ()

@end

@implementation TTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UINavigationBar appearance] setBarTintColor:COLOR_NORMAL];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_Regular_PF(20)}];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    [[UILabel appearance] setFont:FONT_Regular_PF(16)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animate {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    } else
        viewController.hidesBottomBarWhenPushed = NO;
    
    [super pushViewController:viewController animated:animate];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
