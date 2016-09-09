//
//  UserSettingController.m
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/15.
//  Copyright © 2016年 poco. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserSettingController requires ARC support."
#endif

#import "JNEUserSettingController.h"
#import "JNEUserSettingDetailCell.h"
#import "JNEUserSettingIDCell.h"
#import "JNEUserSettingUserIconCell.h"
#import "JNEUserSettingBaseCell.h"
#import "JNEUserSettingQuitCell.h"
#import "JNEUserSettingUserSpaceCell.h"
#import "JNEUserSettingAreaPickerController.h"

#import "JNEUserSettingNicknameController.h"
#import "JNEUserSettingGenderController.h"
#import "JPSApiUserManger.h"

//#import "CloudAlbumEntranceViewController.h"

#import "JPSApiRequestManger.h"
#import "JPSApiUserManger.h"

#import "JNEUserImageLoader.h"

#import "JNEUserImagePickerController.h"
#import "GetIdentifyCodeToRegisterViewController.h"
#import "ViewController.h"

#import "FileOperate.h"
#import "UIAlertViewAddition.h"


#import "UIViewController+MBProgressHUD.h"
#import "NSDicCacheHelper.h"
#import "GCDHelper.h"
#import "CLReporting.h"

#define LOCAL_VIEW_RATE 0.5
#define ERROR_MESSAGE @"message"
#define USER_ICON_CELL_IDENTIFIER @"userIconCellIdentifier"
#define USER_SPACE_CELL_IDENTIFIER @"userSpaceCellIdentifier"
#define ID_CELL_IDENTIFIER @"idCellIdentifier"
#define DETAIL_CELL_IDENTIFIER @"detialCellIdentifier"
#define QUIT_CELL_IDENTIFIER @"quitCellIdentifier"

#define MIN_SECTION_INSET 10
#define DEFAULT_PROFILE @"0"
#define DEFAULT_PROFILE_NULL @""

@interface JNEUserSettingController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, JNEUserSettingGenderControllerDelegate, JNEUserSettingAreaPickerControllerDelegate, JNEUserSettingNicknameControllerDelegate, JNEUserImagePickerControllerDelegate, JNEUserSettingUserSpaceCellDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, strong) UIImageView *gradientTopBar;

@property (nonatomic, strong) UITableView *settingTableView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *cellObjectArray;

@property (nonatomic, strong) JPSApiUser *currentUser;


@end

@implementation JNEUserSettingController

