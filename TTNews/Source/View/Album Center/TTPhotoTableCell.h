//
//  PhotoTableCell.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/22.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPhotoTableCell : UITableViewCell

@property (strong, nonatomic) UIImageView *coverImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;

- (void)setViewsFrame ;
- (void)setImage:(UIImage *)image title:(NSString *)title andNumberContent:(NSString *)content;

@end
