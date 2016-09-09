//
//  JPShareConstant.h
//  JanePlus
//
//  Created by admin on 15/8/21.
//  Copyright (c) 2015年 Allen Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JPShareTool.h"

@class JPShareAuthorizeObject;
@class JPShareContentObject;
@protocol JPShareOperationDelegate;

typedef NS_ENUM(NSUInteger, JPShareType) {
    JPShareTypeSina = 0,            //新浪微博分享
    JPShareTypeTencent,         //腾讯微博分享
    JPShareTypeQQ,              //QQ好友分享
    JPShareTypeQQZone,          //QQ空间分享
    JPShareTypeWechatSession,   //微信好友分享
    JPShareTypeWechatTimeline , //微信朋友圈分享
    JPShareTypePoco ,  //分享POCO
    JPShareTypeFaceBook, //facebook分享
    JPShareTypeTwitter,  //推特分享
    JPShareTypeInstagram //Instagram 分享
};

typedef NS_ENUM(NSUInteger, JPShareLoginType) {
    JPShareLoginTypeSina = 0,       //新浪微博登录
    JPShareLoginTypeTencent,    //腾讯微博登录
    JPShareLoginTypeQQ,         //QQ登录
    JPShareLoginTypeWechat  ,   //微信登录
    JPShareLoginTypePoco ,   //POCO登陆
    JPShareLoginTypeFaceBook, //facebook登陆
    JPShareLoginTypeTwitter , //推特登陆
    JPShareLoginTypeInstagram //Instagram 登陆
};

typedef  NS_ENUM(NSInteger, JPShareMediaType){
    ShareGif,
    ShareVideo,
    ShareWeb,
    ShareImage
};

@protocol JPShareAPI <NSObject>

@required
@property (nonatomic,weak) id<JPShareOperationDelegate> delegate;
@property (nonatomic,assign) JPShareType type;
@property (nonatomic,strong) JPShareAuthorizeObject *object;

- (instancetype)init;
- (void)logIn;
- (void)logOut;
- (void)clearCache;
- (BOOL)isAuthorizeExpired;
- (BOOL)isLogined;
- (void)sendContentWithObject:(JPShareContentObject*)object;
- (NSString*)authorizeFilePath;
+ (void)registerAppShareConfigWith:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (BOOL)isInstallNativeApp;
@optional

//目前sina ,qq ,微信需要实现
+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id)delegate;

//目前facebook需要实现
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end

@protocol JPShareOperationDelegate <NSObject>

- (void)share:(id<JPShareAPI>)share AuthorizeSuccessed:(NSDictionary*)userInfo;
- (void)share:(id<JPShareAPI>)share AuthorizeFail:(NSDictionary*)userInfo;
- (void)share:(id<JPShareAPI>)share AuthorizeCodeSuccess:(NSString*)userInfo;
- (void)share:(id<JPShareAPI>)share AuthorizeCancel:(NSDictionary*)userInfo;
- (void)share:(id<JPShareAPI>)share logOutSuccess:(NSDictionary*)userInfo;

- (void)share:(id<JPShareAPI>)share ShareContentSuccessed:(NSDictionary*)userInfo;
- (void)share:(id<JPShareAPI>)share ShareContentFail:(NSDictionary*)userInfo;
- (void)share:(id<JPShareAPI>)share ShareContentCancel:(NSDictionary*)userInfo;

- (void)share:(id<JPShareAPI>)share requestOauthTokenStart:(NSDictionary*)userInfo;
- (void)share:(id<JPShareAPI>)share requestOauthTokenEnd:(NSDictionary*)userInfo;

- (void)share:(id<JPShareAPI>)share notInstallNativeApp:(NSDictionary*)userInfo;

@end

@interface JPShareConstant : NSObject

+ (UIImage *)resizeThumImage:(UIImage *)image;

@end
