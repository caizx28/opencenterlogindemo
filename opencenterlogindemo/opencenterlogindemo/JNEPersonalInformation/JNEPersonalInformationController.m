//
//  JNEPersonalInformationController.m
//  puzzleApp
//
//  Created by admin on 16/7/21.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEPersonalInformationController requires ARC support."
#endif

#import "JNEPersonalInformationController.h"
//#import "UIColor+Additions.h"
#import "JNEPersonalInformationCell.h"
//#import "UIView+Screenshot.h"
//#import "UIImage+ImageEffects.h"
#import "JNEUserSettingUserSpaceCell.h"
#import "ViewController.h"
#import "JNEUserSettingDetailCell.h"
#import "JNEUserSettingQuitCell.h"
#import "JNEPlayJaneCell.h"
#import "UIAlertViewAddition.h"
//#import "BlurImageOperationQueue.h"
#import "NSDicCacheHelper.h"
#import "GetIdentifyCodeToRegisterViewController.h"
#import "GCDHelper.h"
//#import "JNEWebViewController.h"
//#import "JNECommonWebViewController.h"
//#import "JNEControllerJumpHelper.h"
//#import "JNEHistoryTemplateDownloadController.h"
#import "AFNetworkReachabilityManager.h"
//#import "UIView+Toast.h"
//#import "JNEPlayJaneWebViewControler.h" 
#import "CLReporting.h"
#define LOCAL_VIEW_RATE 0.5
#define MIN_SECTION_INSET 10

@interface JNEPersonalInformationController ()

@property (nonatomic, strong) NSArray *cellObjectArray;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, strong) UITableView *settingTableView;
@property (nonatomic, strong) UIImageView *gradientTopBar;
//@property (nonatomic, strong) JNEBlurTopBar *topBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *settingButton;
//@property (nonatomic, strong) JNEActionSheet *actionSheet;
@property (nonatomic, strong) JPSApiUser *currentUser;
//@property (nonatomic, strong) JNESwipeTransitionDelegate *transitionDelegate;

@end

@implementation JNEPersonalInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellObjectArray = [self getCellObjectArray];
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.settingTableView];
    [self.view addSubview:self.gradientTopBar];
    
    
    __weak __typeof(self)weakSelf = self;
    [[JPSApiUserManger shareInstance].currentUser obtainUserInfoWithCompletionBlock:^(id result, NSError *error) {
        if (!error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf refreshViews];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.text = NSLocalizedString(@"个人信息",nil);
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self configSubviewsFrame];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   // [JNEStatisticsHelper pageviewStartWithName:kJNEBaiduPersoninformationViewId];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [JNEStatisticsHelper pageviewEndWithName:kJNEBaiduPersoninformationViewId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshViews {
    self.cellObjectArray = [self getCellObjectArray];
    [self.settingTableView reloadData];
}


- (void)configSubviewsFrame {
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat screenHeight = CGRectGetHeight(self.view.bounds);
    CGFloat topBarHeight = 88 * LOCAL_VIEW_RATE;
    CGFloat buttonWidth = 100 * LOCAL_VIEW_RATE;
    
    self.backgroundImageView.frame = self.view.bounds;
    self.maskLayer.frame = self.view.bounds;
    self.settingTableView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    self.settingTableView.contentInset = UIEdgeInsetsMake(-MIN_SECTION_INSET, 0, 0, 0);
//    CGRect topBarFrame = CGRectMake(0, 0, screenHeight, topBarHeight);
//    self.gradientTopBar.frame = topBarFrame;
//    self.topBar.frame = topBarFrame;
//    [self.topBar hideContent];
    self.backButton.frame = CGRectMake(0, 0, buttonWidth, topBarHeight);
    self.settingButton.frame = CGRectMake(screenWidth - buttonWidth, 0, buttonWidth, topBarHeight);
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(screenWidth * 0.5, topBarHeight * 0.5);
    
}

