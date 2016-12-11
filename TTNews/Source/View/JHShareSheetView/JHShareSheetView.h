//
//  JHShareSheetView.h
//  TTNews
//
//  Created by jiahui on 2016/12/11.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHShareSheetView : UIView

+ (instancetype)sheetViewGreatWithTitles:(NSArray *)titles shareImagesName:(NSArray *)images;
- (void)show;

@end
