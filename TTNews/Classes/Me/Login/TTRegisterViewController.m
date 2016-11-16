//
//  TTRegisterViewController.m
//  TTNews
//
//  Created by jiahui on 2016/11/16.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTRegisterViewController.h"
#import "DKNightVersion.h"
#import "AppDelegate.h"
#import "TTMailRegisterViewController.h"

@interface TTRegisterViewController () {
    __weak IBOutlet UITextField *_textFieldNickname;
    __weak IBOutlet UITextField *_textFieldMailAddress;
    __weak IBOutlet UITextField *_textFieldIdentifyCode;
    __weak IBOutlet UIImageView *_imageViewIdentify;
    __weak IBOutlet UIButton *_buttonNext;
    
}

@end

@implementation TTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    if (_isForgetPassword) {
        self.navigationItem.title = @"重置密码 1/2";
    } else
        self.navigationItem.title = @"邮箱注册 1/2";
    
    
    _buttonNext.layer.masksToBounds = YES;
    _buttonNext.layer.cornerRadius = 6;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - action perform
- (IBAction)refreshButtonAction:(UIButton *)sender {
    
    
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    TTMailRegisterViewController *registerVC = [[TTMailRegisterViewController alloc] init];
    registerVC.isForgetPassword = _isForgetPassword;
    [self.navigationController pushViewController:registerVC animated:YES];
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
