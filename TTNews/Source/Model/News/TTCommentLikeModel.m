//
//  TTCommentLikeModel.m
//  TTNews
//
//  Created by jiahui on 2017/1/24.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "TTCommentLikeModel.h"

@implementation TTCommentLikeModel

-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _like_id = value;
    } else
        [super setValue:value forKey:key];
}

@end
