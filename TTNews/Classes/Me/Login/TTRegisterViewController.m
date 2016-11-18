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
#import "MBProgressHUD.h"
#import "TTNetworkManager.h"
#import "NSString+Extension.h"

@interface TTRegisterViewController () <UITextFieldDelegate>{
    __weak IBOutlet UITextField *_textFieldNickname;
    __weak IBOutlet UITextField *_textFieldMailAddress;
    __weak IBOutlet UITextField *_textFieldIdentifyCode;
    __weak IBOutlet UIImageView *_imageViewIdentify;
    __weak IBOutlet UIButton *_buttonNext;
    
    BOOL _isMailPassed;
    
}

@property (nonatomic, copy) NSString *imageGuid;

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
    _buttonNext.backgroundColor = [UIColor colorWithDisplayP3Red:232.f/255.f green:114.f/255.f blue:112.f/255.f alpha:1];
    
//    [self initializeNetRequest];
    if (SHARE_APP.guid) {
        _imageGuid = SHARE_APP.guid;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - action perform
- (IBAction)refreshButtonAction:(UIButton *)sender {
    [self refreshPictureVerifyCode];
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    TTMailRegisterViewController *registerVC = [[TTMailRegisterViewController alloc] init];
    registerVC.isForgetPassword = _isForgetPassword;
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _textFieldMailAddress && _textFieldNickname.text.length > 1) {
        if (![_textFieldMailAddress.text isValidateEmail]) {
            [self showMessage:@"邮箱用户名格式不正确"];
            return ;
        }
        [self checkUserNameOrMailUsed];
    } else if (textField == _textFieldNickname && _textFieldMailAddress.text.length >1 ) {
        [self checkUserNameOrMailUsed];
    }
}

#pragma mark - NET WORKER 
- (void)checkUserNameOrMailUsed {
    [[TTNetworkManager shareManager] Get:CHECK_EMAIL_URL Parameters:@{@"email":_textFieldMailAddress.text, @"username":_textFieldNickname.text} Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        NSDictionary *errDic = responseObject[@"errors"];
        if (errDic) {
            [self showMessage:errDic.allValues[0]];
             _isMailPassed = NO;
        } else {
            NSNumber *signalNum = responseObject[@"signal"];
             _isMailPassed = NO;
            if (signalNum.integerValue == 1) {
                [self showMessage:@"邮箱用户名可用"];
                _isMailPassed = YES;
            } else if (signalNum.integerValue == 100090){
                [self showMessage:@"电子邮件被占用"];
            } else if (signalNum.integerValue == 2170){
                [self showMessage:@"昵称被占用"];
            }else if (signalNum.integerValue == 1){
                [self showMessage:responseObject[@"msg"]];
            }
        }
    } Failure:^(NSError *error) {
         _isMailPassed = NO;
    }];
}

- (void)initializeNetRequest {
    [[TTNetworkManager shareManager] Get:INITIALIZE_URL Parameters:nil Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        NSNumber *signalNum = responseObject[@"signal"];
        if (signalNum.integerValue == 1) {
            _imageGuid = responseObject[@"data"][@"GUID"];
        }
    } Failure:^(NSError *error) {
        
    }];
}

- (void)refreshPictureVerifyCode {
    if (!_imageGuid) {
        [self initializeNetRequest];
        return ;
    }
    MBProgressHUD *hud = [self showActivityHud];
    [[TTNetworkManager shareManager] Get:PICTURE_VERIFY_CODE_URL Parameters:@{@"rndUid":_imageGuid} Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
         [hud hideAnimated:YES];
         NSDictionary *errDic = responseObject[@"errors"];
        if (errDic) {
            [self showMessage:errDic.allValues[0]];
        } else{
            NSLog(@"%@",responseObject);
        }
    } Failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
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
        [hud hideAnimated:YES afterDelay:2.0f];
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
