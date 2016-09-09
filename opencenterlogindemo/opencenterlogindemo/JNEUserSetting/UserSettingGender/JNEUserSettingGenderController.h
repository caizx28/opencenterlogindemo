//
//  UserSettingGenderController.h
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/17.
//  Copyright © 2016年 poco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JNEUserSettingGenderController;

@protocol JNEUserSettingGenderControllerDelegate <NSObject>

- (void)userSettingGenderController:(JNEUserSettingGenderController *)controller didSelectGender:(NSString *)gender;

@end

@interface JNEUserSettingGenderController : UIViewController

@property (nonatomic, assign, getter = isMale) BOOL male;
@property (nonatomic, weak) id<JNEUserSettingGenderControllerDelegate> delegate;

@end
