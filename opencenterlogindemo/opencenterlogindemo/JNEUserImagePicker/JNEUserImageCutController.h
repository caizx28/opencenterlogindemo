//
//  JNEUserImageCutController.h
//  puzzleApp
//
//  Created by JiakaiNong on 16/3/8.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JNEUserImageCutController;

typedef NS_ENUM(NSUInteger, JNEUserImageType) {
    JNEUserImageTypeHead,
    JNEUserImageTypeSpace,
};

@protocol JNEUserImageCutControllerDelegate <NSObject>

- (void)userHeadCutController:(JNEUserImageCutController *)controller didEndHandleImage:(UIImage*)image;

@end

@interface JNEUserImageCutController : UIViewController

//@property (nonatomic, retain) NSString *topBarTitle;
//@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) UIImage *shareImage;
@property (nonatomic, assign) JNEUserImageType userImageType;
@property (nonatomic, assign) id<JNEUserImageCutControllerDelegate> delegate;

@end
