//
//  TTMailRegisterViewController.m
//  TTNews
//
//  Created by jiahui on 2016/11/16.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTMailRegisterViewController.h"
#import "MBProgressHUD.h"

@interface TTMailRegisterViewController () {
    
    __weak IBOutlet UIButton *_buttonRegister;
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
    _buttonRegister.backgroundColor = [UIColor colorWithDisplayP3Red:232.f/255.f green:114.f/255.f blue:112.f/255.f alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
