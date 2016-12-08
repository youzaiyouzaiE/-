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
    
    [self.navigationBar setTintColor:[UIColor colorWithHexString:@"f0f0f0"]];

//    [UINavigationBar appearance].dk_tintColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
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
