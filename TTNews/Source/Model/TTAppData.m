//
//  TTAppData.m
//  TTNews
//
//  Created by jiahui on 2016/12/25.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTAppData.h"


NSString * const k_UserInfoDic = @"UserInfoModelDic";
NSString * const k_UserLoginType = @"UseLonginType";

@implementation TTAppData

+ (instancetype)shareInstance {
    static TTAppData *shareInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[TTAppData alloc] init];
    });
    return shareInstance;
}

@end
