//
//  JPSApiResp.h
//  JanePlus
//
//  Created by admin on 16/2/23.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JPSApiAccessInfo;
@class JPSApiUserProfile;

#pragma mark - 响应类

@interface JPSCreditIncomeResp : NSObject
@property (nonatomic, copy) NSString *actionId;
@property (nonatomic, copy) NSString *creditValue;
@property (nonatomic, copy) NSString *creditMessage;
@property (nonatomic, copy) NSNumber *retCode;
@property (nonatomic, copy) NSString *retMsg;
@property (nonatomic, copy) NSDictionary *retData;
@end

@interface JPSRelationResp : NSObject
@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *addTime;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface JPSUploadIconResp : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSError *)localError;
@end

@interface JPSApiBaseResp : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSNumber *retCode;
@property (nonatomic, copy) NSString *retMsg;
@property (nonatomic, copy) NSDictionary *retData;
@property (nonatomic, copy) NSString *retNotice;
@property (nonatomic, copy) NSNumber *clientCode;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, assign) BOOL isOk;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSError *)localError;
@end

@interface JPSGetUserInfoResp : JPSApiBaseResp
@property (nonatomic, retain) JPSApiUserProfile *profile;
@end

@interface JPSThirdParnerSignInResp : JPSApiBaseResp
@property (nonatomic, retain) JPSApiAccessInfo *accessInfo;
@property (nonatomic, retain) JPSApiUserProfile *profile;
@end

@interface JPSDetectAccountIsExistResp : JPSApiBaseResp
@property (nonatomic, copy) NSString *accountExistCheckResult;
@end

@interface JPSGetVerificationCodeResp : JPSApiBaseResp
@property (nonatomic, copy) NSString *verifyCode;
@end

@interface JPSCheckVerificationCodeResp : JPSApiBaseResp
@property (nonatomic, copy) NSString *verifyCodeCheckResult;
@property (nonatomic, copy) NSString *userId;
@end

@interface JPSCreateAccountResp : JPSApiBaseResp
@property (nonatomic, retain) JPSApiAccessInfo *accessInfo;
@property (nonatomic, copy) NSString *uploadFileUrl;
@property (nonatomic, copy) NSString *uploadImageUrl;
@property (nonatomic, copy) NSString *uploadUserIconUrl;
@property (nonatomic, copy) NSString *uploadUserIconUrlWifi;
@end

@interface JPSActionResp : JPSApiBaseResp
@property (nonatomic, copy) NSString *creditValue;
@property (nonatomic, copy) NSString *creditMessage;
@property (nonatomic, copy) NSString *userFreeCredit;
@end

@interface JPSCreditIncomeCollectionResp : JPSApiBaseResp
@property (nonatomic, copy) NSArray<JPSCreditIncomeResp*> *creditIncomeArrary;
@property (nonatomic, copy) NSString *creditTotal;
@property (nonatomic, copy) NSString *userFreeCredit;
@end

@interface JPSTranslateIDResp : JPSApiBaseResp
@property (nonatomic, copy) NSString *pocoId;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *expireTime;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *refreshToken;
@end

@interface JPSRefreshTokenResp : JPSApiBaseResp
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *addId;
@property (nonatomic, copy) NSString *expireTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *userId;
@end

@interface JPSGetBeautyOssUploadTokenResp : JPSApiBaseResp
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *expireIn;
@property (nonatomic, copy) NSString *identify;
@property (nonatomic, copy) NSString *accessKey;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileUrl;
@property (nonatomic, copy) NSString *tokenStr;
@end

@interface JPSAliyunTokenResp : JPSApiBaseResp
@property (nonatomic, copy) NSString *accessKeyId;
@property (nonatomic, copy) NSString *accessKeySecret;
@property (nonatomic, copy) NSString *securityToken;
@property (nonatomic, copy) NSString *bucketName;
@property (nonatomic, copy) NSString *expireIn;
@property (nonatomic, copy) NSString *endPoint;
@property (nonatomic, copy) NSArray *fileBaseNames;
@end

@interface JPSRelationListResp : JPSApiBaseResp
@property (nonatomic, copy) NSArray<JPSRelationResp*> *relations;
@end

@interface JPSUpdateResp : JPSApiBaseResp
@property (nonatomic,assign) BOOL isNeedUpdate;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) BOOL isShowTitle;

@property (nonatomic,copy) NSString *appVersion;
@property (nonatomic,assign) BOOL isShowVersion;

@property (nonatomic,copy) NSString *downloadURL;
@property (nonatomic,copy) NSString * downloadURLDescription;
@property (nonatomic,assign) BOOL isShowDownloadURL;

@property (nonatomic,strong) NSArray<NSString*> *deatils;
@property (nonatomic,assign) BOOL isShowDeatils;

@property (nonatomic,copy) NSString * deatialURL;
@property (nonatomic,copy) NSString * deatialURLDescription;
@property (nonatomic,assign) BOOL isShowDeatialURL;

@property (nonatomic,copy) NSString * ignoreDescription;
@property (nonatomic,assign) BOOL isShowIgnore;

@end

@interface JPSRegisterUserInfoResp : JPSApiBaseResp
@end

@interface JPSUpdateUserInfoResp : JPSApiBaseResp
@end

@interface JPSChangePasswordResp : JPSApiBaseResp
@end

@interface JPSLoginAccountResp : JPSCreateAccountResp
@end

@interface JPSVerifyPasswordResp : JPSApiBaseResp
@end

@interface JPSChangeBindPhoneResp : JPSApiBaseResp
@end

@interface JPSUpdateUserPasswordResp : JPSApiBaseResp
@end

@interface JPSSaveCloudAlbumResp : JPSApiBaseResp
@end

@interface JPSBindMobileResp : JPSApiBaseResp
@end


