//
//  JNEMyInformationController.h
//  puzzleApp
//
//  Created by admin on 16/7/21.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPSApiUser.h"
#import "JNEUserImagePickerController.h"
#import "JNEUserSettingNicknameController.h"

#import "JNEUserSettingGenderController.h"

#import "JNEUserSettingAreaPickerController.h"


@interface JNEMyInformationController : UIViewController<JNEUserImagePickerControllerDelegate,JNEUserSettingNicknameControllerDelegate,JNEUserSettingGenderControllerDelegate,JNEUserSettingAreaPickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@end
