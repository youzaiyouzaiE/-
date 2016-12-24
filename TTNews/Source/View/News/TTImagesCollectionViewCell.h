//
//  TTImagesCollectionViewCell.h
//  TTNews
//
//  Created by jiahui on 2016/12/21.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonActionBlock)(void);

@interface TTImagesCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, copy) ButtonActionBlock blockButtonAction;


@end
