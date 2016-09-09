//
//  JPSApiRep.h
//  JanePlus
//
//  Created by admin on 16/2/23.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import "JPSApiObject.h"

@class JPSGetBeautyOssUploadTokenResp;

@interface JPSApiMobileSignInRep : NSObject
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *area;
@end

@interface JPSApiDetectAccountIsExistRep : JPSApiMobileSignInRep
@property (nonatomic, assign) BOOL isCheckPassword;
@end

@interface JPSApiGetVerificationCodeRep : JPSApiMobileSignInRep
@property (nonatomic, copy) NSString *type; //register //find //bind_mobile
@end

@interface JPSApiCheckVerificationCodeRep : JPSApiGetVerificationCodeRep
@property (nonatomic, copy) NSString *verifyCode;
@end

@interface JPSApiCreateAccountRep : JPSApiCheckVerificationCodeRep
@property (nonatomic, assign) BOOL isCheckVerifyCode;
@end

@interface JPSApiRegisterUserInfoRep : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *password;
@end

@interface JPSApiUploadIconRep : NSObject
@property (nonatomic, retain) JPSGetBeautyOssUploadTokenResp *beautyOssInfo;
@property (nonatomic, copy) NSString *iconPath;
@end

@interface JPSApiUpdateUserInfoRep : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *userIcon;

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *repassword;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *signature;

@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *locationId;
@property (nonatomic, copy) NSString *birthdayYear;
@property (nonatomic, copy) NSString *birthdayMonth;
@property (nonatomic, copy) NSString *birthdayDay;
@property (nonatomic, copy) NSString *userSpace;

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *zoneNum;
@end

@interface JPSApiChangePasswordRep : JPSApiCheckVerificationCodeRep
@end

@interface JPSApiLoginAccountRep : JPSApiMobileSignInRep
@property (nonatomic, copy) NSString *accountType;
@end

@interface JPSApiGetUserInfoRep : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *accessToken;
@end

@interface JPSVerifyPasswordRep : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *password;
@end

@interface JPSChangeBindPhoneRep : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *oldZoneNum;
@property (nonatomic, copy) NSString *oldPhone;
@property (nonatomic, copy) NSString *pnewZoneNum;
@property (nonatomic, copy) NSString *pnewPhone;
@property (nonatomic, assign) BOOL *isCheckMobileOld;
@end

@interface JPSUpdateUserPasswordRep : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *freshPwd;
@property (nonatomic, copy) NSString *oldPwd;
@property (nonatomic, copy) NSString *accessToken;
@end

@interface JPSBindMobileRep : JPSApiMobileSignInRep
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, copy) NSString *accesstoken;
@property (nonatomic, assign) BOOL *isCheckVerifyCode;
@end

@interface JPSActiondRep : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *actionId;
@property (nonatomic, copy) NSString *uniqueCode;
@end

@interface JPSSendToWorlddRep : JPSApiGetUserInfoRep
@property (nonatomic, copy) NSString *pocoId;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *content;
@end

@interface JPSRelationdRep : JPSApiGetUserInfoRep
@property (nonatomic, copy) NSString *typeId;   //关系类型ID(11=>'我的最爱',12 =>'恢复下载')
@property (nonatomic, copy) NSString *objectId; // 对象ID(例如模板ID)
@property (nonatomic, assign) BOOL isDeleteAll; // 是否删除 某个类型的 所有记录，默认为NO
@end

@interface JPSRelationdListRep : JPSApiGetUserInfoRep
@property (nonatomic, copy) NSString *typeId;   //关系类型ID(11=>'我的最爱',12 =>'恢复下载')
@property (nonatomic, copy) NSString *page;     // 请求页面数
@property (nonatomic, copy) NSString *length;   // 请求每页的数量

@end
