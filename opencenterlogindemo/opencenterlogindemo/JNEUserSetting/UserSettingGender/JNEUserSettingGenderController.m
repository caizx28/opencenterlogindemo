//
//  UserSettingGenderController.m
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/17.
//  Copyright © 2016年 poco. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserSettingGenderController requires ARC support."
#endif

#import "JNEUserSettingGenderController.h"

#import "JPSApiUserManger.h"

#define LOCAL_VIEW_RATE 0.5
#define MALE_TITLE_TAG 10001
#define FEMALE_TITLE_TAG 10002
#define SEPARATE_LINE_TAG 10003

@interface JNEUserSettingGenderController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
//@property (nonatomic, strong) UIImageView *blurBackgroundImageView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *genderChooseView;
@property (nonatomic, strong) UIImageView *checkMark;
@property (nonatomic, strong) UIButton *maleButton;
@property (nonatomic, strong) UIButton *femaleButton;

@end

@implementation JNEUserSettingGenderController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.backgroundImageView];
//    [self.view addSubview:self.blurBackgroundImageView];
    
    [self.view addSubview:self.genderChooseView];
    [self.genderChooseView addSubview:[self separateLine]];
    [self.genderChooseView addSubview:[self labelWithText:NSLocalizedString(@"男",nil) Tag:MALE_TITLE_TAG]];
    [self.genderChooseView addSubview:[self labelWithText:NSLocalizedString(@"女",nil) Tag:FEMALE_TITLE_TAG]];
    [self.genderChooseView addSubview:self.checkMark];
    [self.genderChooseView addSubview:self.maleButton];
    [self.genderChooseView addSubview:self.femaleButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.text = NSLocalizedString(@"修改性别",nil);
    self.male = ([[JPSApiUserManger shareInstance].currentUser.profile.sex isEqualToString:@"男"]) ? YES : NO;
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
}

- (void)configSubviewsFrame {
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat topBarHeight = 88 * LOCAL_VIEW_RATE;
    CGFloat buttonWidth = 100 * LOCAL_VIEW_RATE;
    CGFloat genderChooseViewPedding = 40 * LOCAL_VIEW_RATE;
    CGFloat genderChooseViewHeight = 88 * 2 * LOCAL_VIEW_RATE;
    CGFloat leftInset = 40 * LOCAL_VIEW_RATE;
    CGFloat rightInset = 40 * LOCAL_VIEW_RATE;
    CGFloat buttonHeight = 88 * LOCAL_VIEW_RATE;
    CGFloat checkMarkOrginY = self.isMale ? 0 : buttonHeight;
    CGFloat checkMarkWidth = 42 * LOCAL_VIEW_RATE;
    
    self.backgroundImageView.frame = self.view.bounds;
//    self.blurBackgroundImageView.frame = self.backgroundImageView.bounds;
    self.backButton.frame = CGRectMake(0, 0, buttonWidth, topBarHeight);
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(screenWidth * 0.5, topBarHeight * 0.5);
    
    self.genderChooseView.frame = CGRectMake(0, topBarHeight + genderChooseViewPedding, screenWidth, genderChooseViewHeight);
    [self.genderChooseView viewWithTag:SEPARATE_LINE_TAG].frame = CGRectMake(leftInset, genderChooseViewHeight * 0.5, screenWidth - leftInset, 1);
    UILabel *maleLabel = [self.genderChooseView viewWithTag:MALE_TITLE_TAG];
    maleLabel.frame = CGRectMake(leftInset, 0, CGRectGetWidth(maleLabel.frame), buttonHeight);
    UILabel *femaleLabel = [self.genderChooseView viewWithTag:FEMALE_TITLE_TAG];
    femaleLabel.frame = CGRectMake(leftInset, buttonHeight, CGRectGetWidth(femaleLabel.frame), buttonHeight);
    self.maleButton.frame = CGRectMake(0, 0, screenWidth, buttonHeight);
    self.femaleButton.frame = CGRectMake(0, buttonHeight, screenWidth, buttonHeight);
    self.checkMark.frame = CGRectMake(screenWidth - (rightInset + checkMarkWidth), checkMarkOrginY, checkMarkWidth, buttonHeight);
    
}

#pragma mark - Action

- (void)backButtonAction:(UIButton *)sender {
    if (self.transitioningDelegate) {
            }
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

- (void)maleButtonAction:(UIButton *)sender {
    NSLog(@"maleButtonAction");
    self.male = YES;
    [self.view setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(userSettingGenderController:didSelectGender:)]) {
        [self.delegate userSettingGenderController:self didSelectGender:@"男"];
    }
}

- (void)femaleButtonAction:(UIButton *)sender {
    NSLog(@"femaleButtonAction");
    self.male = NO;
    [self.view setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(userSettingGenderController:didSelectGender:)]) {
        [self.delegate userSettingGenderController:self didSelectGender:@"女"];
    }
}

#pragma mark - Injected

- (void)injected {
    [self.view setNeedsLayout];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Pirvate Method

- (UILabel *)labelWithText:(NSString *)text Tag:(NSInteger)tag {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.text = text;
    label.tag = tag;
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:34 * LOCAL_VIEW_RATE];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:87.0 / 255.0 green:72.0 / 255.0 blue:75.0 / 255.0 alpha:1.0];
    return label;
}

- (UIView *)separateLine {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.08];
    view.tag = SEPARATE_LINE_TAG;
    return view;
}

#pragma mark - Setter & Getter

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
//        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomePageBg.jpg"]];
        
//        _backgroundImageView = [[UIImageView alloc] init];
//        _backgroundImageView.backgroundColor = [UIColor redColor];
        
//        CALayer *blackMaskLayer = [CALayer layer];
//        blackMaskLayer.frame = _backgroundImageView.bounds;
//        blackMaskLayer.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
//        [_backgroundImageView.layer addSublayer:blackMaskLayer];
        
    }
    return _backgroundImageView;
}

//- (UIImageView *)blurBackgroundImageView {
//    if (!_blurBackgroundImageView) {
//        UIImage *image = [FileOperate readImageWithFile:[NSString stringWithFormat:@"%@/%@.jpg",APP_CACHES_PATH, USER_SETTING_VIEW]];
//        _blurBackgroundImageView = [[UIImageView alloc] initWithImage:image];
//        _blurBackgroundImageView.alpha = 0.6;
//    }
//    return _blurBackgroundImageView;
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
        UIFont *font = [UIFont systemFontOfSize:34 * LOCAL_VIEW_RATE];
        _titleLabel = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _titleLabel.font = font;
        _titleLabel.textColor = [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    }
    return _titleLabel;
}

- (UIView *)genderChooseView {
    if (!_genderChooseView) {
        _genderChooseView = [[UIView alloc] init];
        _genderChooseView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    return _genderChooseView;
}

- (UIImageView *)checkMark {
    if (!_checkMark) {
        _checkMark = [[UIImageView alloc] init];
        _checkMark.image = [UIImage imageNamed:@"JNEUserSettingCheckMark"];
        _checkMark.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _checkMark;
}

- (UIButton *)maleButton {
    if (!_maleButton) {
        _maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_maleButton addTarget:self action:@selector(maleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maleButton;
}

- (UIButton *)femaleButton {
    if (!_femaleButton) {
        _femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_femaleButton addTarget:self action:@selector(femaleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _femaleButton;
}

@end
