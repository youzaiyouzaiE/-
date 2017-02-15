//
//  TTExposuresNewsViewController.m
//  TTNews
//
//  Created by jiahui on 2016/12/17.
//  Copyright © 2016年 TTNews. All rights reserved.
//

#import "TTExposuresNewsViewController.h"
#import "UITextView+Placeholder.h"
#import "TTLableAndTextFieldView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+MHFacebookImageViewer.h"
#import "MWPhotoBrowser.h"
#import "TTExposuresContentCell.h"
#import "TTLabelAndTextFieldCell.h"
#import "TTLoginViewController.h"
#import "TTRequestManager.h"
#import "TTNetworkSessionManager.h"
#import "MBProgressHUD.h"

#import "TTPhotosGridViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define k_TEXTFIELD     @"textFieldKey"
#define k_TEXTVIEW      @"textViewKey"

static const NSInteger _maxIamges = 9;

@interface TTExposuresNewsViewController () <UITextFieldDelegate, UITextViewDelegate,ExposuresContentViewDelegate,TTLabelAndTextFieldViewDelegate,MWPhotoBrowserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate,TTPhotoGridDelegate>{
    UIBarButtonItem *_rightItem;
    
    NSArray *_sectionTitleArray;
    NSMutableArray *_arraySelectImages;
    NSMutableArray *_arrayWMPhotos;
    NSMutableDictionary *_dicInputContent;
    
    CGRect _tableViewFrame;
    NSIndexPath *_editingIndexPath;
    BOOL _keyboardShowed;
    
    NSMutableData *_reveivedData;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TTExposuresNewsViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"爆料";
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(send)];
    self.navigationItem.rightBarButtonItem = _rightItem;
    _arraySelectImages = [NSMutableArray array];
    _arrayWMPhotos = [NSMutableArray array];
    _sectionTitleArray = @[@"联系方式",@"你的名字",@"你的微信"];
    _dicInputContent = [NSMutableDictionary dictionary];
    _dicInputContent[[NSIndexPath indexPathForRow:0 inSection:1]] = @"";
    _dicInputContent[[NSIndexPath indexPathForRow:2 inSection:1]] = @"";
    
    [self initTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [_tableView registerClass:[TTExposuresContentCell class] forCellReuseIdentifier:@"TTExposuresContentCell"];
    [_tableView registerClass:[TTLabelAndTextFieldCell class] forCellReuseIdentifier:@"TTLabelAndTextFieldCell"];
}

#pragma mark -- UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return  2;
    } else {
        return _sectionTitleArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return [TTExposuresContentCell cellHeightWithImages:_arraySelectImages.count +1];
    } else
        return  44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        TTExposuresContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTExposuresContentCell" forIndexPath:indexPath];
        cell.exposureView.delegate = self;
        cell.exposureView.titleTextField.delegate = self;
        cell.exposureView.contentTextView.delegate = self;
        cell.exposureView.titleTextField.text = _dicInputContent[k_TEXTFIELD];
        cell.exposureView.contentTextView.text = _dicInputContent[k_TEXTVIEW];
        cell.exposureView.arrayImages = _arraySelectImages;
        return cell;
    } else {
        TTLabelAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTLabelAndTextFieldCell" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            cell.labelTextFieldView.titleLabel.text = @"原文链接";
        } else
            cell.labelTextFieldView.titleLabel.text = _sectionTitleArray[indexPath.row];
        cell.labelTextFieldView.delegate = self;
        cell.labelTextFieldView.indexPath = indexPath;
        cell.labelTextFieldView.textField.text = _dicInputContent[indexPath];
        cell.labelTextFieldView.textField.placeholder = _sectionTitleArray[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _editingIndexPath = indexPath;
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _arraySelectImages.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _arrayWMPhotos.count) {
        return [_arrayWMPhotos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - keyboard 
- (void)keyboardDidShowNotification:(NSNotification *)notification {
    if (_keyboardShowed) {
        return;
    }
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _tableViewFrame = _tableView.frame;
    _tableView.frame = CGRectMake(_tableViewFrame.origin.x, _tableViewFrame.origin.y, _tableViewFrame.size.width, _tableViewFrame.size.height - keyboardSize.height);
    [self.tableView scrollToRowAtIndexPath:_editingIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    _keyboardShowed = YES;
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    if (!_keyboardShowed) {
        return ;
    }
   _tableView.frame = _tableViewFrame;
    _keyboardShowed = NO;
}

#pragma mark - ExposuresContentViewDelegate
- (void)exposuresView:(TTExposuresContentView *)exposureView collectionViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.row == _arraySelectImages.count) {
        if (_arraySelectImages.count >= _maxIamges) {
            [TTProgressHUD showMsg:@"最多添加9张图片!"];
            return;
        }
        [self addPhotoAction];
    } else {
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
        browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        browser.alwaysShowControls = NO; //
        browser.enableGrid = NO; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        [browser setCurrentPhotoIndex:indexPath.row];
        [self.navigationController pushViewController:browser animated:YES];
    }
}

- (void)exposuresView:(TTExposuresContentView *)exposureView collectionItemDeleteBtuActionAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    [_arraySelectImages removeObjectAtIndex:indexPath.row];
    [_arrayWMPhotos removeObjectAtIndex:indexPath.row];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
     [_dicInputContent setObject:textField.text forKey:k_TEXTFIELD];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= 50 && ![string isEqualToString:@""]) {
        [self showAlertControlWithMessage:@"主题最多输入50个字符"];
        return NO;
    }
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length >= 1000 && ![text isEqualToString:@""]) {
        [self showAlertControlWithMessage:@"内容最多输入1000个字符"];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [_dicInputContent setObject:textView.text forKey:k_TEXTVIEW];
}

