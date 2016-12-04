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

@property (nonatomic, strong) TTChannelModel *channel;
@property (nonatomic, assign) BOOL hasCycleImage;

@end
