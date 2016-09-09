//
//  JPSApiResp.m
//  JanePlus
//
//  Created by admin on 16/2/23.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import "JPSApiResp.h"
#import "JPSApiObject.h"
#import "NSStringAddition.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error " JPSApiResp (JPSApi_EasyCopy) requires ARC support."
#endif

#pragma mark - 响应类

@implementation JPSApiBaseResp
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        if (dictionary&&[dictionary isKindOfClass:[NSDictionary class]]) {
            self.clientCode = [dictionary objectForKey:@"client_code"];
            self.version = [dictionary objectForKey:@"ver"];
            self.message = [dictionary objectForKey:@"message"];
            self.code = [dictionary objectForKey:@"code"];
            NSDictionary * data  = [dictionary objectForKey:@"data"];
            if ([self.code integerValue] == 200) {
                self.retCode = [data objectForKey:@"ret_code"];
                self.retData = [data objectForKey:@"ret_data"];
                self.retMsg = [data objectForKey:@"ret_msg"];
                self.retNotice = [data objectForKey:@"ret_notice"];
                self.isOk = ([self.retCode integerValue]==0);
            }else {
                self.isOk = NO;
            }
        }
    }
    return self;
}



- (NSError*)localError {
    if (self.isOk) {
        return nil;
    }else {
        NSError * codeError = [self codeError];
        NSError * retCodeError = [self retCodeError];
        return codeError?codeError:retCodeError;
    }
}

- (NSError*)codeError {
    if ([self.code integerValue] == 205) {
        return [NSError errorWithDomain: JPSApiObjectDomain code:[self.code integerValue] userInfo:@{@"message":@"授权失败，请重新登录"}];
    } else if([self.code integerValue] == 200) {
        return nil;
    } else {
        return [NSError errorWithDomain: JPSApiObjectDomain code:[self.code integerValue] userInfo:@{@"message":JPSApiObjectDomainDefaultError}];
    }
}

- (NSError*)retCodeError {
    if ([self.retNotice isEmptyOrWhitespace] || self.retNotice == nil) {
        return [NSError errorWithDomain: JPSApiObjectDomain code:[self.retCode integerValue] userInfo:@{@"message":JPSApiObjectDomainDefaultError}];
    }else{
       return  [NSError errorWithDomain: JPSApiObjectDomain code:[self.retCode integerValue] userInfo:@{@"message":self.retNotice}];
    }
}

@end

@implementation JPSThirdParnerSignInResp

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (self.isOk) {
            self.accessInfo = [[JPSApiAccessInfo alloc] initWithDictionary:[self.retData objectForKey:@"access_info"]];
            self.accessInfo.pwdhash = [self.retData objectForKey:@"pwd_hash"];
            self.accessInfo.type = JPSApiLoginTypeOnThirdPartner;
            self.profile = [[JPSApiUserProfile alloc] initWithThirdParnerDictionary:[self.retData objectForKey:@"user_info"]];
            
            NSDictionary * checkMobile = self.retData[@"check_mobile"];
            
            if (checkMobile&&[checkMobile isKindOfClass:[NSDictionary class]]) {
                self.profile.zone_num = [JPSApiConstant filterNullWithValue:checkMobile[@"zone_num"]];
                self.profile.mobile = [JPSApiConstant filterNullWithValue:checkMobile[@"mobile"]];
            }
            
            if (![self.accessInfo isValid]) {
                self.isOk = NO;
            }
        }
    }
    return self;
}

@end


@implementation JPSDetectAccountIsExistResp
- (instancetype)initWithDictionary:(NSDictionary*)dictionary{
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (self.isOk) {
            self.accountExistCheckResult = [[self.retData objectForKey:@"check_result"] stringValue];
            if([self.accountExistCheckResult isEmptyOrWhitespace] || self.accountExistCheckResult == nil){
                self.isOk = NO;
            }else{
                self.isOk = YES;
            }
        }
    }
    return self;
}

@end

@implementation JPSGetVerificationCodeResp
@end

