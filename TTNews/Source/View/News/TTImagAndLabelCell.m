//
//  TTImagAndLabelCell.m
//  TTNews
//
//  Created by jiahui on 2017/1/25.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "TTImagAndLabelCell.h"
#import <UIImageView+WebCache.h>

static const NSInteger imageSize_W  = 40;
static const NSInteger imageSize_H  =40;

@interface TTImagAndLabelCell () {
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
}

@end

@implementation TTImagAndLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 , 9, imageSize_W, imageSize_H)];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = imageSize_H /2;
    [self.contentView addSubview:_iconImageView];
    
    _titleLabel = [[UILabel alloc] init];// WithFrame:CGRectMake(Screen_Width - 35 - 80, (58 - 26)/2 , 80, 26)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor colorWithHexString:@"#9A9A9A"];
    _titleLabel.font = FONT_Light_PF(16);
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(_iconImageView.mas_right).offset(9);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
}

-(void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    _titleLabel.text = titleString;
}

- (void)setImageUrlString:(NSString *)urlStr {
     [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
}

+ (CGFloat)height {
    return  9 + imageSize_H + 9;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
