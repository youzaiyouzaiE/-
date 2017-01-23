//
//  SinglePictureNewsTableViewCell.h
//  TTNews
//
//  Created by on 16/3/26.
//  Copyright © 2016年  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXNewsEntity.h"
@interface SinglePictureNewsTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *contentTittle;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


- (void)setSourceLabelText:(NSString *)text;


+ (CGFloat)height;

@end
