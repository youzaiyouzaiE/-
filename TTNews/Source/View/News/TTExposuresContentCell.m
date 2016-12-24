//
//  TTExposuresContentCell.m
//  TTNews
//
//  Created by jiahui on 2016/12/24.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTExposuresContentCell.h"

@interface TTExposuresContentCell () <ExposuresContentViewDelegate>

@end

@implementation TTExposuresContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    _exposureView = [[TTExposuresContentView alloc] init];
    [self.contentView addSubview:_exposureView];
    [_exposureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

+ (CGFloat)cellHeightWithImages:(NSInteger)count {
    return [TTExposuresContentView contentHeightWithImages:count] + 2;
}


#pragma mark - ExposuresContentViewDelegate
- (void)exposuresView:(TTExposuresContentView *)exposureView collectionViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
