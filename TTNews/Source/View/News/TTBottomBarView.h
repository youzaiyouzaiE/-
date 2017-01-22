//
//  TTBottomBarView.h
//  TTNews
//
//  Created by jiahui on 2017/1/22.
//  Copyright © 2017年 TTNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTBottomBarView;
@protocol TTBottomBarViewDelegate <NSObject>

@optional
- (void)writeButtonClicked:(TTBottomBarView *)bottomView;
- (void)checkCommentsButtonClicked:(TTBottomBarView *)bottomView;
- (void)storeButtonClicked:(TTBottomBarView *)bottomView isStore:(BOOL)isStore;
- (void)shareButtonClicked:(TTBottomBarView *)bottomView;

@end


@interface TTBottomBarView : UIView

@property (nonatomic, weak) id<TTBottomBarViewDelegate> delegate;
@property (nonatomic, assign) BOOL isStored;

- (void)setCommentNumber:(NSString *)numberStr;
+ (CGFloat)height;

@end