- (NSArray *)getCellObjectArray {
    
    __weak __typeof(self)weakSelf = self;
    
    NSMutableArray *normalSection = [[NSMutableArray alloc] init];
    JNEUserSettingCellObject *userSpaceObject = [JNEUserSettingCellObject objectWithCellIdentifier:@"userSpaceCellIdentifier"
                                                                          title:nil
                                                                         detail:nil
                                                                    excuteBlock:^{
                                                                           [weakSelf userSpaceSettingAction];
                                                                       }];
    userSpaceObject.userSpace = self.currentUser.profile.userSpace;
    userSpaceObject.hideSeparatorLine = YES;
    [normalSection addObject:userSpaceObject];
    
    JNEUserSettingCellObject *myInformationObject = [JNEUserSettingCellObject objectWithCellIdentifier:@"userIconCellIdentifier"
                                                                                                 title:self.currentUser.profile.nickName
                                                                                                detail:nil
                                                                                           excuteBlock:^{
                                                                                                     [weakSelf myInformationAction];
                                                                                                 }];
    myInformationObject.userIcon = self.currentUser.profile.userIcon;
    [normalSection addObject:myInformationObject];

    NSMutableArray *myMaterial = [[NSMutableArray alloc] init];
    JNEUserSettingCellObject *myMaterialObject = [JNEUserSettingCellObject objectWithCellIdentifier:@"titleCellIdentifier"
                                                                                              title:NSLocalizedString(@"我的素材",nil)
                                                                                             detail:nil];
    [myMaterial addObject:myMaterialObject];
    [myMaterial addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"detialCellIdentifier"
                                                                       title:NSLocalizedString(@"素材库",nil)
                                                                      detail:nil
                                                                 excuteBlock:^{
                                                                        [weakSelf materialLibraryAction];
                                                                    }]];
    
    [myMaterial addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"detialCellIdentifier"
                                                                          title:NSLocalizedString(@"历史下载",nil)
                                                                         detail:nil
                                                                    excuteBlock:^{
                                                                        [weakSelf historyDownloadAction];
                                                                    }]];
    
    [myMaterial addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"detialCellIdentifier"
                                                                          title:NSLocalizedString(@"草稿箱",nil)
                                                                         detail:nil
                                                                    excuteBlock:^{
                                                                          [weakSelf draftBoxAction];
                                                                      }]];
    
    
    NSMutableArray *valueAddedService = [[NSMutableArray alloc] init];
    [valueAddedService addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"titleCellIdentifier"
                                                                              title:NSLocalizedString(@"增值服务",nil)
                                                                             detail:nil]];
    
    [valueAddedService addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"detialCellIdentifier"
                                                                              title:NSLocalizedString(@"云相册",nil)
                                                                             detail:nil
                                                                        excuteBlock:^{
                                                                            [weakSelf cloudAlbumAction];
                                                                        }]];
    
    [valueAddedService addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"detialCellIdentifier"
                                                                              title:NSLocalizedString(@"积分",nil)
                                                                             detail:nil
                                                                        excuteBlock:^{
                                                                         [weakSelf integralAction];
                                                                     }]];
    
    NSMutableArray *janeCourse = [[NSMutableArray alloc] init];
    [janeCourse addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"titleCellIdentifier"
                                                                       title:NSLocalizedString(@"简拼教程",nil)
                                                                      detail:nil]];
    
    [janeCourse addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"janeCourseCellIdentifier"
                                                                       title:NSLocalizedString(@"玩转简拼",nil)
                                                                      detail:nil excuteBlock:^{
                                                                          [weakSelf playJaneAction];
                                                                      }]];
    
    NSMutableArray *quitSection = [[NSMutableArray alloc] init];
    [quitSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"titleCellIdentifier"
                                                                              title:nil
                                                                             detail:nil]];
    
    [quitSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"quitCellIdentifier"
                                                                                                 title:nil
                                                                                                detail:nil
                                                                                           excuteBlock:^{
                                                                                               [weakSelf quitAction];
                                                                                           }]];

    
    
    return @[normalSection, myMaterial, valueAddedService, janeCourse, quitSection];
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        NSString *path = [NSString stringWithFormat:@"%@/%@.jpg",APP_CACHES_PATH, NSStringFromClass([self class])];
        UIImage *image = [FileOperate readImageWithFile:path];
        if (!image) {
            image = [UIImage imageNamed:@"shareView_bg.jpg"];
        }
        _backgroundImageView = [[UIImageView alloc] initWithImage:image];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_backgroundImageView.layer addSublayer:self.maskLayer];
    }
    return _backgroundImageView;
}