#pragma mark - UIViewController Lifecycle

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freeCreditChanged:) name:kJPSApiUserfreeCreditChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshViews];
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPSUserCloudAlbumBindPhoneToLoginViewBackActionNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPSUserLoginSuccessNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPSApiUserfreeCreditChangedNotification object:nil];
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
    CGRect topBarFrame = CGRectMake(0, 0, screenHeight, topBarHeight);
    self.gradientTopBar.frame = topBarFrame;
        self.backButton.frame = CGRectMake(0, 0, buttonWidth, topBarHeight);
    self.settingButton.frame = CGRectMake(screenWidth - buttonWidth, 0, buttonWidth, topBarHeight);
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(screenWidth * 0.5, topBarHeight * 0.5);
    
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
    if (section == 0) {
        return MIN_SECTION_INSET;
    } else {
        return 40 * LOCAL_VIEW_RATE;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0;
    NSArray *array = self.cellObjectArray[indexPath.section];
    JNEUserSettingCellObject *object = array[indexPath.row];
    if ([object.identifier isEqualToString:USER_ICON_CELL_IDENTIFIER]) {
        cellHeight = 200 * LOCAL_VIEW_RATE;
    } else if ([object.identifier isEqualToString:QUIT_CELL_IDENTIFIER]) {
        cellHeight = 88 * LOCAL_VIEW_RATE;
    } else if ([object.identifier isEqualToString:USER_SPACE_CELL_IDENTIFIER]) {
        cellHeight = 500 * ViewRateBaseOnIP6;
    }else {
        cellHeight = 88 * LOCAL_VIEW_RATE;
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
    if ([object.identifier isEqualToString:USER_SPACE_CELL_IDENTIFIER]) {
        JNEUserSettingUserSpaceCell *spaceCell = (JNEUserSettingUserSpaceCell*)cell;
        spaceCell.delegate = self;
    }
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat showTopbarValue = (500 * ViewRateBaseOnIP6 + MIN_SECTION_INSET) * 0.5;
    if (scrollView.contentOffset.y >= showTopbarValue) {
      
    } else {
        
    }
}

#pragma mark - DatePickerViewDelegate


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

#pragma mark - JNEUserSettingGenderControllerDelegate

- (void)userSettingGenderController:(JNEUserSettingGenderController *)controller didSelectGender:(NSString *)gender {
    [self customDismissController:controller];
    if (![gender isEqualToString:self.currentUser.profile.sex]) {
        [self showHUD];
        JPSApiUpdateUserInfoRep * rep = [JPSApiUpdateUserInfoRep new];
        rep.sex = gender;
        __weak __typeof(self)weakSelf = self;
        [[JPSApiUserManger shareInstance].currentUser updateUserInfoWithRep:rep CompletionBlock:^(id result, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (!error) {
                [strongSelf refreshUserWithComplteionBlock:^(id result,NSError *er){
                    if (!er) {
                         [[JPSApiUserManger shareInstance].currentUser actionBehaviorWithBehaviorId:kJPSApiUserAddSexActionID];
                    }
                }];
            } else {
                [strongSelf hideHUD];
                [strongSelf showError:error];
            }
        }];
    }
}

#pragma mark - JNEUserSettingAreaPickerControllerDelegate

- (void)userSettingAreaPickerController:(JNEUserSettingAreaPickerController *)controller didSelectAreaWithAreaCode:(NSString *)code {
    [self customDismissController:controller.navigationController];
    if (![code isEqualToString:self.currentUser.profile.locationId]) {
        [self showHUD];
        JPSApiUpdateUserInfoRep * rep = [JPSApiUpdateUserInfoRep new];
        rep.locationId = code;
        __weak __typeof(self)weakSelf = self;
        [[JPSApiUserManger shareInstance].currentUser updateUserInfoWithRep:rep CompletionBlock:^(id result, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (!error) {
                [strongSelf refreshUserWithComplteionBlock:^(id result,NSError *er){
                    if (!er) {
                        [[JPSApiUserManger shareInstance].currentUser actionBehaviorWithBehaviorId:kJPSApiUserAddRegionActionID];
                    }
                }];
            } else {
                [strongSelf hideHUD];
                [strongSelf showError:error];
            }
        }];
    }
    
}

#pragma mark - JNEUserSettingNicknameControllerDelegate

- (void)userSettingNicknameController:(JNEUserSettingNicknameController *)controller didEndEditWithNickname:(NSString *)nickname {
    [self customDismissController:controller];
    if (![nickname isEqualToString:self.currentUser.profile.nickName]) {
        [self showHUD];
        JPSApiUpdateUserInfoRep * rep = [JPSApiUpdateUserInfoRep new];
        rep.nickname = nickname;
        __weak __typeof(self)weakSelf = self;
        [[JPSApiUserManger shareInstance].currentUser updateUserInfoWithRep:rep CompletionBlock:^(id result, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (!error) {
                [strongSelf refreshUserWithComplteionBlock:nil];
            } else {
                [strongSelf hideHUD];
                [strongSelf showError:error];
            }
        }];
    }
}

#pragma mark - JNEActionSheetDelegate



#pragma mark - JNEBlurTopBarDelegate


#pragma mark - JNEUserSettingUserSpaceCellDelegate

- (void)userSpaceCell:(JNEUserSettingUserSpaceCell *)cell didRefreshImage:(UIImage *)image {
    [self refreshBlurBackgroundImage:image inImageView:self.backgroundImageView];
    UIImage *homepageBlurBackground = [self getBlurImage:image];
//    [FileOperate saveImage:homepageBlurBackground withName:[NSString stringWithFormat:@"%@.jpg",NSStringFromClass([BCAHomepageController class])] toDirectory:APP_CACHES_PATH];
}

#pragma mark - Login Sucess  Notificaiton

- (void)loginSucess {
    self.currentUser = [[JPSApiUserManger shareInstance] currentUser];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPSUserLoginSuccessNotification object:nil];
}

