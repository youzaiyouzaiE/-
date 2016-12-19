//
//  TTCommentsModel.m
//  TTNews
//
//  Created by jiahui on 2016/12/19.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTCommentsModel.h"

@implementation TTCommentsModel

- (void)setValue:(id)value forKey:(nonnull NSString *)key {
    if([key isEqualToString:@"id"]){
        self.commentId = value;
    }
    else
        [super setValue:value forKey:key];
}

@end
