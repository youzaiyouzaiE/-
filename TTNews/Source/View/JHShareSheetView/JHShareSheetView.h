//
//  JHShareSheetView.h
//  TTNews
//
//  Created by jiahui on 2016/12/11.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHShareSheetViewDelegate <NSObject>

@optional
- (void)sheetViewdidSelectItemAtIndex:(NSInteger)index;

@end

@interface JHShareSheetView : UIView

@property (nonatomic, weak) id<JHShareSheetViewDelegate> delegate;

+ (instancetype)sheetViewGreatWithTitles:(NSArray *)titles shareImagesName:(NSArray *)images delegate:(id <JHShareSheetViewDelegate>)delegate ;
- (void)show;

@end
