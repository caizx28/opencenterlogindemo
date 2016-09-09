//
//  JPSUserConstant.m
//  JanePlus
//
//  Created by admin on 16/2/19.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import "JPSApiConstant.h"
#import "SBJSON.h"
#import "NSString+Extensions.h"
#import "NSStringAddition.h"
#import "PersistentSettings.h"
#import "AFNetworkReachabilityManager.h"
#import "JPSApiRequestURL.h"
#import "JPSApiUserManger.h"



#if !defined(__has_feature) || !__has_feature(objc_arc)
#error " JPSApiConstant (JPSApi_EasyCopy) requires ARC support."
#endif

 NSString * const kJPSApiUserfreeCreditChangedNotification = @"kJPSApiUserfreeCreditChangedNotification";

 NSString * const kJPSApiUserThirdParnerSignInActionID = @"1001";
 NSString * const kJPSApiUserMobileResisterActionID = @"1002";
 NSString * const kJPSApiUserAddSexActionID = @"1003";
 NSString * const kJPSApiUserAddRegionActionID = @"1004";
 NSString * const kJPSApiUserAddBirthDayActionID = @"1005";
 NSString * const kJPSApiUserOpenJaneAppActionID = @"1007";
 NSString * const kJPSApiUserFirstUploadPicToCloudAlbumActionID = @"1010";
 NSString * const kJPSApiUserBindMobileActionID = @"1011";

 NSString * const kJPSApiUserSharePhotoActionID = @"1024";
 NSString * const kJPSApiUserUsedNewFuntionActionID = @"1025";
 NSString * const kJPSApiUserUsedNewMaterialActionID = @"1026";
 NSString * const kJPSApiUserUsedInvitaionActionID = @"1027";
 NSString * const kJPSApiUserUsedCreateAlbumActionID = @"1028";
 NSString * const kJPSApiUserUsedAlbumFirstImportPicActionID = @"1029";
 NSString * const kJPSApiUserUsedSeeAdActionID = @"1030";
 NSString * const kJPSApiUserUsedUnlockActionID = @"1048";
 NSString * const kJPSApiUserSaveTemplateActionID = @"1051";

 NSString * const kJPSAPiUserTemplateClassActionID = @"JNETemplate";
 NSString * const kJPSAPiUserFontClassActionID = @"JNEFont";
 NSString * const kJPSAPiUserUniqueCodeAppIdentify = @"jianpin";

 NSString * const kJPSApiUserAgreeMentPhp = @"http://www.adnonstop.com/jianpin/wap/user_agreement.php";
 NSString * const kJPSApiUserCreditDescriptionPhp = @"http://www.adnonstop.com/jianpin/wap/credit_description.php";

 NSString * const kJPSApiUserTokenInvalid = @"205";//用户Token失效

@implementation JPSApiConstant

#pragma mark - public method

+ (NSDictionary*)requstJsonDictionaryWithDictionary:(NSDictionary*)dictionary {

    NSString * postString = [self requstJsonStringWithDictionary:dictionary];
    NSDictionary *postDictionary = @{@"req":postString};
    return postDictionary;
}

+ (NSString*)requstJsonStringWithDictionary:(NSDictionary*)dictionary {
    
    SBJSON *jsonTool = [[SBJSON alloc] init] ;
    NSString *paramJsonStr = [jsonTool stringWithObject:dictionary];
    NSString *md5Str = [[NSString stringWithFormat:@"poco_%@_app", paramJsonStr] md5String];
    md5Str = [md5Str lowercaseString];
    if (md5Str.length<=5) {
        return nil;
    }
    NSString *sign_code1 = [md5Str substringFromIndex:5];
    if (sign_code1.length<=8) {
        return nil;
    }
    NSString *sign_code = [sign_code1 substringToIndex:sign_code1.length - 8];
    long timer = (long)[[NSDate date] timeIntervalSince1970];
    NSDictionary *postDataDic = @{
                                  @"version" : [self currentAppVersion],
                                  @"os_type" : @"ios",
                                  @"ctime" : [NSNumber numberWithLongLong:timer],
                                  @"app_name" : PocoAppID,
                                  @"sign_code" : sign_code,
                                  @"is_enc" : [NSNumber numberWithInt:0],
                                  @"param" : dictionary
                                  };
    NSString *postDataJsonStr = [jsonTool stringWithObject:postDataDic];
    return postDataJsonStr;
}