#pragma mark - TTLabelAndTextFieldViewDelegate 
- (void)labeAndTextFieldDidEndEditing:(TTLableAndTextFieldView *)labelTextField {
    [_dicInputContent setObject:labelTextField.textField.text forKey:labelTextField.indexPath];
}

- (BOOL)labeAndTextField:(TTLableAndTextFieldView *)labelTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSIndexPath *index = labelTextField.indexPath;
    if (index.section == 0) {
        if (labelTextField.textField.text.length >= 225 && ![string isEqualToString:@""]) {
            return NO;
        }
    } else if (index.section == 1 && index.row == 0) {
        if (labelTextField.textField.text.length >= 50 && ![string isEqualToString:@""]) {
            [self showAlertControlWithMessage:@"联系方式最多输入50个字符"];
            return NO;
        }
    } else if (index.section == 1 && index.row == 1) {
        if (labelTextField.textField.text.length >= 30 && ![string isEqualToString:@""]) {
            [self showAlertControlWithMessage:@"名字最多输入30个字符"];
            return NO;
        }
    } else if (index.section == 1 && index.row == 2) {
        if (labelTextField.textField.text.length >= 50 && ![string isEqualToString:@""]) {
            [self showAlertControlWithMessage:@"微信最多输入50个字符"];
            return NO;
        }
    }
    return YES;
}

- (void)showAlertControlWithMessage:(NSString *)meg {
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:meg preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}]];
    [self.navigationController presentViewController:alertControl animated:YES completion:nil];
}

#pragma mark - ActionPerform
- (void)send{
    if (!SHARE_APP.isLogin) {
        [self presentLoginView];
    } else {
        if ([self checkParameters]) {
            [self sendHasImageExposureForAF];
        }
    }
}

- (void)addPhotoAction {
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        imagePickerController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        imagePickerController.navigationBar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];

    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
//            //无权限 做一个友好的提示
//            UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相册\n设置>隐私>照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alart show];
//            return ;
//        } else {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
            imagePickerController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
            imagePickerController.navigationBar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
            [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
//            TTPhotosGridViewController *photoGridVC = [[TTPhotosGridViewController alloc] init];
//            photoGridVC.delegate = self;
//            photoGridVC.maxSelected = _maxIamges;
//            photoGridVC.alreadyHaveNum = _arraySelectImages.count;
//            UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:photoGridVC];
//            [self presentViewController:navigationVC animated:YES completion:nil];
//        }
    }]];
    
    [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { }]];
    [self presentViewController:alertControl animated:YES completion:^{ }];
}

