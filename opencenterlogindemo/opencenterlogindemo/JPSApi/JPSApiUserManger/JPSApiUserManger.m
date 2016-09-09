//
//  JPSUserManger.m
//  JanePlus
//
//  Created by admin on 16/2/19.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import "JPSApiUserManger.h"
#import "JPSApiResp.h"
#import "JPSApiRequestManger.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error " JPSApiUserManger (JPSApi_EasyCopy) requires ARC support."
#endif

NSString * const kJPSApiUserMangerCurrentUserIdKey = @"JPSApiUserMangerCurrentUserIdKey";

@interface JPSApiUserManger ()
@property (nonatomic,assign)id<JPSApiUserThirdParnerAuthorizeDelegate> delegate;
@property (nonatomic,copy) NSString *userID;
@end

@implementation JPSApiUserManger

#pragma mark - ShareInstance

+ (JPSApiUserManger *)shareInstance {
    static JPSApiUserManger *shareInstance = nil;
    static dispatch_once_t onceToken;
    @synchronized (self){
        dispatch_once(&onceToken, ^{
            shareInstance = [[super allocWithZone:nil] init];
        });
    }
    return shareInstance;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self shareInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [JPSApiUserManger shareInstance];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public API 

- (NSString*)rootPath {
    NSString * directoryPath = [NSString stringWithFormat:@"%@/JPSApiUserManger",DOWN_MATERIAL_DIR];
    if (![FileOperate isFileExistWithFilePath:directoryPath]) {
        [FileOperate createDirectoryWithName:@"JPSApiUserManger" toDirectory:DOWN_MATERIAL_DIR];
    }
    return directoryPath;
}

- (void)deleteCacheWithUser:(JPSApiUser *)user {
    NSString * userPath = [self userPathWith:user];
    if (![FileOperate isFileExistWithFilePath:userPath]) {
        [FileOperate removeFile:userPath];
    }
}

- (NSString*)userPathWith:(JPSApiUser*)user {

    if (![user isAuthorize]) {
        return @"";
    }
    return [self userPathWithUserId:user.accessInfo.userId];
}

- (NSString*)userPathWithUserId:(NSString*)userId {
    NSString * directoryPath = [NSString stringWithFormat:@"%@/%@_userDirectory",[self rootPath],userId];
    if (![FileOperate isFileExistWithFilePath:directoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return directoryPath;
}

- (NSString*)userInfoFilePathWithId:(NSString*)userId {
    NSString * userPath = [self userPathWithUserId:userId];
    NSLog(@"id是====%@",userId);
    return [NSString stringWithFormat:@"%@/%@",userPath,@"userInfo.rtf"];
}

- (void)signOutCurrenUser {
    
    [FileOperate removeFile:[self userPathWithUserId:self.currentUser.accessInfo.userId]];
    self.currentUser = [[JPSApiUser alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kJPSApiUserMangerCurrentUserIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isUserSignedIn {
    if (self.currentUser&&[self.currentUser isAuthorize]) {
        return YES;
    }
    return NO;
}

- (void)cancelAllReuest {
    //待实现
}

- (BOOL)persistentWithUser:(JPSApiUser*)user {
    NSString * path = [self userInfoFilePathWithId:user.accessInfo.userId];
    NSLog(@"不知道什么路径%@",path);
    //归档
    NSDictionary *uu = @{@"val":@"key"};
     return [NSKeyedArchiver archiveRootObject:user toFile:path];
   
}

- (void)signInWithThirdParnerType:(JPShareLoginType)type delegate:(id<JPSApiUserThirdParnerAuthorizeDelegate>)delegate {
    self.delegate = delegate;
    [JPShare shareObject].delegate = (id<JPShareDelegate>)self;
    [[JPShare shareObject] loginWithType:type];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(user:beginThirdParnerAuthorize:)]) {
        [self.delegate user:nil beginThirdParnerAuthorize:[[JPShare shareObject] shareEngineWithType:type]];
    }
}

#pragma mark - 登录
- (void)signInWithMobieRep:(JPSApiMobileSignInRep *)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock {
    JPSApiLoginAccountRep *acrep = [[JPSApiLoginAccountRep alloc] init];
    acrep.phoneNumber = rep.phoneNumber;
    acrep.area = rep.area;
    acrep.password = rep.password;
    acrep.accountType = @"mobile";
    [JPSApiRequestManger requestLoginAccountWithObject:acrep completeBlock:^(JPSLoginAccountResp *result, NSError *error, AFHTTPRequestOperation *op) {
        if (error||!result.isOk) {
            NSError * localError = error?[JPSApiRequestManger defaultError] :[result localError];
            if (completionBlock) {
                completionBlock(nil,localError);
            }
        }else{
            JPSLoginAccountResp *resp = result;
            self.currentUser = [[JPSApiUser alloc] initWithMobileSignInResp:resp];
            BOOL success =  [self persistentWithUser:self.currentUser];
            if(success){
                [[NSUserDefaults standardUserDefaults] setObject:resp.accessInfo.userId forKey:kJPSApiUserMangerCurrentUserIdKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (completionBlock) {
                    completionBlock(resp,nil);
                }
            }else{
                if (completionBlock) {
                    completionBlock(nil,[NSError errorWithDomain:@"signInWithMobieRep" code:10 userInfo:@{@"message":@"保存登录信息失败"}]);
                }
            }
        }
        
    }];
}

#pragma mark - 验证验证码For注册
- (void)confirmVerifyCodeForRegisterWithRep:(JPSApiCheckVerificationCodeRep *)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock{
    [JPSApiRequestManger requestCheckVerificationCodeWithObject:rep completeBlock:^(JPSCheckVerificationCodeResp *result, NSError *error, AFHTTPRequestOperation *op) {
        if (error||!result.isOk) {
            NSError * localError = error?[JPSApiRequestManger defaultError] : [result localError];
            if (completionBlock) {
                completionBlock(nil,localError);
            }
        }else{
            JPSCheckVerificationCodeResp *resp = result;
            self.checkVerifyCodeResult = rep;
            if (completionBlock) {
                completionBlock(resp,nil);
            }
        }
    }];
}

#pragma mark - 上传头像For注册
- (void)uploadHeadPictureWithRep:(JPSApiCreateAccountRep *)rep icon:(NSString *)iconPath completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock{
    if(self.currentUser.accessInfo.userId && self.currentUser.accessInfo.accessToken)
    {
        [JPSApiRequestManger requestUploadHeadPortraitsWithUserID:self.currentUser.accessInfo.userId Accesstoken:self.currentUser.accessInfo.accessToken withIconPaht:iconPath completeBlock:^(id result, NSError *error, AFHTTPRequestOperation *op) {
            if (error) {
                if (completionBlock) {
                    completionBlock(nil,error);
                }
            }else{
                NSString *iconurl = result;
                if (completionBlock) {
                    completionBlock(iconurl,nil);
                }
            }
        }];
        
    }else{
        [self registerNewAccountWithRep:rep completionBlock:^(id result, NSError *error) {
            if (error) {
                if (completionBlock) {
                    completionBlock(nil,error);
                }
            }else{
                [JPSApiRequestManger requestUploadHeadPortraitsWithUserID:self.currentUser.accessInfo.userId Accesstoken:self.currentUser.accessInfo.accessToken withIconPaht:iconPath completeBlock:^(id result, NSError *error, AFHTTPRequestOperation *op) {
                    if (error) {
                        if (completionBlock) {
                            completionBlock(nil,error);
                        }
                    }else{
                        NSString *iconurl = result;
                        if (completionBlock) {
                            completionBlock(iconurl,nil);
                        }
                    }
                }];
            }
        }];
        
    }
}


#pragma mark -填写用户注册信息

- (void)registerUserInfoWithRep:(JPSApiRegisterUserInfoRep *)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock{
    [JPSApiRequestManger requestRegisterUserInfoWithObject:rep completeBlock:^(JPSRegisterUserInfoResp *result, NSError *error, AFHTTPRequestOperation *op) {
        if (error||!result.isOk){
            NSError * localError = error?[JPSApiRequestManger defaultError] : [result localError];
            if (completionBlock) {
                completionBlock(nil,localError);
            }
        }else{
            JPSRegisterUserInfoResp *resp = result;
            
            BOOL success =  [self persistentWithUser:self.currentUser];
            if(success){
                [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.accessInfo.userId forKey:kJPSApiUserMangerCurrentUserIdKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (completionBlock) {
                    completionBlock(resp,nil);
                }
            }else{
                if (completionBlock) {
                    completionBlock(nil,[NSError errorWithDomain:@"registerNewAccountWithRep" code:10 userInfo:@{@"message":@"保存注册信息失败"}]);
                }
            }
        }
    }];
}


#pragma mark - 验证验证码For忘记密码
- (void)confirmVerifyCodeForChangePasswordWith:(JPSApiCheckVerificationCodeRep *)rep  completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock{
    [JPSApiRequestManger requestCheckVerificationCodeWithObject:rep completeBlock:^(JPSCheckVerificationCodeResp *result, NSError *error, AFHTTPRequestOperation *op) {
        if (error||!result.isOk) {
            NSError * localError = error?[JPSApiRequestManger defaultError] : [result localError];
            if (completionBlock) {
                completionBlock(nil,localError);
            }
        }else{
            JPSCheckVerificationCodeResp *resp = result;
            self.checkVerifyCodeResult = rep;
            if (completionBlock) {
                completionBlock(resp,nil);
            }
        }
    }];
}

#pragma mark - 忘记密码
- (void)forgetPasswordWith:(NSString *)password completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock{
    JPSApiChangePasswordRep *rep = [[JPSApiChangePasswordRep alloc] init];
    rep.phoneNumber = self.checkVerifyCodeResult.phoneNumber;
    rep.password = password;
    rep.area = self.checkVerifyCodeResult.area;
    rep.verifyCode = self.checkVerifyCodeResult.verifyCode;
    [JPSApiRequestManger requestChangePasswordWithObject:rep completeBlock:^(JPSChangePasswordResp *result, NSError *error, AFHTTPRequestOperation *op) {
        if (error||!result.isOk) {
            NSError * localError = error?[JPSApiRequestManger defaultError] :[result localError];
            if (completionBlock) {
                completionBlock(nil,localError);
            }
        }else{
            JPSChangePasswordResp *resp = result;
            if (completionBlock) {
                completionBlock(resp,nil);
            }
        }
    }];
}

#pragma mark - private API

- (void)commonInit {
   __unused NSString * AuthorFilePath = [self rootPath];
    NSString * currentUserId = [[NSUserDefaults standardUserDefaults] objectForKey:kJPSApiUserMangerCurrentUserIdKey];
    if (currentUserId&&![currentUserId isEqualToString:@""]) {
        NSString * currentUserPath = [self userInfoFilePathWithId:currentUserId];
        if ([[NSFileManager defaultManager] fileExistsAtPath:currentUserPath]) {
            @try {
                self.currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:currentUserPath];
            }
            @catch (NSException *exception) {
                self.currentUser = [[JPSApiUser alloc] init];
            }
        }else {
             self.currentUser = [[JPSApiUser alloc] init];
        }
    }else {
        self.currentUser = [[JPSApiUser alloc] init];
    }
}

//手机号注册
- (void)registerNewAccountWithRep:(JPSApiCreateAccountRep *)rep completionBlock:(JPSUserMangerOperationCompletionBlock)completionBlock{
    [JPSApiRequestManger requestCreateAccountWithObject:rep completeBlock:^(JPSCreateAccountResp *result, NSError *error, AFHTTPRequestOperation *op) {
        if (error || !result.isOk) {
            NSError * localError = error?[JPSApiRequestManger defaultError] :[result localError];
            if (completionBlock) {
                completionBlock(nil,localError);
            }
        } else {
            JPSCreateAccountResp *resp = result;
            self.currentUser = [[JPSApiUser alloc] initWithMobileSignInResp:resp];
                if (completionBlock) {
                    completionBlock(resp,nil);
                }
        }
    }];
}

@end
