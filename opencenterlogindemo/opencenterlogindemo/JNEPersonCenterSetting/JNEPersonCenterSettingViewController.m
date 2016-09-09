//
//  JNEPersonCenterSettingControllerViewController.m
//  puzzleApp
//
//  Created by admin on 16/4/22.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#import "JNEPersonCenterSettingViewController.h"
#import "JNEPersonCenterSettingModel.h"
#import "JNEPersonCenterSettingSwitchCell.h"
#import "JNEPersonCenterSettingTableViewCell.h"
#import "JPSApiUserManger.h"

#import "PersistentSettings.h"

#import "GCDHelper.h"
//#import "JNEChangePasswordViewController.h"


#import "ViewController.h"

#import "GetIdentifyCodeToRegisterViewController.h"
#import "NSDicCacheHelper.h"
#import "CLReporting.h"

NSString *const kJNESettingTableViewSwitchCellKey = @"JNEPersonCenterSettingSwitchCell";
NSString *const kJNESettingTableViewCellKey = @"JNEPersonCenterSettingTableViewCell";

NSString *const kJNEUserProfileZero  = @"0";
NSString *const kJNEUserProfileNull  = @"";

@interface JNEPersonCenterSettingViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSArray *settingModels;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIButton *backButton;

@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UILabel *titleLabel;

@end

@implementation JNEPersonCenterSettingViewController

#pragma mark - UIViewController life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.settingModels = [self defaultSettingModels];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    }

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backgroundImageView];
    
   
    
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"设置";
    
    self.titleLabel.text = NSLocalizedString(@"设置", nil);
    [self.titleLabel sizeToFit];
    
    
    self.tableView.width = self.view.width;
    
}

- (void)dealloc {
    self.settingModels = nil;
    self.backButton = nil;
    self.tableView = nil;

    self.backgroundImageView = nil;
    self.titleLabel = nil;
  
    [super dealloc];
}

#pragma mark - Touch Event

- (void)autoRemoveWaterMark:(id)sender {
    [PersistentSettings sharedPersistentSettings].isAutoRemoveWaterMark =  ![PersistentSettings sharedPersistentSettings].isAutoRemoveWaterMark;
    UISwitch * fliterswitch = (UISwitch*)sender;
    fliterswitch.on = [PersistentSettings sharedPersistentSettings].isAutoRemoveWaterMark;
   
}

- (void)changePassword {
    
    if (![[JPSApiUserManger shareInstance] isUserSignedIn]||![[JPSApiUserManger shareInstance].currentUser isBindedMobile]) {
        return;
    }
    
    [GCDHelper dispatchMainQueueBlock:^{
       
    }];
}

- (void)bindMobleAction {
    
    if ([[JPSApiUserManger shareInstance].currentUser isBindedMobile]) {
        return;
    }
    
    [[CLReporting sharedInstance] pushEventNoAppId:1200594 paraString:nil];
    if(![[JPSApiUserManger shareInstance].currentUser isBindedMobile]){
       
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPSUserLoginSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess) name:kJPSUserLoginSuccessNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPSUserCloudAlbumBindPhoneToLoginViewBackActionNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginViewBackAction) name:kJPSUserCloudAlbumBindPhoneToLoginViewBackActionNotification object:nil];
        
        [[NSDicCacheHelper sharedCachier] setObject:[NSString stringWithFormat:@"ThirdLoginUserNoBindPhoneForCellPhoneNumber"] forKey:@"JNEThirdLoginBindPhoneStatus"];
        GetIdentifyCodeToRegisterViewController *getIdentifyCodeToRegisterViewController = [[GetIdentifyCodeToRegisterViewController alloc] initWithNibName:nil bundle:nil];
            }
}

