//
//  TTExposuresContentView.h
//  TTNews
//
//  Created by jiahui on 2016/12/20.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTExposuresContentView;
@protocol ExposuresContentViewDelegate <NSObject>

@optional
- (void)exposuresView:(TTExposuresContentView *)exposureView collectionViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)exposuresView:(TTExposuresContentView *)exposureView collectionItemDeleteBtuActionAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface TTExposuresContentView : UIView

@property (nonatomic, weak) id<ExposuresContentViewDelegate> delegate;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *arrayImages;


+ (CGFloat)contentHeightWithImages:(NSInteger)count;

@end
