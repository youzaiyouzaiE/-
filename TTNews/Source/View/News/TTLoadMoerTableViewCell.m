//
//  TTLoadMoerTableViewCell.m
//  TTNews
//
//  Created by jiahui on 2017/1/21.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "TTLoadMoerTableViewCell.h"


@implementation TTLoadMoerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
