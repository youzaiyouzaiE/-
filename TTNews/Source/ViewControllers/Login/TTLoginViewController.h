//
//  TTLoginViewController.h
//  TTNews
//
//  Created by jiahui on 2016/11/16.
//  Copyright © 2016年 jiahui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBaseViewController.h"

typedef void(^loginSuccessBlock)(NSNumber *, NSString *);

@interface TTLoginViewController : TTBaseViewController

@property (nonatomic, assign) BOOL isPresentInto;
@property (nonatomic, copy) loginSuccessBlock loginBlock;

@end
