//
//  PhotosGridViewController.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/21.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTPhotosGridViewController;
@protocol TTPhotoGridDelegate <NSObject>

-(void)photoGrid:(TTPhotosGridViewController *)grid selectedAset:(NSArray *)assets;

@end


@interface TTPhotosGridViewController : UIViewController


@property (assign, nonatomic) id <TTPhotoGridDelegate> delegate;
@property (assign, nonatomic) NSInteger maxSelected;
@property (assign, nonatomic) NSInteger alreadyHaveNum;


- (void)setPhotoSelected:(BOOL)selected atIndex:(NSUInteger)index;

@end
