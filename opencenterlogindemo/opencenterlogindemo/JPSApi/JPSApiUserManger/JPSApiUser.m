//
//  JPSUser.m
//  JanePlus
//
//  Created by admin on 16/2/19.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import "JPSApiUser.h"
#import "JPSApiResp.h"
#import "NSObject+JPSApi_EasyCopy.h"
#import "JPSApiUserManger.h"
#import "JPSApiRequestManger.h"
#import "AFHTTPRequestOperationManager+JXExtentsion.h"
#import "JPSApiRequestURL.h"
#import "JPSApiSequencer.h"
#import "JPSApiUserPointToastView.h"
#import "NSStringAddition.h"

#import "NSString+Extensions.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error " JPSApiUser (JPSApi_EasyCopy) requires ARC support."
#endif

@interface JPSApiUser ()
@property (nonatomic,strong) AFHTTPRequestOperationManager * manger;
@end

@implementation JPSApiUser

- (instancetype)init {
    self = [super init];
    if (self) {
        self.accessInfo = [[JPSApiAccessInfo alloc] init];
        self.profile = [[JPSApiUserProfile alloc] init];
        self.manger = [AFHTTPRequestOperationManager defaultHTTPRequestOperationManager];
        self.manger.operationQueue.maxConcurrentOperationCount = 1.0;
    }
    return self;
}

- (instancetype)initWithThirdParnerSignInResp:(JPSThirdParnerSignInResp*)resp {
    self = [self init];
    if (self) {
        [self.profile easyDeepCopy:resp.profile];
        [self.accessInfo easyDeepCopy:resp.accessInfo];
    }
    return self;
}

- (instancetype)initWithMobileSignInResp:(JPSLoginAccountResp*)resp {
    self = [self init];
    if (self) {
        [self.accessInfo easyDeepCopy:resp.accessInfo];
    }
    return self;
}

- (BOOL)isAuthorize {
    if ([self.accessInfo isValid]) {
        return YES;
    }
    return NO;
}

- (BOOL)isCachedProfile {
    if ([self.profile isValid]) {
        return YES;
    }
    return NO;
}

- (BOOL)isThirdParnerSignedIn {
    if (self.accessInfo.type == JPSApiLoginTypeOnThirdPartner) {
        return YES;
    }
    return NO;
}

- (BOOL)isNeedFreshToeken {
    
    if (![self isAuthorize]) {
        return NO;
    }
    
    NSDate * date = [NSDate date];
    BOOL isNeedUpdate = NO;
    NSDate * expireTimeDate = [NSDate dateWithTimeIntervalSince1970:[self.accessInfo.expireTime doubleValue]];
    NSInteger days = 30;
    isNeedUpdate = (days <1)?YES:NO;
    return isNeedUpdate;
}

- (BOOL)isBindedMobile {
//    if (!isEmptyOrWhitespaceOrNil(self.profile.mobile)&&!isEmptyOrWhitespaceOrNil(self.profile.zone_num)&&![self.profile.mobile isEqualToString:@"0"]) {
//        return YES;
//    }
    return NO;
}

- (NSString*)userPath {
    if ([self isAuthorize]) {
        return [[JPSApiUserManger shareInstance] userPathWithUserId:self.accessInfo.userId];
    }
    return @"./";
}

- (NSString*)useId {
    if ([self isAuthorize]) {
        return self.accessInfo.userId;
    }
    return @"";
}

- (void)updateUserTokenWithCompletionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock {
    if ([self isAuthorize]&&[self isNeedFreshToeken]) {
        [JPSApiRequestManger requestRefreshTokenWithUserId:self.accessInfo.userId refreshToken:self.accessInfo.refreshToken completeBlock:^(JPSRefreshTokenResp * result, NSError *error, AFHTTPRequestOperation *op) {
            if (!error||result.isOk) {
                self.accessInfo.userId = result.userId;
                self.accessInfo.accessToken = result.accessToken;
                self.accessInfo.refreshToken = result.refreshToken;
                self.accessInfo.expireTime = result.expireTime;
                self.accessInfo.addId = result.addId;
                self.accessInfo.addTime = result.addTime;
                self.accessInfo.updateTime = result.updateTime;
                BOOL success = [[JPSApiUserManger shareInstance] persistentWithUser:self];
                if (success) {
                    if (completionBlock) {
                        completionBlock(result,nil);
                    }
                }else{
                    if (completionBlock) {
                        completionBlock(nil,[NSError errorWithDomain:@"updateUserToken" code:10 userInfo:@{@"message":@"保存用户信息失败"}]);
                    }
                }
            }else {
                if (completionBlock) {
                    completionBlock(nil,[NSError errorWithDomain:@"updateUserToken" code:10 userInfo:@{@"message":@"保存用户信息失败"}]);
                }
            }
        }];
    }else {
        if (completionBlock) {
            completionBlock(nil,[NSError errorWithDomain:@"updateUserToken" code:10 userInfo:@{@"message":@"用户没授权信息"}]);
        }
    }
}

- (void)obtainUserInfoWithCompletionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock {
    if ([self isAuthorize]) {
        if ([self.manger.operationQueue operationCount] > 0) {
             [self.manger.operationQueue cancelAllOperations];
        }
        JPSApiGetUserInfoRep *rep = [[JPSApiGetUserInfoRep alloc] init];
        rep.userId = self.accessInfo.userId;
        rep.accessToken = self.accessInfo.accessToken;
        AFHTTPRequestOperation * operation =   [JPSApiRequestManger requestGetUserInfoWithObject:rep completeBlock:^(JPSGetUserInfoResp *result, NSError *error, AFHTTPRequestOperation *op) {
                if (error||!result.isOk) {
                    NSError * localError = error?[JPSApiRequestManger defaultError] :[result localError];
                    if (completionBlock) {
                        completionBlock(nil,localError);
                    }
                }else{
                    JPSGetUserInfoResp *resp = result;
                    NSLog(@"获得登陆信息%@",_profile);
                    self.profile = resp.profile;
                    BOOL success = [[JPSApiUserManger shareInstance] persistentWithUser:self];
                    if (success) {
                        if (completionBlock) {
                            completionBlock(resp,nil);
                        }
                    }else{
                        if (completionBlock) {
                            completionBlock(nil,[NSError errorWithDomain:@"obtainUserInfo" code:10 userInfo:@{@"message":@"保存用户信息失败"}]);
                        }
                    }
                }
            }];
            [self.manger.operationQueue addOperation:operation];
    }else {
        if (completionBlock) {
            completionBlock(nil,[NSError errorWithDomain:@"obtainUserInfo" code:10 userInfo:@{@"message":@"用户没授权信息"}]);
        }
    }
}

//更新用户信息
- (void)updateUserInfoWithRep:(JPSApiUpdateUserInfoRep *)rep CompletionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock{
    
    if (!rep.userId) {
        rep.userId = self.accessInfo.userId;
    }
    
    if (!rep.accessToken) {
        rep.accessToken = self.accessInfo.accessToken;
    }
    
    [JPSApiRequestManger requestUpdateUserInfoWithObject:rep completeBlock:^(JPSUpdateUserInfoResp *result, NSError *error, AFHTTPRequestOperation *op) {
        if (error || !result.isOk) {
            NSError * localError = error?[JPSApiRequestManger defaultError] :[result localError];
            if (completionBlock) {
                completionBlock(nil,localError);
            }
        } else {
            if (completionBlock) {
                completionBlock(result,nil);
            }
        }
    }];
}

- (void)bindMobile:(JPSBindMobileRep *)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock {
    rep.userId = self.accessInfo.userId;
    rep.area = [JPSApiUserManger shareInstance].checkVerifyCodeResult.area;
    rep.phoneNumber = [JPSApiUserManger shareInstance].checkVerifyCodeResult.phoneNumber;
    rep.verifyCode = [JPSApiUserManger shareInstance].checkVerifyCodeResult.verifyCode;
    rep.accesstoken = self.accessInfo.accessToken;
    [JPSApiRequestManger requestBindMobile:rep completeBlock:^(JPSBindMobileResp *result, NSError *error, AFHTTPRequestOperation *op) {
        if (error || !result.isOk) {
            NSError *error = error?[JPSApiRequestManger defaultError]:[result localError];
            if (completionBlock) {
                completionBlock(nil,error);
            }
        }else{
            JPSBindMobileResp *resp = result;
            self.profile.mobile = rep.phoneNumber;
            self.profile.zone_num = rep.area;
            [[JPSApiUserManger shareInstance] persistentWithUser:self];
            if (completionBlock) {
                completionBlock(resp,nil);
            }
        }
    }];
}

