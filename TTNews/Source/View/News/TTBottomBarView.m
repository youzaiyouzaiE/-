//
//  TTBottomBarView.m
//  TTNews
//
//  Created by jiahui on 2017/1/22.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "TTBottomBarView.h"

static const CGFloat viewHeight = 44.0f;
static const NSInteger itemButt_W = 30;
static const NSInteger itemButt_H = viewHeight - 16;
static const NSInteger buttonMarger = 15;

@interface TTBottomBarView () {
    CGFloat _writeButtonW;
    UIButton *_storeBtn;
}

@end

@implementation TTBottomBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = [UIColor colorWithHexString:@"EFEFEF"];
        [self initCommpents];
    }
    return self;
}

- (void)initCommpents {
    _writeButtonW = Screen_Width - (itemButt_W + buttonMarger)*3 - 18;
    UIButton *writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [writeButton addTarget:self action:@selector(writeCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    [writeButton setTitle:@"发表评论" forState:UIControlStateNormal];
    writeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    writeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    writeButton.titleLabel.font = FONT_Regular_PF(15);
    [writeButton setTitleColor:[UIColor colorWithHexString:@"E5E5E5"] forState:UIControlStateNormal];
    writeButton.backgroundColor = [UIColor whiteColor];
    writeButton.layer.masksToBounds = YES;
    writeButton.layer.borderColor = [UIColor colorWithHexString:@"E5E5E5"].CGColor;
    writeButton.layer.cornerRadius = 5;
    writeButton.layer.borderWidth = 0.5;
    [self addSubview:writeButton];
    [writeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(9);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(_writeButtonW);
        make.height.mas_equalTo(itemButt_H);
    }];
    
    UIButton *checkCommentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkCommentsBtn addTarget:self action:@selector(checkCommentsAction:) forControlEvents:UIControlEventTouchUpInside];
    [checkCommentsBtn setBackgroundImage:[UIImage imageNamed:@"comments"] forState:UIControlStateNormal];
    [checkCommentsBtn setBackgroundImage:[UIImage imageNamed:@"comments_HL"] forState:UIControlStateHighlighted];
    [self addSubview:checkCommentsBtn];
    [checkCommentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(writeButton.mas_right).offset(buttonMarger);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(itemButt_W - 6);
        make.width.mas_equalTo(itemButt_H - 6);
    }];
    
    UILabel *commentNumLabel = [[UILabel alloc] init];
    commentNumLabel.tag = 99;
    commentNumLabel.userInteractionEnabled = NO;
    commentNumLabel.backgroundColor = COLOR_NORMAL;
    commentNumLabel.textColor = [UIColor whiteColor];
    commentNumLabel.font = [UIFont systemFontOfSize:12];
    commentNumLabel.textAlignment = NSTextAlignmentCenter;
    commentNumLabel.layer.masksToBounds = YES;
    commentNumLabel.layer.cornerRadius = 6;
    commentNumLabel.text = @"0";
    [checkCommentsBtn addSubview:commentNumLabel];
    [commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(checkCommentsBtn.mas_top).offset(-4);
        make.right.mas_equalTo(checkCommentsBtn.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(25, 12));
    }];
    
    _storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_storeBtn setBackgroundImage:[UIImage imageNamed:@"store"] forState:UIControlStateNormal];
    [_storeBtn setBackgroundImage:[UIImage imageNamed:@"stored"] forState:UIControlStateSelected];
    [_storeBtn addTarget:self action:@selector(storeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_storeBtn];
    [_storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(checkCommentsBtn.mas_right).offset(buttonMarger + 3);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(itemButt_W);
        make.width.mas_equalTo(itemButt_H);
    }];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share_HL"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_storeBtn.mas_right).offset(buttonMarger);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(itemButt_W);
        make.width.mas_equalTo(itemButt_H);
    }];
}

#pragma mark - action perform
- (void)writeCommentAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(writeButtonClicked:)]) {
        [_delegate writeButtonClicked:self];
    }
}

- (void)checkCommentsAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(checkCommentsButtonClicked:)]) {
        [_delegate checkCommentsButtonClicked:self];
    }
}

- (void)storeAction:(UIButton *)button {
    button.selected = !button.selected;
    if ([_delegate respondsToSelector:@selector(storeButtonClicked:isStore:)]) {
        [_delegate storeButtonClicked:self isStore:button.selected];
    }
}

- (void)shareAction:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(shareButtonClicked:)]) {
        [_delegate shareButtonClicked:self];
    }
}

- (void)setIsStored:(BOOL)isStored {
    _isStored = isStored;
    _storeBtn.selected = _isStored;
}

#pragma mark – exterior
- (void)setCommentNumber:(NSString *)numberStr {
    UILabel *commentNumLabel = (UILabel *)[self viewWithTag:99];
    commentNumLabel.text = FORMAT(@"%@",numberStr);
}

+ (CGFloat)height {
    return viewHeight;
}

@end
