//
//  PhotoTableCell.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/22.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "PhotoTableCell.h"

#define IMAGE_HIGHT         60
#define IMAGE_X             10

#define IMAGE_LABEL_MARGIN      7
#define LABELS_MARGIN          4
#define  LABEL_H                20

@implementation PhotoTableCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//    [self loadViews];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
//        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return self;
}

- (void)loadViews
{
    _coverImageView = [[UIImageView alloc] init];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    [_titleLabel setFont:[UIFont systemFontOfSize:[UIFont systemFontSize] + 5]];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = [UIColor lightGrayColor];
    [_contentLabel setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
    
    [self.contentView addSubview:_coverImageView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_contentLabel];
}

- (void)drawRect:(CGRect)rect {

}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setViewsFrame];
}

- (void)setViewsFrame {
    if (_coverImageView.bounds.size.height == 0) {
//        CGRect bound = self.contentView.bounds;
        _coverImageView.frame = CGRectMake(IMAGE_X,(self.contentView.bounds.size.height - IMAGE_HIGHT)/2, IMAGE_HIGHT, IMAGE_HIGHT);
        _titleLabel.frame = CGRectMake(_coverImageView.frame.origin.x + _coverImageView.frame.size.width + IMAGE_LABEL_MARGIN , (self.contentView.bounds.size.height - LABEL_H*2 - LABELS_MARGIN)/2, self.bounds.size.width - IMAGE_X - IMAGE_HIGHT - IMAGE_LABEL_MARGIN - IMAGE_X - 20, LABEL_H);
        _contentLabel.frame = CGRectMake(_titleLabel.frame.origin.x + 10, _titleLabel.frame.origin.y + LABEL_H + LABELS_MARGIN, _titleLabel.bounds.size.width ,LABEL_H);
    }
    
 
}

- (void)setImage:(UIImage *)image title:(NSString *)title andNumberContent:(NSString *)content {
    if (!image) {
        _coverImageView.image = [UIImage imageNamed:@"NOPhoto"];
    } else
        _coverImageView.image = image;
    _titleLabel.text = title;
    _contentLabel.text = content;
}


@end
