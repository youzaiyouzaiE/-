//
//  TTLoginViewController.m
//  TTNews
//
//  Created by jiahui on 2016/11/16.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTLoginViewController.h"
#import "DKNightVersion.h"
#import "TTRegisterViewController.h"
#import "TTFindPasswordViewController.h"
#import "TTNetworkSessionManager.h"
#import "MBProgressHUD.h"
#import "NSObject+Extension.h"
#import "NSString+Extension.h"
#import "TTAppData.h"

@interface TTLoginViewController () <UITextFieldDelegate> {
    
    __weak IBOutlet UITextField *_userNameTextField;
    __weak IBOutlet UITextField *_passwordTextField;
    __weak IBOutlet UIView *_itemsBackgroundView;
    __weak IBOutlet UIButton *_loginButton;
    
    TTRegisterViewController *_findPassowrdVC;
    TTRegisterViewController *_registerVC;
}


@end

@implementation TTLoginViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_userNameTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录天维新闻";
    if (_isPresentInto) {
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(backAction)];
        self.navigationItem.leftBarButtonItem = item;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    _itemsBackgroundView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x444444, 0xfafafa);
    [self addTapViewResignKeyboard];
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 6;
    _loginButton.dk_backgroundColorPicker = DKColorPickerWithRGB(0xfa5054, 0x444444, 0xfa5054);
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _userNameTextField) {
        
    } else if (textField == _passwordTextField) {
        
    }
    return YES;
}

#pragma mark - Action perform 
- (IBAction)loginAction:(UIButton *)sender {
    if (_userNameTextField.text.length < 1 || [_userNameTextField.text isEqualToString:@""]) {
        [_userNameTextField becomeFirstResponder];
        return ;
    }
    if (_passwordTextField.text.length < 1 || [_passwordTextField.text isEqualToString:@""]) {
        [_passwordTextField becomeFirstResponder];
        return ;
    }
    if (![_userNameTextField.text isValidateEmail]) {
         [self showErrorMessageAlertView:@"邮箱格式不正确"];
        return ;
    }
    if (_passwordTextField.text.length < 6) {
        [self showErrorMessageAlertView:@"密码太短"];
        return ;
    }
    [self loginRequest];
}

- (IBAction)forgetPasswordAction:(UIButton *)sender {
    if (!_findPassowrdVC) {
        _findPassowrdVC = [[TTRegisterViewController alloc] init];
    }
     _findPassowrdVC.isForgetPassword = YES;
    [self.navigationController pushViewController:_findPassowrdVC animated:YES];
}

- (IBAction)registerAction:(UIButton *)sender {
    if (!_registerVC) {
    _registerVC = [[TTRegisterViewController alloc] init];
    }
    _registerVC.isForgetPassword = NO;
    [self.navigationController pushViewController:_registerVC animated:YES];
}


#pragma mark - NET WORKER
- (void)loginRequest{
    MBProgressHUD *hud = [self showActivityHud];
    [[TTNetworkSessionManager shareManager] Get:LOGIN_URL
                                     Parameters:@{@"username":_userNameTextField.text, @"password":_passwordTextField.text}
                                        Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                            [hud hideAnimated:YES];
                                            id errors = responseObject[@"errors"];
                                            if (errors != nil) {
                                                [self showErrorMessageAlertView:errors];
                                            } else {
                                                NSNumber *signalNum = responseObject[@"signal"];
                                                if (signalNum.integerValue == 1) {
                                                    NSDictionary *dateDic = responseObject[@"data"];
                                                    if (dateDic) {
                                                        NSNumber *uid = dateDic[@"uid"];
                                                        NSString *token = dateDic[@"token"];
                                                        if (_isPresentInto) {
                                                            [self userInfoRequestWithUid:uid andToken:token];
                                                        } else {
                                                            self.loginBlock(uid,token);
                                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                [self.navigationController popViewControllerAnimated:YES];
                                                            });
                                                        }
                                                    }
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


- (void)userInfoRequestWithUid:(NSNumber *)uid andToken:(NSString *)token {
    MBProgressHUD *hud = [self showActivityHud];
    [[TTNetworkSessionManager shareManager] Get:USER_INFO_URL
                                     Parameters:@{@"uid":uid, @"token":token}
                                        Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                            [hud hideAnimated:YES];
                                            id errors = responseObject[@"errors"];
                                            if (errors != nil) {
                                                [self showErrorMessageAlertView:errors];
                                            } else {
                                                NSNumber *signalNum = responseObject[@"signal"];
                                                if (signalNum.integerValue == 1) {
                                                    TTUserInfoModel *userInfo = [[TTUserInfoModel alloc] initWithDictionary:responseObject[@"data"]];
                                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"] forKey:k_UserInfoDic];
                                                        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:k_UserLoginType];
                                                    });
                                                    [TTAppData shareInstance].currentUser = userInfo;
                                                    [TTAppData shareInstance].needUpdateUserIcon = YES;
                                                    [TTAppData shareInstance].isLogin = YES;
                                                    SHARE_APP.isLogin = YES;
                                                    [self backAction];
                                                } else {
                                                    [self showMessage:responseObject[@"msg"]];
                                                }
                                            }
                                        }
                                        Failure:^(NSError *error) {
                                            [hud hideAnimated:YES];
                                            [self showMessage:@"获取用户信息失败!请重新登录"];
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