//更新头像
- (void)updateUserHeaderWithPhotoPath:(NSString*)path completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock{
    __weak JPSApiUser * weakSelf = self;
    
    JPSApiSequencer *sequencer = [[JPSApiSequencer alloc] init];
    [sequencer enqueueStep:^(id result, JPSApiSequencerCompletion completion) {
        [JPSApiRequestManger requestUploadHeadPortraitsWithUserID:self.accessInfo.userId Accesstoken:self.accessInfo.accessToken withIconPaht:path completeBlock:^(id result, NSError *error, AFHTTPRequestOperation *op) {
            if (error) {
                if (completionBlock) {
                    completionBlock(nil,error);
                }
            }else{
                NSString *iconurl = result;
                if (completion) {
                    completion(iconurl,nil);
                }
            }
        }];
    }];
    
    [sequencer enqueueStep:^(NSString *result, JPSApiSequencerCompletion completion) {
        if (result) {
            JPSApiUpdateUserInfoRep * rep = [[JPSApiUpdateUserInfoRep alloc] init];
            rep.userId = weakSelf.accessInfo.userId;
            rep.accessToken = weakSelf.accessInfo.accessToken;
            rep.userIcon = result;
            [JPSApiRequestManger requestUpdateUserInfoWithObject:rep completeBlock:^(JPSUpdateUserInfoResp *result, NSError *error, AFHTTPRequestOperation *op) {
                if (error || !result.isOk) {
                    NSError * localError = error?[JPSApiRequestManger defaultError] :[result localError];
                    if (completionBlock) {
                        completionBlock(nil,localError);
                    }
                } else {
                    if (completionBlock) {
                        completionBlock(result,nil);
                    }
                }
            }];
        }else {
            if (completion) {
                completion(nil,[JPSApiRequestManger defaultError]);
            }
        }
    }];
    [sequencer run];
}

//更新封面图片
- (void)updateUserSpaceWithPhotoPath:(NSString*)path completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock {
    __weak JPSApiUser * weakSelf = self;
    
    JPSApiSequencer *sequencer = [[JPSApiSequencer alloc] init];
    [sequencer enqueueStep:^(id result, JPSApiSequencerCompletion completion) {
        [JPSApiRequestManger requestUploadHeadPortraitsWithUserID:self.accessInfo.userId Accesstoken:self.accessInfo.accessToken withIconPaht:path completeBlock:^(id result, NSError *error, AFHTTPRequestOperation *op) {
            if (error) {
                if (completionBlock) {
                    completionBlock(nil,error);
                }
            }else{
                NSString *iconurl = result;
                if (completion) {
                    completion(iconurl,nil);
                }
            }
        }];
    }];
    
    [sequencer enqueueStep:^(NSString *result, JPSApiSequencerCompletion completion) {
        if (result) {
            JPSApiUpdateUserInfoRep * rep = [[JPSApiUpdateUserInfoRep alloc] init];
            rep.userId = weakSelf.accessInfo.userId;
            rep.accessToken = weakSelf.accessInfo.accessToken;
            rep.userSpace = result;
            [JPSApiRequestManger requestUpdateUserInfoWithObject:rep completeBlock:^(JPSUpdateUserInfoResp *result, NSError *error, AFHTTPRequestOperation *op) {
                if (error || !result.isOk) {
                    NSError * localError = error?[JPSApiRequestManger defaultError] :[result localError];
                    if (completionBlock) {
                        completionBlock(nil,localError);
                    }
                } else {
                    if (completionBlock) {
                        completionBlock(result,nil);
                    }
                }
            }];
        }else {
            if (completion) {
                completion(nil,[JPSApiRequestManger defaultError]);
            }
        }
    }];
    [sequencer run];
}

//修改用户密码
- (void)updatePasswordWith:(JPSUpdateUserPasswordRep *)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock {
    rep.userId = self.accessInfo.userId;
    rep.accessToken = self.accessInfo.accessToken;
    [JPSApiRequestManger requestUpdateUserPasswordWithObject:rep completeBlock:^(JPSUpdateUserPasswordResp *result, NSError *error, AFHTTPRequestOperation *op) {
        if (error||!result.isOk) {
            NSError * localError = error?[JPSApiRequestManger defaultError] :[result localError];
            if (completionBlock) {
                completionBlock(nil,localError);
            }
        }else{
            JPSUpdateUserPasswordResp *resp = result;
            if (completionBlock) {
                completionBlock(resp,nil);
            }
        }
    }];
}

