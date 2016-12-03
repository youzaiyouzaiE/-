//
//  MeTableViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/25.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "MeTableViewController.h"
#import <SDImageCache.h>
#import "TTDataTool.h"
#import <SVProgressHUD.h>
#import "UIImage+Extension.h"
#import "TTConst.h"
#import "SendFeedbackViewController.h"
#import "AppInfoViewController.h"
#import "EditUserInfoViewController.h"
#import "UIImage+Extension.h"
#import "UserInfoCell.h"
#import "SwitchCell.h"
#import <DKNightVersion.h>
#import "TwoLabelCell.h"
#import "DisclosureCell.h"
#import "TTLoginViewController.h"
#import "AppDelegate.h"
#import "TTNetworkManager.h"
#import "MBProgressHUD.h"
#import "NSObject+Extension.h"


static NSString *const UserInfoCellIdentifier = @"UserInfoCell";
static NSString *const SwitchCellIdentifier = @"SwitchCell";
static NSString *const TwoLabelCellIdentifier = @"TwoLabelCell";
static NSString *const DisclosureCellIdentifier = @"DisclosureCell";

@interface MeTableViewController ()<UIAlertViewDelegate> {
    BOOL _isLoginSuccess;
    NSNumber *_uid;
    NSString *_token;
    
    NSString *_nickName;
    NSString *_signature;
}

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, weak) UISwitch *shakeCanChangeSkinSwitch;
@property (nonatomic, weak) UISwitch *imageDownLoadModeSwitch;
@property (nonatomic, assign) CGFloat cacheSize;
@property (nonatomic, copy) NSString *currentSkinModel;


@end

CGFloat const footViewHeight = 30;

@implementation MeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self caculateCacheSize];
    [self setupBasic];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isLoginSuccess) {
        [self userInfoRequest];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

-(void)setupBasic{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame) + 30, 0, 0, 0);
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
    [self.tableView registerClass:[UserInfoCell class] forCellReuseIdentifier:UserInfoCellIdentifier];
    [self.tableView registerClass:[SwitchCell class] forCellReuseIdentifier:SwitchCellIdentifier];
    [self.tableView registerClass:[TwoLabelCell class] forCellReuseIdentifier:TwoLabelCellIdentifier];
    [self.tableView registerClass:[DisclosureCell class] forCellReuseIdentifier:DisclosureCellIdentifier];
}

-(void)caculateCacheSize {
    float imageCache = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.sqlite"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    float sqliteCache = [fileManager attributesOfItemAtPath:path error:nil].fileSize/1024.0/1024.0;
    self.cacheSize = imageCache;
}

- (void)userInfoRequest {
    MBProgressHUD *hud = [self showActivityHud];
    [[TTNetworkManager shareManager] Get:USER_INFO_URL
                              Parameters:@{@"uid":_uid, @"token":_token}
                                 Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                     [hud hideAnimated:YES];
                                     id errors = responseObject[@"errors"];
                                     if (errors != nil) {
                                         [self showErrorMessageAlertView:errors];
                                     } else {
                                         NSNumber *signalNum = responseObject[@"signal"];
                                         if (signalNum.integerValue == 1) {
                                             _nickName = responseObject[@"data"][@"nickname"];
                                             _signature = responseObject[@"data"][@"signature"];
                                             if (_signature.length < 1) {
                                                 _signature = @"这家伙很懒,什么也没留下";
                                             }
                                             [[NSUserDefaults standardUserDefaults] setObject:_nickName forKey:UserNameKey];
                                             [[NSUserDefaults standardUserDefaults] setObject:_signature forKey:UserSignatureKey];
                                             [self.tableView reloadData];
                                         } else {
                                             [self showMessage:responseObject[@"msg"]];
                                         }
                                     }
                                     _isLoginSuccess = NO;
                                 }
                                 Failure:^(NSError *error) {
                                     [hud hideAnimated:YES];
                                     [self showMessage:@"获取用户信息失败!"];
                                 }];
}

#pragma mark - Table view data source

#pragma mark -UITableViewDataSource 返回tableView有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark -UITableViewDataSource 返回tableView每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return footViewHeight;
}

