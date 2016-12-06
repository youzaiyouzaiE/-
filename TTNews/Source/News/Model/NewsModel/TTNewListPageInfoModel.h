//
//  TTNewListPageInfoModel.h
//  TTNews
//
//  Created by jiahui on 2016/12/4.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTBaseModel.h"

@interface TTNewListPageInfoModel : TTBaseModel

@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *current_page;
@property (nonatomic, strong) NSDictionary *links;
@property (nonatomic, strong) NSNumber *per_page;
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSNumber *total_pages;

@end