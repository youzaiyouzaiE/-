//
//  TTChannelModel.h
//  TTNews
//
//  Created by jiahui on 2016/12/4.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTBaseModel.h"

@interface TTChannelModel : TTBaseModel

@property (nonatomic, strong) NSNumber *id_Channel;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *grade;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSNumber *order;

@end
