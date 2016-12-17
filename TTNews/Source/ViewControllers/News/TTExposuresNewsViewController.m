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
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+MHFacebookImageViewer.h"

@interface TTExposuresNewsViewController () <TTLabelAndTextFieldViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIBarButtonItem *_rightItem;
    
    UIView *_backGroundView;
    UIButton *_addImageBtn;
    
    TTLableAndTextFieldView *_linkView;
    TTLableAndTextFieldView *_phoneNumView;
    TTLableAndTextFieldView *_nameView;
    TTLableAndTextFieldView *_weChatNumView;
    
    NSInteger _imageIndex;
    NSMutableArray *_arraySelectImages;
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
    _arraySelectImages = [NSMutableArray array];
    _imageIndex = 0;
    
    [self initComponents];
    // Do any additional setup after loading the view from its nib.
}

- (void)initComponents {
    _backGroundView = [[UIView alloc] init];
    _backGroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backGroundView];
    [_backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10 + 30 + 1 + 5+ 80 + ((Screen_Width - 30) - 5*3)/4 + 8 + 1 + [TTLableAndTextFieldView height] );
    }];
    
    UITextField *titleTextField = [[UITextField alloc] init];
    [_backGroundView addSubview:titleTextField];
    titleTextField.placeholder = @"标题";
    titleTextField.font = [UIFont systemFontOfSize:18];
    [titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    
    AddLineViewInView(_backGroundView, titleTextField,1);
    
    UITextView *contentTextView = [[UITextView alloc] init];
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.font = [UIFont systemFontOfSize:16];
    contentTextView.placeholder = @"描述一下，你要爆料的内容";
    [_backGroundView addSubview:contentTextView];
    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleTextField.mas_bottom).offset(5);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(80);
    }];
    
    _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addImageBtn setImage:[UIImage imageNamed:@"AlbumAddBtn"] forState:UIControlStateNormal];
    [_addImageBtn setImage:[UIImage imageNamed:@"AlbumAddBtnHL"] forState:UIControlStateHighlighted];
    [_addImageBtn addTarget:self action:@selector(addPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundView addSubview:_addImageBtn];
    [_addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        NSInteger image_W = ((Screen_Width - 30) - 5*3)/4;
        make.top.mas_equalTo(contentTextView.mas_bottom).offset(3);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(image_W,image_W - 3));
    }];
    
     AddLineViewInView(_backGroundView, _addImageBtn,8);
    
    _linkView = [[TTLableAndTextFieldView alloc] init];
    _linkView.delegate = self;
    _linkView.titleLabel.text = @"原文链接";
    [_backGroundView addSubview:_linkView];
    [_linkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_addImageBtn.mas_bottom).offset(8 + 1);
        make.height.mas_equalTo([TTLableAndTextFieldView height]);
    }];
    
//    UIView *
    UIView *bottomBGView = [[UIView alloc] init];
    bottomBGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBGView];
    [bottomBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backGroundView.mas_bottom).offset(10);
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
        make.top.mas_equalTo(_phoneNumView.mas_bottom).offset(2);
        make.height.mas_equalTo([TTLableAndTextFieldView height]);
    }];
    AddLineViewInView(bottomBGView, _nameView,1);
    
    _weChatNumView = [[TTLableAndTextFieldView alloc] init];
    _weChatNumView.delegate = self;
    _weChatNumView.titleLabel.text = @"你的微信";
    [bottomBGView addSubview:_weChatNumView];
    [_weChatNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_nameView.mas_bottom).offset(2);
        make.height.mas_equalTo([TTLableAndTextFieldView height]);
    }];
}

UIView* AddLineViewInView(UIView *superView ,UIView *underView, NSInteger underViewGap) {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    [superView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(underView.mas_bottom).offset(underViewGap);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(1);
    }];
    return lineView;
}

- (void)addImageViewWithImage:(UIImage *)image inLocation:(NSInteger )index {
    NSInteger image_W = ((Screen_Width - 30) - 5*3)/4;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [_backGroundView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addImageBtn.mas_top);
        make.left.mas_equalTo(15 + (image_W +5) *index);
        make.size.mas_equalTo(CGSizeMake(image_W,image_W - 3));
    }];
    [imageView setupImageViewer];
    
    [_addImageBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        if (index == 3) {
             make.left.mas_equalTo(15 + (image_W + 5) * (index + 1) + 15);
        } else
            make.left.mas_equalTo(15 + (image_W + 5) * (index + 1));
    }];
    [self.view setNeedsLayout];
    _imageIndex ++;
    [_arraySelectImages addObject:image];
}

#pragma mark - ActionPerform
- (void)send{
    
}

- (void)addPhotoAction {
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        imagePickerController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        imagePickerController.navigationBar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];

    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        imagePickerController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        imagePickerController.navigationBar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
    }]];
    
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { }]];
    [self presentViewController:alertControl animated:YES completion:^{ }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self addImageViewWithImage:image inLocation:_imageIndex];
    [self.navigationController dismissViewControllerAnimated: YES completion:^{
    
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - TTLabelAndTextFieldViewDelegate
- (void)labeAndTextFieldDidBeginEditing:(TTLableAndTextFieldView *)view {
    CGRect frame = view.textField.frame;
    CGRect realRect = [view.textField convertRect:frame toView:self.view];
    int offset = realRect.origin.y + realRect.size.height - (self.view.frame.size.height - 230.0);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if (offset >= 0) {
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


