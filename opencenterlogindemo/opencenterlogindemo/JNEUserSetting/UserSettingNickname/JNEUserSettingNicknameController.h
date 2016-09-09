//
//  UserSettingNicknameController.h
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/16.
//  Copyright © 2016年 poco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JNEUserSettingNicknameController;

@protocol JNEUserSettingNicknameControllerDelegate <NSObject>

- (void)userSettingNicknameController:(JNEUserSettingNicknameController *)controller didEndEditWithNickname:(NSString *)nickname;

@end

@interface JNEUserSettingNicknameController : UIViewController

@property (nonatomic, weak) id<JNEUserSettingNicknameControllerDelegate> delegate;

@end
