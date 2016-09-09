//
//  JNEMyInformationController.m
//  puzzleApp
//
//  Created by admin on 16/7/21.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEMyInformationController requires ARC support."
#endif

#import "JNEMyInformationController.h"
#import "JNEUserSettingCellObject.h"
#import "JPSApiUserManger.h"
#import "UIViewController+MBProgressHUD.h"
#import "JNEUserImageLoader.h"

#import "JPSApiRep.h"

#import "JNEUserSettingUserIconCell.h"
#import "JNEUserSettingIDCell.h"
#import "ViewController.h"
#import "JNEMyInformationDetailCell.h"
#import "CLReporting.h"
#define DEFAULT_PROFILE @"0"
#define DEFAULT_PROFILE_NULL @""

@interface JNEMyInformationController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *cellObjectArray;
@property (nonatomic, strong) JPSApiUser *currentUser;


@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, strong) UITableView *settingTableView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JNEMyInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellObjectArray = [self getCellObjectArray];
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.settingTableView];
//    [self.view addSubview:self.gradientTopBar];
    
    
    
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
    [self refreshViews];
    self.titleLabel.text = NSLocalizedString(@"我的资料",nil);
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
//    [JNEStatisticsHelper pageviewStartWithName:kJNEBaiduMyinformationViewId];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [JNEStatisticsHelper pageviewEndWithName:kJNEBaiduMyinformationViewId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)getCellObjectArray {
    __weak __typeof(self)weakSelf = self;
    NSMutableArray *normalSection = [[NSMutableArray alloc] init];
    JNEUserSettingCellObject *userIconObject = [JNEUserSettingCellObject objectWithCellIdentifier:@"userIconCellIdentifier"
                                                                                            title:NSLocalizedString(@"头像",nil)
                                                                                           detail:nil
                                                                                      excuteBlock:^{
                                                                                          [weakSelf userIconSettingAction];
                                                                                      }];
    userIconObject.userIcon = self.currentUser.profile.userIcon;
    [normalSection addObject:userIconObject];
    
    [normalSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"myInformationDetialCellIdentifier"
                                                                          title:NSLocalizedString(@"昵称",nil)
                                                                         detail:self.currentUser.profile.nickName
                                                                    excuteBlock:^{
                                                                        [weakSelf nickNameSettingAction];
                                                                    }]];
    
    [normalSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"idCellIdentifier"
                                                                          title:NSLocalizedString(@"ID",nil)
                                                                         detail:self.currentUser.profile.userId]];
    
    NSMutableArray *profileSection = [[NSMutableArray alloc] init];
    NSString *gender = self.currentUser.profile.sex;
    NSString *genderString;
    if ([gender isEqualToString:DEFAULT_PROFILE_NULL]) {
        genderString = NSLocalizedString(@"未填写",nil);
    } else {
        genderString = ([self.currentUser.profile.sex isEqualToString:@"男"]) ? NSLocalizedString(@"男",nil) : NSLocalizedString(@"女",nil);
    }
    [profileSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"myInformationDetialCellIdentifier"
                                                                           title:NSLocalizedString(@"性别",nil)
                                                                          detail:genderString
                                                                     excuteBlock:^{
                                                                         [weakSelf genderSettingAction];
                                                                     }]];
    NSString *year = self.currentUser.profile.birthdayYear;
    NSString *month = self.currentUser.profile.birthdayMonth;
    NSString *day = self.currentUser.profile.birthdayDay;
    NSString *birthdayString = [year isEqualToString:DEFAULT_PROFILE] ? NSLocalizedString(@"未填写",nil) : [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
    [profileSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"myInformationDetialCellIdentifier"
                                                                           title:NSLocalizedString(@"生日",nil)
                                                                          detail:birthdayString
                                                                     excuteBlock:^{
                                                                         [weakSelf birthdaySettingAction];
                                                                     }]];
    
//    NSString *locationString = [self.currentUser.profile.locationId isEqualToString:DEFAULT_PROFILE] ? NSLocalizedString(@"未填写",nil) : [JNELocationTreeTransfer locationNameWithLocationTree:self.currentUser.profile.locationIdTree];
    NSString *locationString = @"地区";
    [profileSection addObject:[JNEUserSettingCellObject objectWithCellIdentifier:@"myInformationDetialCellIdentifier"
                                                                           title:NSLocalizedString(@"地区",nil)
                                                                          detail:locationString
                                                                     excuteBlock:^{
                                                                         [weakSelf areaSettingAction];
                                                                     }]];
    
    return @[normalSection, profileSection];
}

- (UIImageView *)backgroundImageView {
//    if (!_backgroundImageView) {
//        _backgroundImageView = [[UIImageView alloc] initWithImage:[BlurImageSynchronize readBlurImageWithKey:NSStringFromClass([self class])]];
//        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
//    }
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
        _settingTableView.scrollEnabled = NO;
        _settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_settingTableView registerClass:[JNEUserSettingUserIconCell class] forCellReuseIdentifier:@"userIconCellIdentifier"];
        [_settingTableView registerClass:[JNEMyInformationDetailCell class] forCellReuseIdentifier:@"myInformationDetialCellIdentifier"];
        [_settingTableView registerClass:[JNEUserSettingIDCell class] forCellReuseIdentifier:@"idCellIdentifier"];
        
       
    }
    return _settingTableView;
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _titleLabel.font = [UIFont systemFontOfSize:34 * LOCAL_VIEW_RATE];
        _titleLabel.textColor = [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    }
    return _titleLabel;
}

