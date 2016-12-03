//
//  TTBaseModel.m
//  TTNews
//
//  Created by jiahui on 2016/12/3.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTBaseModel.h"

@implementation TTBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (id)valueForUndefinedKey:(NSString *)key
{
    // subclass implementation should provide correct key value mappings for custom keys
    NSLog(@"Undefined Key: %@", key);
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // subclass implementation should set the correct key value mappings for custom keys
    NSLog(@"Undefined Key: %@ key value is: %@", key, value);
}

#pragma mark - need subClass added method
///subclass implementation should do this deep
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder { // NS_DESIGNATED_INITIALIZER
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}



- (instancetype)copyWithZone:(NSZone *)zone {
    TTBaseModel *newModel = [[TTBaseModel allocWithZone:zone] init];
    return newModel;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    TTBaseModel *newModel = [[TTBaseModel allocWithZone:zone] init];
    return newModel;
}



@end
