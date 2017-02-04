//
//  SinglePictureNewsTableViewCell.m
//  TTNews
//
//  Created by  on 16/3/26.
//  Copyright © 2016年  All rights reserved.
//

#import "SinglePictureNewsTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <DKNightVersion.h>

@interface SinglePictureNewsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTittleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sourecLabel_W;
@property (weak, nonatomic) IBOutlet UILabel *labelImage;

@end
@implementation SinglePictureNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.commentCount.text = [NSString stringWithFormat:@"%d评论",arc4random()%1000];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    self.newsTittleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    _sourceLabel.layer.masksToBounds = YES;
    _sourceLabel.layer.borderColor = COLOR_HexStr(@"DCDCDC").CGColor;
    _sourceLabel.layer.borderWidth = 0.5f;
    _sourceLabel.layer.cornerRadius = 4.0f;
    _labelImage.hidden = YES;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    UIImage *placeHolderImage = [UIImage imageNamed:@"images_default"];
    if (imageUrl && imageUrl.length > 1) {
        placeHolderImage = [UIImage imageNamed:@"images_failed"];
        _labelImage.hidden = YES;
    } else
        _labelImage.hidden = NO;
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeHolderImage];
}

- (void)setContentTittle:(NSString *)contentTittle {
    _contentTittle = contentTittle;
    self.newsTittleLabel.text = contentTittle;
}

- (void)setSourceLabelText:(NSString *)text {
    if (text.length < 1) {
        _sourceLabel.hidden = YES;
        return ;
    } else
        _sourceLabel.hidden = NO;
    _sourceLabel.text = text;
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(200, _sourceLabel.height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:_sourceLabel.font}
                                     context:nil].size;
    _sourecLabel_W.constant = ceil(size.width + 10);
}

+ (CGFloat)height {
    return 97;
}


@end