- (void)addRelationWithRep:(JPSRelationdRep*)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock {
    if ([self isAuthorize]&&rep) {
        rep.userId = self.accessInfo.userId;
        rep.accessToken = self.accessInfo.accessToken;
        rep.typeId = !rep.typeId?@"":rep.typeId;
        rep.objectId = !rep.objectId?@"":rep.objectId;
        [JPSApiRequestManger requestAddRelationWithReq:rep completeBlock:^(JPSApiBaseResp * result, NSError *error, AFHTTPRequestOperation *op) {
            if (error||!result.isOk) {
                NSError * localError = error?[JPSApiRequestManger defaultError] :[result localError];
                if (completionBlock) {
                    completionBlock(nil,localError);
                }
            }else{
                if (completionBlock) {
                    completionBlock(result,nil);
                }
            }
        }];
    }else {
        if (completionBlock) {
            completionBlock(nil,[NSError errorWithDomain:@"JPSApiUser" code:-1 userInfo:@{@"message":@"没授权"}]);
        }
    }
}

- (void)deleteRelationWithRep:(JPSRelationdRep*)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock {
    if ([self isAuthorize]&&rep) {
        rep.userId = self.accessInfo.userId;
        rep.accessToken = self.accessInfo.accessToken;
        rep.typeId = !rep.typeId?@"":rep.typeId;
        if (rep.isDeleteAll) {
            [JPSApiRequestManger requestDeleteAllRelationWithReq:rep completeBlock:^(JPSApiBaseResp * result, NSError *error, AFHTTPRequestOperation *op) {
                if (error||!result.isOk) {
                    NSError * localError = error?[JPSApiRequestManger defaultError] :[result localError];
                    if (completionBlock) {
                        completionBlock(nil,localError);
                    }
                }else{
                    if (completionBlock) {
                        completionBlock(result,nil);
                    }
                }
            }];
        } else {
            [JPSApiRequestManger requestDeleteRelationWithReq:rep completeBlock:^(JPSApiBaseResp * result, NSError *error, AFHTTPRequestOperation *op) {
                if (error||!result.isOk) {
                    NSError * localError = error?[JPSApiRequestManger defaultError] :[result localError];
                    if (completionBlock) {
                        completionBlock(nil,localError);
                    }
                }else{
                    if (completionBlock) {
                        completionBlock(result,nil);
                    }
                }
            }];
        }
    }else {
        if (completionBlock) {
            completionBlock(nil,[NSError errorWithDomain:@"JPSApiUser" code:-1 userInfo:@{@"message":@"没授权"}]);
        }
    }
}

- (void)obtainRelationsWithRep:(JPSRelationdListRep*)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock {
    if ([self isAuthorize]&&rep) {
        rep.userId = self.accessInfo.userId;
        rep.accessToken = self.accessInfo.accessToken;
        rep.typeId = !rep.typeId?@"":rep.typeId;
        rep.page = !rep.page?@"1":rep.page;
        rep.length = !rep.length?@"100":rep.length;
        [JPSApiRequestManger requestGetRelationWithReq:rep completeBlock:^(JPSRelationListResp * result, NSError *error, AFHTTPRequestOperation *op) {
            if (error||!result.isOk) {
                NSError * localError = error?[JPSApiRequestManger defaultError] :[result localError];
                if (completionBlock) {
                    completionBlock(nil,localError);
                }
            }else{
                if (completionBlock) {
                    completionBlock(result,nil);
                }
            }
        }];
    }else {
        if (completionBlock) {
            completionBlock(nil,[NSError errorWithDomain:@"JPSApiUser" code:-1 userInfo:@{@"message":@"没授权"}]);
        }
    }
}

#pragma mark  - 广场相关