- (void)presentLoginView {
    TTLoginViewController *loginVC = [[TTLoginViewController alloc] init];
    loginVC.isPresentInto = YES;
    loginVC.loginBlock = ^(NSNumber *uid, NSString *token) { };
    UINavigationController *navitagtionVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navitagtionVC animated:YES completion:^{ }];
}

- (BOOL)checkParameters {
    if (!_dicInputContent[k_TEXTFIELD]) {
        [TTProgressHUD showMsg:@"请输入爆料标题！"];
        return NO;
    }
    if (!_dicInputContent[k_TEXTVIEW] || [_dicInputContent[k_TEXTVIEW] isEqualToString:@""] || ((NSString *)_dicInputContent[k_TEXTVIEW]).length < 2) {
        [TTProgressHUD showMsg:@"请输入爆料内容！"];
        return NO;
    }
    if (!_dicInputContent[[NSIndexPath indexPathForRow:1 inSection:1]]) {
        [TTProgressHUD showMsg:@"请输入您的名字"];
        return NO;
    }
    return YES;
}

#pragma mark - PhotoGridDelegate
- (void)photoGrid:(TTPhotosGridViewController *)grid selectedAset:(NSArray *)assets {
//    if (!_imageManager) {
//        self.imageManager = [[PHCachingImageManager alloc] init];
//    }
//    PHImageRequestOptions *option = [PHImageRequestOptions new];
//    option.synchronous = YES;
//    [assets enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * stop) {
//        [self.imageManager requestImageForAsset:asset
//                                     targetSize:[self imageAssetSize:asset]
//                                    contentMode:PHImageContentModeAspectFill
//                                        options:option
//                                  resultHandler:^(UIImage *result, NSDictionary *info) {
//                                      [self saveImageToDocument:result imageName:[AppData random_uuid]];
//                                  }];
//    }];
//    [self.collectionView reloadData];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [_arraySelectImages addObject:image];
    MWPhoto *photo = [MWPhoto photoWithImage:image];
    [_arrayWMPhotos addObject:photo];
    [self.navigationController dismissViewControllerAnimated: YES completion:^{
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - networking
- (void)sendHasImageExposureForAF {
    __block MBProgressHUD *hud = [self progressHUD];
    NSMutableArray *imageDataArr = [NSMutableArray array];
    if (_arraySelectImages.count > 0) {
        for (UIImage *image in _arraySelectImages) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [imageDataArr addObject:imageData];
        }
    }
    NSDictionary *dic = @{@"title" : _dicInputContent[k_TEXTFIELD],
                          @"desc" : _dicInputContent[k_TEXTVIEW],
                          @"link" : _dicInputContent[[NSIndexPath indexPathForRow:1 inSection:0]],
                          @"contact" : _dicInputContent[[NSIndexPath indexPathForRow:0 inSection:1]],
                          @"uname" : _dicInputContent[[NSIndexPath indexPathForRow:1 inSection:1]],
                          @"wechat" : _dicInputContent[[NSIndexPath indexPathForRow:2 inSection:1]]
                          };
    [[AFHTTPSessionManager manager] POST:TT_EXPOSURES_URL
                              parameters:nil
               constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
                                   for (NSString *key in dic.allKeys) {
                                       [formData appendPartWithFormData:[dic[key] dataUsingEncoding:NSUTF8StringEncoding]
                                                                   name:key];
                                   }
                                   for (NSData *imageData in imageDataArr) {
                                       NSInteger index = 0;
                                       [formData appendPartWithFileData:imageData
                                                                   name:@"pics[]"
                                                               fileName:[NSString stringWithFormat:@"phonto %@",@(index)]
                                                               mimeType:@"image/jpeg"];
                                       index++;
                                   }
                                }
                                progress:^(NSProgress *progress){
                                    hud.progressObject = progress;
                                }
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                     [hud hideAnimated:YES];
                                     [TTProgressHUD showDoneOnView:self.view];
                                     NSLog(@"Response: %@", responseObject);
                                 }
                                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                                     [hud hideAnimated:YES];
                                     NSLog(@"Error: %@", error);
                                 }];
}


- (MBProgressHUD *)progressHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    return hud;
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


