//
//  TTImagesCollectionViewCell.m
//  TTNews
//
//  Created by jiahui on 2016/12/21.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTImagesCollectionViewCell.h"

@implementation TTImagesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initComment];
    }
    return self;
}

- (void)initComment {
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"deleteImage"] forState:UIControlStateNormal];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"deleteImage_HL"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:_deleteButton];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-3);
        make.top.mas_equalTo(3);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.contentView bringSubviewToFront:_deleteButton];
}

- (void)deleteButtonAction:(UIButton *)button {
    _blockButtonAction();
}

@end
