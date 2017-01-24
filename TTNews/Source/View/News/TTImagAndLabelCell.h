//
//  TTImagAndLabelCell.h
//  TTNews
//
//  Created by jiahui on 2017/1/25.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTImagAndLabelCell : UITableViewCell

@property (nonatomic, copy) NSString *titleString;

- (void)setImageUrlString:(NSString *)urlStr;


+ (CGFloat)height;

@end