- (CALayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CALayer layer];
        _maskLayer.backgroundColor = [[[UIColor grayColor] colorWithAlphaComponent:0.86] CGColor];
    }
    return _maskLayer;
}

- (UITableView *)settingTableView {
    if (!_settingTableView) {
        _settingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _settingTableView.dataSource = self;
        _settingTableView.delegate = self;
        _settingTableView.backgroundColor = [UIColor clearColor];
        _settingTableView.sectionHeaderHeight = 0;
        _settingTableView.sectionFooterHeight = 0;
        _settingTableView.showsVerticalScrollIndicator = NO;
        _settingTableView.bounces = YES;
        _settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_settingTableView registerClass:[JNEUserSettingUserSpaceCell class] forCellReuseIdentifier:@"userSpaceCellIdentifier"];
        [_settingTableView registerClass:[JNEPersonalInformationCell class] forCellReuseIdentifier:@"userIconCellIdentifier"];
        [_settingTableView registerClass:[JNEUserSettingBaseCell class] forCellReuseIdentifier:@"titleCellIdentifier"];
        [_settingTableView registerClass:[JNEUserSettingDetailCell class] forCellReuseIdentifier:@"detialCellIdentifier"];
        [_settingTableView registerClass:[JNEPlayJaneCell class] forCellReuseIdentifier:@"janeCourseCellIdentifier"];
        [_settingTableView registerClass:[JNEUserSettingQuitCell class] forCellReuseIdentifier:@"quitCellIdentifier"];
    }
    return _settingTableView;
}

- (UIImageView *)gradientTopBar {
    if (!_gradientTopBar) {
        _gradientTopBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JNEUserSettingTopBar"]];
        _gradientTopBar.contentMode = UIViewContentModeScaleAspectFill;
        _gradientTopBar.userInteractionEnabled = YES;
    }
    return _gradientTopBar;
}

//- (JNEBlurTopBar *)topBar {
//    if (!_topBar) {
//        _topBar = [[JNEBlurTopBar alloc] initWithFrame:CGRectZero];
//        _topBar.delegate = self;
//    }
//    return _topBar;
//}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"JNEUserSettingBack"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"JNEUserSettingBack_hover"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _titleLabel.font = [UIFont systemFontOfSize:34 * LOCAL_VIEW_RATE];
        _titleLabel.textColor = [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    }
    return _titleLabel;
}

- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setImage:[UIImage imageNamed:@"JNEUserSettingSetting"] forState:UIControlStateNormal];
        [_settingButton setImage:[UIImage imageNamed:@"JNEUserSettingSetting_hover"] forState:UIControlStateHighlighted];
        [_settingButton addTarget:self action:@selector(settingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

//- (JNEActionSheet *)actionSheet {
//    if (!_actionSheet) {
//        _actionSheet = [[JNEActionSheet alloc] initWithTitlesArray:@[NSLocalizedString(@"更换封面",nil)] cancelButtonTitle:NSLocalizedString(@"取消",nil ) itemHeight:110 * MATERIALBASERATE delegate:self];
//        _actionSheet.backgroundColor = [UIColor colorWithRGBHexString:@"e8e9e9"];
//    }
//    return _actionSheet;
//}

- (JPSApiUser *)currentUser {
    if (!_currentUser) {
        _currentUser = [JPSApiUserManger shareInstance].currentUser;
    }
    return _currentUser;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellObjectArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.cellObjectArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return MIN_SECTION_INSET;
//    } else {
        return 5*ViewRateBaseOnIP6;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0;
    NSArray *array = self.cellObjectArray[indexPath.section];
    JNEUserSettingCellObject *object = array[indexPath.row];
    if ([object.identifier isEqualToString:@"userSpaceCellIdentifier"]) {
        cellHeight = 500 * ViewRateBaseOnIP6;
    } else if ([object.identifier isEqualToString:@"userIconCellIdentifier"]) {
        cellHeight = 160*ViewRateBaseOnIP6;
    }else {
        cellHeight = 88 * ViewRateBaseOnIP6;
    }
    return cellHeight;
}

- (JNEUserSettingBaseCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.cellObjectArray[indexPath.section];
    JNEUserSettingCellObject *object = array[indexPath.row];
    if (indexPath.row == array.count - 1) {
        object.hideSeparatorLine = YES;
    }
    JNEUserSettingBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:object.identifier];
    [cell configCellWithObject:object];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.cellObjectArray[indexPath.section];
    JNEUserSettingCellObject *object = array[indexPath.row];
    if (object.excuteBlock) {
        object.excuteBlock();
    }
}

#pragma mark - JNEUserImagePickerControllerDelegate

- (void)userHeadPickerController:(JNEUserImagePickerController *)controller didPickImage:(UIImage *)image {
    [self showHUD];
    NSString *tempImageKey = @"tempImageKey";
    NSString *tempCacheKey = @"tempCacheKey";
    __weak __typeof(self)weakSelf = self;
    [JNEUserImageLoader saveImageToLocalWithImage:image URLString:tempImageKey cacheKey:tempCacheKey completion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSString *localPath = [JNEUserImageLoader localPathWithURLString:tempImageKey cacheKey:tempCacheKey];
        if (controller.userImageType == JNEUserImageTypeHead) {
            [strongSelf uploadUserHeadWithLocalPath:localPath];
        } else {
            [strongSelf uploadUserSpaceWithLocalPath:localPath];
        }
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)uploadUserHeadWithLocalPath:(NSString *)path {
    __weak __typeof(self)weakSelf = self;
    [[JPSApiUserManger shareInstance].currentUser updateUserHeaderWithPhotoPath:path completionBlock:^(id result, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!error) {
            [strongSelf refreshUserWithComplteionBlock:nil];
        } else {
            [strongSelf hideHUD];
            [strongSelf showError:error];
        }
    }];
}

- (void)uploadUserSpaceWithLocalPath:(NSString *)path {
    __weak __typeof(self)weakSelf = self;
    [[JPSApiUserManger shareInstance].currentUser updateUserSpaceWithPhotoPath:path completionBlock:^(id result, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!error) {
            [strongSelf refreshUserWithComplteionBlock:nil];
        } else {
            [strongSelf hideHUD];
            [strongSelf showError:error];
        }
    }];
}


#pragma mark - JNEActionSheetDelegate

//- (void)actionSheet:(JNEActionSheet *)actionSheet didClickButton:(UIButton *)button {
//    if (button.tag == 0) {
//        [self saveBlurImageForKey:CHOOSE_PICTURE_VIEW];
//        JNEUserImagePickerController *pickerController = [[JNEUserImagePickerController alloc] init];
//        pickerController.delegate = self;
//        pickerController.userImageType = JNEUserImageTypeSpace;
//        [self presentViewController:pickerController animated:YES completion:nil];
//    }
//}
//
//- (void)actionSheetCancel:(JNEActionSheet *)actionSheet{
//    
//}
//
//#pragma mark - JNEBlurTopBarDelegate
//
//- (void)blurTopBar:(JNEBlurTopBar *)topBar animateWithAlpha:(CGFloat)alpha {
//    self.gradientTopBar.alpha = 1 - alpha;
//}

#pragma mark - JNEUserSettingUserSpaceCellDelegate

- (void)userSpaceCell:(JNEUserSettingUserSpaceCell *)cell didRefreshImage:(UIImage *)image {
    [self refreshBlurBackgroundImage:image inImageView:self.backgroundImageView];
    UIImage *homepageBlurBackground = [self getBlurImage:image];
//    [FileOperate saveImage:homepageBlurBackground withName:[NSString stringWithFormat:@"%@.jpg",NSStringFromClass([BCAHomepageController class])] toDirectory:APP_CACHES_PATH];
    [FileOperate saveImage:homepageBlurBackground withName:[NSString stringWithFormat:@"%@.jpg",@"personhear"] toDirectory:APP_CACHES_PATH];
}

#pragma mark - Login Sucess  Notificaiton

