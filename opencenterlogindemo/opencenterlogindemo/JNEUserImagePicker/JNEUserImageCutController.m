//
//  JNEUserImageCutController.m
//  puzzleApp
//
//  Created by JiakaiNong on 16/3/8.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserImageCutController requires ARC support."
#endif

#import "JNEUserImageCutController.h"
//#import "UIImage+Resize.h"
//#import "UIImage+Rotating.h"
#include "math.h"
//#import "CGAffineTransformFun.h"

#define VIEW_RATE ([[UIScreen mainScreen] bounds].size.width / 640.0f)
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define CHOOSE_PICTURE_VIEW @"JNEAlbumPickerNavigationController"
static CGFloat kminLength = 400;

@interface JNEUserImageCutController () <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat xScale;
@property (nonatomic, assign) CGFloat yScale;
@property (nonatomic, assign) CGFloat imageRatio;

@property (nonatomic, strong) UIImageView *adjustBorderImageView;
@property (nonatomic, strong) UIImageView *adjustImageView;
@property (nonatomic, strong) UIScrollView *adjustView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;

@end

@implementation JNEUserImageCutController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:[self backgroundImageView]];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.adjustBorderImageView];
    [self.view addSubview:self.adjustView];
    [self.view addSubview:self.sureButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configViewFrame];
    [self initImage];
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

- (void)configViewFrame {
    CGFloat viewCenterX = CGRectGetMidX(self.view.bounds);
    CGFloat viewCenterOffsetY = -110 * MATERIALBASERATE;
    
    CGFloat cancelButtonTopInset = 11 * VIEW_MATERIAL_BASE_RATE;
    CGFloat sureButtonBottomInset = 60 * VIEW_RATE;
    
    if (IS_568_HEIGHT_LOGICPIXEL) {
        sureButtonBottomInset = 100 * VIEW_RATE;
    }else if(IS_480_HEIGHT_LOGICPIXEL) {
        cancelButtonTopInset = 20 * VIEW_MATERIAL_BASE_RATE;
        sureButtonBottomInset = 100 * MATERIALBASERATE;
    }
    
    CGFloat cancelButtonHeight = CGRectGetHeight(self.cancelButton.frame);
    CGFloat sureButtonHeight = CGRectGetHeight(self.sureButton.frame);
    
    self.cancelButton.center = CGPointMake(viewCenterX, cancelButtonTopInset + cancelButtonHeight / 2);
    self.sureButton.center = CGPointMake(viewCenterX, CGRectGetHeight(self.view.bounds) - (sureButtonBottomInset + sureButtonHeight / 2));
    
    CGFloat adjustViewWidth = ceil(510 * VIEW_MATERIAL_BASE_RATE);
    CGFloat adjustViewHeight = adjustViewWidth;
    CGFloat adjustBorderWidth = 2;
    CGRect adjustViewFrame = CGRectMake(0, 0, adjustViewWidth, adjustViewHeight);
    UIImage *adjustBorderImage = [UIImage imageNamed:@"JNEUserImagePickerHeadCuttingBox"];
    if (self.userImageType == JNEUserImageTypeSpace) {
        adjustViewWidth = ceil(654 * ViewRateBaseOnIP6);
        adjustViewHeight = ceil(437 * ViewRateBaseOnIP6);
        adjustViewFrame = CGRectMake(0, 0, adjustViewWidth, adjustViewHeight);
        adjustBorderImage = [UIImage imageNamed:@"JNEUserImagePickerSpaceCuttingBox"];
    }
    self.adjustView.frame = adjustViewFrame;
    self.adjustBorderImageView.frame = CGRectMake(0, 0, adjustViewWidth + adjustBorderWidth, adjustViewHeight + adjustBorderWidth);
    self.adjustBorderImageView.image = adjustBorderImage;
    self.adjustView.center = CGPointMake(ceil(SCREEN_WIDTH / 2), ceil(SCREEN_HEIGHT / 2 + viewCenterOffsetY));
    self.self.adjustBorderImageView.center = CGPointMake(ceil(SCREEN_WIDTH / 2), ceil(SCREEN_HEIGHT / 2 + viewCenterOffsetY));
}

- (void)initImage {
    CGFloat zoomScale = MAX(self.xScale, self.yScale);
    self.adjustView.minimumZoomScale = zoomScale;
    self.adjustView.maximumZoomScale = ceil(zoomScale);
    self.adjustView.zoomScale = zoomScale;
    if (self.isShareImageTypeLandscape) {
        self.adjustView.contentOffset = CGPointMake((self.adjustView.contentSize.width - self.adjustView.frame.size.width) / 2, 0);
    } else {
        self.adjustView.contentOffset = CGPointMake(0, (self.adjustView.contentSize.height - self.adjustView.frame.size.height) / 2);
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.adjustImageView;
}

#pragma mark - Actions

- (void)cancelButtonEvent:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

- (void)sureButtonEvent:(id)sender {
    UIImage *image = [self getImageInAdjustView:self.adjustView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(userHeadCutController:didEndHandleImage:)]) {
        [self.delegate userHeadCutController:self didEndHandleImage:image];
    }
}

