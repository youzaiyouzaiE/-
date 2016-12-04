//
//  TTTopChannelContianerView.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/29.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTTopChannelContianerView.h"
#import <DKNightVersion.h>

@interface TTTopChannelContianerView()

@property (nonatomic, weak) UIButton *lastSelectedButton;


@end

static CGFloat kTitleLabelNorimalFont = 13;
static CGFloat kTitleLabelSelectedFont = 16;
static CGFloat kAddChannelWidth = 30;
static CGFloat kSliderViewWidth = 20;
static CGFloat buttonWidth = 65;

@implementation TTTopChannelContianerView

#pragma mark 初始化View
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

#pragma mark channelNameArray的setter方法，channelNameArray
- (void)setChannelNameArray:(NSArray *)channelNameArray {
    _channelNameArray = channelNameArray;
    CGFloat buttonWidth = self.scrollView.frame.size.width/5;
    self.scrollView.contentSize = CGSizeMake(buttonWidth * channelNameArray.count + 20, 0);
    for (NSInteger i = 0; i < channelNameArray.count; i++) {
        UIButton *button = [self createChannelButton];
        button.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, self.frame.size.height);
        [button setTitle:channelNameArray[i] forState:UIControlStateNormal];
        [self.scrollView addSubview:button];
    }
    
    [self clickChannelButton:self.scrollView.subviews[0]];
}

#pragma mark 初始化子控件
- (void)initialization {
    self.alpha = 0.9;
    
    //初始化scrollView
    UIScrollView *scrollView = [self createScrollView];
    self.scrollView = scrollView;
    [self addSubview:self.scrollView];
    
    //初始化scrollView右侧的显示阴影效果的imageView
    [self addSubview:[self createSliderView]];
    
    //初始化右侧的加号button
    UIButton *button = [self createTheAddButton];
    self.addButton = button;
    [self addSubview:self.addButton];
    
}

#pragma mark 创建容纳channelButton的ScrollView
- (UIScrollView *)createScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - kAddChannelWidth, self.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    return scrollView;
}

#pragma mark 创建右侧的加号Button
- (UIButton *)createTheAddButton {
    UIButton *addChannelButton =[UIButton buttonWithType:UIButtonTypeCustom];
    addChannelButton.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x343434, 0xfafafa);
    self.addButton = addChannelButton;
    [addChannelButton setImage:[UIImage imageNamed:@"home_header_add_slim"] forState:UIControlStateNormal];
    addChannelButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - kAddChannelWidth, 0, kAddChannelWidth, kAddChannelWidth);
    [addChannelButton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
    return addChannelButton;
}

#pragma mark 初始化scrollView右侧的显示阴影效果的imageView
- (UIView *)createSliderView {
    UIImageView *slideView = [[UIImageView alloc] init];
    slideView.frame = CGRectMake(self.frame.size.width - kSliderViewWidth -kAddChannelWidth, 0, kSliderViewWidth, self.frame.size.height);
    slideView.alpha = 0.9;
    slideView.image = [UIImage imageNamed:@"slidetab_mask"];
    return slideView;
}

#pragma mark 创建ChannelButton
- (UIButton *)createChannelButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x949494, 0xfafafa);
    [button setTitleColor:[UIColor colorWithRed:243/255.0 green:75/255.0 blue:80/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [button.titleLabel setFont:[UIFont systemFontOfSize:kTitleLabelNorimalFont]];
    [button addTarget:self action:@selector(clickChannelButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark 选择了某个ChannelButton
- (void)clickChannelButton:(UIButton *)sender {
    self.lastSelectedButton.titleLabel.font = [UIFont systemFontOfSize:kTitleLabelNorimalFont];
    self.lastSelectedButton.enabled = YES;
    self.lastSelectedButton = sender;
    self.lastSelectedButton.enabled = NO;
    //选中的标签要居中，也就是scrollView的offset.x加屏幕的一半要等于标签的中心
    CGFloat newOffsetX = sender.center.x - [UIScreen mainScreen].bounds.size.width*0.5;
    if (newOffsetX < 0) {
        newOffsetX = 0;
    }
    if (newOffsetX > self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
        newOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [sender.titleLabel setFont:[UIFont systemFontOfSize:kTitleLabelSelectedFont]];
        [sender layoutIfNeeded];
        [self.scrollView setContentOffset:CGPointMake(newOffsetX, 0)];
    }];
    
    NSInteger index = [self.scrollView.subviews indexOfObject:sender];
    if ([self.delegate respondsToSelector:@selector(topChannelView:chooseChannelWithIndex:)]) {
        [self.delegate topChannelView:self chooseChannelWithIndex:index];
    }
}

#pragma mark 选中某个ChannelButton
- (void)selectChannelButtonWithIndex:(NSInteger)index {
    [self clickChannelButton:self.scrollView.subviews[index]];
}

#pragma mark 删除某个ChannelButton
- (void)deleteChannelButtonWithIndex:(NSInteger)index {
    NSInteger realIndex= index;
    [self.scrollView.subviews[realIndex] removeFromSuperview];
    //后面的button的x向左移动buuton宽度的距离
    for (NSInteger i = realIndex; i<self.scrollView.subviews.count; i++) {
        UIButton *button = self.scrollView.subviews[i];
        CGRect buttonFrame = button.frame;
        button.frame = CGRectMake(buttonFrame.origin.x - button.frame.size.width, buttonFrame.origin.y, buttonFrame.size.width, buttonFrame.size.height);
    }
    
    //将scrollView的contentSize减小一个buuton的宽度
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width - self.scrollView.frame.size.width/5, 0);
}

#pragma mark 点击addButton,展示或隐藏添加channel的View
- (void)clickAddButton:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(topChannelView:addActionWithButton:)]) {
        [self.delegate topChannelView:self addActionWithButton:button];
    }
//    [UIView animateWithDuration:0.3 animations:^{
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    
}

#pragma mark 添加新闻频道：增加scrollView的contensize，然后在最后添加一个channelButton
- (void)addAChannelButtonWithChannelName:(NSString *)channelName {
//    CGFloat buttonWidth = self.scrollView.frame.size.width/5;
    UIButton *button = [self createChannelButton];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width + buttonWidth, 0);
    button.frame = CGRectMake(self.scrollView.contentSize.width - buttonWidth , 0, buttonWidth, self.frame.size.height);
    [button setTitle:channelName forState:UIControlStateNormal];
    [self.scrollView addSubview:button];
}

#pragma mark
- (void)didShowEditChannelView:(BOOL)value {
    if (value == YES) {//显示编辑新闻频道View
        self.addButton.selected = YES;
        self.scrollView.hidden = YES;
    } else {//显示编辑新闻频道View
        self.addButton.selected = NO;
        self.scrollView.hidden = NO;
    }
}

@end
