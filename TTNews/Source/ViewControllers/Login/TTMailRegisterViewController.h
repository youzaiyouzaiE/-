//
//  TTMailRegisterViewController.h
//  TTNews
//
//  Created by jiahui on 2016/11/16.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBaseViewController.h"

@interface TTMailRegisterViewController : TTBaseViewController

@property (nonatomic, assign) BOOL isForgetPassword;

@property (nonatomic, copy) NSString *mailStr;
@property (nonatomic, copy) NSString *nickNameStr;

@end
