//
//  TTLoginViewController.h
//  TTNews
//
//  Created by jiahui on 2016/11/16.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loginSuccessBlock)(NSNumber *, NSString *);

@interface TTLoginViewController : UIViewController

@property (nonatomic, copy) loginSuccessBlock loginBlock;

@end
