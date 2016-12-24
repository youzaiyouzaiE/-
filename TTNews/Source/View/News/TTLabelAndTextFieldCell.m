//
//  TTLabelAndTextFieldCell.m
//  TTNews
//
//  Created by jiahui on 2016/12/20.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTLabelAndTextFieldCell.h"


@implementation TTLabelAndTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    _labelTextFieldView = [[TTLableAndTextFieldView alloc] init];
    [self.contentView addSubview:_labelTextFieldView];
    [_labelTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

+ (CGFloat)height {
    return 42;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