- (void)autoFliterEvent:(id)sender {
//    if ([UIPuzzleHelper isLowiPhone]) {
//        if (![PersistentSettings sharedPersistentSettings].isAutoFilter) {
//            UIAlertView *tmp_alter = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"亲的手机型号配置较低，设置自动美化可能会崩溃哦！是否设置？", nil) cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitle:NSLocalizedString(@"确定", nil) completionBlock:^(NSInteger buttonIndex, UIAlertView *alertView) {
//                if (buttonIndex == 1) {
//                    [PersistentSettings sharedPersistentSettings].isAutoFilter = ![PersistentSettings sharedPersistentSettings].isAutoFilter;
//                }
//                
//                UISwitch *fliterswitch = (UISwitch *)sender;
//                fliterswitch.on = [PersistentSettings sharedPersistentSettings].isAutoFilter;
//            }] autorelease];
//            [tmp_alter show];
//        } else {
//            [PersistentSettings sharedPersistentSettings].isAutoFilter = ![PersistentSettings sharedPersistentSettings].isAutoFilter;
//        }
//    } else {
//        [PersistentSettings sharedPersistentSettings].isAutoFilter = ![PersistentSettings sharedPersistentSettings].isAutoFilter;
//    }
//    
//    UISwitch *fliterswitch = (UISwitch *)sender;
//    fliterswitch.on = [PersistentSettings sharedPersistentSettings].isAutoFilter;
//    [JNEStatisticsHelper pushEventWithActionID:kJNEStatAutoBeautySettingEntryId];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"版本太低" delegate:self cancelButtonTitle:@"呵呵 垃圾" otherButtonTitles:nil,nil];
    alert.tag = 41785;
    [alert show];
}

- (void)usercommentEvent {
   
}

- (void)feedBackEvent {
    
    [[CLReporting sharedInstance] pushEventNoAppId:1200006 paraString:nil];
}

- (void)resetMaterialEvent {
//    CustomizationAlterView *alter = [[[CustomizationAlterView alloc] initWithTitle:nil
//                                                                           message:NSLocalizedString(@"注意！此功能将会把所有\n已下载过的素材清除\n并将本地素材恢复到初始状态。", nil)
//                                                                      buttonTitles:@[NSLocalizedString(@"取消", nil), NSLocalizedString(@"重置", nil)]] autorelease];
//    
//    alter.enabledCaptureScreenBg = YES;
//    alter.rightBlock = ^(void) {
//        PLCRotatingProgressBarData *configureData = [[[PLCRotatingProgressBarData alloc] init] autorelease];
//        configureData.loadingString = NSLocalizedString(@"正在重置", nil);
//        configureData.successString = NSLocalizedString(@"重置成功！", nil);
//        configureData.failString = NSLocalizedString(@"重置失败！", nil);
//        
//        PLCRotatingProgressBar *resetLoadingView = [[[PLCRotatingProgressBar alloc] initWithRotatingProgressBarData:configureData] autorelease];
//        [resetLoadingView show:self.view];
//        
//        [GCDHelper dispatchBlock:^{
//            ChooseTemplateData *templateData = [[[ChooseTemplateData alloc] init] autorelease];
//            [templateData restMaterial];
//        } completion:^{
//            [resetLoadingView showSuccess];
//        }];
//    };
//    [alter show];
//    [JNEStatisticsHelper pushEventWithActionID:kJNEStatResetSettingEntryId];
}

- (void)wipeCacheEvent {
//    CustomizationAlterView *alter = [[[CustomizationAlterView alloc] initWithTitle:nil
//                                                                           message:NSLocalizedString(@"注意！此功能将会把所有\n已下载过的素材清除。", nil)
//                                                                      buttonTitles:@[NSLocalizedString(@"取消", nil), NSLocalizedString(@"确认清除", nil)]] autorelease];
//    
//    alter.enabledCaptureScreenBg = YES;
//    alter.rightBlock = ^(void) {
//        PLCRotatingProgressBarData *configureData = [[[PLCRotatingProgressBarData alloc] init] autorelease];
//        configureData.loadingString = NSLocalizedString(@"正在清除缓存", nil);
//        configureData.successString = NSLocalizedString(@"清除成功！", nil);
//        configureData.failString = NSLocalizedString(@"清除失败！", nil);
//        
//        PLCRotatingProgressBar *wipeCacheLoadingView = [[[PLCRotatingProgressBar alloc] initWithRotatingProgressBarData:configureData] autorelease];
//        [wipeCacheLoadingView show:self.view];
//        
//        [GCDHelper dispatchBlock:^{
//            ChooseTemplateData *templateData = [[[ChooseTemplateData alloc] init] autorelease];
//            [templateData wipeMaterialCache];
//        } completion:^{
//            [wipeCacheLoadingView showSuccess];
//        }];
//    };
//    [alter show];
//     [JNEStatisticsHelper pushEventWithActionID:kJNEStatCleanCacheSettingEntryId];
}

- (void)buyVipMemberEvent {
//    JNBaseWebView *webcontroller = [JNBaseWebView webViewWithURL:[[IAPMemberVipService instance] vipMemberWebPageURL]];
//    
//    [webcontroller snapshotView:self.view];
//    [webcontroller loadRequest];
//    [self.view addSubview:webcontroller.view animatedType:AnimationTransitionFadeIn];
//    [self addChildViewController:webcontroller];
//    [JNEStatisticsHelper pushEventWithActionID:kJNEStatBuyVipSettingEntryId];
}

