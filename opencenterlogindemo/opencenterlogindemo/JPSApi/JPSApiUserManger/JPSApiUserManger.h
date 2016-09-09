//
//  JPSUserManger.h
//  JanePlus
//
//  Created by admin on 16/2/19.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPShare.h"
#import "JPSApiConstant.h"
#import "JPSApiObject.h"
#import "JPSApiUser.h"

@class JPSApiMobileSignInRep;
@class JPSApiCheckVerificationCodeRep;
@class JPSApiCreateAccountRep;
@class JPSApiChangePasswordRep;
@class JPSUpdateUserPasswordRep;
@class JPSBindMobileRep;
@class JPSApiRegisterUserInfoRep;

@protocol JPSApiUserThirdParnerAuthorizeDelegate <NSObject>
- (void)user:(JPSApiUser*)user  beginThirdParnerAuthorize:(id<JPShareAPI>)share;
- (void)user:(JPSApiUser*)user  thirdParnerAuthorizeCodeSuccess:(id<JPShareAPI>)share;
- (void)user:(JPSApiUser*)user  successedThirdParnerAuthorize:(id<JPShareAPI>)share;
- (void)user:(JPSApiUser*)user  failThirdParnerAuthorize:(id<JPShareAPI>)share;
- (void)user:(JPSApiUser*)user  successAuthorize:(NSDictionary*)userInfo;
- (void)user:(JPSApiUser*)user  failAuthorize:(NSError*)error;
@end

@interface JPSApiUserManger : NSObject {
}

@property (nonatomic,readonly)id<JPSApiUserThirdParnerAuthorizeDelegate> delegate;
@property (nonatomic,retain) JPSApiUser * currentUser;
@property (nonatomic,retain) JPSApiCheckVerificationCodeRep *checkVerifyCodeResult;

+ (JPSApiUserManger *)shareInstance ;

- (NSString*)rootPath;
- (void)cancelAllReuest;
- (BOOL)isUserSignedIn;
- (void)signOutCurrenUser;
- (void)deleteCacheWithUser:(JPSApiUser *)user;
- (BOOL)persistentWithUser:(JPSApiUser*)user;
- (NSString*)userPathWithUserId:(NSString*)userId;

- (void)signInWithThirdParnerType:(JPShareLoginType)type delegate:(id<JPSApiUserThirdParnerAuthorizeDelegate>)delegate;
- (void)signInWithMobieRep:(JPSApiMobileSignInRep*)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)confirmVerifyCodeForRegisterWithRep:(JPSApiCheckVerificationCodeRep *)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)uploadHeadPictureWithRep:(JPSApiCreateAccountRep *)rep icon:(NSString *)iconPath completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)registerUserInfoWithRep:(JPSApiRegisterUserInfoRep *)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)confirmVerifyCodeForChangePasswordWith:(JPSApiCheckVerificationCodeRep *)rep  completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)forgetPasswordWith:(NSString *)password completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;

@end
