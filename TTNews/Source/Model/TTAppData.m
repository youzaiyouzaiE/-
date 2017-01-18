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

- (NSString *)currentUserIconURLString {
    NSDictionary *avatarDic = _currentUser.avatar;
    NSString *prefx = avatarDic[@"prefix"];
    NSString *dir = avatarDic[@"dir"];
    NSString *name = avatarDic[@"name"];
    NSString *namePostfix = avatarDic[@"namePostfix"];
    NSString *ext = avatarDic[@"ext"];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@%@%@small.%@",prefx,dir,name,namePostfix,ext];
    return URLStr;
}

#pragma mark - FilePath
+ (NSString *)getCachesDirectoryDocumentPath:(NSString *)documentName {//创建文件夹
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cacheDirectoryPath stringByAppendingPathComponent:documentName];
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:path]) {
        NSLog(@"File not found Couldn't find the file at path: %@",path);
        if ([mager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
            return path;
        } else {
            NSLog(@"创建 %@ 失败",documentName);
            return nil;
        }
    } else
        return path;
}

///得到广告文件地址
+ (NSString *)getADDocumentPath {
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *adComponentPath = [cacheDirectoryPath stringByAppendingPathComponent:@"/AD"];
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:adComponentPath]) {
        if ([mager createDirectoryAtPath:adComponentPath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return adComponentPath;
        } else {
            NSLog(@"创建 AD 文件夹 失败");
            return nil;
        }
    } else
        return adComponentPath;
}

//返回广告图片本地地址，没有返回nil 有对比是否相同，不同删旧图，返回空
+ (NSString *)getADImageFilePath:(NSString *)imageName {
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *adComponentPath = [cacheDirectoryPath stringByAppendingPathComponent:@"/AD"];
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:adComponentPath]) {
        if ([mager createDirectoryAtPath:adComponentPath withIntermediateDirectories:YES attributes:nil error:nil]) {
            
        } else {
            NSLog(@"创建 AD 文件夹 失败");
            return nil;
        }
         return nil;
    } else {///存在文件夹
        NSArray *filesName = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:adComponentPath error:nil];
        NSString *fileName = [filesName firstObject];
        if (fileName) {
              NSString *imagePath = [adComponentPath stringByAppendingPathComponent:imageName];
            if ([fileName isEqualToString:imageName]) {
                return imagePath;
            } else {//不同，移除旧图
                 NSError *error = nil;
                if (![[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error]) {
                    [[NSFileManager defaultManager] removeItemAtPath:adComponentPath error:&error];
                }
                return nil;
            }
        }
        return nil;
    }
        return nil;
}

@end