//获取pocoId
- (void)obtainSqureIdWithCompletionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock {
    if ([self isAuthorize]) {
        JPSApiGetUserInfoRep * req = [JPSApiGetUserInfoRep new];
        req.userId = self.accessInfo.userId;
        req.accessToken = self.accessInfo.accessToken;
        [JPSApiRequestManger requestPocoIDWithMeirenId:req completeBlock:^(JPSTranslateIDResp * result, NSError *error, AFHTTPRequestOperation *op) {
            if (!error&&result.isOk) {
                NSMutableDictionary * accountDic = [NSMutableDictionary dictionary];
                [accountDic setObject:@"广场用户" forKey:@"nickname"];
                [accountDic setObject:result.password forKey:@"password"];
                [accountDic setObject:result.pocoId forKey:@"pocoID"];
                [accountDic setObject:result.accessToken forKey:@"accessToken"];
                [accountDic setObject:result.expireTime forKey:@"expireTime"];
                [accountDic setObject:result.refreshToken forKey:@"refreshToken"];
                
            }
            if (completionBlock) {
                completionBlock(result,error);
            }
        }];
    }else {
        if (completionBlock) {
            completionBlock(nil,[NSError errorWithDomain:@"JPSApiUser" code:-1 userInfo:@{@"message":@"没授权"}]);
        }
    }
}

#pragma mark - 用户积分 消费

- (void)actionConsumerBehaviorWithTemplateId:(NSString*)templateId  completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock{
    NSString * uniqueCode = [self uniqueCodeStringWithArray:@[kJPSAPiUserUniqueCodeAppIdentify,kJPSAPiUserTemplateClassActionID,templateId]];
    [self actionConsumerBehaviorWithBehaviorId:kJPSApiUserUsedUnlockActionID uniqueCode:uniqueCode  completionBlock:completionBlock];
}

- (void)actionConsumerBehaviorWithBehaviorId:(NSString*)behaviorId uniqueCode:(NSString*)uniqueCode completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock {
    if ([self isAuthorize]) {
        JPSActiondRep * rep = [JPSActiondRep new];
        rep.userId = self.accessInfo.userId;
        rep.accessToken = self.accessInfo.accessToken;
        rep.actionId = behaviorId;
        rep.uniqueCode = uniqueCode;
        [JPSApiRequestManger requestkCreditConsumerWithObject:rep completeBlock:^(JPSActionResp * result, NSError *error, AFHTTPRequestOperation *op) {
            if (!error&&result.isOk) {
                self.profile.freeCredit = result.userFreeCredit;
                [[JPSApiUserManger shareInstance] persistentWithUser:self];
                [self postMainThreadNotificationWithName:kJPSApiUserfreeCreditChangedNotification userInfo:nil];
            }
            if (completionBlock) {
                completionBlock(result,error);
            }
        }];
    }else {
        if (completionBlock) {
            completionBlock(nil,[NSError errorWithDomain:@"JPSApiUser" code:-1 userInfo:@{@"message":@"没授权"}]);
        }
    }
}

#pragma mark - 用户积分收入

- (void)actionNewMaterialBehaviorWithTemplateId:(NSString *)templateId  {
    NSArray *identifys = @[kJPSAPiUserTemplateClassActionID,templateId];
    [self actionBehaviorWithBehaviorId:kJPSApiUserUsedNewMaterialActionID identifys:identifys];
}

- (void)actionBehaviorWithBehaviorId:(NSString*)behaviorId identify:(NSString *)identify {
    [self actionBehaviorWithBehaviorId:behaviorId identifys:@[identify]];
}

- (void)actionBehaviorWithBehaviorId:(NSString*)behaviorId identifys:(NSArray *)identifys {
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:kJPSAPiUserUniqueCodeAppIdentify];
    [array addObjectsFromArray:identifys];
    NSString * uniqueCode = [self uniqueCodeStringWithArray:array];
    [self actionBehaviorWithBehaviorId:behaviorId uniqueCode:uniqueCode isShowTips:YES completionBlock:nil];
}

- (void)actionBehaviorWithBehaviorIds:(NSArray*)behaviorIds {
    [self actionBehaviorWithBehaviorIds:behaviorIds completionBlock:nil];
}

- (void)actionBehaviorWithBehaviorIds:(NSArray*)behaviorIds
                      completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock  {
    
    [self actionBehaviorWithBehaviorIds:behaviorIds isShowTips:YES completionBlock:completionBlock];
}

