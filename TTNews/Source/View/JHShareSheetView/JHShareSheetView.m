//
//  JHShareSheetView.m
//  TTNews
//
//  Created by jiahui on 2016/12/11.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "JHShareSheetView.h"
#import "JHCollectionViewQuaternionLayout.h"

@interface JHCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *iconName;

@end

@implementation JHCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _iconImage = [[UIImageView alloc] init];
//    _iconImage.backgroundColor = [UIColor purpleColor];
    _iconImage.layer.cornerRadius = 5;
    _iconImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    _iconName = [[UILabel alloc] init];
//    _iconName.backgroundColor = [UIColor redColor];
    _iconName.textAlignment = NSTextAlignmentCenter;
    _iconName.font = [UIFont systemFontOfSize:13];
//    _iconName.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_iconName];
    [_iconName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImage.mas_bottom).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(3);
        make.right.mas_equalTo(self.mas_right).offset(-3);
        make.height.mas_equalTo(15);
    }];
}

+ (CGFloat)itemHeight {
    return 5 + 40 + 5 + 15 + 5;
}

+ (CGFloat)itemWidth {
    return  40;
}

@end

@interface JHShareSheetView () <UICollectionViewDelegate,UICollectionViewDataSource,JHCollectionViewDelegateQuaternionLayout>{
    UICollectionView *_collectionView;
    UIView *_bottomView;
    
}

@property (nonatomic, copy) NSArray *arrayTitles;
@property (nonatomic, copy) NSArray *arrayImages;
@end


@implementation JHShareSheetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        
    }
    return self;
}

+ (instancetype)sheetViewGreatWithTitles:(NSArray *)titles shareImagesName:(NSArray *)images delegate:(id <JHShareSheetViewDelegate>)delegate {
    JHShareSheetView *sheetView = [[JHShareSheetView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    sheetView.arrayImages = images;
    sheetView.arrayTitles = titles;
    return sheetView;
}

- (void)setupViews {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    
    _bottomView = [[UIView alloc] init];
//    _bottomView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x000000, 0xfafafa);
    _bottomView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    [self addSubview:_bottomView];
    _bottomView.frame = CGRectMake(0, Screen_Height, Screen_Width, 130);
//    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top).offset(Screen_Height);
//        make.right.left.mas_equalTo(0);
////        make.bottom.mas_equalTo(self.mas_bottom).offset(130);
//        make.height.mas_equalTo(130);
//    }];
    
    JHCollectionViewQuaternionLayout *layout = [[JHCollectionViewQuaternionLayout alloc] init];
    layout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.bounces = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[JHCollectionViewCell class] forCellWithReuseIdentifier:@"JHCollectionViewCell"];
    [_bottomView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo([JHCollectionViewCell itemHeight]);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomView.mas_left).offset(-1);
        make.right.mas_equalTo(_bottomView.mas_right).offset(1);
        make.bottom.mas_equalTo(_bottomView.mas_bottom).offset(1);
        make.height.mas_equalTo(40);
    }];
    
    UIView *topGestureView = [[UIView alloc] init];
    topGestureView.backgroundColor = [UIColor clearColor];
    [self addSubview:topGestureView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    [topGestureView addGestureRecognizer:tapGesture];
    [topGestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(Screen_Height - 130);
    }];
}

- (void)tappedCancel {
    [UIView animateWithDuration:0.3 animations:^{
      _bottomView.frame = CGRectMake(0, Screen_Height, Screen_Width, 130);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
       _bottomView.frame = CGRectMake(0, Screen_Height-130 , Screen_Width, 130);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - JHCollectionViewDelegateTripletLayout
- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(0.f, 0, 0.f, 0);
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView {
    return 10.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView{
    return 10.f;
}

#pragma mar - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrayTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHCollectionViewCell" forIndexPath:indexPath];
//    cell.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
    cell.iconName.text = _arrayTitles[indexPath.row];
    cell.iconImage.image = [UIImage imageNamed:_arrayImages[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//     NSLog(@"select items is :%@",@(indexPath.row));
    if ([_delegate respondsToSelector:@selector(sheetViewdidSelectItemAtIndex:)]) {
        [_delegate sheetViewdidSelectItemAtIndex:indexPath.row];
    }
}

@end
