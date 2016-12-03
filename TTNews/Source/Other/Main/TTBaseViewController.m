//
//  TTBaseViewController.m
//  TTNews
//
//  Created by jiahui on 2016/12/3.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTBaseViewController.h"

@interface TTBaseViewController () <UINavigationControllerDelegate>

@end

@implementation TTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTapViewResignKeyboard {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)resignKeyboard {
    [self.view endEditing:YES];
}

- (void)naviBackAction {
     NSLog(@"SubClass: ACTION");
}

- (void)backAction {
    [self naviBackAction];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        UIViewController *topController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        if([topController respondsToSelector:@selector(controllerDismissedByPopGesture:)]) {
            [topController performSelector:@selector(controllerDismissedByPopGesture:) withObject:@([context isCancelled])];
        } }];
}

- (void)controllerDismissedByPopGesture:(NSNumber*)isCancel {
    if (![isCancel intValue]) {
        [self naviBackAction];
    }
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