- (JPSApiUser *)currentUser {
    if (!_currentUser) {
        _currentUser = [JPSApiUserManger shareInstance].currentUser;
    }
    return _currentUser;
}



- (void)configSubviewsFrame {
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat screenHeight = CGRectGetHeight(self.view.bounds);
    CGFloat topBarHeight = 88 * LOCAL_VIEW_RATE;
    CGFloat buttonWidth = 100 * LOCAL_VIEW_RATE;
    
    self.backgroundImageView.frame = self.view.bounds;
    self.maskLayer.frame = self.view.bounds;
    
    self.settingTableView.frame = CGRectMake(0, 64, screenWidth, screenHeight);
//    self.settingTableView.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    self.backButton.frame = CGRectMake(0, 0, buttonWidth, topBarHeight);
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(screenWidth * 0.5, topBarHeight * 0.5);
    
}

#pragma mark - Action

- (void)backButtonAction:(UIButton *)sender {
    NSLog(@"用nai代替");
}

- (void)userIconSettingAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200501 paraString:nil];
//    [self saveBlurImageForKey:CHOOSE_PICTURE_VIEW];
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JNEUserImagePickerController *pickerController = [[JNEUserImagePickerController alloc] init];
//        pickerController.delegate = strongSelf;
        pickerController.userImageType = JNEUserImageTypeHead;
        [strongSelf presentViewController:pickerController animated:YES completion:nil];
    });
}

- (void)nickNameSettingAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200502 paraString:nil];
//    [BlurImageSynchronize saveBlurImageToCacheWithView:self.view cacheKey:NSStringFromClass([JNEUserSettingNicknameController class])];
    JNEUserSettingNicknameController *controller = [[JNEUserSettingNicknameController alloc] init];
//    controller.delegate = self;
    [self customPresentController:controller];
}

- (void)genderSettingAction {
    [[CLReporting sharedInstance] pushEventNoAppId:1200506 paraString:nil];
//    [BlurImageSynchronize saveBlurImageToCacheWithView:self.view cacheKey:NSStringFromClass([JNEUserSettingGenderController class])];
    JNEUserSettingGenderController *controller = [[JNEUserSettingGenderController alloc] init];
//    controller.delegate = self;
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
//    controller.delegate = self;
//    controller.recieveObjectArray = [JNELocationJsonParser defaultLocationObjectArray];
    [self customPresentNavigationController:controller];
}

#pragma mark - JNEBlurTopBarDelegate

//- (void)blurTopBar:(JNEBlurTopBar *)topBar animateWithAlpha:(CGFloat)alpha {
////    self.gradientTopBar.alpha = 1 - alpha;
//}

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
        return 43*ViewRateBaseOnIP6;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0;
    NSArray *array = self.cellObjectArray[indexPath.section];
    JNEUserSettingCellObject *object = array[indexPath.row];
    if ([object.identifier isEqualToString:@"userIconCellIdentifier"]) {
        cellHeight = 200 * LOCAL_VIEW_RATE;
    } else {
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

#pragma mark - DatePickerViewDelegate

//- (void)datePickerView:(JNEDatePickerView *)view didSelectDate:(NSDate *)date {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *dateString = [dateFormatter stringFromDate:date];
//    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
//    JPSApiUserProfile *profile = self.currentUser.profile;
//    BOOL yearMatch = ([dateArray[0] integerValue] == [profile.birthdayYear integerValue]);
//    BOOL monthMatch = ([dateArray[1] integerValue] == [profile.birthdayMonth integerValue]);
//    BOOL dayMatch = ([dateArray[2] integerValue] == [profile.birthdayDay integerValue]);
//    if (!(yearMatch & monthMatch && dayMatch)) {
//        [self showHUD];
//        JPSApiUpdateUserInfoRep * rep = [JPSApiUpdateUserInfoRep new];
//        rep.birthdayYear = dateArray[0];
//        rep.birthdayMonth = dateArray[1];
//        rep.birthdayDay = dateArray[2];
//        __weak __typeof(self)weakSelf = self;
//        [[JPSApiUserManger shareInstance].currentUser updateUserInfoWithRep:rep CompletionBlock:^(id result, NSError *error) {
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            if (!error) {
//                [strongSelf refreshUserWithComplteionBlock:^(id result,NSError *er){
//                    if (!er) {
//                        [[JPSApiUserManger shareInstance].currentUser actionBehaviorWithBehaviorId:kJPSApiUserAddBirthDayActionID];
//                    }
//                }];
//            } else {
//                [strongSelf hideHUD];
//                [strongSelf showError:error];
//            }
//        }];
//    }
//    
//}

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

#pragma mark - Private Method

//- (void)saveBlurImageForKey:(NSString *)key {
//    UIImage * image = [self.view imageByRenderingView:NO scale:1.0];
//    image  = [image applyDefaultBlurWithHeight:160.0];
//    [FileOperate saveImage:image withName:[NSString stringWithFormat:@"%@.jpg",key] toDirectory:APP_CACHES_PATH];
//}

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

- (void)showError:(NSError *)error {
    NSString *message = error.userInfo[@"message"];
//    [[[UIAlertView alloc] initWithTitle:nil message:message cancelButtonTitle:NSLocalizedString(@"确认",nil) otherButtonTitle:nil completionBlock:^(NSInteger buttonIndex, UIAlertView *alertView) {
//        nil;
//    }] show];
}

- (void)refreshViews {
    self.cellObjectArray = [self getCellObjectArray];
    [self.settingTableView reloadData];
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

- (void)customPresentNavigationController:(UIViewController *)controller {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    navigationController.navigationBarHidden = YES;
    [self customPresentController:navigationController];
}

@end
