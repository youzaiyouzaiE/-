//
//  TTADPresentView.m
//  TTNews
//
//  Created by jiahui on 2017/1/18.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import "TTADPresentView.h"
#import "TTAppData.h"

//static const NSInteger remainTime = 3;

@interface TTADPresentView () {
   UIImageView *_adImageView;
//   UIButton *_passBtn;
    NSInteger _remainTime;
}


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
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAdDetail)];
//    [_adImageView addGestureRecognizer:tap];
    
    UIButton *_passBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_passBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_passBtn setTitle:[NSString stringWithFormat:@"跳过 3"] forState:UIControlStateNormal];
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
    [self changePassButtonTitle:_passBtn];
    
}

#pragma mark - action Perform
- (void)changePassButtonTitle:(UIButton *)button {
    button.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
    button.layer.borderWidth = 0;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    _remainTime = 3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(_remainTime <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self dismiss];
            });
        } else {
            int seconds = _remainTime % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:[NSString stringWithFormat:@"跳过 %d",seconds] forState:UIControlStateNormal];
            });
            _remainTime--;
        }
    });
    dispatch_resume(_timer);
}

- (void)pushToAdDetail {
    [self dismiss];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoad" object:nil userInfo:nil];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc
{
        NSLog(@"%@ -> %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end
