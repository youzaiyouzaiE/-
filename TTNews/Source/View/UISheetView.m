//
//  UISheetView.m
//  Meet
//
//  Created by jiahui on 16/5/10.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "UISheetView.h"

#define TABLE_CELL_H        44
#define TABLE_SECTION_GAP   5

#define Screen_Height                       [UIScreen mainScreen].bounds.size.height

@interface UISheetView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate> {
    NSArray *_arrayContents;
    CGRect _frame;
    NSString *_titleMessage;
     NSInteger _activeItem;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation UISheetView

- (instancetype)initWithContenArray:(NSArray *)array titleMessage:(NSString *)message andActiveItem:(NSInteger)item {
    self = [super init];
    if (self) {
        _activeItem = item;
        self = [self initWithContenArray:array titleMessage:message];
    }
    return self;
}

- (instancetype)initWithContenArray:(NSArray *)array titleMessage:(NSString *)message {
    self = [super init];
    if (self) {
        if (message != nil && message.length > 0 && ![message isEqualToString:@""]) {
            _titleMessage = message;
        } else
            _titleMessage = nil;
       self = [self initWithContenArray:array];
    }
    return self;
}


- (instancetype)initWithContenArray:(NSArray *)array {
    self = [super init];
    if (self) {
        _arrayContents = array;
        if (_arrayContents && _arrayContents.count >= 2) {
            self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            [self loadContentView];
        }
    }
    return self;
}

- (void)loadContentView {
    if (_arrayContents == nil) {
        return;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Screen_Height + self.bounds.size.height, self.bounds.size.width, _arrayContents.count * TABLE_CELL_H + TABLE_SECTION_GAP) style:UITableViewStylePlain];
    if (_titleMessage) {
        _tableView.frame = CGRectMake(0, Screen_Height + self.bounds.size.height, self.bounds.size.width, (_arrayContents.count + 1) * TABLE_CELL_H + TABLE_SECTION_GAP);
    }
    _frame = self.tableView.frame;
    self.tableView.scrollEnabled = NO;
    [self addSubview:self.tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    if(IOS_7LAST){
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 1, 0, 0);
    }
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

#pragma mark - tapAction 
- (void)tapGestureAction:(id)sender {
    [self hidden];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint pointInTab = [gestureRecognizer locationInView:_tableView];
    if (pointInTab.y > 0) {
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_titleMessage) {
            return _arrayContents.count;
        } else {
            return _arrayContents.count - 1;
        }
    }else if (section == 1) {
        return 1;
    } else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return TABLE_SECTION_GAP;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLE_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    if (indexPath.section == 0) {
        if (_titleMessage) {
            if (indexPath.row == 0) {
                cell.textLabel.text = _titleMessage;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.textColor = [UIColor lightGrayColor];
            } else
                cell.textLabel.text = _arrayContents[indexPath.row -1];
        } else
            cell.textLabel.text = _arrayContents[indexPath.row];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = _arrayContents.lastObject;
    }
    
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(sheetView:didSelectRowAtIndex:)]) {
        NSInteger index;
        if (!_titleMessage) {
            if (indexPath.section == 0) {
                index = indexPath.row;
            } else {
                index = _arrayContents.count - 1;
            }
        } else {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    return;
                }
                index = indexPath.row -1;
            } else {
                index = _arrayContents.count - 1;
            }
        }
        [self.delegate sheetView:self didSelectRowAtIndex:index];
    }
}

- (void)show {
    [self animationForShow:YES];
}

- (void)hidden {
    [self animationForShow:NO];
}

- (void)animationForShow:(BOOL)isShow {
  [UIView animateWithDuration:0.3 animations:^{
      if (isShow) {
          self.hidden = NO;
      }
      isShow ? (_tableView.frame = CGRectMake(0, Screen_Height - _tableView.bounds.size.height, CGRectGetWidth(_tableView.bounds), CGRectGetHeight(_tableView.bounds))) : (_tableView.frame = _frame );
  } completion:^(BOOL finished) {
      _isShow = isShow;
      if (!isShow) {
          self.hidden = YES;
      }
  }];
}

@end
