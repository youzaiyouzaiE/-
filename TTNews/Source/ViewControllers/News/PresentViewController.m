//
//  PresentViewController.m
//  NavigationTransitionController
//
//  Created by jiahui on 2017/1/4.
//  Copyright © 2017年 Chris Eidhof. All rights reserved.
//

#import "PresentViewController.h"
#import "TTNormalDismissAnimation.h"
#import "TTPanInteractiveTransition.h"

@interface PresentViewController () <UIViewControllerTransitioningDelegate> {
    UIPanGestureRecognizer* _panRecognizer;
}

@property (nonatomic, strong) TTNormalDismissAnimation *dismissAnimation;
@property (nonatomic, strong) TTPanInteractiveTransition *transitionController;


@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = CGRectMake(50, 50, 220, 50);
    [self.view addSubview:dismissButton];
    dismissButton.backgroundColor = [UIColor yellowColor];
    [dismissButton setTitle:@"dismess" forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _dismissAnimation = [TTNormalDismissAnimation new];
    _transitionController = [[TTPanInteractiveTransition alloc] init];
    self.transitioningDelegate = self;
    [self.transitionController wireToViewController:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)dismissAction:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark – UIViewControllerTransitioningDelegate
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
//                                                                   presentingController:(UIViewController *)presenting
//                                                                       sourceController:(UIViewController *)source {
//    return nil;
//}

//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
//    return self.interactionController;
//}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissAnimation;
}


- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
     return self.transitionController.interacting ? self.transitionController : nil;
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
