//
//  JPSApiRequestManger.m
//  JanePlus
//
//  Created by admin on 16/2/23.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import "JPSApiRequestManger.h"
#import "NSStringAddition.h"
#import "AFHTTPRequestOperationManager+JXExtentsion.h"
#import "AFHTTPRequestOperationManager+JPSApi.h"
#import "JPSApiConstant.h"
#import "JPSApiRequestURL.h"
#import "JPSApiResp.h"
#import "SBJSON.h"
#import "NSString+Extensions.h"
#import "JPShareAuthorizeObject.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error " JPSApiRequestManger (JPSApi_EasyCopy) requires ARC support."
#endif

NSString * const JPSApiRequestMangerDomain = @"JPSApiRequestMangerDomain";
NSString * const JPSApiRequestMangerDefaultError = @"网络请求出错";

@implementation JPSApiRequestManger

+ (NSError*)defaultError {
    return [NSError errorWithDomain:JPSApiRequestMangerDomain code:JPSApiErrorInDefaultError userInfo:@{@"message":JPSApiRequestMangerDefaultError}];
}


+ (AFHTTPRequestOperation *)requestAliyunOssUploadTokenWithUserID:(NSString *)userid
                                                       fileNameCount:(int)fileNameCount
                                                         completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock {
    
    NSDictionary *paramDic = @{
                               @"user_id" : userid,
                               @"file_base_name_count":[NSNumber numberWithInt:fileNameCount]
                               };
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager] jps_POST:kRequestAliyunTokenURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
        JPSAliyunTokenResp * resp = [[JPSAliyunTokenResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return op;
}

+ (AFHTTPRequestOperation *)requestNewThirdPartPartnerBindWithObject:(JPShareAuthorizeObject*)object
                                                       completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:object.expirationDate];
    NSDictionary * authorizeDictionary = @{@"openid":object.userID,
                                           @"access_token":object.token,
                                           @"signed_request":@"",
                                           @"expires_in" : dateString,
                                           @"partner":[JPSApiConstant requestShareTypeStringWithType:object.type]
                                           };
    
    NSMutableDictionary * authorizes = [NSMutableDictionary dictionaryWithDictionary:authorizeDictionary];
    
    if (object.refreshToken) {
        [authorizes setObject:object.refreshToken forKey:@"refresh_token"];
    }
    
    if (object.unionid) {
        [authorizes setObject:object.unionid forKey:@"unionid"];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager] jps_POST:kRequestNewThirdPartPartnerBindURL parameters:authorizes success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
        JPSLog(@"第三方登录：%@",responseObject);
        JPSThirdParnerSignInResp * resp = [[JPSThirdParnerSignInResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return op;
}


+ (AFHTTPRequestOperation *)requestGetVerificationCodeWithObject:(JPSApiGetVerificationCodeRep *)rep
                                                   completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock{
    NSDictionary *paramDic = @{
                               @"phone" : rep.phoneNumber,
                               @"zone_num" : rep.area,
                               @"type" : rep.type
                               };
    JPSLog(@"获取验证码：%@",kRequestGetVertifyCodeURL);
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager] jps_POST:kRequestGetVertifyCodeURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"获取验证码：%@",responseObject);
        JPSGetVerificationCodeResp *resp = [[JPSGetVerificationCodeResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestCheckVerificationCodeWithObject:(JPSApiCheckVerificationCodeRep *)rep
                                                     completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock{
    NSDictionary *paramDic = @{
                               @"phone" : rep.phoneNumber,
                               @"zone_num" : rep.area,
                               @"verify_code" : rep.verifyCode,
                               @"type" : rep.type
                               };
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager] jps_POST:kRequestJudgeVertifyCodeURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"检验验证码：%@",responseObject);
        JPSCheckVerificationCodeResp *resp = [[JPSCheckVerificationCodeResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestCreateAccountWithObject:(JPSApiCreateAccountRep *)rep
                                             completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock{
    NSDictionary *paramDic = @{
                               @"phone" : rep.phoneNumber,
                               @"zone_num" : rep.area,
                               @"verify_code" : rep.verifyCode
                               };
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager] jps_POST:kRequestRegisterURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"注册：%@",responseObject);
        JPSCreateAccountResp *resp = [[JPSCreateAccountResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestRegisterUserInfoWithObject:(JPSApiRegisterUserInfoRep *)rep
                                                completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock{
    NSDictionary *paramDic = @{
                               @"user_id" : rep.userId,
                               @"access_token" : rep.accessToken,
                               @"user_icon" : rep.userIcon,
                               @"nickname" : rep.nickname,
                               @"pwd" : rep.password
                               };
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager] jps_POST:KRequestRegisterUserInfoURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"填写用户注册信息：%@",responseObject);
        JPSRegisterUserInfoResp *resp = [[JPSRegisterUserInfoResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestGetBeautyOssUploadTokenWithUserID:(NSString *)userid
                                                         Accesstoken:(NSString *)accesstoken
                                                       completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock{
    NSDictionary *paramDic = @{
                               @"user_id" : userid,
                               @"access_token" : accesstoken,
                               @"file_ext" :@"jpg"
                                };
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager] jps_POST:kRequestGetBeautyOssUploadToken parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"美人获取上传token：%@",responseObject);
        JPSGetBeautyOssUploadTokenResp *resp = [[JPSGetBeautyOssUploadTokenResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestUploadIconWithObject:(JPSApiUploadIconRep *)rep
                                          completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock{
    NSString *str1 = ([AFNetworkReachabilityManager sharedManager].reachableViaWiFi)?URL_UPLOAD_USER_HEAD_COVER_HTTPS_WIFI:URL_UPLOAD_USER_HEAD_COVER_HTTPS;
    NSString *str2 = URL_UPLOAD_USER_HEAD_COVER_DIC;
    NSString *identify = rep.beautyOssInfo.identify;
    NSString *expire = rep.beautyOssInfo.expireIn;
    NSString *accessKey = rep.beautyOssInfo.accessKey;
    NSString *access_token = rep.beautyOssInfo.accessToken;
    
    NSString *url = [NSString stringWithFormat:@"%@%@?identify=%@&expire=%@&access_key=%@&access_token=%@",str1,str2,identify,expire,accessKey,access_token];
    
    NSString *key = rep.beautyOssInfo.fileName;//rep.beautyOssInfo.iconFile;;
    NSDictionary *paramDic = @{
                               @"key" : key
                               };
    SBJSON *jsonTool = [[SBJSON alloc] init];
    NSString *paramJsonStr = [jsonTool stringWithObject:paramDic];
    
    NSInteger timeIntval = (NSUInteger)[[NSDate date] timeIntervalSince1970];
    NSNumber *timeNumber = [NSNumber numberWithInteger:timeIntval];
    
    NSString *sign = [NSString stringToSha1:[NSString stringWithFormat:@"object_store%@%@%@bodyauth",str2,paramJsonStr,timeNumber]];
    
    NSDictionary *middleparamDic = @{
                                     @"time" : timeNumber,
                                     @"sign" : sign,
                                     @"params" : paramDic
                                     };
    NSString *middleparamJsonStr = [jsonTool stringWithObject:middleparamDic];
    NSDictionary *postparamDic = @{
                                   @"data" : middleparamJsonStr
                                   };
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager] POST:url parameters:postparamDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSURL *usericonurl = [NSURL fileURLWithPath:rep.iconPath];
        [formData appendPartWithFileURL:usericonurl name:@"upFile" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *responseData = responseObject;
        NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
        JPSLog(@"上传头像：%@",responseDic);
        JPSUploadIconResp *resp = [[JPSUploadIconResp alloc] initWithDictionary:responseDic];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (JPSApiSequencer *)requestUploadHeadPortraitsWithUserID:(NSString *)userid
                                              Accesstoken:(NSString *)accesstoken
                                             withIconPaht:(NSString *)iconPath
                                            completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock{
    JPSApiSequencer *sequencer = [[JPSApiSequencer alloc] init];
    [sequencer enqueueStep:^(id result, JPSApiSequencerCompletion completion) {
        [JPSApiRequestManger requestGetBeautyOssUploadTokenWithUserID:userid Accesstoken:accesstoken completeBlock:^(JPSGetBeautyOssUploadTokenResp *result, NSError *error, AFHTTPRequestOperation *op) {
            if (error||!result.isOk) {
                NSError * localError = error?[self defaultError] : [result localError];
                if (completeBlock) {
                    completeBlock(nil,localError,op);
                }
            }else{
                JPSGetBeautyOssUploadTokenResp *resp = result;
                completion(resp,nil);
            }

        }];
    }];
    
    [sequencer enqueueStep:^(JPSGetBeautyOssUploadTokenResp *result, JPSApiSequencerCompletion completion) {
        if (!result) {
            return ;
        }
        JPSApiUploadIconRep *rep = [[JPSApiUploadIconRep alloc] init];
        rep.beautyOssInfo = result;
        rep.iconPath = iconPath;
        NSString *iconUrl = result.fileUrl;//result.iconUrl;
        [JPSApiRequestManger requestUploadIconWithObject:rep completeBlock:^(JPSUploadIconResp *result, NSError *error, AFHTTPRequestOperation *op) {
            if (error||![result.returnCode isEqualToString:@"0"]) {
                NSError * localError = error?[self defaultError] : [result localError];
                if (completeBlock) {
                    completeBlock(nil,localError,op);
                }
            }else{
                if (completeBlock) {
                    completeBlock(iconUrl,nil,op);
                }
                completion(nil,nil);
            }
            
        }];
    }];
    
    [sequencer run];
    return sequencer;
}

+ (AFHTTPRequestOperation *)requestUpdateUserInfoWithObject:(JPSApiUpdateUserInfoRep *)rep
                                              completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock{
     NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
     //更换头像 //更换空间背景图片 //更换昵称 //Facebook设置头像和昵称
    if (rep.userId) {
        [paramDic setObject:rep.userId forKey:@"user_id"];
    }
    
    if (rep.accessToken) {
        [paramDic setObject:rep.accessToken forKey:@"access_token"];
    }
    
    if (rep.nickname) {
        [paramDic setObject:rep.nickname forKey:@"nickname"];
    }
    
    if (rep.userIcon) {
        [paramDic setObject:rep.userIcon forKey:@"user_icon"];
    }
    
    if (rep.sex) {
        [paramDic setObject:rep.sex forKey:@"sex"];
    }
    
    if (rep.mobile) {
        [paramDic setObject:rep.mobile forKey:@"mobile"];
    }
    
    if (rep.zoneNum) {
        [paramDic setObject:rep.zoneNum forKey:@"zone_num"];
    }
    
    if (rep.signature) {
        [paramDic setObject:rep.signature forKey:@"signature"];
    }
    
    if (rep.locationId) {
        [paramDic setObject:rep.locationId forKey:@"location_id"];
    }
    
    if (rep.birthdayYear) {
        [paramDic setObject:rep.birthdayYear forKey:@"birthday_year"];
    }
    
    if (rep.birthdayMonth) {
        [paramDic setObject:rep.birthdayMonth forKey:@"birthday_month"];
    }
    
    if (rep.birthdayDay) {
        [paramDic setObject:rep.birthdayDay forKey:@"birthday_day"];
    }
    
    if (rep.userSpace) {
        [paramDic setObject:rep.userSpace forKey:@"user_space"];
    }
    
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestUpdateUserInfoURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"更新用户信息：%@",responseObject);
        JPSUpdateUserInfoResp *resp = [[JPSUpdateUserInfoResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestChangePasswordWithObject:(JPSApiChangePasswordRep *)rep
                                              completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock{
    NSDictionary *paramDic = @{
                               @"zone_num" : rep.area,
                               @"phone" : rep.phoneNumber,
                               @"verify_code" : rep.verifyCode,
                               @"password" : rep.password
                               };
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestResetPasswordURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"忘记密码：%@",responseObject);
        JPSChangePasswordResp *resp = [[JPSChangePasswordResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestLoginAccountWithObject:(JPSApiLoginAccountRep *)rep
                                      completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock{
    NSDictionary *paramDic = @{
                               @"phone" : rep.phoneNumber,
                               @"zone_num" :rep.area,
                               @"password" : rep.password
                               };
    NSLog(@"登录URL%@",kRequestLoginURL);
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestLoginURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"登录:%@",responseObject);
        JPSLoginAccountResp *resp = [[JPSLoginAccountResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestGetUserInfoWithObject:(JPSApiGetUserInfoRep *)rep
                                           completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock{
    NSDictionary *paramDic = @{
                               @"user_id" : rep.userId,
                               @"access_token" : rep.accessToken
                               };
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_postReuestOperation:kRequestGetUserInfoURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"获取用户信息:%@",responseObject);
        JPSGetUserInfoResp *resp = [[JPSGetUserInfoResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestUpdateUserPasswordWithObject:(JPSUpdateUserPasswordRep *)rep
                                               completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock{
    NSDictionary *paramDic = @{
                               @"user_id" : rep.userId,
                               @"new_pwd" : rep.freshPwd,
                               @"old_pwd" : rep.oldPwd,
                               @"access_token" : rep.accessToken
                               };
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestUpdateUserPasswordUrl parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"修改用户密码:%@",responseObject);
        JPSUpdateUserPasswordResp *resp = [[JPSUpdateUserPasswordResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestBindMobile:(JPSBindMobileRep *)rep
                                completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock{
    NSDictionary *paramDic = @{
                               @"user_id" : rep.userId,
                               @"zone_num" : rep.area,
                               @"phone" : rep.phoneNumber,
                               @"verify_code" : rep.verifyCode,
                               @"password" : rep.password
                               };
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:KReguestBindMobileURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"用户关联手机号:%@",responseObject);
        JPSBindMobileResp *resp = [[JPSBindMobileResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestBehaviorActionWithObject:(JPSActiondRep*)rep
                                              completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock  {
    NSDictionary *paramDic = nil;
    if (rep.actionId) {
       paramDic = @{
                                   @"user_id" : rep.userId,
                                   @"action_id" : rep.actionId,
                                   @"access_token" : rep.accessToken
                                   };
    }
   
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestBehaviorActionURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSActionResp *resp = [[JPSActionResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestCreditIncomeWithObject:(JPSActiondRep*)rep
                                              completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock  {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (rep.actionId) {
        [paramDic setObject:rep.userId forKey:@"user_id"];
        [paramDic setObject:rep.actionId forKey:@"action_id"];
        [paramDic setObject:rep.accessToken forKey:@"access_token"];
        if (rep.uniqueCode) {
             [paramDic setObject:rep.uniqueCode forKey:@"unique_code"];
        }
    }
    
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestCreditIncomeURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"积分收入%@",responseObject);
        JPSCreditIncomeCollectionResp *resp = [[JPSCreditIncomeCollectionResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestkCreditConsumerWithObject:(JPSActiondRep*)rep
                                            completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock  {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (rep.actionId) {
        [paramDic setObject:rep.userId forKey:@"user_id"];
        [paramDic setObject:rep.actionId forKey:@"action_id"];
        [paramDic setObject:rep.accessToken forKey:@"access_token"];
        if (rep.uniqueCode) {
            [paramDic setObject:rep.uniqueCode forKey:@"unique_code"];
        }
    }
    
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestrCreditConsumerURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"积分消费%@",responseObject);
        JPSActionResp *resp = [[JPSActionResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}


+ (AFHTTPRequestOperation *)requestPocoIDWithMeirenId:(JPSApiGetUserInfoRep*)req
                                        completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock {
    
    NSDictionary *paramDic = @{
                               @"user_id" : req.userId,
                                @"access_token" : req.accessToken,
                               };
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestPocoIdURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"转换POCOID%@",responseObject);
        JPSTranslateIDResp *resp = [[JPSTranslateIDResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}

+ (AFHTTPRequestOperation *)requestSendToWorldWithReq:(JPSSendToWorlddRep*)req
                                             completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock {
    
    NSDictionary *paramDic = @{
                               @"user_id" : req.userId,
                               @"access_token" : req.accessToken,
                               @"img_url" : req.imageURL,
                               @"content" : req.content,
                               @"poco_id" : req.pocoId,
                               };
    
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestSendToWorldURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"发送到世界%@",responseObject);
        JPSApiBaseResp *resp = [[JPSApiBaseResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;

}

+ (AFHTTPRequestOperation *)requestRefreshTokenWithUserId:(NSString*)userId
                                             refreshToken:(NSString*)refreshToken
                                            completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock {
    NSDictionary *paramDic = @{
                               @"user_id" : userId,
                                @"refresh_token" : refreshToken,
                               };
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestRefreshTokenURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSRefreshTokenResp *resp = [[JPSRefreshTokenResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;

}

+ (AFHTTPRequestOperation *)requestAddRelationWithReq:(JPSRelationdRep*)req
                                            completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock {
    NSDictionary *paramDic = @{
                               @"user_id" : req.userId,
                               @"access_token" : req.accessToken,
                               @"type_id":req.typeId,
                               @"object_id":req.objectId,
                               };
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestAddRelationURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
         JPSLog(@"添加关系%@",responseObject);
        JPSApiBaseResp *resp = [[JPSApiBaseResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
    
}

+ (AFHTTPRequestOperation *)requestDeleteRelationWithReq:(JPSRelationdRep*)req
                                        completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock {
    
    NSMutableDictionary *paramDic =[ @{
                               @"user_id" : req.userId,
                               @"access_token" : req.accessToken,
                               @"type_id":req.typeId,
                               } mutableCopy];
    
    if (req.objectId) {
        [paramDic setObject:req.objectId forKey:@"object_id"];
    }
    
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestDelRelationURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"删除关系%@",responseObject);
        JPSApiBaseResp *resp = [[JPSApiBaseResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
}


+ (AFHTTPRequestOperation *)requestDeleteAllRelationWithReq:(JPSRelationdRep*)req
                                           completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock {
    
    NSMutableDictionary *paramDic =[ @{
                                       @"user_id" : req.userId,
                                       @"access_token" : req.accessToken,
                                       @"type_id":req.typeId,
                                       } mutableCopy];
    
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestDelAllRelationURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"删除所有关系%@",responseObject);
        JPSApiBaseResp *resp = [[JPSApiBaseResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
    
}

+ (AFHTTPRequestOperation *)requestGetRelationWithReq:(JPSRelationdListRep*)req
                                           completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock {
    NSDictionary *paramDic = @{
                               @"user_id" : req.userId,
                               @"access_token" : req.accessToken,
                               @"type_id":req.typeId,
                               @"page":req.page,
                               @"length":req.length,
                               @"b_select_count":[NSNumber numberWithBool:NO],
                               };
    AFHTTPRequestOperation *afHTTPRequestOperation = [[AFHTTPRequestOperationManager defaultHTTPRequestOperationManager]jps_POST:kRequestGetRelationURL parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JPSLog(@"获取关系列表%@",responseObject);
        JPSRelationListResp *resp = [[JPSRelationListResp alloc] initWithDictionary:responseObject];
        if (completeBlock) {
            completeBlock(resp,nil,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeBlock) {
            completeBlock(nil,[self defaultError],operation);
        }
    }];
    return afHTTPRequestOperation;
    
}

@end
