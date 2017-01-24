//
//  TTLikesIconCell.h
//  TTNews
//
//  Created by jiahui on 2017/1/23.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTLikesIconCell : UITableViewCell

- (void)setLikeIconsWithURLArray:(NSArray *)array;
- (void)setLikesNumber:(NSNumber *)num;

+ (CGFloat)height;

@end
