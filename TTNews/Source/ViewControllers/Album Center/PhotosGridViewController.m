//
//  PhotosGridViewController.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/21.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "PhotosGridViewController.h"
#import "PhotoGridCell.h"
#import "PhotoTableCell.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SDImageCache.h"
#import "MWCommon.h"
#import "MWPhotoBrowser.h"
#import "MBProgressHUD.h"
#import "MWPhoto.h"

static NSString * const reuseIdentifier = @"PhotoGridCell";

@interface PhotosGridViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,PHPhotoLibraryChangeObserver,MWPhotoBrowserDelegate> {
    UIButton *titleButton;
    UIImageView *arrowImage;
    UIView *backGroundView;
    
    //
    NSMutableArray *_arrayItemSelectType;////NSNumber  是否选中对应的item
    NSMutableArray *_arrayTableContent;////PHAssetCollection 存入有图片的AssetCollection
    PHFetchResult *_currentItems;////当前显示的item里内容
    NSMutableArray *_arryTableImageAsset;
    NSUInteger _selectIndx;
    
    UIButton *_browseBut;
    UIButton *_completeBut;
    
    NSMutableArray *_arraySelectdAssets;////从相册里选中的图片
    NSMutableDictionary *_selectAssetsDic;/////选中的Asset在_currentItems里的位置（用于浏览时更改_currentItems 里的_arrayItemSelectType）
    NSMutableArray *_arrayBrowserSelectAssetsType;////NSNumber  选中图片里对应的item type 可以修改
    MWPhotoBrowser *_browser;//////预览下的查看图片
    NSArray *_copySelectdArray;
    BOOL _isBrowser;////浏览状态下查看
    PHImageRequestOptions *_options;
}

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (strong, nonatomic) NSMutableArray *photos;

@end

@implementation PhotosGridViewController

static CGSize AssetGridThumbnailSize;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrayTableContent = [NSMutableArray array];
    _arrayItemSelectType = [NSMutableArray array];
    _arryTableImageAsset = [NSMutableArray array];
    _arraySelectdAssets = [NSMutableArray array];
    _selectAssetsDic = [NSMutableDictionary dictionary];
    
    self.navigationItem.title = @"相册";
    
    [self customNavigationBar];
    [self loadImageDataFormAlbum];
    self.imageManager = [[PHCachingImageManager alloc] init];
    
    [self addCollectionView];
    [self addBottomViewAndSubVeiw];
    [self addTableViewAndBackgroudnView];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self setNeedsStatusBarAppearanceUpdate];
    
    _options = [PHImageRequestOptions new];
    _options.networkAccessAllowed = YES;
    _options.resizeMode = PHImageRequestOptionsResizeModeFast;
    _options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    _options.synchronous = false;
    _options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
//        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithDouble: progress], @"progress",
//                              self, @"photo", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_PROGRESS_NOTIFICATION object:dict];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(iClouldImageLoadComplete:)
                                                 name:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                               object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
     NSLog(@"memory warning !!!!");
    _currentItems = nil;
    _arraySelectdAssets = nil;
    _selectAssetsDic = nil;
}

- (void)iClouldImageLoadComplete:(NSNotification *)notification {
    MWPhoto *photo = [notification object];
     NSLog(@"%d",photo.index);
    PhotoGridCell *cell = (PhotoGridCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:photo.index inSection:0]];
    cell.isICloudAsset = NO;
}

- (void)loadImageDataFormAlbum
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    _currentItems = [PHAsset fetchAssetsWithOptions:options];
//    NSLog(@"照片流？所有照片？ content:%d,", _currentItems.count);
    
    PHFetchResult *fetchResults = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
//    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];//////同上
    [fetchResults enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL *stop) {
        PHFetchResult *sasets = [PHAsset fetchAssetsInAssetCollection:obj options:options];
//         NSLog(@"%@ content:%d,",obj.localizedTitle, sasets.count);
        if (sasets.count > 0 && obj.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos && obj.assetCollectionSubtype != 1000000201) {
            if (obj.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                [_arrayTableContent insertObject:obj atIndex:0];
                [_arryTableImageAsset insertObject:[sasets objectAtIndex:0] atIndex:0];
            } else {
                [_arrayTableContent addObject:obj];
                [_arryTableImageAsset addObject:[sasets objectAtIndex:0]];
            }
        }
    }];
    [topLevelUserCollections enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL *stop) {
        PHFetchResult *sasets = [PHAsset fetchAssetsInAssetCollection:obj options:options];
//         NSLog(@"%@ content:%d,",obj.localizedTitle, sasets.count);
        if (sasets.count > 0) {
            [_arrayTableContent addObject:obj];
            [_arryTableImageAsset addObject:[sasets objectAtIndex:0]];
        }
    }];
    [self defaultItemSelectType];
}

