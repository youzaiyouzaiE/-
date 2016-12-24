//
//  TTExposuresContentCell.h
//  TTNews
//
//  Created by jiahui on 2016/12/24.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTExposuresContentView.h"


@interface TTExposuresContentCell : UITableViewCell

@property (nonatomic, strong) TTExposuresContentView *exposureView;

+ (CGFloat)cellHeightWithImages:(NSInteger)count;

@end