- (void)actionBehaviorWithBehaviorIds:(NSArray*)behaviorIds
                           isShowTips:(BOOL)isShowTips
                      completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock  {
    
    [self actionBehaviorWithBehaviorIds:behaviorIds uniqueCodes:nil isShowTips:isShowTips completionBlock:completionBlock];
}

- (void)actionBehaviorWithBehaviorId:(NSString*)behaviorId {
    [self actionBehaviorWithBehaviorId:behaviorId completionBlock:nil];
}

- (void)actionBehaviorWithBehaviorId:(NSString*)behaviorId
                     completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock {
    
    [self actionBehaviorWithBehaviorId:behaviorId isShowTips:YES completionBlock:completionBlock];
}

- (void)actionBehaviorWithBehaviorId:(NSString*)behaviorId
                          isShowTips:(BOOL)isShowTips
                     completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock  {
    
    [self actionBehaviorWithBehaviorId:behaviorId uniqueCode:nil isShowTips:isShowTips completionBlock:completionBlock];
}

- (void)actionBehaviorWithBehaviorIds:(NSArray*)behaviorIds
                          uniqueCodes:(NSArray*)uniqueCodes
                           isShowTips:(BOOL)isShowTips
                      completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock  {
    
    if ([self isAuthorize]) {
        if (behaviorIds&&[behaviorIds count]>0) {
            NSString * actionId = [behaviorIds componentsJoinedByString:@","];
            NSString * uniqueCode = [uniqueCodes componentsJoinedByString:@","];
            [self actionBehaviorWithBehaviorId:actionId uniqueCode:uniqueCode isShowTips:isShowTips completionBlock:completionBlock];
        }
    }else {
        if (completionBlock) {
            completionBlock(nil,[NSError errorWithDomain:@"JPSApiUser" code:-1 userInfo:@{@"message":@"没授权"}]);
        }
    }
}

- (void)actionBehaviorWithBehaviorId:(NSString*)behaviorId
                          uniqueCode:(NSString*)uniqueCode
                          isShowTips:(BOOL)isShowTips
                     completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock  {
    
    if ([self isAuthorize]) {
        if (behaviorId) {
            JPSActiondRep * rep = [JPSActiondRep new];
            rep.userId = self.accessInfo.userId;
            rep.accessToken = self.accessInfo.accessToken;
            rep.actionId = behaviorId;
            rep.uniqueCode = uniqueCode;
            [JPSApiRequestManger requestCreditIncomeWithObject:rep completeBlock:^(JPSCreditIncomeCollectionResp * result, NSError *error, AFHTTPRequestOperation *op) {
                 if (!error&&result.isOk) {
                    JPSCreditIncomeResp * firstcreditIncome = [result.creditIncomeArrary firstObject];
                    if ([firstcreditIncome.creditValue integerValue] > 0&&[firstcreditIncome.retCode integerValue] == 0) {
                        JPSLog(@"%@",result.userFreeCredit);
                        self.profile.freeCredit = result.creditTotal;
                        [[JPSApiUserManger shareInstance] persistentWithUser:self];
                        [self postMainThreadNotificationWithName:kJPSApiUserfreeCreditChangedNotification userInfo:nil];
                        if (isShowTips) {
                            [JPSApiUserPointToastView showToastWithDescription:firstcreditIncome.creditMessage];
                        }
                    }
                }
                if (completionBlock) {
                    completionBlock(result,error);
                }
            }];
        }
    }else {
        if (completionBlock) {
            completionBlock(nil,[NSError errorWithDomain:@"JPSApiUser" code:-1 userInfo:@{@"message":@"没授权"}]);
        }
    }
}

#pragma mark - private

- (void)postMainThreadNotificationWithName:(NSString*)name  userInfo:(NSString*)freeCredit {
    NSNotification* notification = [NSNotification notificationWithName:name
                                                                 object:[freeCredit copy]
                                                               userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
}

- (NSString*)uniqueCodeStringWithArray:(NSArray*)params {
    NSString * uniqueCodeString = @"";
    for (NSString * param in params) {
        uniqueCodeString = [NSString stringWithFormat:@"%@%@",uniqueCodeString,param];
    }
    
    if (![uniqueCodeString isEqualToString:@""]) {
        return [[uniqueCodeString md5String] lowercaseString];
    }
    
    return nil;
}

@end