- (void)defaultItemSelectType {
    [_arrayItemSelectType removeAllObjects];
    for (int i = 0; i < _currentItems.count; i++) {
        [_arrayItemSelectType addObject:[NSNumber numberWithBool:NO]];
    }
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Loop through the section fetch results, replacing any fetch results that have been updated.
//        NSMutableArray *updatedSectionFetchResults = [self.sectionFetchResults mutableCopy];
//        __block BOOL reloadRequired = NO;
//        
//        [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
//            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
//            
//            if (changeDetails != nil) {
//                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
//                reloadRequired = YES;
//            }
//        }];
//        
//        if (reloadRequired) {
//            self.sectionFetchResults = updatedSectionFetchResults;
//            [self.tableView reloadData];
//        }
        
    });
}

#pragma mark - view
-(void)customNavigationBar
{
    UIButton *cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut setFrame:CGRectMake(0, 0, 40, 40)];
    [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBut addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBut];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    self.navigationController.navigationBar.barTintColor = NAVIGATION_BAR_COLOR;
    
    titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    NSString *title =@"所有照片";
    [titleButton setTitle:@"所有照片" forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:font];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : font}];
//    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [titleButton addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleButton setFrame:CGRectMake(0, 0,  self.view.bounds.size.width - 65 *2, 44)];
//    titleButton.backgroundColor = [UIColor yellowColor];
    
    arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewArrowDown"]];
//    arrowImage.backgroundColor = [UIColor redColor];
    [arrowImage setFrame:CGRectMake((titleButton.bounds.size.width - size.width)/2 + size.width +3,(titleButton.bounds.size.height - 15)/2 , 15, 15)];
    [titleButton addSubview:arrowImage];
    self.navigationItem.titleView = titleButton;
    
    
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBut setFrame:CGRectMake(0, 0, 40, 40)];
    rightBut.hidden = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)addCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 2, 5, 2);
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width -10)/4, (self.view.bounds.size.width -10)/4);
    AssetGridThumbnailSize = [self smallSize];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[PhotoGridCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_collectionView];
}

- (void)addBottomViewAndSubVeiw
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    bottomView.backgroundColor = NAVIGATION_BAR_COLOR;
    
    _browseBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_browseBut setFrame:CGRectMake(10, 5, 50, 35)];
    [_browseBut setTitle:NSLocalizedString(@"浏览", @"Donexx") forState:UIControlStateNormal];
    [_browseBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _browseBut.enabled = NO;
    [_browseBut addTarget:self action:@selector(browseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_browseBut];
    
    
     _completeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeBut setFrame:CGRectMake(self.view.bounds.size.width - 85, 5, 78, 35)];
    [_completeBut setTitle:NSLocalizedString(@"完成", @"Donexx") forState:UIControlStateNormal];
    [_completeBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _completeBut.enabled = NO;
    [_completeBut addTarget:self action:@selector(completeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_completeBut];
    
    [self.view addSubview:bottomView];
}

- (void)addTableViewAndBackgroudnView
{
    backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backGroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    backGroundView.alpha = 0;
    [self.view addSubview:backGroundView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -self.view.bounds.size.height*2/3, self.view.bounds.size.width, self.view.bounds.size.height*2/3) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [backGroundView addGestureRecognizer:tapGesture];
}

#pragma mark - action 
- (void)cancelButtonAction:(UIButton *)button {
    [self dismissView];
}

- (void)titleButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    [self backGroundViewHiddenOrShowAnimation:button.selected];
}

- (void)backGroundViewHiddenOrShowAnimation:(BOOL)isShow {
    titleButton.selected = isShow;
    [UIView animateWithDuration:0.4 animations:^{
        if (isShow) {
            arrowImage.transform =CGAffineTransformMakeRotation(-M_PI);
            backGroundView.alpha = 1;
            _tableView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height*2/3);
        } else {
            arrowImage.transform = CGAffineTransformMakeRotation(0);
            backGroundView.alpha = 0;
            _tableView.frame = CGRectMake(0, -self.view.bounds.size.height*2/3, self.view.bounds.size.width, self.view.bounds.size.height*2/3);
        }
    }];
}

- (void)tapGestureAction:(id)sender {
    [self backGroundViewHiddenOrShowAnimation:NO];
    
}

- (void)completeButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(photoGrid:selectedAset:)]) {
        [_delegate photoGrid:self selectedAset:_arraySelectdAssets];
    }
    [self dismissView];
}