#pragma mark - LoginViewBackActionNotification

- (void)loginViewBackAction {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPSUserCloudAlbumBindPhoneToLoginViewBackActionNotification object:nil];
    [self goBackHomepage];
}

#pragma mark - JNEChangePasswordViewControllerDelegate


#pragma mark - freeCreditChanged

- (void)freeCreditChanged:(NSNotification*)notification {
   [self refreshViews];
}

#pragma mark - Action

- (void)settingButtonAction:(UIButton *)sender {
     [[CLReporting sharedInstance] pushEventNoAppId:1200593 paraString:nil];
    
//    [[MainViewController shareInstance] presentControllerByKey:USER_CENTER_SETTINGVIEW animated:YES];
}

- (void)backButtonAction:(UIButton *)sender {
    [self dismiss];
}

- (void)userIconSettingAction:(UIButton *)sender {
    [[CLReporting sharedInstance] pushEventNoAppId:1200501 paraString:nil];
//    [self saveBlurImageForKey:CHOOSE_PICTURE_VIEW];
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JNEUserImagePickerController *pickerController = [[JNEUserImagePickerController alloc] init];
        pickerController.delegate = strongSelf;
        pickerController.userImageType = JNEUserImageTypeHead;
        [strongSelf presentViewController:pickerController animated:YES completion:nil];
    });
}

- (void)userSpaceSettingAction:(UIButton *)sender {
    [[CLReporting sharedInstance] pushEventNoAppId:1200519 paraString:nil];
//    [self.actionSheet show];
}

- (void)nickNameSettingAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200502 paraString:nil];
//    [BlurImageSynchronize saveBlurImageToCacheWithView:self.view cacheKey:NSStringFromClass([JNEUserSettingNicknameController class])];
    JNEUserSettingNicknameController *controller = [[JNEUserSettingNicknameController alloc] init];
    controller.delegate = self;
    [self customPresentController:controller];
}

- (void)bindMobleAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200594 paraString:nil];
    if(![[JPSApiUserManger shareInstance].currentUser isBindedMobile]){
//        [self saveBlurImageForKey:LOGIN_VIEW];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPSUserLoginSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess) name:kJPSUserLoginSuccessNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPSUserCloudAlbumBindPhoneToLoginViewBackActionNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginViewBackAction) name:kJPSUserCloudAlbumBindPhoneToLoginViewBackActionNotification object:nil];
        
        [[NSDicCacheHelper sharedCachier] setObject:[NSString stringWithFormat:@"ThirdLoginUserNoBindPhoneForCellPhoneNumber"] forKey:@"JNEThirdLoginBindPhoneStatus"];
        GetIdentifyCodeToRegisterViewController *getIdentifyCodeToRegisterViewController = [[GetIdentifyCodeToRegisterViewController alloc] initWithNibName:nil bundle:nil];
        [self customPresentNavigationController:getIdentifyCodeToRegisterViewController];
    }
}

- (void)materailAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200592 paraString:nil];
    //[[NSDicCacheHelper sharedCachier] setObject:[NSNumber numberWithBool:YES] forKey:PUZZLE_HOME_PAGE_IS_SHOW_MATERIAL_CENTER];
//    [[MainViewController shareInstance] presentControllerByKey:COVER_VIEW  animated:YES];
}

- (void)cloudAlbumAction {

//    if([[JPSApiUserManger shareInstance].currentUser isBindedMobile]){
//        [[CLReporting sharedInstance] pushEvent:1200508 paraString:nil];
//        BCAHomepageController *controller = [[BCAHomepageController alloc] init];
//        [BlurImageSynchronize saveBlurImageToCacheWithView:self.view cacheKey:NSStringFromClass([BCAHomepageController class])];
//        [self customPresentNavigationController:controller];
//    }else{
//        [self saveBlurImageForKey:LOGIN_VIEW];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPSUserLoginSuccessNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess) name:kJPSUserLoginSuccessNotification object:nil];
//    
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPSUserCloudAlbumBindPhoneToLoginViewBackActionNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginViewBackAction) name:kJPSUserCloudAlbumBindPhoneToLoginViewBackActionNotification object:nil];
//    
//        [[NSDicCacheHelper sharedCachier] setObject:[NSString stringWithFormat:@"ThirdLoginUserNoBindPhoneForCloudAlbum"] forKey:@"JNEThirdLoginBindPhoneStatus"];
//        GetIdentifyCodeToRegisterViewController *getIdentifyCodeToRegisterViewController = [[GetIdentifyCodeToRegisterViewController alloc] initWithNibName:nil bundle:nil];
//        [self customPresentNavigationController:getIdentifyCodeToRegisterViewController];
//    }
}

