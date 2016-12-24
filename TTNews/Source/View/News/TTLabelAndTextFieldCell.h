//
//  TTLabelAndTextFieldCell.h
//  TTNews
//
//  Created by jiahui on 2016/12/20.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTLableAndTextFieldView.h"

@interface TTLabelAndTextFieldCell : UITableViewCell

@property (nonatomic, strong) TTLableAndTextFieldView *labelTextFieldView;



+ (CGFloat)height;

@end
