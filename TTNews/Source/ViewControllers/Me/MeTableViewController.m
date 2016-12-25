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
#import "TwoLabelCell.h"
#import "DisclosureCell.h"
#import "TTLoginViewController.h"
#import "AppDelegate.h"
#import "TTNetworkSessionManager.h"
#import "MBProgressHUD.h"
#import "NSObject+Extension.h"
#import "TTUserInfoModel.h"
#import "TTAppData.h"
#import "UIImageView+WebCache.h"

static NSString *const UserInfoCellIdentifier = @"UserInfoCell";
static NSString *const SwitchCellIdentifier = @"SwitchCell";
static NSString *const TwoLabelCellIdentifier = @"TwoLabelCell";
static NSString *const DisclosureCellIdentifier = @"DisclosureCell";

@interface MeTableViewController ()<UIAlertViewDelegate,UITableViewDelegate, UITableViewDataSource> {
    BOOL _isGetToken;
    NSNumber *_uid;
    NSString *_token;
    NSString *_userIconURLStr;
}

@property (nonatomic, strong) UITableView *tableView;
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
    if (_isGetToken) {
        [self userInfoRequest];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

-(void)setupBasic{
//    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
    self.title = @"我的";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    [self.tableView registerClass:[UserInfoCell class] forCellReuseIdentifier:UserInfoCellIdentifier];
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
    [[TTNetworkSessionManager shareManager] Get:USER_INFO_URL
                              Parameters:@{@"uid":_uid, @"token":_token}
                                        Success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                                            [hud hideAnimated:YES];
                                            id errors = responseObject[@"errors"];
                                            if (errors != nil) {
                                                [self showErrorMessageAlertView:errors];
                                            } else {
                                                NSNumber *signalNum = responseObject[@"signal"];
                                                if (signalNum.integerValue == 1) {
                                                    TTUserInfoModel *userInfo = [[TTUserInfoModel alloc] initWithDictionary:responseObject[@"data"]];
                                                    NSMutableDictionary *avatarDic = userInfo.avatar;
                                                    [self getUserIconImageWithAvatarDic:avatarDic];
                                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"] forKey:k_UserInfoDic];
                                                        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:k_UserLoginType];
                                                    });
                                                    [TTAppData shareInstance].currentUser = userInfo;
                                                    SHARE_APP.isLogin = YES;
                                                    [self.tableView reloadData];
                                                } else {
                                                    [self showMessage:responseObject[@"msg"]];
                                                }
                                            }
                                            _isGetToken = NO;
                                        }
                                 Failure:^(NSError *error) {
                                     [hud hideAnimated:YES];
                                     [self showMessage:@"获取用户信息失败!"];
                                 }];
}

- (NSString *)getUserIconImageWithAvatarDic:(NSDictionary *)avatarDic {
    NSString *prefx = avatarDic[@"prefix"];
    NSString *dir = avatarDic[@"dir"];
    NSString *name = avatarDic[@"name"];
    NSString *namePostfix = avatarDic[@"namePostfix"];
    NSString *ext = avatarDic[@"ext"];
    _userIconURLStr = [NSString stringWithFormat:@"%@%@%@%@small.%@",prefx,dir,name,namePostfix,ext];
    return _userIconURLStr;
}

- (NSString *)userImagePath {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"headerImage"];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return footViewHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 100;
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:UserInfoCellIdentifier];
        cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        UIImage *image;
        NSString *name;
        NSString *content;
        if (SHARE_APP.isLogin) {
            NSString *path = [self userImagePath];
            image = [UIImage imageWithContentsOfFile:path];
            if (image == nil) {
                image = [UIImage imageNamed:@"defaultUserIcon"];
            }
            name = [TTAppData shareInstance].currentUser.username;
            content = [TTAppData shareInstance].currentUser.signature;
        } else {
            image = [UIImage imageNamed:@"defaultUserIcon"];
            name = @"登录/注册";
            content = @"登录后更精彩";
        }
        if (_userIconURLStr.length > 1) {
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_userIconURLStr] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [UIImageJPEGRepresentation(image, 1.0) writeToFile:[self userImagePath] atomically:YES];
            }];
        } else {
            cell.avatarImageView.image = image;
        }
        cell.nameLabel.text = name;
        cell.contentLabel.text = content;
        return cell;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        TwoLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:TwoLabelCellIdentifier];
        cell.leftLabel.text = @"清除缓存";
        cell.rightLabel.text = [NSString stringWithFormat:@"%.1f MB",self.cacheSize];
        return cell;
    }
    DisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:DisclosureCellIdentifier];
    if (indexPath.row == 1) {
        cell.leftLabel.text = @"反馈";
         return cell;
    } else if(indexPath.row == 2) {
        cell.leftLabel.text = @"关于";
         return cell;
    } else if(indexPath.row == 3) {
        cell.leftLabel.text = @"退出";
         return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (SHARE_APP.isLogin) {
            [self.navigationController pushViewController:[[EditUserInfoViewController alloc] init] animated:YES];
        } else {
            TTLoginViewController *loginVC = [[TTLoginViewController alloc] init];
            loginVC.loginBlock = ^(NSNumber *uid, NSString *token) {
                _uid = uid;
                _token = token;
                _isGetToken = YES;
            };
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    } else if (indexPath.section == 1 && indexPath.row ==0) {
        [SVProgressHUD show];
        [TTDataTool deletePartOfCacheInSqlite];
        [[SDImageCache sharedImageCache] clearDisk];
        [SVProgressHUD showSuccessWithStatus:@"缓存清除完毕!"];
        [self performSelector:@selector(dismissSvprogressHud) withObject:nil afterDelay:1];
        TwoLabelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.rightLabel.text = [NSString stringWithFormat:@"0.0MB"];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [self.navigationController pushViewController:[[SendFeedbackViewController alloc] init] animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        [self.navigationController pushViewController:[[AppInfoViewController alloc] init] animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 3) {
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
        [self.tableView reloadData];
        SHARE_APP.isLogin = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:k_UserLoginType];
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
- (void)showMessage:(NSString *)message {
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