#pragma mark -UITableViewDataSource 返回indexPath对应的cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 100;
    
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] init];
    footView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, footViewHeight);
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
    [footView addSubview:lineView1];
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.frame = CGRectMake(0, footViewHeight - 1, [UIScreen mainScreen].bounds.size.width, 1);
    [footView addSubview:lineView2];
    
    if (section==2) {
        [lineView2 removeFromSuperview];
    }
    return footView;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoCellIdentifier];
        cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);

        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"headerImage"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        if (image == nil) {
            image = [UIImage imageNamed:@"defaultUserIcon"];
            [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
        }
        NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:UserNameKey];
        NSString *content = [[NSUserDefaults standardUserDefaults] stringForKey:UserSignatureKey];
        [cell setAvatarImage:image Name:name Signature:content];
        return cell;
    }
    
    if (indexPath.section == 1&&indexPath.row <2) {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:SwitchCellIdentifier];
        cell.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"摇一摇夜间模式";
            self.shakeCanChangeSkinSwitch = cell.theSwitch;
            BOOL status = [[NSUserDefaults standardUserDefaults] boolForKey:IsShakeCanChangeSkinKey];
            cell.theSwitch.on = status;
            [cell.theSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
        } else if (indexPath.row == 1) {
            cell.leftLabel.text = @"夜间模式";
            cell.theSwitch.on= [self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]?YES:NO;
            self.changeSkinSwitch = cell.theSwitch;
            [cell.theSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
        }
        return cell;
        }
    
    //第三组cell
    if (indexPath.section == 1 && indexPath.row == 2) {
        TwoLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:TwoLabelCellIdentifier];
        cell.leftLabel.text = @"清除缓存";
        cell.rightLabel.text = [NSString stringWithFormat:@"%.1f MB",self.cacheSize];
        return cell;
    }
    
    DisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:DisclosureCellIdentifier];
    if (indexPath.row == 3) {
        cell.leftLabel.text = @"反馈";
         return cell;
    } else if(indexPath.row == 4) {
        cell.leftLabel.text = @"关于";
         return cell;
    } else if(indexPath.row == 5) {
        cell.leftLabel.text = @"退出";
         return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        AppDelegate *appDelegat = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegat.isLogin) {
            [self.navigationController pushViewController:[[EditUserInfoViewController alloc] init] animated:YES];
        } else {
            TTLoginViewController *loginVC = [[TTLoginViewController alloc] init];
            loginVC.loginBlock = ^(NSNumber *uid, NSString *token) {
                _uid = uid;
                _token = token;
                _isLoginSuccess = YES;
                appDelegat.isLogin = YES;
            };
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    } else if (indexPath.section == 1 && indexPath.row ==2) {
        [SVProgressHUD show];
        [TTDataTool deletePartOfCacheInSqlite];
        [[SDImageCache sharedImageCache] clearDisk];
        [SVProgressHUD showSuccessWithStatus:@"缓存清除完毕!"];
        [self performSelector:@selector(dismissSvprogressHud) withObject:nil afterDelay:1];
        TwoLabelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.rightLabel.text = [NSString stringWithFormat:@"0.0MB"];
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        [self.navigationController pushViewController:[[SendFeedbackViewController alloc] init] animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 4) {
        [self.navigationController pushViewController:[[AppInfoViewController alloc] init] animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 5) {
        if (SHARE_APP.isLogin) {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                               message:@"退出当前帐号,将不能同步收藏,评论,分享等"
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                     otherButtonTitles:@"确认退出", nil];
            [alerView show];
        }
    }
}

#pragma mark - UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:@"注册/登录" forKey:UserNameKey];
        [[NSUserDefaults standardUserDefaults] setObject:@"登录推荐更精准" forKey:UserSignatureKey];
        [self.tableView reloadData];
        SHARE_APP.isLogin = NO;
        
        [SVProgressHUD show];
        [TTDataTool deletePartOfCacheInSqlite];
        [[SDImageCache sharedImageCache] clearDisk];
        [SVProgressHUD showSuccessWithStatus:@"已退出登!"];
        [self performSelector:@selector(dismissSvprogressHud) withObject:nil afterDelay:1];
    }
}

- (void)dismissSvprogressHud{
    [SVProgressHUD dismiss];
}


-(void)switchDidChange:(UISwitch *)theSwitch {
    if (theSwitch == self.changeSkinSwitch) {
        if (theSwitch.on == YES) {//切换至夜间模式
            self.dk_manager.themeVersion = DKThemeVersionNight;
            self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];

        } else {
            self.dk_manager.themeVersion = DKThemeVersionNormal;
            self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];

        }
    
    } else if (theSwitch == self.shakeCanChangeSkinSwitch) {//摇一摇夜间模式
        BOOL status = self.shakeCanChangeSkinSwitch.on;
        [[NSUserDefaults standardUserDefaults] setObject:@(status) forKey:IsShakeCanChangeSkinKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([self.delegate respondsToSelector:@selector(shakeCanChangeSkin:)]) {
            [self.delegate shakeCanChangeSkin:status];
        }
   }
}

-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearDisk];
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


@end
