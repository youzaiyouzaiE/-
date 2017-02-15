//
//  PhotoGridCell.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/22.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPhotosGridViewController.h"

@interface TTPhotoGridCell : UICollectionViewCell

@property (nonatomic, weak) TTPhotosGridViewController *photoGridController;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *selectButton;
@property (nonatomic) NSUInteger index;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic) BOOL isICloudAsset;

- (void)loadSubViewsFrame ;

@end