@implementation JPSCheckVerificationCodeResp
- (instancetype)initWithDictionary:(NSDictionary*)dictionary{
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (self.isOk) {
            self.verifyCodeCheckResult = [[self.retData objectForKey:@"check_result"] stringValue];
            self.userId = [self.retData objectForKey:@"user_id"];
            if([self.verifyCodeCheckResult isEmptyOrWhitespace] || self.verifyCodeCheckResult == nil){
                self.isOk = NO;
            }else{
                if ([self.verifyCodeCheckResult isEqualToString:@"1"]) {
                    self.isOk = YES;
                } else {
                    self.isOk = NO;
                }
                
            }
        }
    }
    return self;
}

@end


@implementation JPSCreateAccountResp
- (instancetype)initWithDictionary:(NSDictionary*)dictionary{
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (self.isOk) {
            self.accessInfo = [[JPSApiAccessInfo alloc] initWithDictionary:[self.retData objectForKey:@"access_info"]];
            self.accessInfo.pwdhash = [self.retData objectForKey:@"pwd_hash"];
            self.accessInfo.type = JPSApiLoginTypeOnPhone;
            NSDictionary *uploadUrlsDic = [self.retData objectForKey:@"upload_urls"];
            self.uploadFileUrl = [uploadUrlsDic objectForKey:@"upload_file_url"];
            self.uploadImageUrl = [uploadUrlsDic objectForKey:@"upload_image_url"];
            self.uploadUserIconUrl = [uploadUrlsDic objectForKey:@"upload_user_icon_url"];
            self.uploadUserIconUrlWifi = [uploadUrlsDic objectForKey:@"upload_user_icon_url_wifi"];
            if (![self.accessInfo isValid]) {
                self.isOk = NO;
            }
        }
    }
    return self;
}

@end

@implementation JPSRegisterUserInfoResp
@end

@implementation JPSGetBeautyOssUploadTokenResp
- (instancetype)initWithDictionary:(NSDictionary*)dictionary{
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (self.isOk) {
            self.accessToken = [self.retData objectForKey:@"access_token"];
            self.expireIn = [[self.retData objectForKey:@"expire_in"] stringValue];
            self.identify = [[self.retData objectForKey:@"identify"] stringValue];
            self.accessKey = [self.retData objectForKey:@"access_key"];
            self.fileName = [self.retData objectForKey:@"file_name"];
            self.fileUrl = [self.retData objectForKey:@"file_url"];
            self.tokenStr = [self.retData objectForKey:@"token_str"];
            if ([self.accessToken isEmptyOrWhitespace] || (self.accessToken == nil)||
                [self.expireIn isEmptyOrWhitespace] || (self.expireIn == nil)||
                [self.identify isEmptyOrWhitespace] || (self.identify == nil)||
                [self.accessKey isEmptyOrWhitespace] || (self.accessKey == nil)||
                [self.fileName isEmptyOrWhitespace] || (self.fileName == nil)||
                [self.fileUrl isEmptyOrWhitespace] || (self.fileUrl == nil)||
                [self.tokenStr isEmptyOrWhitespace] || (self.tokenStr == nil)
                ) {
                self.isOk = NO;
            }

        }
    }
    return self;
}

@end

@implementation JPSUploadIconResp
- (instancetype)initWithDictionary:(NSDictionary*)dictionary{
    self = [super init];
    if (self) {
        if (dictionary&&[dictionary isKindOfClass:[NSDictionary class]]) {
            self.returnCode = [[dictionary objectForKey:@"code"] stringValue];
            self.returnMessage = [dictionary objectForKey:@"message"];
        }
    }
    return self;
}

- (NSError*)localError {
    if ([self.returnCode isEqualToString:@"0"]) {
        return nil;
    }else {
        return [NSError errorWithDomain: @"JPSUploadIconResp" code:self.returnCode userInfo:@{@"message":@"上传头像失败"}];
    }
}
@end

@implementation JPSGetUserInfoResp
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (self.isOk) {
            self.profile = [[JPSApiUserProfile alloc] initWithDictionary:self.retData];
            if (![self.profile isValid]) {
                self.isOk = NO;
            }
        }
    }
    return self;
}

