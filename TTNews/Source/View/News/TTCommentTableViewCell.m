//
//  TTCommentTableViewCell.m
//  TTNews
//
//  Created by jiahui on 2016/12/18.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTCommentTableViewCell.h"

@interface TTCommentTableViewCell () {
    UILabel *_labelComment;
}

@end

@implementation TTCommentTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
          [self initComponents];
    }
     return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initComponents];
//    }
//    return self;
//}


#define IMAGE_W         30
#define COMMENT_FONT    [UIFont systemFontOfSize:12]


- (void)initComponents {
    _imageViewPortrait = [[UIImageView alloc] init];
    _imageViewPortrait.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
    [self.contentView addSubview:_imageViewPortrait];
    [_imageViewPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(IMAGE_W, IMAGE_W));
    }];
    _imageViewPortrait.layer.masksToBounds = YES;
//    _imageViewPortrait.layer.borderWidth = 1;
    _imageViewPortrait.layer.cornerRadius = IMAGE_W/2;
    
    _labelName = [[UILabel alloc] init];
    _labelName.text = @"name";
    _labelName.textColor = [UIColor colorWithHexString:@"E5E5E5"];
    _labelName.font = COMMENT_FONT;
    [self.contentView addSubview:_labelName];
    [_labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageViewPortrait.mas_right).offset(10);
        make.top.mas_equalTo(_imageViewPortrait.mas_top).offset((IMAGE_W - 16)/2);
        make.right.mas_equalTo (self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(16);
    }];
    
    _labelComment = [[UILabel alloc] init];
    _labelComment.textColor = [UIColor blackColor];
    _labelComment.numberOfLines = 0;
    _labelComment.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_labelComment];
    [_labelComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageViewPortrait.mas_bottom);
        make.left.mas_equalTo(_labelName.mas_left);
        make.right.mas_equalTo (self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(22);
    }];
    
    _labeDate = [[UILabel alloc] init];
    _labeDate.text = @"name";
    _labeDate.textColor = [UIColor colorWithHexString:@"E5E5E5"];
    _labeDate.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_labeDate];
    [_labeDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labelComment.mas_bottom).offset(5);
        make.left.mas_equalTo(_labelName.mas_left);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(16);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentStr:(NSString *)commentStr {
    _labelComment.text = commentStr;
    _commentStr = commentStr;
    CGSize size = [commentStr boundingRectWithSize:CGSizeMake(Screen_Width - 15 - IMAGE_W - 10 - 15, MAXFLOAT) options:MAXFLOAT attributes:@{NSFontAttributeName:COMMENT_FONT} context:nil].size;
    [_labelComment mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
    }];
}


+ (CGFloat)heightWithCommentContent:(NSString *)content {
    CGSize size = [content boundingRectWithSize:CGSizeMake(Screen_Width - 15 - IMAGE_W - 10 - 15, MAXFLOAT) options:MAXFLOAT attributes:@{NSFontAttributeName:COMMENT_FONT} context:nil].size;
    return 6 + IMAGE_W + size.height + 5 + 16 + 5;
}

@end