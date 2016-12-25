//
//  TTAppData.h
//  TTNews
//
//  Created by jiahui on 2016/12/25.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTUserInfoModel.h"

extern NSString * const k_UserLoginType;
extern NSString * const k_UserInfoDic;


@interface TTAppData : NSObject

@property (nonatomic, strong) TTUserInfoModel *currentUser;

@property (nonatomic, assign) BOOL needUpdateUserIcon;//须要更我的界面，当present LoginView 登录后



+ (instancetype)shareInstance;
- (NSString *)currentUserIconURLString;

@end
