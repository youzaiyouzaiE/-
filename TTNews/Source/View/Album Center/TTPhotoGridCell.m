//
//  PhotoGridCell.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/22.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "TTPhotoGridCell.h"

@implementation TTPhotoGridCell


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Grey background
        self.backgroundColor = [UIColor colorWithWhite:0.12 alpha:1];
        
        // Image
        _imageView = [UIImageView new];
        _imageView.frame = self.bounds;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_imageView];

        // Selection button
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.contentMode = UIViewContentModeTopRight;
        _selectButton.adjustsImageWhenHighlighted = NO;
        [_selectButton setImage:[UIImage imageNamed:@"checkbox_bg"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"checkbox_click"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectionButtonPressed) forControlEvents:UIControlEventTouchDown];
//        _selectButton.hidden = YES;
        _selectButton.frame = CGRectMake(0, 0, 31, 31);
        [self addSubview:_selectButton];
    }
    return  self;
}

#pragma mark - Selection
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    _selectButton.selected = isSelected;
}

- (void)selectionButtonPressed {
    _selectButton.selected = !_selectButton.selected;
    [_photoGridController setPhotoSelected:_selectButton.selected atIndex:_index];
}

- (void)loadSubViewsFrame {
    _imageView.frame = self.bounds;
    _selectButton.frame = CGRectMake(self.bounds.size.width - _selectButton.frame.size.width - 0,
                                     0, _selectButton.frame.size.width, _selectButton.frame.size.height);
}

#pragma mark - View
- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    _selectButton.frame = CGRectMake(self.bounds.size.width - _selectButton.frame.size.width - 0, 0, _selectButton.frame.size.width, _selectButton.frame.size.height);
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _imageView.alpha = 0.6;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _imageView.alpha = 1;
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    _imageView.alpha = 1;
    [super touchesCancelled:touches withEvent:event];
}

@end