@end

@implementation JPSAliyunTokenResp

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (self.isOk) {
            self.accessKeyId = [self.retData objectForKey:@"access_key_id"];
            self.accessKeySecret = [[self.retData objectForKey:@"access_key_secret"] stringValue];
            self.securityToken = [[self.retData objectForKey:@"security_token"] stringValue];
            self.bucketName = [self.retData objectForKey:@"bucket_name"];
            self.expireIn = [self.retData objectForKey:@"expire_in"];
            self.endPoint = [self.retData objectForKey:@"endpoint"];
            self.fileBaseNames = [self.retData objectForKey:@"file_base_name_arr"];
        }
    }
    return self;
}
@end

@implementation JPSActionResp

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (self.isOk) {
            self.creditValue = [JPSApiConstant filterNullWithValue:self.retData[@"credit_value"]];
            self.creditMessage = [JPSApiConstant filterNullWithValue:self.retData[@"credit_message"]];
            self.userFreeCredit = [JPSApiConstant filterNullWithValue:self.retData[@"credit_total"]];
        }
    }
    return self;
}
@end

@implementation JPSCreditIncomeResp

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.retCode = [dictionary objectForKey:@"ret_code"];
        self.retData = [dictionary objectForKey:@"ret_data"];
        self.retMsg = [dictionary objectForKey:@"ret_msg"];
        self.creditValue = [JPSApiConstant filterNullWithValue:self.retData[@"credit_value"]];
        self.creditMessage = [JPSApiConstant filterNullWithValue:self.retData[@"credit_message"]];
    }
    return self;
}
@end

@implementation JPSCreditIncomeCollectionResp

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (self.isOk) {
            NSDictionary * creditDetail = self.retData[@"credit_detail"];
            self.creditTotal =    [JPSApiConstant filterNullWithValue:self.retData[@"credit_total"]];
            self.userFreeCredit =  [JPSApiConstant filterNullWithValue:self.retData[@"user_free_credit"]] ;
            NSMutableArray * creditIncomeRespArrary = [NSMutableArray array];
            [creditDetail enumerateKeysAndObjectsUsingBlock:^(NSString  * key, NSDictionary  * obj, BOOL * _Nonnull stop) {
                JPSCreditIncomeResp * resp = [[JPSCreditIncomeResp alloc] initWithDictionary:obj];
                resp.actionId = key;
                [creditIncomeRespArrary addObject:resp];
            }];
            self.creditIncomeArrary = creditIncomeRespArrary;
        }
    }
    return self;
}
@end


@implementation JPSTranslateIDResp

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (self.isOk) {
            self.password = [JPSApiConstant filterNullWithValue:self.retData[@"pwd_hash"]];
            self.pocoId = [JPSApiConstant filterNullWithValue:self.retData[@"poco_id"]];
            NSDictionary * tokenInfo = self.retData[@"access_token"];
            self.accessToken = [JPSApiConstant filterNullWithValue:tokenInfo[@"access_token"]];
            self.refreshToken = [JPSApiConstant filterNullWithValue:tokenInfo[@"refresh_token"]];
            self.expireTime = [JPSApiConstant filterNullWithValue:tokenInfo[@"expire_time"]];
        }
    }
    return self;
}
@end

@implementation JPSRefreshTokenResp

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (self.isOk) {
            NSDictionary * tokenInfo = self.retData[@"access_info"];
            self.accessToken = [JPSApiConstant filterNullWithValue:tokenInfo[@"access_token"]];
            self.refreshToken = [JPSApiConstant filterNullWithValue:tokenInfo[@"refresh_token"]];
            self.expireTime = [JPSApiConstant filterNullWithValue:tokenInfo[@"expire_time"]];
            self.userId = [JPSApiConstant filterNullWithValue:tokenInfo[@"user_id"]];
            self.addId = [JPSApiConstant filterNullWithValue:tokenInfo[@"app_id"]];
            self.updateTime = [JPSApiConstant filterNullWithValue:tokenInfo[@"udpate_time"]];
        }
    }
    return self;
}
@end

