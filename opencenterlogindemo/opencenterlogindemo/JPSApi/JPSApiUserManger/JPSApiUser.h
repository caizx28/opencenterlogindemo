//
//  JPSUser.h
//  JanePlus
//
//  Created by admin on 16/2/19.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPSApiObject.h"


@class JPSThirdParnerSignInResp;
@class JPSCreateAccountResp;
@class JPSApiUpdateUserInfoRep;
@class JPSUpdateUserPasswordRep;
@class AFHTTPRequestOperationManager;
@class JPSBindMobileRep;
@class JPSRelationdRep;
@class JPSRelationdListRep;

@interface JPSApiUser : NSObject
@property (nonatomic, retain) JPSApiAccessInfo *accessInfo;
@property (nonatomic, retain) JPSApiUserProfile *profile;
@property (nonatomic, readonly) AFHTTPRequestOperationManager *manger;

- (instancetype)init;
- (instancetype)initWithThirdParnerSignInResp:(JPSThirdParnerSignInResp *)resp;
- (instancetype)initWithMobileSignInResp:(JPSCreateAccountResp *)resp;
- (BOOL)isThirdParnerSignedIn;
- (BOOL)isBindedMobile;
- (BOOL)isAuthorize;
- (BOOL)isCachedProfile;
- (BOOL)isNeedFreshToeken;
- (NSString *)userPath;
- (NSString *)useId;

- (void)obtainUserInfoWithCompletionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)updateUserTokenWithCompletionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)updateUserInfoWithRep:(JPSApiUpdateUserInfoRep *)rep CompletionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)updateUserHeaderWithPhotoPath:(NSString *)path completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)updateUserSpaceWithPhotoPath:(NSString *)path completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)updatePasswordWith:(JPSUpdateUserPasswordRep *)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)bindMobile:(JPSBindMobileRep *)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)obtainSqureIdWithCompletionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;

//我的最爱／恢复下载相关接口
- (void)addRelationWithRep:(JPSRelationdRep*)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)deleteRelationWithRep:(JPSRelationdRep*)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;
- (void)obtainRelationsWithRep:(JPSRelationdListRep*)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;

- (void)actionConsumerBehaviorWithTemplateId:(NSString*)templateId
                             completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;

- (void)actionConsumerBehaviorWithBehaviorId:(NSString*)behaviorId
                                  uniqueCode:(NSString*)uniqueCode
                             completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;

- (void)actionNewMaterialBehaviorWithTemplateId:(NSString *)templateId;

- (void)actionBehaviorWithBehaviorId:(NSString*)behaviorId identify:(NSString *)identify;

- (void)actionBehaviorWithBehaviorId:(NSString*)behaviorId identifys:(NSArray *)identifys ;

- (void)actionBehaviorWithBehaviorId:(NSString *)behaviorId;

- (void)actionBehaviorWithBehaviorIds:(NSArray *)behaviorIds;

- (void)actionBehaviorWithBehaviorIds:(NSArray *)behaviorIds
                      completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;

- (void)actionBehaviorWithBehaviorId:(NSString *)behaviorId
                     completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock;

- (NSString*)uniqueCodeStringWithArray:(NSArray*)params;

@end
