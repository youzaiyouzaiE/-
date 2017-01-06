//
//  EDProgressHUD.m
//  EDOwn
//
//  Created by  on 16/3/11.
//  Copyright © 2016年 ed. All rights reserved.
//

#import "TTProgressHUD.h"
#import "MBProgressHUD.h"

#define Window ([UIApplication sharedApplication].keyWindow)

const static NSTimeInterval kMsgDuration = 1;

@interface TTProgressHUD ()

@end

@implementation TTProgressHUD

static MBProgressHUD *_hud = nil;
static UIImageView *_loadingImage = nil;

#pragma mark - HUD
+ (void)show {
    [self showHUDAddedTo:nil userInteractionEnabled:YES];
}

+ (void)showClear {
    [self showHUDAddedTo:nil userInteractionEnabled:NO];
}

+ (void)showHUDAddedTo:(UIView *)view {
    [self showHUDAddedTo:view userInteractionEnabled:YES];
}

+ (void)showHUDAddedTo:(UIView *)view userInteractionEnabled:(BOOL)enabled {
    if (!view) view = Window;
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    _hud.removeFromSuperViewOnHide = YES;
    _hud.mode = MBProgressHUDModeIndeterminate;
    //        _hud.animationType = MBProgressHUDAnimationZoomOut;
    _hud.margin = 10.0f;
    //        _hud.userInteractionEnabled = YES;
    [_hud showAnimated:YES];
}

+ (void)dismiss {
    [_hud hideAnimated:YES];
    [_hud removeFromSuperview];
    _hud = nil;
    Window.userInteractionEnabled = YES;
}

#pragma mark - message HUD
+ (void)showMsg:(NSString *)msg {
    [self showMsg:msg onView:nil];
}

+ (void)showMsg:(NSString *)msg onView:(UIView *)view {
    
    // view为空时，显示在当前的window上
    if (!view) view = Window;
    
    //没有消息就不显示
    if((msg == nil) || [msg isEqualToString:@""]) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    hud.detailsLabel.text = msg;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    double length = msg.length;
    NSTimeInterval duration = length * 0.04 + kMsgDuration;
    [hud hideAnimated:YES afterDelay:duration];
}

+ (void)showMessageToView:(UIView *)view message:(NSString *)message autoHideTime:(NSTimeInterval )interval {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    contentLabel.numberOfLines = 0;
    [contentLabel setTextAlignment:NSTextAlignmentCenter];
    contentLabel.text = message;
    hud.customView = contentLabel;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:interval];
}


+ (void)showDoneOnView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = NSLocalizedString(@"Done", @"HUD done title");
    [hud hideAnimated:YES afterDelay:1.0f];
}

+ (MBProgressHUD *)showProgressHUDOnView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        //        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
    return hud;
}


@end
