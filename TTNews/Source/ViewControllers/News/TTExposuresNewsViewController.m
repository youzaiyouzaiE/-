//
//  TTExposuresNewsViewController.m
//  TTNews
//
//  Created by jiahui on 2016/12/17.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTExposuresNewsViewController.h"
#import "UITextView+Placeholder.h"
#import "TTLableAndTextFieldView.h"

@interface TTExposuresNewsViewController () <TTLabelAndTextFieldViewDelegate>{
    UIBarButtonItem *_rightItem;
    
    TTLableAndTextFieldView *_linkView;
    TTLableAndTextFieldView *_phoneNumView;
    TTLableAndTextFieldView *_nameView;
    TTLableAndTextFieldView *_weChatNumView;
    
    
}

@end

@implementation TTExposuresNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"爆料";
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(send)];
    self.navigationItem.rightBarButtonItem = _rightItem;
    
    [self addTapViewResignKeyboard];
    
    [self initComponents];
    // Do any additional setup after loading the view from its nib.
}

- (void)initComponents {
    UIView *backGroundView = [[UIView alloc] init];
    backGroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backGroundView];
    [backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(233);
    }];
    
    UITextField *titleTextField = [[UITextField alloc] init];
    [backGroundView addSubview:titleTextField];
    titleTextField.placeholder = @"标题";
    titleTextField.font = [UIFont systemFontOfSize:18];
    [titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    
    AddLineViewInView(backGroundView, titleTextField,1);
    
    UITextView *contentTextView = [[UITextView alloc] init];
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.font = [UIFont systemFontOfSize:16];
    contentTextView.placeholder = @"描述一下，你要爆料的内容";
    [backGroundView addSubview:contentTextView];
    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleTextField.mas_bottom).offset(5);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(80);
    }];
    
    UIButton *addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImageBtn setImage:[UIImage imageNamed:@"AlbumAddBtn"] forState:UIControlStateNormal];
    [addImageBtn setImage:[UIImage imageNamed:@"AlbumAddBtnHL"] forState:UIControlStateHighlighted];
    [addImageBtn addTarget:self action:@selector(addPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [backGroundView addSubview:addImageBtn];
    [addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentTextView.mas_bottom).offset(3);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo([UIImage imageNamed:@"AlbumAddBtn"].size);
    }];
    
     AddLineViewInView(backGroundView, addImageBtn,5);
    
    _linkView = [[TTLableAndTextFieldView alloc] init];
    _linkView.delegate = self;
    _linkView.titleLabel.text = @"原文链接";
    [backGroundView addSubview:_linkView];
    [_linkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(addImageBtn.mas_bottom).offset(3);
        make.height.mas_equalTo([TTLableAndTextFieldView height]);
    }];
    
    UIView *bottomBGView = [[UIView alloc] init];
    bottomBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBGView];
    [bottomBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backGroundView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([TTLableAndTextFieldView height] *3);
    }];
    
    _phoneNumView = [[TTLableAndTextFieldView alloc] init];
    _phoneNumView.delegate = self;
    _phoneNumView.titleLabel.text = @"联系方式";
    [bottomBGView addSubview:_phoneNumView];
    [_phoneNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([TTLableAndTextFieldView height]);
    }];
    AddLineViewInView(bottomBGView, _phoneNumView,1);
    
    _nameView = [[TTLableAndTextFieldView alloc] init];
    _nameView.delegate = self;
    _nameView.titleLabel.text = @"你的名字";
    [bottomBGView addSubview:_nameView];
    [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_phoneNumView.mas_bottom).offset(0);
        make.height.mas_equalTo([TTLableAndTextFieldView height]);
    }];
    AddLineViewInView(bottomBGView, _nameView,1);
    
    _weChatNumView = [[TTLableAndTextFieldView alloc] init];
    _weChatNumView.delegate = self;
    _weChatNumView.titleLabel.text = @"你的微信";
    [bottomBGView addSubview:_weChatNumView];
    [_weChatNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_nameView.mas_bottom).offset(0);
        make.height.mas_equalTo([TTLableAndTextFieldView height]);
    }];
}


void AddLineViewInView(UIView *superView ,UIView *underView, NSInteger underViewGap) {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    [superView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(underView.mas_bottom).offset(underViewGap);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - ActionPerform
- (void)send{
    
}

- (void)addPhotoAction {
    
}

#pragma mark - TTLabelAndTextFieldViewDelegate
- (void)labeAndTextFieldDidBeginEditing:(TTLableAndTextFieldView *)textField {
    CGRect frame = textField.frame;
    int offset = frame.origin.y + frame.size.height - (self.view.frame.size.height - 225.0);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if (offset > 0) {
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

- (void)labeAndTextFieldDidEndEditing:(TTLableAndTextFieldView *)textField {
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


