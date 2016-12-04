//
//  TTNewsContentViewController.m
//  TTNews
//
//  Created by jiahui on 2016/12/4.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTNewsContentViewController.h"
#import "SDCycleScrollView.h"

#import "TopTextTableViewCell.h"
#import "TopPictureTableViewCell.h"
#import "BigPictureTableViewCell.h"
#import "SinglePictureNewsTableViewCell.h"
#import "MultiPictureTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TTNewsContentViewController () <SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    SDCycleScrollView *_cycleScrollView;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TTNewsContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_hasCycleImage) {
        [self addCycleScrollView];
    }
    [self addTabelView];
    
}

- (void)addCycleScrollView {
     _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero
                                                           delegate:self
                                                   placeholderImage:[UIImage imageNamed:@"night_photoset_list_cell_icon"]];
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    _cycleScrollView.imageURLStringsGroup = @[@"http://59.110.23.172/upload/cover_pic/cover_583aa10295b68.jpeg",
                                             @"http://59.110.23.172/upload/cover_pic/cover_583d1b400be13.jpeg",
                                             @"http://59.110.23.172/upload/cover_pic/cover_583f8fdc038ce.png"];
//    _cycleScrollView.localizationImageNamesGroup = @[];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    [self.view addSubview:_cycleScrollView];
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(120);
    }];
}

-(void)addTabelView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_hasCycleImage) {
            make.top.mas_equalTo(_cycleScrollView.mas_bottom);
        } else
            make.top.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SinglePictureNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"SinglePictureCell"];
}

#pragma mark - SDCycleScrollViewDelegate 
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
}

#pragma mark -- UITableView 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SinglePictureNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SinglePictureCell"];
    
    return cell;
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
