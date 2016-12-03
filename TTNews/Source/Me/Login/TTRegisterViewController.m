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
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSObject+Extension.h"
#import <DKNightVersion.h>

@interface TTRegisterViewController () <UITextFieldDelegate>{
    __weak IBOutlet UITextField *_textFieldNickname;
    __weak IBOutlet UITextField *_textFieldMailAddress;
    __weak IBOutlet UITextField *_textFieldIdentifyCode;
    __weak IBOutlet UIImageView *_imageViewIdentify;
    __weak IBOutlet UIButton *_buttonNext;
    __weak IBOutlet UIView *_itemsBackgroundView;
    
    __weak IBOutlet UIActivityIndicatorView *_activityIndicatior;
    
    BOOL _isCheckingMail;////正在校验邮件地址
//    BOOL _isMailPassed;
    BOOL _isSendingEmail;//
    
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
    _buttonNext.dk_backgroundColorPicker = DKColorPickerWithRGB(0xfa5054, 0x444444, 0xfa5054);
    _itemsBackgroundView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x444444, 0xfafafa);
    
    _activityIndicatior.hidden = YES;
    if (SHARE_APP.guid) {
        _imageGuid = SHARE_APP.guid;
        [self refreshPictureVerifyCode];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     _activityIndicatior.hidden = YES;
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
    if ([self checkInputAvailability]) {
          [self sendEmailRequest];
    }
}

- (BOOL)checkInputAvailability {
    if (_textFieldNickname.text.length < 1) {
        [_textFieldNickname becomeFirstResponder];
        return NO;
    }
    if (_textFieldMailAddress.text.length < 1) {
        [_textFieldMailAddress becomeFirstResponder];
        return NO;
    }
    if (_textFieldIdentifyCode.text.length < 4) {
        [_textFieldIdentifyCode becomeFirstResponder];
        [self showMessage:@"请输入正确的检证码"];
        return NO;
    }
    if (![_textFieldMailAddress.text isValidateEmail]) {
        [self showMessage:@"邮箱格式不正确"];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _textFieldMailAddress && _textFieldNickname.text.length > 1) {
        if (![_textFieldMailAddress.text isValidateEmail] && _textFieldMailAddress.text.length > 1) {
            [self showMessage:@"邮箱格式不正确"];
            return;
        }
        if (!_isCheckingMail) {
              [self checkUserNameOrMailUsed];
        }
    } else if (textField == _textFieldNickname && _textFieldMailAddress.text.length > 1 ) {
        if (textField.text.length < 6) {
             [self showMessage:@"昵称至少6个字符"];
        }
        if (!_isCheckingMail && ![_textFieldMailAddress.text isValidateEmail]) {
            [self checkUserNameOrMailUsed];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

#pragma mark - NET WORKER 
- (void)checkUserNameOrMailUsed {
    _isCheckingMail = YES;
    [[TTNetworkManager shareManager] Get:CHECK_EMAIL_URL
                              Parameters:@{@"email":_textFieldMailAddress.text, @"username":_textFieldNickname.text}
                                 Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                     _isCheckingMail = NO;
                                     id errors = responseObject[@"errors"];
                                     if (![errors isEmptyObj]) {
                                         [self showErrorMessageAlertView:errors];
                                     } else {
                                         NSNumber *signalNum = responseObject[@"signal"];
                                         if (signalNum.integerValue == 1) {
                                             if (_isForgetPassword) {
                                                 [self showMessage:@"邮箱/用户不存在"];
                                             } else
                                                 [self showMessage:@"邮箱用户名可用"];
                                         } else if (signalNum.integerValue == 100090){
                                             if (_isForgetPassword) {
                                                  NSLog(@"邮箱已存在");
//                                                 [self showMessage:@"邮箱已存在"];
                                             } else
                                                 [self showMessage:@"电子邮件被占用"];
                                         } else if (signalNum.integerValue == 2170){
                                             if (_isForgetPassword) {
                                                 NSLog(@"昵称已存在");
//                                                 [self showMessage:@"昵称已存在"];
                                             } else
                                                 [self showMessage:@"昵称被占用"];
                                         } else if (signalNum.integerValue == 1){
                                             [self showMessage:responseObject[@"msg"]];
                                         }
                                     }
                                 }
                                 Failure:^(NSError *error) {
                                     //         _isMailPassed = NO;
                                     _isCheckingMail = NO;
                                 }];
}

- (void)initializeNetRequest {
    [[TTNetworkManager shareManager] Get:INITIALIZE_URL Parameters:nil Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        NSNumber *signalNum = responseObject[@"signal"];
        if (signalNum.integerValue == 1) {
            _imageGuid = responseObject[@"data"][@"GUID"];
            SHARE_APP.guid = _imageGuid;
        }
    } Failure:^(NSError *error) {
        
    }];
}

- (void)refreshPictureVerifyCode {
    if (!_imageGuid) {
        [self initializeNetRequest];
        return ;
    }
    _activityIndicatior.hidden = NO;
    NSString *urlStr = [PICTURE_VERIFY_CODE_URL stringByAppendingString:[NSString stringWithFormat:@"?rndUid=%@",_imageGuid]];
    [_imageViewIdentify sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _activityIndicatior.hidden = YES;
        _imageViewIdentify.image = image;
        [[SDImageCache sharedImageCache] clearMemory];
    }];
}

- (void)sendEmailRequest {
    MBProgressHUD *hud = [self showActivityHud];
    [[TTNetworkManager shareManager] Get:SEND_EMAIL_URL
                              Parameters:@{@"email":_textFieldMailAddress.text, @"username":_textFieldNickname.text, @"rndUid":_imageGuid, @"picVerifyCode":_textFieldIdentifyCode.text}
                                 Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                     [hud hideAnimated:YES];
                                     id errors = responseObject[@"errors"];
                                     if (![errors isEmptyObj]) {
                                         [self showErrorMessageAlertView:errors];
                                     } else {
                                         NSNumber *signalNum = responseObject[@"signal"];
                                         if (signalNum.integerValue == 1) {
                                             [self showMessage:@"邮件发送成功"];
                                             TTMailRegisterViewController *mailRequesVC = [[TTMailRegisterViewController alloc] init];
                                             mailRequesVC.mailStr = _textFieldMailAddress.text;
                                             mailRequesVC.nickNameStr = _textFieldNickname.text;
                                             mailRequesVC.isForgetPassword = _isForgetPassword;
                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                   [self.navigationController pushViewController:mailRequesVC animated:YES];
                                             });
                                             return ;
                                         } else if (signalNum.integerValue == 103){
                                             [self showMessage:@"邮件发送中"];
                                         } else if (signalNum.integerValue == 6086){
                                             [[[UIAlertView alloc] initWithTitle:@"提示"
                                                                         message:@"邮件发送次数已经达到上限"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"知道了"
                                                               otherButtonTitles:nil, nil]
                                              show];
                                         }
                                     }
                                 }
                                 Failure:^(NSError *error) {
                                     [hud hideAnimated:YES];
                                     [self showMessage:[NSString stringWithFormat:@"请求出错! %@",error.localizedDescription]];
                                 }];
}

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
//            _isMailPassed = NO;
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
//            _isMailPassed = NO;
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
