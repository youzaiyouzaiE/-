//
//  NSObject+Extension.m
//  TTNews
//
//  Created by jiahui on 2016/11/18.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)
- (BOOL)isEmptyObj
{
    if (self==nil) {
        return YES;
    }
    if (self==NULL) {
        return YES;
    }
    if (self==[NSNull null]) {
        return YES;
    }
    if ([self isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *) self;
        if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
            return YES;
        }
        if ([str isEqualToString:@"(null)"]) {
            return YES;
        }
        return NO;
    }
    if ([self isKindOfClass:[NSData class]]) {
        return [((NSData *)self) length]<=0;
    }
    if ([self isKindOfClass:[NSDictionary class]]) {
        return [((NSDictionary *)self) count]<=0;
    }
    if ([self isKindOfClass:[NSArray class]]) {
        return [((NSArray *)self) count]<=0;
    }
    if ([self isKindOfClass:[NSSet class]]) {
        return [((NSSet *)self) count]<=0;
    }
    return NO;
}

@end
