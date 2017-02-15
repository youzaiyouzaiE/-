//
//  PhotosGridViewController.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/21.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotosGridViewController;
@protocol PhotoGridDelegate <NSObject>

-(void)photoGrid:(PhotosGridViewController *)grid selectedAset:(NSArray *)assets;

@end


@interface PhotosGridViewController : UIViewController


@property (assign, nonatomic) id <PhotoGridDelegate> delegate;
@property (assign, nonatomic) NSInteger maxSelected;
@property (assign, nonatomic) NSInteger alreadyHaveNum;


- (void)setPhotoSelected:(BOOL)selected atIndex:(NSUInteger)index;

@end
