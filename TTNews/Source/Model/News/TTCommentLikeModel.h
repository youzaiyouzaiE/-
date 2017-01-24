//
//  TTCommentLikeModel.h
//  TTNews
//
//  Created by jiahui on 2017/1/24.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "TTBaseModel.h"

@interface TTCommentLikeModel : TTBaseModel
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, strong) NSNumber *comment_id;
@property (nonatomic, strong) NSNumber *like_id;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *user_nick;
@property (nonatomic, strong) NSNumber *user_id;
@property (nonatomic, copy) NSString *updated_at;

@end
