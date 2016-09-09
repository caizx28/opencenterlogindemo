//
//  JPSApiUserManger+ThirdParnerSignIn.m
//  JanePlus
//
//  Created by admin on 16/2/24.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import "JPSApiUserManger+ThirdParnerSignIn.h"
#import "JPSApiRequestManger.h"
#import "JPSApiResp.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error " JPSApiUserManger+ThirdParnerSignIn  requires ARC support."
#endif

@implementation JPSApiUserManger (ThirdParnerSignIn)

#pragma  mark -  JPShareDelegate

- (void)share:(id<JPShareAPI>)share AuthorizeSuccessed:(NSDictionary*)userInfo {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(user:successedThirdParnerAuthorize:)]) {
        [self.delegate user:nil successedThirdParnerAuthorize:share];
    }
    
    JPShareAuthorizeObject * jpAuthorizeObject =  [[JPShare shareObject] authorizeObjectWithType:share.object.type];
    [JPSApiRequestManger requestNewThirdPartPartnerBindWithObject:jpAuthorizeObject completeBlock:^(JPSThirdParnerSignInResp* result, NSError *error, AFHTTPRequestOperation *op) {
        if (error) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(user:failAuthorize:)]) {
                [self.delegate user:nil failAuthorize:error];
            }
        }else {
            if (result.isOk) {
                JPSApiUser * user = [[JPSApiUser alloc] initWithThirdParnerSignInResp:result];
                self.currentUser = user;
                self.currentUser.accessInfo.thirdPanerType = share.object.type;
                 BOOL success =  [self persistentWithUser:self.currentUser];
                if(success) {
                    [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.accessInfo.userId forKey:kJPSApiUserMangerCurrentUserIdKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(user:successAuthorize:)]) {
                        [self.delegate user:user successAuthorize:nil];
                    }
                }else {
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(user:failAuthorize:)]) {
                        [self.delegate user:nil failAuthorize:[NSError errorWithDomain:@"signInWithMobieRep" code:10 userInfo:@{@"message":@"保存登录信息失败"}]];
                    }
                }
                return ;
            }
            
            if (self.delegate&&[self.delegate respondsToSelector:@selector(user:failAuthorize:)]) {
                [self.delegate user:nil failAuthorize:[result localError]];
            }
        }
    }];
}

- (void)share:(id<JPShareAPI>)share AuthorizeFail:(NSDictionary*)userInfo {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(user:failThirdParnerAuthorize:)]) {
        [self.delegate user:nil failThirdParnerAuthorize:share];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(user:failAuthorize:)]) {
        [self.delegate user:nil failAuthorize:nil];
    }
}

- (void)share:(id<JPShareAPI>)share AuthorizeCancel:(NSDictionary*)userInfo {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(user:failThirdParnerAuthorize:)]) {
        [self.delegate user:nil failThirdParnerAuthorize:share];
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(user:failAuthorize:)]) {
        [self.delegate user:nil failAuthorize:nil];
    }
}

- (void)share:(id<JPShareAPI>)share AuthorizeCodeSuccess:(NSString*)userInfo {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(user:thirdParnerAuthorizeCodeSuccess:)]) {
        [self.delegate user:nil thirdParnerAuthorizeCodeSuccess:share];
    }
}


- (void)share:(id<JPShareAPI>)share requestOauthTokenStart:(NSDictionary*)userInfo {;}
- (void)share:(id<JPShareAPI>)share logOutSuccess:(NSDictionary*)userInfo {;}
- (void)share:(id<JPShareAPI>)share ShareContentSuccessed:(NSDictionary*)userInfo{;}
- (void)share:(id<JPShareAPI>)share ShareContentFail:(NSDictionary*)userInfo{;}
- (void)share:(id<JPShareAPI>)share ShareContentCancel:(NSDictionary*)userInfo{;}
- (void)share:(id<JPShareAPI>)share notInstallNativeApp:(NSDictionary*)userInfo;{;}

@end