- (void)bonusAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200504 paraString:nil];
//    [BlurImageSynchronize saveBlurImageToCacheWithView:self.view cacheKey:MISSIONHALLVIEW];
//    [[MainViewController shareInstance] presentControllerByKey:MISSIONHALLVIEW  animated:YES];
}

- (void)genderSettingAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200506 paraString:nil];
//    [BlurImageSynchronize saveBlurImageToCacheWithView:self.view cacheKey:NSStringFromClass([JNEUserSettingGenderController class])];
    JNEUserSettingGenderController *controller = [[JNEUserSettingGenderController alloc] init];
    controller.delegate = self;
    [self customPresentController:controller];
}

- (void)birthdaySettingAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200507 paraString:nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    JPSApiUserProfile *profile = self.currentUser.profile;
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@", profile.birthdayYear, profile.birthdayMonth, profile.birthdayDay]];
//    self.datePickerView.currentDate = date;
//    [self.datePickerView show];
}

- (void)areaSettingAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200505 paraString:nil];
//    [BlurImageSynchronize saveBlurImageToCacheWithView:self.view cacheKey:NSStringFromClass([JNEUserSettingAreaPickerController class])];
    JNEUserSettingAreaPickerController *controller = [[JNEUserSettingAreaPickerController alloc] init];
    controller.delegate = self;
//    controller.recieveObjectArray = [JNELocationJsonParser defaultLocationObjectArray];
    [self customPresentNavigationController:controller];
}

- (void)passwordSettingAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200503 paraString:nil];
//    [BlurImageSynchronize saveBlurImageToCacheWithView:self.view cacheKey:NSStringFromClass([JNEChangePasswordViewController class])];
//    JNEChangePasswordViewController *changePasswordViewController = [[JNEChangePasswordViewController alloc] init];
//    changePasswordViewController.delegate = self;
//    [self customPresentController:changePasswordViewController];
}

- (void)quitAction {
//    __weak __typeof(self)weakSelf = self;
//    [UIAlertView showAlertViewWithTitle:nil message:NSLocalizedString(@"是否退出登录?",nil) cancelButtonTitle:NSLocalizedString(@"取消",nil ) otherButtonTitle:NSLocalizedString(@"退出",nil) tag:0 completionBlock:^(NSInteger buttonIndex, UIAlertView *alertView) {
//        if (buttonIndex == 1) {
//            [[JPSApiUserManger shareInstance] signOutCurrenUser];
//            [weakSelf goBackHomepage];
//        }
//    }];
}

#pragma mark - Private Method

- (void)showError:(NSError *)error {
//    NSString *message = error.userInfo[ERROR_MESSAGE];
//    [[[UIAlertView alloc] initWithTitle:nil message:message cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitle:nil completionBlock:^(NSInteger buttonIndex, UIAlertView *alertView) {
//        nil;
//    }] show];
}

- (void)saveBlurImageForKey:(NSString *)key {
//    UIImage * image = [self.view imageByRenderingView:NO scale:1.0];
//    image  = [image applyDefaultBlurWithHeight:160.0];
//    [FileOperate saveImage:image withName:[NSString stringWithFormat:@"%@.jpg",key] toDirectory:APP_CACHES_PATH];
}

- (void)refreshViews {
    self.cellObjectArray = [self getCellObjectArray];
    [self.settingTableView reloadData];
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
    return baseImage;
}

- (void)dismiss {
//    [[MainViewController shareInstance] goBackControllerAnimated:YES];
}

- (void)goBackHomepage {
//    [[MainViewController shareInstance] goBackCoverControllerAnimated:YES cATransition:nil];
}

