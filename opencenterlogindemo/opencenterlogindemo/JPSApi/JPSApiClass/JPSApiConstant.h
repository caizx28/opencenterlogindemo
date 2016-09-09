//
//  JPSUserConstant.h
//  JanePlus
//
//  Created by admin on 16/2/19.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPShareConstant.h"

typedef  NS_ENUM(NSInteger, JPSApiErrorType){
    JPSApiErrorInDefaultError =0,
    JPSApiErrorInProtocolError,
};

typedef  NS_ENUM(NSInteger, JPSApiLoginType){
    JPSApiLoginTypeOnUnknown = 0,
    JPSApiLoginTypeOnThirdPartner ,
    JPSApiLoginTypeOnPhone,
};

typedef void (^JPSUserMangerOperationCompletionBlock)(id result,NSError *error);

FOUNDATION_EXTERN NSString * const kJPSApiUserMangerCurrentUserIdKey;
FOUNDATION_EXTERN NSString * const kJPSApiUserfreeCreditChangedNotification;

#pragma mark - 积分相关
//2.0.0版本添加
FOUNDATION_EXTERN NSString * const kJPSApiUserThirdParnerSignInActionID;//使用第三方授权登陆
FOUNDATION_EXTERN NSString * const kJPSApiUserMobileResisterActionID;//通过手机注册账号
FOUNDATION_EXTERN NSString * const kJPSApiUserAddSexActionID;//补充性别信息
FOUNDATION_EXTERN NSString * const kJPSApiUserAddRegionActionID;//补充地区信息
FOUNDATION_EXTERN NSString * const kJPSApiUserAddBirthDayActionID;//补充生日信息
FOUNDATION_EXTERN NSString * const kJPSApiUserOpenJaneAppActionID;//每天打开简拼
FOUNDATION_EXTERN NSString * const kJPSApiUserFirstUploadPicToCloudAlbumActionID;//第一次上传图片到云相册
FOUNDATION_EXTERN NSString * const kJPSApiUserBindMobileActionID;//绑定手机

//2.1.0版本添加
FOUNDATION_EXTERN NSString * const kJPSApiUserSharePhotoActionID ;//分享照片到第三方平台
FOUNDATION_EXTERN NSString * const kJPSApiUserUsedNewFuntionActionID;//使用新功能
FOUNDATION_EXTERN NSString * const kJPSApiUserUsedNewMaterialActionID ;//使用新素材
FOUNDATION_EXTERN NSString * const kJPSApiUserUsedInvitaionActionID ;//邀请好友
FOUNDATION_EXTERN NSString * const kJPSApiUserUsedSeeAdActionID ;//看广告
FOUNDATION_EXTERN NSString * const kJPSApiUserUsedCreateAlbumActionID ;//创建相册文件夹
FOUNDATION_EXTERN NSString * const kJPSApiUserUsedAlbumFirstImportPicActionID ;//首次导入相片到相册
FOUNDATION_EXTERN NSString * const kJPSApiUserUsedUnlockActionID ;//解锁素材行为ID
FOUNDATION_EXTERN NSString * const kJPSApiUserSaveTemplateActionID;//保存模板

FOUNDATION_EXTERN NSString * const kJPSAPiUserTemplateClassActionID ;//模板分类id
FOUNDATION_EXTERN NSString * const kJPSAPiUserFontClassActionID;//字典分类id
FOUNDATION_EXTERN NSString * const kJPSAPiUserUniqueCodeAppIdentify;//UniqueCode app_name

FOUNDATION_EXTERN NSString * const kJPSApiUserAgreeMentPhp;//用户许可协议
FOUNDATION_EXTERN NSString * const kJPSApiUserCreditDescriptionPhp;//积分规则

//2.2.0添加

FOUNDATION_EXTERN NSString * const kJPSApiUserTokenInvalid;//用户Token失效

@interface JPSApiConstant : NSObject

+ (NSString *)currentAppVersion;
+ (NSString*)requstJsonStringWithDictionary:(NSDictionary*)dictionary;
+ (NSDictionary*)requstJsonDictionaryWithDictionary:(NSDictionary*)dictionary;
+ (NSString*)requstURLWithSourceURL:(NSString*)url;
+ (NSString*)requestShareTypeStringWithType:(JPShareLoginType)type;
+ (NSString *)filterNullWithValue:(id)value;
+ (NSDictionary*)needCheckInstallAppActionIDMappings;

+ (NSString*)JPSApiUserAgreeMentURL;
+ (NSString*)JPSApiUserCreditDescriptionURL;
+ (NSString*)JPSApiUserMissionHallURL;
+ (NSString*)JPSApiUserInviteFriendURL;
+ (NSString*)JPSApiUserPlayJanedURL;
+ (NSString*)webURLWithParams:(NSDictionary*)params baseURL:(NSString*)baseURL;


@end