- (void)restoreVipMemberEvent {
//    PLCRotatingProgressBarData *configureData = [[[PLCRotatingProgressBarData alloc] init] autorelease];
//    
//    configureData.loadingString = NSLocalizedString(@"恢复中", nil);
//    configureData.successString = NSLocalizedString(@"你订购的项目已恢复!", nil);
//    configureData.failString = NSLocalizedString(@"恢复失败", nil);
//    
//    self.iapLoadingView = [[[PLCRotatingProgressBar alloc] initWithRotatingProgressBarData:configureData] autorelease];
//    [self.iapLoadingView show:self.view];
//    [[IAPMemberVipService instance] restoreMemberShip];
//    [JNEStatisticsHelper pushEventWithActionID:kJNEStatRestoreVipSettingEntryId];
}

- (void)backButtonAction:(UIButton *)sender {
//    [[MainViewController shareInstance]goBackControllerAnimated:YES];
//     [JNEStatisticsHelper pushEventWithActionID:kJNEStatBackSettingEntryId];
}

- (void)languageEvent {
//    [BlurImageSynchronize saveBlurImageToCacheWithView:self.view cacheKey:USER_CENTER_LANGUAGE_SETTINGVIEW];
//    [[MainViewController shareInstance] presentControllerByKey:USER_CENTER_LANGUAGE_SETTINGVIEW animated:YES];
//    [JNEStatisticsHelper pushEventWithActionID:kJNEStatLanguageSettingEntryId];
}

- (void)checkUpdateEvent {}

- (void)imageQualityEvent {
//    [BlurImageSynchronize saveBlurImageToCacheWithView:self.view cacheKey:USER_CENTER_IMAGEQUANLITY_SETTINGVIEW];
//    [[MainViewController shareInstance] presentControllerByKey:USER_CENTER_IMAGEQUANLITY_SETTINGVIEW animated:YES];
//    [JNEStatisticsHelper pushEventWithActionID:kJNEStatPhotoQualitySettingEntryId];
}


#pragma mark  vip member nofication

- (void)vipMemberStateChange:(NSNotification*)nofication {
//    NSDictionary * otherInfo = [nofication userInfo];
//    if (otherInfo) {
//        if ([[otherInfo allKeys] containsObject:@"error"]) {
//            if (self.iapLoadingView) {
//                [self.iapLoadingView showFail];
//                self.iapLoadingView = nil;
//            }
//        }else  {
//            if (self.iapLoadingView) {
//                [self.iapLoadingView showSuccess];
//            }
//        }
//    }else {
//        if (self.iapLoadingView) {
//            [self.iapLoadingView showFail];
//        }
//    }
//    self.iapLoadingView = nil;
}

