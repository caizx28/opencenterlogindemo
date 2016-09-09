//
//  JNEUserImagePickerController.m
//  puzzleApp
//
//  Created by JiakaiNong on 16/3/8.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserImagePickerController requires ARC support."
#endif

#import "JNEUserImagePickerController.h"
//#import "JNEAlbumPickerNavigationController.h"
#import "UserHeaderManger.h"


@interface JNEUserImagePickerController () <JNEUserImageCutControllerDelegate>



@end

@implementation JNEUserImagePickerController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
//    [self addChildViewController:self.pickerController];
//    [self.view addSubview:self.pickerController.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
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

#pragma mark - JNEAlbumPickerNavigationControllerDelegate

//- (void)pickerNavigationController:(JNEAlbumPickerNavigationController *)controller didSelectImage:(UIImage *)image {
//    JNEUserImageCutController *cutController = [[JNEUserImageCutController alloc] init];
//    cutController.delegate = self;
//    cutController.shareImage = image;
//    cutController.userImageType = self.userImageType;
//    [self presentViewController:cutController animated:YES completion:^{
//        nil;
//    }];
//}

#pragma mark - JNEUserImageCutControllerDelegate

- (void)userHeadCutController:(JNEUserImageCutController *)controller didEndHandleImage:(UIImage*)image {
    [[UserHeaderManger shareInstance] saveUserHeaderToLocal:image];
    if (self.delegate && [self.delegate respondsToSelector:@selector(userHeadPickerController:didPickImage:)]) {
        [self.delegate userHeadPickerController:self didPickImage:image];
    }
}

#pragma mark - Setter & Getter

//- (JNEAlbumPickerNavigationController *)pickerController {
//    if (!_pickerController) {
//        _pickerController = [[JNEAlbumPickerNavigationController alloc] initWithPickerDelegate:self multiPicker:NO];
//    }
//    return _pickerController;
//}

@end
