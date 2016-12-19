//
//  TTCommentsModel.h
//  TTNews
//
//  Created by jiahui on 2016/12/19.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTBaseModel.h"

@interface TTCommentsModel : TTBaseModel

@property (nonatomic, strong) NSNumber *commentId;
@property (nonatomic, strong) NSNumber *atricle_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, strong) NSNumber *user_id;
@property (nonatomic, copy) NSString *user_nick;
@property (nonatomic, strong) NSNumber *reply_to_id;
@property (nonatomic, strong) NSNumber *deleted_at;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, strong) NSNumber *blocked;
@property (nonatomic, copy) NSString *user_avatar;///头像
@property (nonatomic, copy) NSString *parent;

@end
