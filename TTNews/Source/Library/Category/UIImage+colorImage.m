//
//  UIImage+colorImage.m
//  TTNews
//
//  Created by jiahui on 2017/1/21.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "UIImage+colorImage.h"

@implementation UIImage (colorImage)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
