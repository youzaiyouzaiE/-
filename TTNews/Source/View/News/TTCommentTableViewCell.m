//
//  TTCommentTableViewCell.m
//  TTNews
//
//  Created by jiahui on 2016/12/18.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTCommentTableViewCell.h"
//#import "NIAttributedLabel.h"
//#import "TTTAttributedLabel.h"

@interface TTCommentTableViewCell () {
//    NIAttributedLabel *_labelComment;
//    TTTAttributedLabel *_labelComment;
    
    UIButton *_topCommentLikeButton;
    UILabel *_topCommentNumberLabel;
    
    UILabel *_labelComment;
    
    UIButton *_deleteButton;
    UIButton *_commentShareButton;
    UILabel *_bottomCommentNumLabel;
    UIButton *_bottomCommentLikeButton;
}

@end

@implementation TTCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
          [self initComponents];
    }
     return self;
}

static const  CGFloat image_W = 40;
#define COMMENT_FONT FONT_Regular_PF(14)

- (void)initComponents {
    _imageViewPortrait = [[UIImageView alloc] init];
    _imageViewPortrait.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
    [self.contentView addSubview:_imageViewPortrait];
    [_imageViewPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(image_W, image_W));
    }];
    _imageViewPortrait.layer.masksToBounds = YES;
    _imageViewPortrait.layer.cornerRadius = image_W/2;
    
    _labelName = [[UILabel alloc] init];
    _labelName.text = @"name";
    _labelName.textColor = COLOR_HexStr(@"#4990e2");
    _labelName.font = FONT_Regular_PF(14);
    [self.contentView addSubview:_labelName];
    [_labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageViewPortrait.mas_top);
        make.left.mas_equalTo (_imageViewPortrait.mas_right).offset(15);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(120);
    }];
    
    _topCommentNumberLabel = [[UILabel alloc] init];
    _topCommentNumberLabel.font = FONT_Light_PF(12);
    _topCommentNumberLabel.text = @"999";
    _topCommentNumberLabel.hidden = YES;
    _topCommentNumberLabel.textColor = [UIColor colorWithHexString:@"#9A9A9A"];
    [self.contentView addSubview:_topCommentNumberLabel];
    [_topCommentNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageViewPortrait.mas_top);
        make.right.mas_equalTo (self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(23);
    }];
    
    _topCommentLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topCommentLikeButton setBackgroundImage:[UIImage imageNamed:@"comment_like"] forState:UIControlStateNormal];
    [_topCommentLikeButton setBackgroundImage:[UIImage imageNamed:@"comment_like_press"] forState:UIControlStateSelected];
    [_topCommentLikeButton addTarget:self action:@selector(topCommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _topCommentLikeButton.hidden = YES;
    [self.contentView addSubview:_topCommentLikeButton];
    [_topCommentLikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageViewPortrait.mas_top);
        make.right.mas_equalTo(_topCommentNumberLabel.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    _labelComment = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelComment.textColor = [UIColor blackColor];
    _labelComment.numberOfLines = 0;
    _labelComment.font = COMMENT_FONT;
    [self.contentView addSubview:_labelComment];
    [_labelComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labelName.mas_bottom).offset(8);
        make.left.mas_equalTo(_labelName.mas_left);
        make.right.mas_equalTo (self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(22);
    }];
    
    _labeDate = [[UILabel alloc] init];
    _labeDate.textColor = [UIColor colorWithHexString:@"#9A9A9A"];
    _labeDate.font = FONT_Light_PF(12);
    [self.contentView addSubview:_labeDate];
    [_labeDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labelComment.mas_bottom).offset(12);
        make.left.mas_equalTo(_labelName.mas_left);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(18);
    }];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.titleLabel.font = FONT_Light_PF(12);
    [_deleteButton setTitleColor:[UIColor colorWithHexString:@"#9A9A9A"] forState:UIControlStateNormal];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    _deleteButton.hidden = YES;
    [self.contentView addSubview:_deleteButton];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labeDate.mas_top);
        make.left.mas_equalTo(_labeDate.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(30);
    }];
    
    _commentShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentShareButton setBackgroundImage:[UIImage imageNamed:@"comment_share"] forState:UIControlStateNormal];
    [_commentShareButton setBackgroundImage:[UIImage imageNamed:@"comment_share_HL"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:_commentShareButton];
    [_commentShareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labeDate.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    _bottomCommentNumLabel = [[UILabel alloc] init];
    _bottomCommentNumLabel.font = FONT_Light_PF(12);
    _bottomCommentNumLabel.text = @"999";
    _bottomCommentNumLabel.textColor = [UIColor colorWithHexString:@"#9A9A9A"];
    [self.contentView addSubview:_bottomCommentNumLabel];
    [_bottomCommentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labeDate.mas_top);
        make.right.mas_equalTo (_commentShareButton.mas_left).offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(23);
    }];

    _bottomCommentLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomCommentLikeButton setBackgroundImage:[UIImage imageNamed:@"comment_like"] forState:UIControlStateNormal];
    [_bottomCommentLikeButton setBackgroundImage:[UIImage imageNamed:@"comment_like_press"] forState:UIControlStateSelected];
    [_bottomCommentLikeButton addTarget:self action:@selector(topCommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_bottomCommentLikeButton];
    [_bottomCommentLikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labeDate.mas_top);
        make.right.mas_equalTo(_bottomCommentNumLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
}

- (void)setIsShowTopLike:(BOOL)isShowTopLike {
    _isShowTopLike = isShowTopLike;
    _topCommentNumberLabel.hidden = !isShowTopLike;
    _topCommentLikeButton.hidden = !isShowTopLike;
    _bottomCommentLikeButton.hidden = isShowTopLike;
    _bottomCommentNumLabel.hidden = isShowTopLike;
    _commentShareButton.hidden = isShowTopLike;
}

- (void)setCanDeleteComment:(BOOL)canDeleteComment {
    _canDeleteComment = canDeleteComment;
    _deleteButton.hidden = !canDeleteComment;
}

- (void)commentContentStr:(NSString *)commentStr replyNickName:(NSString *)nickName {
      _commentStr = commentStr;
    CGSize size ;
    if (nickName.length > 0) {
        NSString *comment = @"回复";
        comment = [comment stringByAppendingFormat:@"%@: %@",nickName,commentStr];
        NSRange range = [comment rangeOfString:nickName];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:comment];
        [attString addAttribute:NSForegroundColorAttributeName value:COLOR_HexStr(@"#4990e2") range:range];
        [attString addAttribute:NSFontAttributeName value:COMMENT_FONT range:NSMakeRange(0, attString.length -1)];
        _labelComment.attributedText = attString;
        size = [_labelComment.text boundingRectWithSize:CGSizeMake(Screen_Width - 15 - image_W - 10 - 15, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:COMMENT_FONT}
                                                context:nil].size;
    } else {
        _labelComment.text = commentStr;
        size = [_labelComment.text boundingRectWithSize:CGSizeMake(Screen_Width - 15 - image_W - 10 - 15, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:COMMENT_FONT}
                                                context:nil].size;
    }
    [_labelComment mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ceil(size.height) + 2);
    }];
}

+ (CGFloat)heightWithCommentContent:(NSString *)content replyNickName:(NSString *)nickName{
    NSString *contentString = nil;
    if (nickName.length > 0) {
        contentString = [NSString stringWithFormat:@"回复%@: %@",nickName,content];
    } else
        contentString = content;
    CGSize size = [contentString boundingRectWithSize:CGSizeMake(Screen_Width - 15 - image_W - 10 - 15, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:COMMENT_FONT}
                                        context:nil].size;
    return 18 + 22 + 8 + size.height + 12 + 18 + 18;
}

#pragma mark - Action
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)topCommentButtonAction:(UIButton *)button  {
    button.selected = !button.selected;
    
}



@end
