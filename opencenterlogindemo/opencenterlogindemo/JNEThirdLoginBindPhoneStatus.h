//
//  JNEThirdLoginBindPhoneStatus.h
//  puzzleApp
//
//  Created by admin on 16/3/21.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#ifndef JNEThirdLoginBindPhoneStatus_h
#define JNEThirdLoginBindPhoneStatus_h

typedef NS_ENUM(NSInteger,JNEThirdLoginBindPhoneStatus){
    NomalRegistrationProcess = 0,
    ThirdLoginUserNoBindPhoneForCloudAlbum = 1,
    ThirdLoginUserNoBindPhoneForCellPhoneNumber = 2
};

#endif /* JNEThirdLoginBindPhoneStatus_h */
