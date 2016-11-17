//
//  TTLoginViewController.m
//  TTNews
//
//  Created by jiahui on 2016/11/16.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTLoginViewController.h"
#import "DKNightVersion.h"
#import "AppDelegate.h"
#import "TTRegisterViewController.h"
#import "TTFindPasswordViewController.h"
#import "TTNetworkManager.h"
#import "MBProgressHUD.h"

@interface TTLoginViewController () <UITextFieldDelegate> {
    
    __weak IBOutlet UITextField *_userNameTextField;
    __weak IBOutlet UITextField *_passwordTextField;
    __weak IBOutlet UIButton *_loginButton;
    
    TTRegisterViewController *_findPassowrdVC;
    TTRegisterViewController *_registerVC;
    
}
@property (nonatomic, copy) NSString *guid;

@end

@implementation TTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登陆天天新闻";
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 6;
    _loginButton.backgroundColor = [UIColor colorWithDisplayP3Red:232.f/255.f green:114.f/255.f blue:112.f/255.f alpha:1];
//    [self initializeNetRequest];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - netWork request 
- (void)initializeNetRequest {
    [[TTNetworkManager shareManager] Get:INITIALIZE_URL Parameters:nil Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        NSNumber *signalNum = responseObject[@"signal"];
        if (signalNum.integerValue == 1) {
            _guid = responseObject[@"data"][@"GUID"];
        }
        
    } Failure:^(NSError *error) {
        
    }];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _userNameTextField) {
        
    } else if (textField == _passwordTextField) {
        
    }
    return YES;
}


#pragma mark - HUD view
- (void)showMessageToView:(UIView *)view message:(NSString *)message
{
    [self showMessageToView:view message:message autoHide:YES];
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
