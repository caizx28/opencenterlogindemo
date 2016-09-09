//
//  UserSettingAreaPickerController.m
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/16.
//  Copyright © 2016年 poco. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserSettingAreaPickerController requires ARC support."
#endif

#import "JNEUserSettingAreaPickerController.h"

#import "JNEUserSettingAreaCell.h"

#import "JPSApiUserManger.h"


#define AREA_CELL_IDENTIFIER @"areaCellIdentifier"

#define LOCAL_VIEW_RATE 0.5

@interface JNEUserSettingAreaPickerController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
//@property (nonatomic, strong) UIImageView *blurBackgroundImageView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *areaTableView;
@property (nonatomic, strong) NSMutableArray *prepareObjectArray;
@property (nonatomic, strong) NSArray *areaObjectArray;
@property (nonatomic, strong) NSString *choosenAreaCode;

@end

@implementation JNEUserSettingAreaPickerController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.areaObjectArray = [self getAreaObjectArray];
    self.choosenIndex = [self initChoosenIndex];
    [self.view addSubview:self.backgroundImageView];
//    [self.view addSubview:self.blurBackgroundImageView];
    self.navigationItem.title = @"地区";
    [self.view addSubview:self.areaTableView];
    }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.text = NSLocalizedString(@"地区",nil);
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
    CGFloat topBarHeight = 88 * LOCAL_VIEW_RATE;
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat buttonWidth = 100 * LOCAL_VIEW_RATE;
    
    self.backgroundImageView.frame = self.view.bounds;
//    self.blurBackgroundImageView.frame = self.backgroundImageView.bounds;
    
    self.areaTableView.frame = self.view.bounds;
    self.areaTableView.contentInset = UIEdgeInsetsMake(topBarHeight, 0, 0, 0);
    self.areaTableView.contentOffset = CGPointMake(0, -topBarHeight);
    
    self.backButton.frame = CGRectMake(0, 0, buttonWidth, topBarHeight);
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(screenWidth * 0.5, topBarHeight * 0.5);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.areaObjectArray.count;
}

- (JNEUserSettingAreaCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNEUserSettingAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:AREA_CELL_IDENTIFIER];
    JNELocationObject *object = self.areaObjectArray[indexPath.row];
    [cell configCellWithObject:object];
//    cell.choosen = (indexPath.row == self.choosenIndex) ? YES : NO;
   
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JNELocationObject *selectObject = self.areaObjectArray[indexPath.row];
//    if (selectObject.child.count) {
//        JNEUserSettingAreaPickerController *controller = [[JNEUserSettingAreaPickerController alloc] init];
//        controller.delegate = self.delegate;
//        controller.recieveObjectArray = [JNELocationJsonParser locationObjectArrayWithChild:selectObject.child];
//        [self.navigationController pushViewController:controller animated:YES];
//    } else {
//        if ([self.delegate respondsToSelector:@selector(userSettingAreaPickerController:didSelectAreaWithAreaCode:)]) {
//            [self.delegate userSettingAreaPickerController:self didSelectAreaWithAreaCode:selectObject.locationID];
//        }
//        self.choosenIndex = indexPath.row;
//        [tableView reloadData];
//    }
}

#pragma mark - Action

- (void)backButtonAction:(UIButton *)sender {
//    if (self.navigationController.transitioningDelegate) {
//        JNESwipeTransitionDelegate *transitionDelegate = self.navigationController.transitioningDelegate;
//        transitionDelegate.targetEdge = UIRectEdgeLeft;
//    }
//    if (self.navigationController.viewControllers.count == 1) {
//        [self.navigationController dismissViewControllerAnimated:YES completion:^{
//            nil;
//        }];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - Private Method

- (NSArray *)getAreaObjectArray {
//    if (self.recieveObjectArray) {
//        return self.recieveObjectArray;
//    } else {
//       
//    }
    return self.recieveObjectArray;
}

- (NSInteger)initChoosenIndex {
    NSInteger index = NSIntegerMax;
    for (NSInteger i = 0; i < self.areaObjectArray.count; i++) {
        JNELocationObject *object = self.areaObjectArray[i];
        
    }
    return index;
}

#pragma mark - Setter & Getter

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
//        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomePageBg.jpg"]];
//        CALayer *blackMaskLayer = [CALayer layer];
//        blackMaskLayer.frame = _backgroundImageView.bounds;
//        blackMaskLayer.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
//        [_backgroundImageView.layer addSublayer:blackMaskLayer];
//
//        _backgroundImageView = [[UIImageView alloc] initWithImage:[BlurImageSynchronize readBlurImageWithKey:NSStringFromClass([self class])]];
//        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
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
        _titleLabel = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _titleLabel.font = [UIFont systemFontOfSize:34 * LOCAL_VIEW_RATE];
        _titleLabel.textColor = [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    }
    return _titleLabel;
}

- (NSMutableArray *)prepareObjectArray {
    if (!_prepareObjectArray) {
        _prepareObjectArray = [[NSMutableArray alloc] init];
    }
    return _prepareObjectArray;
}

- (UITableView *)areaTableView {
    if (!_areaTableView) {
        _areaTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _areaTableView.dataSource = self;
        _areaTableView.delegate = self;
        _areaTableView.backgroundColor = [UIColor clearColor];
        _areaTableView.sectionHeaderHeight = 0;
        _areaTableView.sectionFooterHeight = 0;
//        _areaTableView.showsVerticalScrollIndicator = NO;
        _areaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_areaTableView registerClass:[JNEUserSettingAreaCell class] forCellReuseIdentifier:AREA_CELL_IDENTIFIER];
    }
    return _areaTableView;
}

@end