@implementation JPSRelationResp
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        NSDictionary * tokenInfo = dictionary;
        self.objectId = [JPSApiConstant filterNullWithValue:tokenInfo[@"object_id"]];
        self.typeId = [JPSApiConstant filterNullWithValue:tokenInfo[@"type_id"]];
        self.userId = [JPSApiConstant filterNullWithValue:tokenInfo[@"user_id"]];
        self.addTime = [JPSApiConstant filterNullWithValue:tokenInfo[@"add_time"]];
    }
    return self;
}
@end

@implementation JPSRelationListResp

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (self.isOk) {
            NSArray * relations = self.retData[@"relation"];
            NSMutableArray * list = [NSMutableArray array];
            if ([relations isKindOfClass:[NSArray class]]) {
                for (NSDictionary *relation  in relations) {
                    JPSRelationResp * resp = [[JPSRelationResp alloc] initWithDictionary:relation];
                    [list addObject:resp];
                }
            }
            self.relations = list;
        }
    }
    return self;
}

@end


@implementation JPSUpdateResp

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        if (self.isOk) {
            
            if ([[self.retData allKeys] containsObject:@"update_type"]&&
                [[self.retData allKeys] containsObject:@"title"]&&
                [[self.retData allKeys] containsObject:@"version"]&&
                [[self.retData allKeys] containsObject:@"details_url_btn"]&&
                [[self.retData allKeys] containsObject:@"download_url_btn"]&&
                [[self.retData allKeys] containsObject:@"is_ignore"]&&
                [[self.retData allKeys] containsObject:@"details"]) {
                
                NSInteger updateType  = [[self.retData objectForKey:@"update_type"] integerValue];
                
                self.isNeedUpdate = (updateType == 1)?YES:NO;
                
                NSDictionary * title = self.retData[@"title"];
                self.title = [JPSApiConstant filterNullWithValue:title[@"val"]];
                self.isShowTitle = [[title objectForKey:@"is_show"] boolValue];
                
                NSDictionary * version = self.retData[@"version"];
                self.appVersion = [JPSApiConstant filterNullWithValue:version[@"val"]];
                self.isShowVersion = [[version objectForKey:@"is_show"] boolValue];
                
                NSDictionary * details_url = self.retData[@"details_url_btn"];
                self.deatialURL = [JPSApiConstant filterNullWithValue:details_url[@"val"]];
                self.deatialURLDescription = [JPSApiConstant filterNullWithValue:details_url[@"name"]];
                self.isShowDeatialURL = [[details_url objectForKey:@"is_show"] boolValue];
                
                NSDictionary * download_url = self.retData[@"download_url_btn"];
                self.downloadURL = [JPSApiConstant filterNullWithValue:download_url[@"val"]];
                self.downloadURLDescription = [JPSApiConstant filterNullWithValue:download_url[@"name"]];
                self.isShowDownloadURL = [[download_url objectForKey:@"is_show"] boolValue];
                
                NSDictionary * ignore = self.retData[@"is_ignore"];
                self.ignoreDescription = [JPSApiConstant filterNullWithValue:ignore[@"name"]];
                self.isShowIgnore = [[download_url objectForKey:@"is_show"] boolValue];
                
                
                NSDictionary * details = self.retData[@"details"];
                self.deatils = details[@"val"];
                self.isShowDeatils = [[download_url objectForKey:@"is_show"] boolValue];

            }else {
                self.isNeedUpdate = NO;
            }
         }
    }
    return self;
}

@end

@implementation JPSUpdateUserInfoResp
@end

@implementation JPSChangePasswordResp
@end

@implementation JPSLoginAccountResp
@end

@implementation JPSVerifyPasswordResp
@end

@implementation JPSChangeBindPhoneResp
@end

@implementation JPSUpdateUserPasswordResp
@end

@implementation JPSSaveCloudAlbumResp
@end

@implementation JPSBindMobileResp
@end
