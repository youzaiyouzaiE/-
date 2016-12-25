//
//  TTLableAndTextFieldView.m
//  TTNews
//
//  Created by jiahui on 2016/12/17.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTLableAndTextFieldView.h"

@interface TTLableAndTextFieldView () <UITextFieldDelegate>{
    
}

@end


@implementation TTLableAndTextFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor yellowColor];
        [self greateUIs];
    }
    return self;
}

#define FONT_SIZE   16
- (void)greateUIs {
    self.titleLabel = [[UILabel alloc] init];
//    _titleLabel.backgroundColor = [UIColor redColor];
    _titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE -1];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(22);
    }];
    
    _textField = [[UITextField alloc] init];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.font = [UIFont systemFontOfSize:FONT_SIZE];
    _textField.borderStyle = UITextBorderStyleNone;
    [self addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(_titleLabel.mas_right).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(30);
    }];
}

+ (CGFloat)height {
    return 40;
}

#pragma mark – UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([_delegate respondsToSelector:@selector(labeAndTextFieldShouldBeginEditing:)]) {
        return [_delegate labeAndTextFieldShouldBeginEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if([_delegate respondsToSelector:@selector(labeAndTextFieldDidBeginEditing:)]) {
        [_delegate labeAndTextFieldDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if([_delegate respondsToSelector:@selector(labeAndTextFieldShouldEndEditing:)]) {
        return [_delegate labeAndTextFieldShouldEndEditing:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([_delegate respondsToSelector:@selector(labeAndTextFieldDidEndEditing:)]) {
        [_delegate labeAndTextFieldDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([_delegate respondsToSelector:@selector(labeAndTextField:shouldChangeCharactersInRange:replacementString:)]) {
       return [_delegate labeAndTextField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
