//
//  TTBaseModel.h
//  TTNews
//
//  Created by jiahui on 2016/12/3.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTBaseModel : NSObject <NSCoding,NSCopying,NSMutableCopying>

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