#pragma mark - Private Methods

- (UIImage *)getImageInAdjustView:(UIScrollView *)view {
//    UIImage *imageBeCroped = [self.adjustImageView.image croppedImage:[self croppedRectWithImage:self.adjustImageView.image view:view]];
//    CGFloat pro = imageBeCroped.size.width > imageBeCroped.size.height ? (kminLength / imageBeCroped.size.height) : (kminLength / imageBeCroped.size.width);
//    imageBeCroped = [imageBeCroped scaleByFactor:pro];
//    imageBeCroped = [ImageUtil changeBrightnessContrastSaturation2:imageBeCroped brightness:0 contrast:0 saturationValue:0 sharpen:30] ;
    return self.adjustImageView.image;
}

- (CGRect)croppedRectWithImage:(UIImage *)image view:(UIScrollView *)view {
    CGFloat xScale = view.contentSize.width / image.size.width;
    CGFloat yScale = view.contentSize.height / image.size.height;
    CGPoint imageOffset = view.contentOffset;
    CGFloat rectWidth = ceil(view.frame.size.width / xScale);
    CGFloat rectHeight = ceil(view.frame.size.height / yScale);
    return CGRectMake(imageOffset.x / xScale, imageOffset.y / yScale, rectWidth, rectHeight);
}

#pragma mark - Setter & Getter

- (CGFloat)xScale {
    return self.adjustView.frame.size.width / self.adjustImageView.frame.size.width;
}

- (CGFloat)yScale {
    return self.adjustView.frame.size.height / self.adjustImageView.frame.size.height;
}

- (CGFloat)imageRatio {
    return self.adjustImageView.frame.size.width / self.adjustImageView.frame.size.height;
}

- (BOOL)isShareImageTypeLandscape {
    return self.xScale < self.yScale?YES:NO;
}

- (UIImageView *)adjustBorderImageView {
    if (!_adjustBorderImageView) {
        _adjustBorderImageView = [[UIImageView alloc] init];
    }
    return _adjustBorderImageView;
}

- (UIScrollView *)adjustView {
    if (!_adjustView) {
        _adjustView = [[UIScrollView alloc]init];
        _adjustView.contentSize = self.adjustImageView.frame.size;
        _adjustView.clipsToBounds = YES;
        _adjustView.showsHorizontalScrollIndicator = NO;
        _adjustView.showsVerticalScrollIndicator = NO;
        _adjustView.alwaysBounceHorizontal = YES;
        _adjustView.alwaysBounceVertical = YES;
        _adjustView.delegate = self;
        [_adjustView addSubview:self.adjustImageView];
    }
    return _adjustView;
}

- (UIImageView *)adjustImageView {
    if (!_adjustImageView) {
        _adjustImageView = [[UIImageView alloc]initWithImage:self.shareImage];
    }
    return _adjustImageView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        CGFloat buttonWidth = 136 * VIEW_MATERIAL_BASE_RATE;
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
        [_sureButton setImage:[UIImage imageNamed:@"PuzzleWordTipsIcon_ok_normal.png"] forState:UIControlStateNormal];
        [_sureButton setImage:[UIImage imageNamed:@"PuzzleWordTipsIcon_ok_highlight.png"] forState:UIControlStateHighlighted];
        [_sureButton addTarget:self action:@selector(sureButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        CGFloat buttonWidth = 80 * VIEW_MATERIAL_BASE_RATE;
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
        [_cancelButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [_cancelButton setImage:[UIImage imageNamed:@"cancel_hover.png"] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIImageView *)backgroundImageView {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = [UIImage imageNamed:@"shareView_bg.jpg"];
    [self.view addSubview:backgroundImageView];
    
    CALayer *blackMaskLayer = [CALayer layer];
    blackMaskLayer.frame = backgroundImageView.bounds;
    blackMaskLayer.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
    [backgroundImageView.layer addSublayer:blackMaskLayer];
    
    UIImageView *blurBackgroundImageView = [[UIImageView alloc] initWithFrame:backgroundImageView.bounds];
    blurBackgroundImageView.image = [FileOperate readImageWithFile:[NSString stringWithFormat:@"%@/%@.jpg",APP_CACHES_PATH, CHOOSE_PICTURE_VIEW ]];
    blurBackgroundImageView.alpha = 0.6;
    [backgroundImageView addSubview:blurBackgroundImageView];
    
    return backgroundImageView;
}

@end
