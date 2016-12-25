//
//  TTLableAndTextFieldView.h
//  TTNews
//
//  Created by jiahui on 2016/12/17.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTLableAndTextFieldView;

@protocol TTLabelAndTextFieldViewDelegate <NSObject>

@optional
- (BOOL)labeAndTextFieldShouldBeginEditing:(TTLableAndTextFieldView *)labelTextField;
- (void)labeAndTextFieldDidBeginEditing:(TTLableAndTextFieldView *)labelTextField;
- (BOOL)labeAndTextFieldShouldEndEditing:(TTLableAndTextFieldView *)labelTextField;
- (void)labeAndTextFieldDidEndEditing:(TTLableAndTextFieldView *)labelTextField;
- (BOOL)labeAndTextField:(TTLableAndTextFieldView *)labelTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end

@interface TTLableAndTextFieldView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, weak) id<TTLabelAndTextFieldViewDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;////For tableView Cell

+ (CGFloat)height;

@end