- (void)browseButtonAction:(UIButton *)sender {
    if (!_arrayBrowserSelectAssetsType) {
        _arrayBrowserSelectAssetsType = [NSMutableArray array];
    } else {
        [_arrayBrowserSelectAssetsType removeAllObjects];
    }
    NSMutableArray *photos = [NSMutableArray array];
    [_arraySelectdAssets enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        MWPhoto *photo = [MWPhoto photoWithAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight)];
        [photos addObject:photo];
        [_arrayBrowserSelectAssetsType addObject:[NSNumber numberWithBool:YES]];
    }];
    _photos = photos;
    _browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    _browser.displayActionButton = NO;
    _browser.displayNavArrows = NO;
    _browser.displaySelectionButtons = YES;
    _browser.alwaysShowControls = NO;
    _browser.zoomPhotosToFill = YES;
    _browser.enableGrid = NO;
    _browser.startOnGrid = NO;
    _browser.enableSwipeToDismiss = NO;
    _browser.autoPlayOnAppear = NO;
     [_browser setCurrentPhotoIndex:0];
    [self.navigationController pushViewController:_browser animated:YES];
    _isBrowser = YES;
    
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)checkToolbarButtonType {
    if (_arraySelectdAssets.count > 0) {
        _browseBut.enabled = YES;
        _completeBut.enabled = YES;
        [_completeBut setTitle:FORMAT(@"完成(%lu)", (unsigned long)_arraySelectdAssets.count) forState:UIControlStateNormal];
        [_browseBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_completeBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    } else {
        _browseBut.enabled = NO;
        _completeBut.enabled = NO;
        [_completeBut setTitle:@"完成" forState:UIControlStateNormal];
        [_browseBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_completeBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

#pragma mark - data
- (void)setPhotoSelected:(BOOL)selected atIndex:(NSUInteger)index////set Value
{
    PhotoGridCell *cell = (PhotoGridCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (_arraySelectdAssets.count + _alreadyHaveNum == _maxSelected && selected) {
        [[UITools shareInstance] showMessageToView:self.view message:[NSString stringWithFormat:@"最多选择%ld张图片",(long)_maxSelected] autoHide:YES];
        cell.selectButton.selected = NO;
        return ;
    }
    if (cell.isICloudAsset && selected) {
        [[UITools shareInstance] showMessageToView:self.view message:@"此图片在iColud上,点击图片获取" autoHide:YES];
        cell.selectButton.selected = NO;
        return ;
    }
    
    [_arrayItemSelectType setObject:[NSNumber numberWithBool:selected] atIndexedSubscript:index];
    PHAsset *asset = _currentItems[index];
    if (selected) {
        [_arraySelectdAssets addObject:asset];
        [_selectAssetsDic setObject:[NSNumber numberWithInteger:index] forKey:asset.localIdentifier];
    } else {
        [_arraySelectdAssets removeObject:asset];
        [_selectAssetsDic removeObjectForKey:asset.localIdentifier];
    }
    [self checkToolbarButtonType];
}

- (void)setBrowserSelectedItemType:(BOOL)select atIndex:(NSUInteger)index {
    [_arrayBrowserSelectAssetsType setObject:[NSNumber numberWithBool:select] atIndexedSubscript:index];
    PHAsset *asset = _copySelectdArray[index];
    if (select) {
        [_arraySelectdAssets addObject:asset];
    } else {
        [_arraySelectdAssets removeObject:asset];
    }
    
    NSInteger realSelectIndx = [self currentItemsIndexWihtAssetLocalIdentifier:asset.localIdentifier];
    /////修改真实选择数组选择状态
    [_arrayItemSelectType setObject:[NSNumber numberWithBool:select] atIndexedSubscript:realSelectIndx];
    
    ////更改Cell 上的选择状态
    PhotoGridCell *cell = (PhotoGridCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:realSelectIndx inSection:0]];
    cell.selectButton.selected = select;
    
    [self checkToolbarButtonType];
}

- (NSInteger)currentItemsIndexWihtAssetLocalIdentifier:(NSString *)identifier{
    return ((NSNumber *)[_selectAssetsDic objectForKey:identifier]).intValue;
}

#pragma mark - load album source
- (CGSize)smallSize {
     CGFloat scale = [UIScreen mainScreen].scale;
    return CGSizeMake((self.view.bounds.size.width -10) * scale/4, (self.view.bounds.size.width -10) * scale/4);
}

- (CGSize)targetSizeWithSize:(CGRect)bounds {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(CGRectGetWidth(bounds) * scale, CGRectGetHeight(bounds) * scale);
    return targetSize;
}

- (void)loadTableViewImageView {
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _currentItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = _currentItems[indexPath.item];
    PhotoGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.photoGridController = self;
    cell.index = indexPath.row;
    cell.representedAssetIdentifier = asset.localIdentifier;
//     NSLog(@"%@",asset.localIdentifier);
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:nil
                                                resultHandler:^(NSData *imageData, NSString *dataUTI,UIImageOrientation orientation, NSDictionary *info) {
                                                    if (imageData == nil) {
//                                                         NSLog(@"data is nil");
                                                    }
                                                        if([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                                                        cell.isICloudAsset = YES;
//                                                             NSLog(@" is iColud");
                                                    } else
                                                        cell.isICloudAsset = NO;
                                                }];
    
//    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:AssetGridThumbnailSize contentMode:PHImageContentModeAspectFit options:_options resultHandler:^(UIImage * result, NSDictionary *info) {
//        if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
//            cell.imageView.image = result;
//        }
//        if([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
//            cell.isICloudAsset = YES;
//        } else
//            cell .isICloudAsset = NO;
//    }];
    
    [self.imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:_options
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  // Set the cell's thumbnail image if it's still showing the same asset.
                                  if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                      cell.imageView.image = result;
                                  }
                                  if([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                                      cell.isICloudAsset = YES;
                                  }
                              }];
    if (_arrayItemSelectType.count > 0) {
        cell.selectButton.selected = [(NSNumber *)_arrayItemSelectType[indexPath.row] boolValue];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photos = [NSMutableArray array];
    [_currentItems enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        MWPhoto *photo = [MWPhoto photoWithAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight)];
        [photos addObject:photo];
    }];
    _photos = photos;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = YES;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:indexPath.row];
    [self.navigationController pushViewController:browser animated:YES];
    _isBrowser = NO;
 }

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if (photoBrowser == _browser ) {
        _copySelectdArray = nil;
        _copySelectdArray = [_arraySelectdAssets copy];
    }
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    if (photoBrowser == _browser) {
        return [(NSNumber *)_arrayBrowserSelectAssetsType[index] boolValue];
    } else
        return  [(NSNumber *)_arrayItemSelectType[index] boolValue];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    
    if (photoBrowser == _browser) {
        [self setBrowserSelectedItemType:selected atIndex:index];
        #warning FUNCTION
    } else {
        if (_arraySelectdAssets.count + _alreadyHaveNum == _maxSelected && selected) {
            [[UITools shareInstance] showMessageToView:photoBrowser.view message:[NSString stringWithFormat:@"最多选择%ld张图片",(long)_maxSelected] autoHide:YES];
            [photoBrowser setCurrentPhotoSelectedButtonType:NO];
            return ;
        }
        PhotoGridCell *cell = (PhotoGridCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        if (cell.isICloudAsset && selected) {
            [photoBrowser setCurrentPhotoSelectedButtonType:NO];
            return ;
        }
        [self setPhotoSelected:selected atIndex:index];
        cell.selectButton.selected = selected;
    }
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
     NSLog(@"finished ");
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayTableContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const cellIdentifier = @"PHimageCell";
    PhotoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PhotoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == _selectIndx) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else
        cell.accessoryType = UITableViewCellAccessoryNone;
    PHAssetCollection *assetCollection = _arrayTableContent[indexPath.row];
    PHFetchResult *sasets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    [cell setImage:nil title:assetCollection.localizedTitle andNumberContent:[NSString stringWithFormat:@"%lu",(unsigned long)sasets.count]];
    
    PHAsset *imageAsset = _arryTableImageAsset[indexPath.item];
    [self.imageManager requestImageForAsset:imageAsset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                      cell.coverImageView.image = result;
                              }];
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectIndx == indexPath.row) {
        [self backGroundViewHiddenOrShowAnimation:NO];
        return ;
    }
    _selectIndx = indexPath.row;
    PHAssetCollection *assetCollection = _arrayTableContent[indexPath.row];
    [self modifyCurrentItemsContentWihtAssetCollection:assetCollection];
    [self modifyNavigationTitleButtionWithString:assetCollection.localizedTitle];
}

- (void)modifyCurrentItemsContentWihtAssetCollection:(PHAssetCollection *)collection {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    _currentItems = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    [self defaultItemSelectType];
    [self.collectionView reloadData];
    [self.tableView reloadData];
    [self backGroundViewHiddenOrShowAnimation:NO];
    [_arraySelectdAssets removeAllObjects];
    [_selectAssetsDic removeAllObjects];
    [self checkToolbarButtonType];
}

- (void)modifyNavigationTitleButtionWithString:(NSString *)titleString
{
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [titleButton setTitle:titleString forState:UIControlStateNormal];
    CGSize size = [titleString sizeWithAttributes:@{NSFontAttributeName : font}];
//    [titleButton setFrame:CGRectMake(0, 0, size.width + 3 +15, 44)];
    [arrowImage setFrame:CGRectMake((titleButton.bounds.size.width - size.width)/2 + size.width +3,(titleButton.bounds.size.height - 15)/2 , 15, 15)];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end


