//
//  JNEUserImagePickerController.h
//  puzzleApp
//
//  Created by JiakaiNong on 16/3/8.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNEUserImageCutController.h"

@class JNEUserImagePickerController;

@protocol JNEUserImagePickerControllerDelegate <NSObject>

- (void)userHeadPickerController:(JNEUserImagePickerController *)controller didPickImage:(UIImage *)image;

@end

@interface JNEUserImagePickerController : UIViewController

@property (nonatomic, assign) id<JNEUserImagePickerControllerDelegate> delegate;
@property (nonatomic, assign) JNEUserImageType userImageType;

@end
