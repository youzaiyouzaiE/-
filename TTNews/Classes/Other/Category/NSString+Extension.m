//
//  NSString+Extension.m
//  TTNews
//
//  Created by jiahui on 2016/11/18.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

#pragma mark -- 利用正则表达式验证
- (BOOL)isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
