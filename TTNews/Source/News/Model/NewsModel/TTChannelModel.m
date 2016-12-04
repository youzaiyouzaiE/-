//
//  TTChannelModel.m
//  TTNews
//
//  Created by jiahui on 2016/12/4.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTChannelModel.h"

@implementation TTChannelModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _id_Channel = value;
    } else if([key isEqualToString:@"children"]) {
        if (!_children) {
            _children = [NSMutableArray array];
        }
        for (NSDictionary *channelDic in value) {
            TTChannelModel *channel = [[TTChannelModel alloc] initWithDictionary:channelDic];
            [_children addObject:channel];
        }
    } else {
        [super setValue:value forKey:key];
    }
}

@end
