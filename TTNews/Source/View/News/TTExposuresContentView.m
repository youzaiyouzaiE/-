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
#import "SDiOSVersion.h"
#import "TTImagesCollectionViewCell.h"

@interface TTExposuresContentView () < UICollectionViewDataSource, UICollectionViewDelegate,JHCollectionViewDelegateQuaternionLayout> {
    
}

@end

@implementation TTExposuresContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _arrayImages = [NSMutableArray array];
        [self initComponents];
        [self initCollectionView];
    }
    return self;
}

- (void)initComponents {
    _titleTextField = [[UITextField alloc] init];
    _titleTextField.returnKeyType = UIReturnKeyDone;
    [self addSubview:_titleTextField];
    _titleTextField.placeholder = @"标题";
    _titleTextField.font = [UIFont systemFontOfSize:18];
    [_titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    AddLineViewInView(self, _titleTextField,1);
    
    _contentTextView = [[UITextView alloc] init];
    _contentTextView.backgroundColor = [UIColor whiteColor];
//    _contentTextView.backgroundColor = [UIColor redColor];
    _contentTextView.font = [UIFont systemFontOfSize:16];
    _contentTextView.placeholder = @"描述一下，你要爆料的内容";
    [self addSubview:_contentTextView];
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleTextField.mas_bottom).offset(5);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(100);
    }];
}

-(void)setArrayImages:(NSMutableArray *)arrayImages {
    [_arrayImages removeAllObjects];
    [_arrayImages addObjectsFromArray:arrayImages];
    [self.collectionView reloadData];
}

#define  ItemHeight  80
- (void)initCollectionView {
    JHCollectionViewQuaternionLayout *collectionLayout = [[JHCollectionViewQuaternionLayout alloc] init];
    collectionLayout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentTextView.mas_bottom).offset(5);
        make.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];;
    [_collectionView registerClass:[TTImagesCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
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

+ (CGFloat)contentHeightWithImages:(NSInteger)count {
    return 30 + 100 + 3 + + 5 + (ItemHeight + 5)* ceil(count/4.0) + 20 + 5;
}

#pragma mark - UICollectionViewDelegat
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrayImages.count +1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTImagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row == _arrayImages.count) {
        cell.deleteButton.hidden = YES;
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn"];
    } else {
        cell.imageView.image = _arrayImages[indexPath.row];
        cell.deleteButton.hidden = NO;
        __weak __typeof(self)weakSelf = self;
        cell.blockButtonAction = ^{
            [weakSelf.arrayImages removeObjectAtIndex:indexPath.row];
            [weakSelf.collectionView reloadData];
            if ([_delegate respondsToSelector:@selector(exposuresView:collectionItemDeleteBtuActionAtIndexPath:)]) {
                [_delegate exposuresView:self collectionItemDeleteBtuActionAtIndexPath:indexPath];
            }
        };
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(exposuresView:collectionViewDidSelectItemAtIndexPath:)]) {
        [_delegate exposuresView:self collectionViewDidSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - JHCollectionViewDelegateQuaternionLayout
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section {
    CGFloat width = ItemHeight;
    DeviceSize size = [SDiOSVersion deviceSize];
    if ( size == Screen3Dot5inch || size == Screen4inch) {
        width = (Screen_Width - 30 - 5*3)/4;
    }
    return CGSizeMake(width, ItemHeight);
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(5, 15, 20, 15);
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView {
    CGFloat spacing = 5;
    DeviceSize size = [SDiOSVersion deviceSize];
    if ( size == Screen3Dot5inch || size == Screen4inch) {
       
    } else {
        CGFloat itemWidth = ItemHeight;
        spacing = (Screen_Width - 30 - itemWidth * 4) /3;
    }
    return spacing;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView {
    return 5.0f;
}

@end
