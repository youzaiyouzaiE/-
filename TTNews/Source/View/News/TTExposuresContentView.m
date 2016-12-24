//
//  TTExposuresContentView.m
//  TTNews
//
//  Created by jiahui on 2016/12/20.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTExposuresContentView.h"
#import "UITextView+Placeholder.h"

#import "JHCollectionViewQuaternionLayout.h"


@interface TTExposuresContentView () <UICollectionViewDataSource, UICollectionViewDelegate,JHCollectionViewDelegateQuaternionLayout> {
    UITextView *_contentTextView;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation TTExposuresContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initComponents];
        
    }
    return self;
}

- (void)initComponents {
    UITextField *titleTextField = [[UITextField alloc] init];
    [self addSubview:titleTextField];
    titleTextField.placeholder = @"标题";
    titleTextField.font = [UIFont systemFontOfSize:18];
    [titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    AddLineViewInView(self, titleTextField,1);
    
    _contentTextView = [[UITextView alloc] init];
    _contentTextView.backgroundColor = [UIColor clearColor];
    _contentTextView.font = [UIFont systemFontOfSize:16];
    _contentTextView.placeholder = @"描述一下，你要爆料的内容";
    [self addSubview:_contentTextView];
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleTextField.mas_bottom).offset(5);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(80);
    }];
}

- (void)initCollectionView {
    JHCollectionViewQuaternionLayout *collectionLayout = [[JHCollectionViewQuaternionLayout alloc] init];
    collectionLayout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentTextView.mas_bottom);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(120);
    }];;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
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


#pragma mark - UICollectionViewDelegat
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrayImages.count + 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - JHCollectionViewDelegateQuaternionLayout

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section {
    return CGSizeMake(70, 80);
}

//- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView {
//    
//    
//}
//
//- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView {
//    
//}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView {
    return 5.0f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView {
    return 5.0f;
}

@end
