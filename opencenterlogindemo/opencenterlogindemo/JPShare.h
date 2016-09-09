//
//  JPShare.h
//  JanePlus
//
//  Created by admin on 15/8/21.
//  Copyright (c) 2015年 Allen Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPShareConstant.h"
#import "JPShareAuthorizeObject.h"
#import "JPShareContentObject.h"
#import "JPShareContentObjectTranslater.h"

@class JPShare;

@protocol JPShareDelegate <NSObject>

- (void)share:(JPShare *)share notInstallNativeApp:(NSDictionary*)userInfo;

- (void)share:(id<JPShareAPI> )share AuthorizeSuccessed:(NSDictionary*)userInfo;
- (void)share:(id<JPShareAPI> )share AuthorizeFail:(NSDictionary*)userInfo;

- (void)share:(id<JPShareAPI>)share AuthorizeCodeSuccess:(NSString*)userInfo;

- (void)share:(id<JPShareAPI>)share AuthorizeCancel:(NSDictionary*)userInfo;
- (void)share:(id<JPShareAPI>)share logOutSuccess:(NSDictionary*)userInfo;

- (void)share:(id<JPShareAPI>)share ShareContentSuccessed:(NSDictionary*)userInfo;
- (void)share:(id<JPShareAPI>)share ShareContentFail:(NSDictionary*)userInfo;
- (void)share:(id<JPShareAPI>)share ShareContentCancel:(NSDictionary*)userInfo;

- (void)share:(id<JPShareAPI>)share requestOauthTokenStart:(NSDictionary*)userInfo;
- (void)share:(id<JPShareAPI>)share requestOauthTokenEnd:(NSDictionary*)userInfo;

@end

@interface JPShare : NSObject

@property (nonatomic,weak) id<JPShareDelegate> delegate;
@property (nonatomic,strong) id<JPShareContentObjectTranslater>  contentObjectTranslater;

+ (JPShare *)shareObject;

+ (BOOL)handleOpenURL:(UIApplication *)application
                  openURL:(NSURL *)url
        sourceApplication:(NSString *)sourceApplication
               annotation:(id)annotation;

+ (void)registerAppShareConfigWith:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (NSString*)shareFileRootPath;

+ (id<JPShareContentObjectTranslater>)contentObjectTranslaterWithType:(JPShareContentObjectTranslaterType)type;

+ (JPShareLoginType)shareTypeConvertToLoginTypeWith:(JPShareType)type;

+ (CGFloat)shareImageCompressRateWithType:(JPShareType)type;

- (instancetype)init;

- (void)loginWithType:(JPShareLoginType)type;

- (void)logoutWithType:(JPShareLoginType)type;

- (void)logoutAllSharePlatform;

- (void)sendWithContentObject:(JPShareContentObject*)object;

- (void)sendWithContentObject:(JPShareContentObject*)object contentObjectTranslater:(id<JPShareContentObjectTranslater>)contentObjectTranslater;

- (BOOL)isLogineWithType:(JPShareLoginType)type;

- (JPShareAuthorizeObject*)authorizeObjectWithType:(JPShareLoginType)type;

- (id<JPShareAPI>)shareEngineWithType:(JPShareLoginType)type;

- (BOOL)isInstallNativeAppWithType:(JPShareLoginType)type;

@end


@interface JPShareConfiguretion : NSObject

@property (nonatomic,readonly,assign) Class  ShareClass;
@property (nonatomic,readonly,copy) NSString * ShareAppKey;
@property (nonatomic,readonly,copy) NSString * ShareAppSecret;
@property (nonatomic,readonly,copy) NSString * ShareAppRedirectURI;
@property (nonatomic,readonly,copy) NSString * ShareAuthorizeFile;
@property (nonatomic,readonly,copy) NSString * SharePlatform;
@property (nonatomic,readonly,copy) NSString * ShareURLIdentify;

+ (JPShareConfiguretion *)configuretionWithDictionary:(NSDictionary*)dictionary;

+ (JPShareConfiguretion *)configuretionWithType:(JPShareLoginType)type;

+ (NSArray<JPShareConfiguretion*> *)shareConfiguretions ;

+ (Class)shareClassWithPlatformString:(NSString*)platformString;

@end

