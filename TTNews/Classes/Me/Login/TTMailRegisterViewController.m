//
//  TTMailRegisterViewController.m
//  TTNews
//
//  Created by jiahui on 2016/11/16.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTMailRegisterViewController.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
