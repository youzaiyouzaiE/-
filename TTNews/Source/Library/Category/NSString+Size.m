//
//  NSString+Size.m
//  TTNews
//
//  Created by jiahui on 2017/1/23.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGFloat)stringHeightWithFont:(UIFont *)font andInZoneWidth:(CGFloat)width {
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil].size;
    return ceil(size.height);
}




@end