+ (NSString *)currentAppVersion {
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *soft_version=[dict objectForKey:@"CFBundleShortVersionString"];
    return soft_version;
}

+ (NSString*)requestShareTypeStringWithType:(JPShareLoginType)type {
    NSDictionary * partnerMapping = @{@(JPShareLoginTypeFaceBook):@"facebook",
                                      @(JPShareLoginTypeSina):@"sina",
                                      @(JPShareLoginTypeQQ):@"qq",
                                      @(JPShareLoginTypeWechat):@"weixin_open"
                                      };
    return [partnerMapping objectForKey:@(type)];
}

+ (NSString *)filterNullWithValue:(id)value
{
    if([value isKindOfClass:[NSNull class]]) {
        return @"";
    }
    else if(value == nil) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@", value];
}

+ (NSDictionary*)needCheckInstallAppActionIDMappings {
    NSDictionary * arry = @{@"BeautyCamera":@"1008",
                            @"PocoCamera":@"1013",
                            @"babyCamera":@"1015",
                            @"ArtCamera20140919":@"1014",
                            @"jack":@"1012",
                            @"InterCamera":@"1053",
                            @"circle20160324":@"1054"};
    return arry;
}

+ (NSString*)requstURLWithSourceURL:(NSString*)url {
    
    if (![self isWifi]) {
        return url;
    }
    
    NSDictionary * urlMapping = @{kRequestNewThirdPartPartnerBindURL:kRequestNewThirdPartPartnerBindURL};
    if ([[urlMapping allKeys] containsObject:url]) {
        return [urlMapping objectForKey:url];
    }
    return url;
}

+ (NSString*)JPSApiUserAgreeMentURL {
    return [NSString stringWithFormat:@"%@?version=%@",kJPSApiUserAgreeMentPhp,[self currentAppVersion]];
}

+ (NSString*)JPSApiUserCreditDescriptionURL {
    return [NSString stringWithFormat:@"%@?version=%@",kJPSApiUserCreditDescriptionPhp,[self currentAppVersion]];
}

+ (NSString*)JPSApiUserMissionHallURL{
    if ([[JPSApiUserManger shareInstance] isUserSignedIn]) {
        NSString * useId = [JPSApiUserManger shareInstance].currentUser.accessInfo.userId;
        NSString * accessToken = [JPSApiUserManger shareInstance].currentUser.accessInfo.accessToken;
        return [self webURLWithParams:@{@"user_id":useId,
                                        @"access_token":accessToken} baseURL:kRequestMissonHallURL];
    }
    return kRequestMissonHallURL;
}

+ (NSString*)JPSApiUserInviteFriendURL {
    if ([[JPSApiUserManger shareInstance] isUserSignedIn]) {
        NSString * useId = [JPSApiUserManger shareInstance].currentUser.accessInfo.userId;
        NSString * accessToken = [JPSApiUserManger shareInstance].currentUser.accessInfo.accessToken;
        return [self webURLWithParams:@{@"user_id":useId,
                                        @"access_token":accessToken} baseURL:kRequestInviteFriendURL];
    }
    return kRequestInviteFriendURL;
}

+ (NSString*)JPSApiUserPlayJanedURL {
    return [NSString stringWithFormat:@"%@version=%@&os_type=ios",kRequestPlayJanedURL,[self currentAppVersion]];
}

+ (NSString*)webURLWithParams:(NSDictionary*)params baseURL:(NSString*)baseURL{
    NSString * param = [NSString encodeBase64String:[self requstJsonStringWithDictionary:params]];
    NSString * URL = [NSString stringWithFormat:@"%@&req=%@",baseURL,param];
    return URL;
}

#pragma mark - private  method 

+ (BOOL)isWifi {
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
}

@end
