//
//  TTNewListModel.m
//  TTNews
//
//  Created by jiahui on 2016/12/4.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTNewListModel.h"

@implementation TTNewListModel

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _id_list = value;
    } else if([key isEqualToString:@"description"]) {
        _desc = value;
    } else
        [super setValue:value forKey:key];
    
}

@end
