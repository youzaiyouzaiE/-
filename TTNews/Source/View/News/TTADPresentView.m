//
//  TTADPresentView.m
//  TTNews
//
//  Created by jiahui on 2017/1/18.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "TTADPresentView.h"
#import "TTAppData.h"

@interface TTADPresentView () {
   UIImageView *_adImageView;
   UIButton *_passBtn;
}

//@property (nonatomic, copy) NSString *imagePath;

@end

@implementation TTADPresentView

+ (instancetype)showADImageView {
//    return nil;
    NSString *adComponentPath = [TTAppData getADDocumentPath];
    NSArray *filesName = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:adComponentPath error:nil];
    NSString *fileName = [filesName firstObject];
    if (fileName) {
        NSString *imagePath = [adComponentPath stringByAppendingPathComponent:fileName];
        TTADPresentView *adImageView = [[TTADPresentView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        [adImageView installCommpentsWithImagePath:imagePath];
        [[UIApplication sharedApplication].keyWindow addSubview:adImageView];
        return adImageView;
    } else
        return  nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)installCommpentsWithImagePath:(NSString *)imagePath {
    // 1.广告图片
    _adImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _adImageView.userInteractionEnabled = YES;
    _adImageView.contentMode = UIViewContentModeScaleAspectFill;
    _adImageView.clipsToBounds = YES;
    _adImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    [self addSubview:_adImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAdDetail)];
    [_adImageView addGestureRecognizer:tap];
    
    _passBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_passBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_passBtn setTitle:[NSString stringWithFormat:@"跳过"] forState:UIControlStateNormal];
    _passBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_passBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _passBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
    _passBtn.layer.cornerRadius = 4;
    [self addSubview:_passBtn];
    [self bringSubviewToFront:_passBtn];
    [_passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
}

- (void)pushToAdDetail {
    [self dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoad" object:nil userInfo:nil];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
