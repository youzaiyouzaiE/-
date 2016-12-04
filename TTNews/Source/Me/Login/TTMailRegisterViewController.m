//
//  TTMailRegisterViewController.m
//  TTNews
//
//  Created by jiahui on 2016/11/16.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTMailRegisterViewController.h"
#import "MBProgressHUD.h"
#import "TTNetworkSessionManager.h"
#import "NSObject+Extension.h"
#import <DKNightVersion.h>
@interface TTMailRegisterViewController ()<UITextFieldDelegate> {
    __weak IBOutlet UIButton *_buttonRegister;
    __weak IBOutlet UITextField *_textFieldPassword;
    __weak IBOutlet UITextField *_textFieldAgain;
    __weak IBOutlet UITextField *_textFieldMailCode;
    __weak IBOutlet UIView *_itemsBackgroundView;
    
}

@end

@implementation TTMailRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_isForgetPassword) {
        self.navigationItem.title = @"重置密码 2/2";
        [_buttonRegister setTitle:@"确  定" forState:UIControlStateNormal];
    } else {
        self.navigationItem.title = @"邮箱注册 2/2";
        [_buttonRegister setTitle:@"注  册" forState:UIControlStateNormal];
    }
    _buttonRegister.layer.masksToBounds = YES;
    _buttonRegister.layer.cornerRadius = 6;
    _buttonRegister.dk_backgroundColorPicker = DKColorPickerWithRGB(0xfa5054, 0x444444, 0xfa5054);
    _itemsBackgroundView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x444444, 0xfafafa);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _textFieldPassword) {
        if (textField.text.length <6) {
            [self showMessage:@"密码至少需6个字符"];
            return ;
        }
    }
}

#pragma mark - Action Perform
- (IBAction)registerAction:(UIButton *)sender {
    if (_textFieldPassword.text.length < 1) {
        [_textFieldPassword becomeFirstResponder];
        return ;
    }
    if (_textFieldAgain.text.length < 1) {
        [_textFieldAgain becomeFirstResponder];
        return ;
    }
    if (_textFieldMailCode.text.length < 1) {
        [_textFieldMailCode becomeFirstResponder];
        return ;
    }
    if ([self checkInformationAvailability]) {
        [self registerNetRequest];
    }
}


- (BOOL)checkInformationAvailability {
    if (![_textFieldPassword.text isEqualToString:_textFieldAgain.text]) {
        [self showMessage:@"密码输入不一致!"];
        return NO;
    }
    if (_textFieldMailCode.text.length < 6) {
        [self showMessage:@"邮件验证码不正确!"];
        return NO;
    }
    return YES;
}

#pragma mark - NET WORKER
- (void)registerNetRequest{
    MBProgressHUD *hud = [self showActivityHud];
    [[TTNetworkSessionManager shareManager] Get:REGISTER_URL
                              Parameters:@{@"email":_mailStr, @"emailVerifyCode":_textFieldMailCode.text,@"username":_nickNameStr, @"password":_textFieldPassword.text}
                                 Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                     [hud hideAnimated:YES];
                                     id errors = responseObject[@"errors"];
                                     if (![errors isEmptyObj]) {
                                         [self showErrorMessageAlertView:errors];
                                     } else {
                                         NSNumber *signalNum = responseObject[@"signal"];
                                         if (signalNum.integerValue == 1) {
                                             if (_isForgetPassword) {
                                                  [self showMessage:@"修改成功!"];
                                             } else {
                                                 [self showMessage:@"注册成功!"];
                                             }
                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                  [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                                             });
                                         } else {
                                             [self showMessage:responseObject[@"msg"]];
                                         }
                                     }
                                 }
                                 Failure:^(NSError *error) {
                                    [hud hideAnimated:YES];
                                    [self showMessage:error.description];
                                 }];
}

#pragma mark - alertView
- (void)showErrorMessageAlertView:(id)errors {
    if ([errors isKindOfClass:[NSDictionary class]]) {
        NSDictionary *errDic = errors;
        if (errDic.allValues.count > 0) {
            [[[UIAlertView alloc] initWithTitle:@"提示"
                                        message:errDic.allValues.firstObject
                                       delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil]
             show];
            return ;
        }
    } else if ([errors isKindOfClass:[NSArray class]]) {
        NSArray *errArr = errors;
        if (errArr.count > 0) {
            [[[UIAlertView alloc] initWithTitle:@"提示"
                                        message:errArr.firstObject
                                       delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil]
             show];
            return ;
        }
    }
}

#pragma mark - HUD view
- (void)showMessage:(NSString *)message
{
    [self showMessageToView:self.view message:message autoHide:YES];
}

- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    if (autoHide) {
        [hud hideAnimated:YES afterDelay:1.5f];
    }
    return hud;
}

- (MBProgressHUD *)showActivityHud {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    //    hud.labelText = @"";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    return hud;
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