- (void)customPresentNavigationController:(UIViewController *)controller {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.navigationBarHidden = YES;
    [self customPresentController:navigationController];
}

- (void)customPresentController:(UIViewController *)controller {
//    __weak __typeof(self)weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        JNESwipeTransitionDelegate *transitionDelegate = strongSelf.transitionDelegate;
//        transitionDelegate.targetEdge = UIRectEdgeRight;
//        controller.transitioningDelegate = transitionDelegate;
//        controller.modalPresentationStyle = UIModalPresentationFullScreen;
//        [strongSelf presentViewController:controller animated:YES completion:^{
//            nil;
//        }];
//    });
}

- (void)customDismissController:(UIViewController *)controller {
//    if (controller.transitioningDelegate) {
//        JNESwipeTransitionDelegate *transitionDelegate = controller.transitioningDelegate;
//        transitionDelegate.targetEdge = UIRectEdgeLeft;
//    }
//    [controller dismissViewControllerAnimated:YES completion:^{
//        nil;
//    }];
}

#pragma mark - Setter & Getter

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
        _maskLayer.backgroundColor = [[[UIColor orangeColor] colorWithAlphaComponent:0.86] CGColor];
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
        [_settingTableView registerClass:[JNEUserSettingDetailCell class] forCellReuseIdentifier:DETAIL_CELL_IDENTIFIER];
        [_settingTableView registerClass:[JNEUserSettingIDCell class] forCellReuseIdentifier:ID_CELL_IDENTIFIER];
        [_settingTableView registerClass:[JNEUserSettingUserIconCell class] forCellReuseIdentifier:USER_ICON_CELL_IDENTIFIER];
        [_settingTableView registerClass:[JNEUserSettingQuitCell class] forCellReuseIdentifier:QUIT_CELL_IDENTIFIER];
        [_settingTableView registerClass:[JNEUserSettingUserSpaceCell class] forCellReuseIdentifier:USER_SPACE_CELL_IDENTIFIER];
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

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"JNEUserSettingBack"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"JNEUserSettingBack_hover"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}


- (JPSApiUser *)currentUser {
    if (!_currentUser) {
        _currentUser = [JPSApiUserManger shareInstance].currentUser;
    }
    return _currentUser;
}


