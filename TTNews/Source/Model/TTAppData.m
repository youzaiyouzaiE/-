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

//返回广告图片本地地址，没有返回nil ，传入nil则移除之前图片
+ (NSString *)getADImageFilePath:(NSString *)imageName {
    NSString *cacheDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *adComponentPath = [cacheDirectoryPath stringByAppendingPathComponent:@"/AD"];
    NSFileManager *mager = [NSFileManager defaultManager];
    if (![mager fileExistsAtPath:adComponentPath]) {
        if ([mager createDirectoryAtPath:adComponentPath withIntermediateDirectories:YES attributes:nil error:nil]) {
            
        } else {
            NSLog(@"创建 AD 文件夹 失败");
        }
        return nil;
    } else {///存在文件夹
        NSArray *filesName = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:adComponentPath error:nil];
        NSString *fileName = [filesName firstObject];
        if (fileName) {
            NSString *imagePath = [adComponentPath stringByAppendingPathComponent:fileName];
            if ([fileName isEqualToString:imageName]) {
                return imagePath;
            } else {//不同，移除旧图
                NSError *error = nil;
                BOOL isSuccess = [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error];
                if (!isSuccess) {
                    NSLog(@"remove small %@.JPG Error :%@",imageName,error.localizedDescription);
                    BOOL isRemove = [[NSFileManager defaultManager] removeItemAtPath:adComponentPath error:&error];
                    if (isRemove) {
                        NSLog(@"delete success");
                    }
                }
                return nil;
            }
        }
        return nil;
    }
}


#pragma mark – DATE
//返回更直观的时间
+ (NSString *)intervalSinceNow:(NSString *)theDate {
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    else if (cha/86400>1&&cha/864000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    else
    {
        //        timeString = [NSString stringWithFormat:@"%d-%"]
        NSArray *array = [theDate componentsSeparatedByString:@" "];
        //        return [array objectAtIndex:0];
        timeString = [array objectAtIndex:0];
    }
    return timeString;
}

+ (NSString *)dateFormatMMDD {
//    1.通过date方法创建出来的对象,就是当前时间对象;
    NSDate *date = [NSDate date];
    NSLog(@"now = %@", date);
    
//    2.获取当前所处时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSLog(@"now = %@", zone);
    
//    3.获取当前时区和指定时间差
    NSInteger seconds = [zone secondsFromGMTForDate:date];
    NSLog(@"seconds = %lu", seconds);
    
    NSDate *nowDate = [date dateByAddingTimeInterval:seconds];
    NSLog(@"nowDate = %@", nowDate);
    
//    创建一个时间格式化对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
//    按照什么样的格式来格式化时间
    formatter.dateFormat = @"MM月dd日";
    NSString *res = [formatter stringFromDate:date];
    return res;
}


@end
