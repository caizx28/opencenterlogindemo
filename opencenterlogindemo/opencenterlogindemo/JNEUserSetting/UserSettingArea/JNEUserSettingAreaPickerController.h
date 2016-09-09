//
//  UserSettingAreaPickerController.h
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/16.
//  Copyright © 2016年 poco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JNEUserSettingAreaPickerController;

@protocol JNEUserSettingAreaPickerControllerDelegate <NSObject>

- (void)userSettingAreaPickerController:(JNEUserSettingAreaPickerController *)controller didSelectAreaWithAreaCode:(NSString *)code;

@end

@interface JNEUserSettingAreaPickerController : UIViewController

@property (nonatomic, strong) NSArray *recieveObjectArray;
@property (nonatomic, assign) NSInteger choosenIndex;
@property (nonatomic, weak) id<JNEUserSettingAreaPickerControllerDelegate> delegate;

@end
