//
//  TTNewsContentViewController.h
//  TTNews
//
//  Created by jiahui on 2016/12/4.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTBaseViewController.h"
#import "TTChannelModel.h"

@interface TTNewsContentViewController : TTBaseViewController

@property (nonatomic, strong) TTChannelModel *channel;///频道用于拉取数据，头条为单独的接口获取数据
@property (nonatomic, assign) BOOL isFristNews;

@end
