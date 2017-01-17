//
//  TTNewsArticleInfo.h
//  TTNews
//
//  Created by jiahui on 2016/12/19.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTBaseModel.h"

@interface TTNewsArticleInfo : TTBaseModel ///article_info  评论信息

@property (nonatomic, strong) NSNumber *article_id;
@property (nonatomic, strong) NSNumber *view_num;
@property (nonatomic, strong) NSNumber *comment_num;

@end