- (NSArray *)getCellObjectArray {
    
    __weak __typeof(self)weakSelf = self;
    
    NSMutableArray *normalSection = [[NSMutableArray alloc] init];
    JNEUserSettingCellObject *userSpaceObject = [JNEUserSettingCellObject objectWithCellIdentifier:USER_SPACE_CELL_IDENTIFIER
                                                                                            title:nil
                                                                                           detail:nil
                                                                                      excuteBlock:^{
                                                                                          [weakSelf userSpaceSettingAction:nil];
                                                                                      }];
    userSpaceObject.userSpace = self.currentUser.profile.userSpace;
    userSpaceObject.hideSeparatorLine = YES;
    [normalSection addObject:userSpaceObject];
    JNEUserSettingCellObject *userIconObject = [JNEUserSettingCellObject objectWithCellIdentifier:USER_ICON_CELL_IDENTIFIER
                                                                                      title:NSLocalizedString(@"头像",nil)
                                                                                     detail:nil
                                                                                excuteBlock:^{
                                                                                    [weakSelf userIconSettingAction:nil];
                                                                                }];
    userIconObject.userIcon = self.currentUser.profile.userIcon;
    [normalSection addObject:userIconObject];
    [normalSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:DETAIL_CELL_IDENTIFIER
                                                                  title:NSLocalizedString(@"昵称",nil)
                                                                 detail:self.currentUser.profile.nickName
                                                            excuteBlock:^{
                                                                [weakSelf nickNameSettingAction];
                                                            }]];
    
    [normalSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:ID_CELL_IDENTIFIER
                                                                  title:NSLocalizedString(@"ID",nil)
                                                                 detail:self.currentUser.profile.userId]];
    
    NSString *mobileString = self.currentUser.profile.mobile;
    NSString *mobileCellIdentifier = ID_CELL_IDENTIFIER;
    if ([self.currentUser.profile.mobile isEqualToString:DEFAULT_PROFILE_NULL] || [self.currentUser.profile.mobile isEqualToString:DEFAULT_PROFILE]) {
        mobileString = NSLocalizedString(@"未绑定",nil);
        mobileCellIdentifier = DETAIL_CELL_IDENTIFIER;
    }
    
    [normalSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:mobileCellIdentifier
                                                                  title:NSLocalizedString(@"手机号码",nil)
                                                                 detail:mobileString
                                                                 excuteBlock:^{
                                                                     [weakSelf bindMobleAction];
                                                                 }]];
    
    NSMutableArray *materialSection = [[NSMutableArray alloc] init];
    [materialSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:DETAIL_CELL_IDENTIFIER
                                                                     title:NSLocalizedString(@"素材库",nil)
                                                                    detail:@""
                                                               excuteBlock:^{
                                                                   [weakSelf materailAction];
                                                               }]];
    
    
    NSMutableArray *cloudAlbumSection = [[NSMutableArray alloc] init];
    [cloudAlbumSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:DETAIL_CELL_IDENTIFIER
                                                                  title:NSLocalizedString(@"云相册",nil)
                                                                 detail:@""
                                                            excuteBlock:^{
                                                                [weakSelf cloudAlbumAction];
                                                            }]];
    
    NSMutableArray *profileSection = [[NSMutableArray alloc] init];
    [profileSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:DETAIL_CELL_IDENTIFIER
                                                               title:NSLocalizedString(@"积分",nil)
                                                              detail:self.currentUser.profile.freeCredit
                                                            excuteBlock:^{
                                                                [weakSelf bonusAction];
                                                            }]];
    NSString *gender = self.currentUser.profile.sex;
    NSString *genderString;
    if ([gender isEqualToString:DEFAULT_PROFILE_NULL]) {
        genderString = NSLocalizedString(@"未填写",nil);
    } else {
        genderString = ([self.currentUser.profile.sex isEqualToString:@"男"]) ? NSLocalizedString(@"男",nil) : NSLocalizedString(@"女",nil);
    }
    [profileSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:DETAIL_CELL_IDENTIFIER
                                                               title:NSLocalizedString(@"性别",nil)
                                                              detail:genderString
                                                            excuteBlock:^{
                                                                [weakSelf genderSettingAction];
                                                            }]];
    NSString *year = self.currentUser.profile.birthdayYear;
    NSString *month = self.currentUser.profile.birthdayMonth;
    NSString *day = self.currentUser.profile.birthdayDay;
    NSString *birthdayString = [year isEqualToString:DEFAULT_PROFILE] ? NSLocalizedString(@"未填写",nil) : [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
    [profileSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:DETAIL_CELL_IDENTIFIER
                                                               title:NSLocalizedString(@"生日",nil)
                                                              detail:birthdayString
                                                            excuteBlock:^{
                                                                [weakSelf birthdaySettingAction];
                                                            }]];
//    NSString *locationString = [self.currentUser.profile.locationId isEqualToString:DEFAULT_PROFILE] ? NSLocalizedString(@"未填写",nil) : [JNELocationTreeTransfer locationNameWithLocationTree:self.currentUser.profile.locationIdTree];
    NSString *locationString = @"地区";
    [profileSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:DETAIL_CELL_IDENTIFIER
                                                                  title:NSLocalizedString(@"地区",nil)
                                                                 detail:locationString
                                                            excuteBlock:^{
                                                                [weakSelf areaSettingAction];
                                                            }]];
    
    if (![self.currentUser isThirdParnerSignedIn]) {
        [profileSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:DETAIL_CELL_IDENTIFIER
                                                                         title:NSLocalizedString(@"修改密码",nil)
                                                                        detail:@""
                                                                   excuteBlock:^{
                                                                       [weakSelf passwordSettingAction];
                                                                   }]];
    }
    
    NSArray *quitSection = [NSArray arrayWithObject:[JNEUserSettingCellObject objectWithCellIdentifier:QUIT_CELL_IDENTIFIER
                                                                                              title:nil
                                                                                             detail:nil
                                                                                        excuteBlock:^{
                                                                                            [weakSelf quitAction];
                                                                                        }]];
    return @[normalSection, materialSection, cloudAlbumSection, profileSection, quitSection];
}


@end
