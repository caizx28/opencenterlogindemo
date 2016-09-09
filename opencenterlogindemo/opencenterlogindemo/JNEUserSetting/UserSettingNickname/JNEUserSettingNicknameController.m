//
//  UserSettingNicknameController.m
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/16.
//  Copyright © 2016年 poco. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserSettingNicknameController requires ARC support."
#endif

#import "JNEUserSettingNicknameController.h"

#import "JPSApiUserManger.h"



#import "NSStringAddition.h"



#define LOCAL_VIEW_RATE 0.5
#define MAX_NICKNAME_LENGTH 16

@interface JNEUserSettingNicknameController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
//@property (nonatomic, strong) UIImageView *blurBackgroundImageView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation JNEUserSettingNicknameController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.backgroundImageView];
//    [self.view addSubview:self.blurBackgroundImageView];
    
    [self.view addSubview:self.editView];
    [self.editView addSubview:self.textField];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.text = NSLocalizedString(@"修改昵称",nil);
    self.textField.text = [JPSApiUserManger shareInstance].currentUser.profile.nickName;
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
    [self.textField becomeFirstResponder];
    
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
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)configSubviewsFrame {
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat topBarHeight = 88 * LOCAL_VIEW_RATE;
    CGFloat buttonWidth = 100 * LOCAL_VIEW_RATE;
    CGFloat editViewHeight = 90 * LOCAL_VIEW_RATE;
    CGFloat editViewPedding = 40 * LOCAL_VIEW_RATE;
    CGFloat textFieldLeftInset = 40 * LOCAL_VIEW_RATE;
    CGFloat textFieldRightInset = 26 * LOCAL_VIEW_RATE;
    CGFloat rightInset = 40 * LOCAL_VIEW_RATE;
    
    self.backgroundImageView.frame = self.view.bounds;
//    self.blurBackgroundImageView.frame = self.backgroundImageView.bounds;
    self.backButton.frame = CGRectMake(0, 0, buttonWidth, topBarHeight);
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(screenWidth * 0.5, topBarHeight * 0.5);
    [self.sureButton sizeToFit];
    self.sureButton.frame = CGRectMake(screenWidth - self.sureButton.frame.size.width - rightInset, 0,  self.sureButton.frame.size.width, topBarHeight);

    self.editView.frame = CGRectMake(0, 80 + editViewPedding, screenWidth, editViewHeight);
    self.textField.frame = CGRectMake(textFieldLeftInset, 0, screenWidth - (textFieldLeftInset + textFieldRightInset), editViewHeight);
    
}

#pragma mark - JPSLoginCustomUIAlertViewDelegate

//- (void)sureAction:(JPSLoginCustomUIAlertViewWithOneButton *)currentAlertView btn:(UIButton*)sender {
//    [self.textField becomeFirstResponder];
//}

#pragma mark - Action

- (void)backButtonAction:(UIButton *)sender {
//    if (self.transitioningDelegate) {
//        JNESwipeTransitionDelegate *transitionDelegate = self.transitioningDelegate;
//        transitionDelegate.targetEdge = UIRectEdgeLeft;
//    }
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

- (void)sureButtonAction:(UIButton *)sender {
//    if ([[self.textField.text trimmedWhitespaceString] length] == 0) {
//        JPSLoginCustomUIAlertViewWithOneButton *customAlertView = [[JPSLoginCustomUIAlertViewWithOneButton alloc] initWithFrame:SCREEN_BOUNDS];
//        customAlertView.delegate = self;
//        [self.textField resignFirstResponder];
//        [customAlertView customAlertViewshow];
//        [customAlertView setTipContent:NSLocalizedString(@"昵称不能为空！",nil) sureContent:NSLocalizedString(@"确认",nil)];
//        [self.view addSubview:customAlertView];
//    } else {
//        if ([self.delegate respondsToSelector:@selector(userSettingNicknameController:didEndEditWithNickname:)]) {
//            [self.delegate userSettingNicknameController:self didEndEditWithNickname:self.textField.text];
//        }
//    }
}

- (void)textFieldDidChange:(UITextField *)sender {
    UITextRange *selectedRange = [sender markedTextRange];
    UITextPosition *position = [sender positionFromPosition:selectedRange.start offset:0];
    // 不在输入状态下
    if (!position) {
        NSMutableString *text = [sender.text mutableCopy];
        text = [[text stringByReplacingOccurrencesOfString:@" " withString:@""] mutableCopy];
        text = [[text stringByReplacingOccurrencesOfString:@"\n" withString:@""] mutableCopy];
        while (text.length > MAX_NICKNAME_LENGTH) {
            NSRange rangeIndex = [text rangeOfComposedCharacterSequenceAtIndex:MAX_NICKNAME_LENGTH];
            NSInteger deleteLength = rangeIndex.length;
            text = [[text substringToIndex:text.length - deleteLength] mutableCopy];
        }
        //如果需要按Byte长度限制 将while的内容替换成这个
        //        editNickNameView.editField.text = [text subStringWithMaxBytesLen:20];
        sender.text = text;
    }
}

#pragma mark - Injected

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Setter & Getter

- (UIImageView *)backgroundImageView {
//    if (!_backgroundImageView) {
//        _backgroundImageView = [[UIImageView alloc] initWithImage:[BlurImageSynchronize readBlurImageWithKey:NSStringFromClass([self class])]];
//        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
//    }
    return _backgroundImageView;
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

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:NSLocalizedString(@"完成",nil) forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:34 * LOCAL_VIEW_RATE];
        [_sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
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

- (UIView *)editView {
    if (!_editView) {
        _editView = [[UIView alloc] init];
        _editView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        _editView.userInteractionEnabled = YES;
    }
    return _editView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.font = [UIFont systemFontOfSize:34 * LOCAL_VIEW_RATE];
        _textField.textColor = [UIColor blackColor];
        _textField.tintColor = [UIColor orangeColor];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

@end
