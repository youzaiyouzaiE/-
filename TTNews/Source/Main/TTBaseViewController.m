//
//  TTBaseViewController.m
//  TTNews
//
//  Created by jiahui on 2016/12/3.
//  Copyright © 2016年 HOME. All rights reserved.
//

#import "TTBaseViewController.h"
#import "TTJudgeNetworking.h"
#import "TTNormalDismissAnimation.h"
#import "TTPanInteractiveTransition.h"

@interface TTBaseViewController ()<UIViewControllerTransitioningDelegate>  {
    UITapGestureRecognizer *_tapGestureRecognizer;
}

@property (nonatomic, strong) TTNormalDismissAnimation *dismissAnimation;
@property (nonatomic, strong) TTPanInteractiveTransition *transitionController;

@end

@implementation TTBaseViewController

- (void)dealloc
{
     NSLog(@"%@ -> %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(naviBackAction)];
    
//    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_pic_back_icon"]
//                                                              style:UIBarButtonItemStylePlain
//                                                             target:self
//                                                             action:@selector(backAction)];
//    self.navigationItem.leftBarButtonItem = item;
    
//    if (self.navigationController.interactivePopGestureRecognizer) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    if([TTJudgeNetworking judge] == NO) {
        [SVProgressHUD showErrorWithStatus:@"无网络连接!"];
        [self performSelector:@selector(dismissSvprogressHud) withObject:nil afterDelay:1];
    }
}

- (void)dismissSvprogressHud {
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITapGestureRecognizer *)addTapViewResignKeyboard {
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    _tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_tapGestureRecognizer];
    return _tapGestureRecognizer;
}

- (void)resignKeyboard {
    [self.view endEditing:YES];
}

- (void)backAction {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)needInteractiveTransitionDissmiss:(BOOL)isNeed {
//    if (isNeed) {
//        _dismissAnimation = [TTNormalDismissAnimation new];
//        _transitionController = [[TTPanInteractiveTransition alloc] init];
//        self.transitioningDelegate = self;
//        [self.transitionController wireToViewController:self];
//    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _tapGestureRecognizer) {
        [self.view endEditing:YES];
        return NO;
    } else {
        if (self.navigationController.viewControllers.count == 1) {//关闭主界面的右滑返回
            return NO;
        } else {
            return YES;
        }
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        UIViewController *topController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        if([topController respondsToSelector:@selector(controllerDismissedByPopGesture:)]) {
            [topController performSelector:@selector(controllerDismissedByPopGesture:) withObject:@([context isCancelled])];
        } }
     ];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    
}

- (void)controllerDismissedByPopGesture:(NSNumber*)isCancel {
    if (![isCancel intValue]) {
//        [self.navigationController popViewControllerAnimated:YES];
        [self naviBackAction];
    }
}

- (void)naviBackAction {
//     [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark – UIViewControllerTransitioningDelegate
//-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    return self.dismissAnimation;
//}
//
//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
//    return self.transitionController.interacting ? self.transitionController : nil;
//}

@end