#pragma mark - UITableView data source and delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNEPersonCenterSettingModel *model = [self.settingModels objectAtIndex:indexPath.row];
    
    if (model.isHeader) {
        return 85 * ViewRateBaseOnIP6;
    } else {
        return 88 * ViewRateBaseOnIP6;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.settingModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNEPersonCenterSettingModel *model = [self.settingModels objectAtIndex:indexPath.row];
    __block JNEPersonCenterSettingViewController *weakSelf = self;
    
    if (model.isSwitch) {
        JNEPersonCenterSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:kJNESettingTableViewSwitchCellKey forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.swichValueChangeBlock = ^(JNEPersonCenterSettingModel * model ,UISwitch *obj) {
//            if ([model.identify isEqualToString:@"isAutoFilter"]) {
//               [weakSelf autoFliterEvent:obj];
//            }else {
//                [weakSelf autoRemoveWaterMark:obj];
//            }
//        };
        cell.model = model;
        return cell;
    } else {
        JNEPersonCenterSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJNESettingTableViewCellKey forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JNEPersonCenterSettingModel *model = self.settingModels[indexPath.row];
    
    if (model.seletorString) {
        SEL seleter = NSSelectorFromString(model.seletorString);
        [self performSelector:seleter withObject:nil];
    }
}

#pragma mark - getter setter

- (NSArray *)defaultSettingModels {
    NSMutableArray <JNEPersonCenterSettingModel *> *models = [NSMutableArray array];
    JNEPersonCenterSettingModel *topModel = nil;

    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"账号", nil) content:@"" isHeader:YES];
    [models addObject:topModel];
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"修改密码", nil) content:@"" isHeader:NO];
    topModel.seletorString = @"changePassword";
    [models addObject:topModel];
    
    
    NSString *mobileString = [JPSApiUserManger shareInstance].currentUser.profile.mobile;
    if ([mobileString isEqualToString:kJNEUserProfileNull] || [mobileString isEqualToString:kJNEUserProfileZero]) {
        mobileString = NSLocalizedString(@"未绑定",nil);
    }

    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"手机号码", nil) content:mobileString isHeader:NO];
    topModel.seletorString = @"bindMobleAction";
    [models addObject:topModel];

    
   NSString *languageDescription = @"zhongwan";
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"语言", nil) content:@"" isHeader:YES];
    [models addObject:topModel];
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:languageDescription content:@"" isHeader:NO];
    topModel.seletorString = @"languageEvent";
    [models addObject:topModel];
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"照片", nil) content:@"" isHeader:YES];
    [models addObject:topModel];
    
    NSString *imageQualityDescription = ([PersistentSettings sharedPersistentSettings].originImageLength == 640) ? NSLocalizedString(@"普通", nil) : NSLocalizedString(@"高清", nil);
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"照片质量", nil) content:imageQualityDescription isHeader:NO];
    topModel.seletorString = @"imageQualityEvent";
    [models addObject:topModel];
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"自动美化", nil) content:[NSNumber numberWithBool:[PersistentSettings sharedPersistentSettings].isAutoFilter] isHeader:NO isSwitch:YES];
    topModel.identify = @"isAutoFilter";
    [models addObject:topModel];
    
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"素材", nil) content:@"" isHeader:YES];
    [models addObject:topModel];
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"清除缓存", nil) content:@"" isHeader:NO];
    topModel.seletorString = @"wipeCacheEvent";
    [models addObject:topModel];
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"重置", nil) content:@"" isHeader:NO];
    topModel.seletorString = @"resetMaterialEvent";
    [models addObject:topModel];
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:@"VIP" content:@"" isHeader:YES];
    [models addObject:topModel];
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"至臻VIP服务", nil) content:@"" isHeader:NO];
    topModel.seletorString = @"buyVipMemberEvent";
    [models addObject:topModel];
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"恢复已购", nil) content:@"" isHeader:NO];
    topModel.seletorString = @"restoreVipMemberEvent";
    [models addObject:topModel];
    
//    if ([[IAPMemberVipService instance] isBuyedRemoveWaterMark]) {
//        topModel =   [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"自动去水印",nil) content:[NSNumber numberWithBool:[PersistentSettings sharedPersistentSettings].isAutoRemoveWaterMark ] isHeader:NO isSwitch:YES];
//        topModel.identify = @"isAutoRemoveWaterMark";
//        [models addObject:topModel];
//    }
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"版本", nil) content:@"" isHeader:YES];
    [models addObject:topModel];
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"给个好评", nil) content:@"" isHeader:NO];
    topModel.seletorString = @"usercommentEvent";
    [models addObject:topModel];
    
    topModel = [JNEPersonCenterSettingModel initWithTitle:NSLocalizedString(@"问题反馈", nil) content:@"" isHeader:NO];
    topModel.seletorString = @"feedBackEvent";
    [models addObject:topModel];
    return models;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UIFont *font = [UIFont systemFontOfSize:34 * MATERIALBASERATE];
        _titleLabel = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _titleLabel.font = font;
        _titleLabel.textColor = [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    }
    
    return _titleLabel;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
//        _backgroundImageView = [[UIImageView alloc] initWithImage:[BlurImageSynchronize readBlurImageWithKey:NSStringFromClass([self class])]];
        _backgroundImageView.frame = self.view.frame;
    }
    
    return _backgroundImageView;
}



- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_backButton setImage:[UIImage imageNamed:@"JNEUserSettingBack"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"JNEUserSettingBack_hover"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.width = 100 * MATERIALBASERATE;
        _backButton.height = 88 * MATERIALBASERATE;
    }
    
    return _backButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JNEPersonCenterSettingTableViewCell class] forCellReuseIdentifier:kJNESettingTableViewCellKey];
        [_tableView registerClass:[JNEPersonCenterSettingSwitchCell class] forCellReuseIdentifier:kJNESettingTableViewSwitchCellKey];
    }
    
    return _tableView;
}

- (void)reload {
    self.settingModels = [self defaultSettingModels];
    [self.tableView reloadData];
}

@end