- (void)loginSucess {
    self.currentUser = [[JPSApiUserManger shareInstance] currentUser];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPSUserLoginSuccessNotification object:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat showTopbarValue = (500 * ViewRateBaseOnIP6 + MIN_SECTION_INSET) * 0.5;
    if (scrollView.contentOffset.y >= showTopbarValue) {
        
    } else {
       
    }
}

#pragma mark - private method

- (void)dismiss {
//    [[ViewController shareInstance] goBackControllerAnimated:YES];
    NSLog(@"edfdfdf");
}

- (void)saveBlurImageForKey:(NSString *)key {
    UIImage * image = [self imageByRenderingView:NO scale:1.0];
//    image  = [image applyDefaultBlurWithHeight:160.0];
    [FileOperate saveImage:image withName:[NSString stringWithFormat:@"%@.jpg",key] toDirectory:APP_CACHES_PATH];
}
-(UIImage*)imageByRenderingView:(BOOL)isOpaque  scale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, isOpaque, scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)refreshUserWithComplteionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock {
    __weak __typeof(self)weakSelf = self;
    [[JPSApiUserManger shareInstance].currentUser obtainUserInfoWithCompletionBlock:^(id result, NSError *error) {
        if (!error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf refreshViews];
            [strongSelf hideHUD];
        }
        if (completionBlock) {
            completionBlock(nil,error);
        }
    }];
}
- (void)showAlert:(NSString *)title withMessage:(NSString *)message withBtnTitle:(NSString *)btnTitle
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:btnTitle otherButtonTitles:nil,nil];
    alert.tag = 41785;
    [alert show];
}
- (void)showError:(NSError *)error {
    NSString *message = error.userInfo[@"message"];
    [self showAlert:nil withMessage:message withBtnTitle:@"确定"];
}

- (void)goBackHomepage {
    NSLog(@"没有返回");
}

- (void)customPresentNavigationController:(UIViewController *)controller {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.navigationBarHidden = YES;
    [self customPresentController:navigationController];
}

- (void)customPresentController:(UIViewController *)controller {
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [strongSelf presentViewController:controller animated:YES completion:^{
            nil;
        }];
    });
}

- (void)refreshBlurBackgroundImage:(UIImage *)baseImage inImageView:(UIImageView *)imageView {
    __block UIImage *tempImage = nil;
    __weak __typeof(self)weakSelf = self;
    [GCDHelper dispatchBlock:^{
        tempImage = [weakSelf getBlurImage:baseImage];
    } completion:^{
        imageView.image = tempImage;
        [FileOperate saveImage:tempImage withName:[NSString stringWithFormat:@"%@.jpg",NSStringFromClass([self class])] toDirectory:APP_CACHES_PATH];
    }];
}

- (UIImage *)getBlurImage:(UIImage *)baseImage {
//    BlurImageModel *model = [BlurImageModel defaultBlurImageModel];
//    BlurImageSynchronize *blurImageSyn = [[BlurImageSynchronize alloc] initWithImage:baseImage model:model];
//    return [blurImageSyn blurImage];
    UIImage *ima = [UIImage imageNamed:@"ima01.png"];
    return ima;
    
}

#pragma mark - action

- (void)backButtonAction:(UIButton *)sender {
    [self dismiss];
}

- (void)settingButtonAction:(UIButton *)sender {
    NSLog(@"settingButtonAction");
    [[CLReporting sharedInstance] pushEventNoAppId:1200593 paraString:nil];
    
}

- (void)userSpaceSettingAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200519 paraString:nil];
   
}

- (void)myInformationAction {
    
}

- (void)materialLibraryAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200592 paraString:nil];
    
}

- (void)historyDownloadAction {
    
}

- (void)draftBoxAction {
   // NSLog(@"草稿箱");
   
}

- (void)cloudAlbumAction {
    if([[JPSApiUserManger shareInstance].currentUser isBindedMobile]){
        [[CLReporting sharedInstance] pushEvent:1200508 paraString:nil];
       
    }else{
        
    }
}

- (void)integralAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200504 paraString:nil];
  }

- (void)playJaneAction {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"playJaneKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   
}

- (void)quitAction {
   
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"是否退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出",nil];
    alert.tag = 41785;
    [alert show];
    NSLog(@"退出成功，但是没有清除信息");
}

@end
