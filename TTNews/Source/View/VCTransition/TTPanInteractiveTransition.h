//
//  TTPanInteractiveTransition.h
//  JHTransitionPro
//
//  Created by jiahui on 2017/2/7.
//  Copyright © 2017年 Jiahui. All rights reserved.
//


@interface TTPanInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;
- (void)wireToViewController:(UIViewController*)viewController;

@end
