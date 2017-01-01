//
//  EDProgressHUD.h
//  EDOwn
//
//  Created  on 16/3/11.
//  Copyright © 2016年 ed. All rights reserved.
//

@class  MBProgressHUD;
@interface TTProgressHUD : NSObject

/*!
 *  @brief 显示菊花,添加到当前widonw上，显示期间可以响应
 */
+ (void)show;

/*!
 *  @brief 显示菊花,添加到指定view上
 *  @param view    显示提示信息的view
 */
+ (void)showHUDAddedTo:(nullable UIView *)view;
+ (void)showHUDAddedTo:(nullable UIView *)view userInteractionEnabled:(BOOL)enabled;

/*!
 *  @brief 显示菊花,添加到当前widonw上，显示期间不能响应
 */
+ (void)showClear;

/*!
 *  @brief 隐藏菊花
 */
+ (void)dismiss;

/*!
 *  @brief 显示提示信息，显示在window上
 *
 *  @param Msg 提示信息内容
 */
+ (void)showMsg:(nonnull NSString *)msg;

/*!
 *  @brief 显示提示信息
 *
 *  @param Msg 提示信息内容
 *  @param view    显示提示信息的view
 */
+ (void)showMsg:(nonnull NSString *)msg onView:(nullable UIView *)view;

+ (void)showMessageToView:(nonnull UIView *)view message:(nullable NSString *)message autoHideTime:(NSTimeInterval )interval;


+ (void)showDoneOnView:(nullable UIView *)view;

+ (nonnull MBProgressHUD *)showProgressHUDOnView:(nullable UIView *)view;
@end
