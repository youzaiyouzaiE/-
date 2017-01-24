//
//  TTLikesIconCell.m
//  TTNews
//
//  Created by jiahui on 2017/1/23.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "TTLikesIconCell.h"
#import <UIImageView+WebCache.h>

@interface TTLikesIconCell () {
    UILabel *_likeNumberLabel;
}

@end

@implementation TTLikesIconCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    _likeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width - 35 - 80, (58 - 26)/2 , 80, 26)];
    _likeNumberLabel.textAlignment = NSTextAlignmentRight;
    _likeNumberLabel.textColor = [UIColor colorWithHexString:@"#9A9A9A"];
    _likeNumberLabel.font = FONT_Light_PF(14);
    [self.contentView addSubview:_likeNumberLabel];
//    [_likeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-35);
//        make.centerY.mas_equalTo(self.contentView.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(100, 26));
//    }];
    
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + 40*i, 9, 40, 40)];
        imageView.tag = i + 1;
        imageView.hidden = YES;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 20;
        [self.contentView addSubview:imageView];
    }
}

- (void)setLikeIconsWithURLArray:(NSArray *)array{
    NSInteger index = 0;
    for (NSString *urlStr in array) {
        if (index > 3) {
            return ;
        }
        UIImageView *imageView = [self.contentView viewWithTag:index+1];
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        index ++;
    }
}

- (void)setLikesNumber:(NSNumber *)num {
    _likeNumberLabel.text = FORMAT(@"%@ 人赞过",num);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)height {
    return  9 + 40 + 9;
}

@end
