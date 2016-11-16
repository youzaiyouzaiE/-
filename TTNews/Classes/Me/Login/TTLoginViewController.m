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

@interface TTLoginViewController () <UITextFieldDelegate> {
    
    __weak IBOutlet UITextField *_userNameTextField;
    __weak IBOutlet UITextField *_passwordTextField;
    __weak IBOutlet UIButton *_loginButton;
    
    TTRegisterViewController *_findPassowrdVC;
    TTRegisterViewController *_registerVC;
    
}

@end

@implementation TTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登陆天天新闻";
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 6;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
