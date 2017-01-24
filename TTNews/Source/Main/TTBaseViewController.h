//
//  TTBaseViewController.h
//  TTNews
//
//  Created by jiahui on 2016/12/3.
//  Copyright © 2016年 HOME. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTBaseViewController : UIViewController <UINavigationControllerDelegate,UIGestureRecognizerDelegate>

- (void)backAction;

- (void)naviBackAction;

- (void)addTapViewResignKeyboard;

- (void)dismissSvprogressHud;

@end
