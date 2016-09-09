//
//  JPSApiRequestManger.h
//  JanePlus
//
//  Created by admin on 16/2/23.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "JPSApiObject.h"
#import "JPSApiRep.h"
#import "JPSApiSequencer.h"

typedef void (^JPSApiRequestMangerCompletionBlock)(id result,NSError *error,AFHTTPRequestOperation*op);

@class JPShareAuthorizeObject;

@interface JPSApiRequestManger : NSObject

+ (NSError*)defaultError;

//更新token
+ (AFHTTPRequestOperation *)requestRefreshTokenWithUserId:(NSString*)userId
                                             refreshToken:(NSString*)refreshToken
                                        completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock;

//美人id 转POCO
+ (AFHTTPRequestOperation *)requestPocoIDWithMeirenId:(JPSApiGetUserInfoRep*)req
                                              completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock;

+ (AFHTTPRequestOperation *)requestSendToWorldWithReq:(JPSSendToWorlddRep*)req
                                        completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock;
/*
 触发积分统计
 */

+ (AFHTTPRequestOperation *)requestBehaviorActionWithObject:(JPSActiondRep*)rep
                                                     completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock;

//积分收入
+ (AFHTTPRequestOperation *)requestCreditIncomeWithObject:(JPSActiondRep*)rep
                                            completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock;

//积分消费
+ (AFHTTPRequestOperation *)requestkCreditConsumerWithObject:(JPSActiondRep*)rep
                                               completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock;

/**
 *  获取阿里云token
 *
 */
+ (AFHTTPRequestOperation *)requestAliyunOssUploadTokenWithUserID:(NSString *)userid
                                                       fileNameCount:(int)fileNameCount
                                                       completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock;
/**
 *  通过第三方授权，登陆账号
 *
 */
+ (AFHTTPRequestOperation *)requestNewThirdPartPartnerBindWithObject:(JPShareAuthorizeObject*)object
                                                       completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock;

/**
 *   检测账号是否存在
 */
+ (AFHTTPRequestOperation *)requestDetectAccountIsExistWithObject:(JPSApiDetectAccountIsExistRep *)rep
                                                    completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock;

/**
 *  获取手机短信验证码
 */

+ (AFHTTPRequestOperation *)requestGetVerificationCodeWithObject:(JPSApiGetVerificationCodeRep *)rep
                                                   completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock;

/**
 *  校验手机验证码
 */
+ (AFHTTPRequestOperation *)requestCheckVerificationCodeWithObject:(JPSApiCheckVerificationCodeRep *)rep
                                                     completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock;

/**
 *  通过手机号注册账号
 */
+ (AFHTTPRequestOperation *)requestCreateAccountWithObject:(JPSApiCreateAccountRep *)rep
                                             completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock;

/**
 *  填写用户注册信息
 */
+ (AFHTTPRequestOperation *)requestRegisterUserInfoWithObject:(JPSApiRegisterUserInfoRep *)rep
                                                completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock;

/**
 *  获取云服务器授权Token
 */
+ (AFHTTPRequestOperation *)requestGetBeautyOssUploadTokenWithUserID:(NSString *)userid
                                                         Accesstoken:(NSString *)accesstoken
                                                       completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock;

/**
 *  上传本地头像文件到云服务器
 */
+ (AFHTTPRequestOperation *)requestUploadIconWithObject:(JPSApiUploadIconRep *)rep
                                          completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock;

/**
 *  上传头像 - 2个接口合并
 */
+ (JPSApiSequencer *)requestUploadHeadPortraitsWithUserID:(NSString *)userid
                                              Accesstoken:(NSString *)accesstoken
                                             withIconPaht:(NSString *)iconPath
                                            completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock;

/**
 *  更新用户信息
 */
+ (AFHTTPRequestOperation *)requestUpdateUserInfoWithObject:(JPSApiUpdateUserInfoRep *)rep
                                              completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock;


/**
 *  忘记密码
 */
+ (AFHTTPRequestOperation *)requestChangePasswordWithObject:(JPSApiChangePasswordRep *)rep
                                              completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock;


/**
 *  手机号登录
 */
+ (AFHTTPRequestOperation *)requestLoginAccountWithObject:(JPSApiLoginAccountRep *)rep
                                      completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock;

/**
 *  获取用户信息
 */
+ (AFHTTPRequestOperation *)requestGetUserInfoWithObject:(JPSApiGetUserInfoRep *)rep
                                           completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock;


/**
 *  修改密码
 */
+ (AFHTTPRequestOperation *)requestUpdateUserPasswordWithObject:(JPSUpdateUserPasswordRep *)rep
                                                  completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock;

/**
 *  用户关联手机号
 */
+ (AFHTTPRequestOperation *)requestBindMobile:(JPSBindMobileRep *)rep
                                completeBlock:(JPSApiRequestMangerCompletionBlock)completeBlock;

/**
 *  添加关系对象
 */
+ (AFHTTPRequestOperation *)requestAddRelationWithReq:(JPSRelationdRep*)req
                                        completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock;

/*
 删除关系对象
 */
+ (AFHTTPRequestOperation *)requestDeleteRelationWithReq:(JPSRelationdRep*)req
                                           completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock;

/*
 删除某个类别的所有记录
 */
+ (AFHTTPRequestOperation *)requestDeleteAllRelationWithReq:(JPSRelationdRep*)req
                                              completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock;

//获取关系列表
+ (AFHTTPRequestOperation *)requestGetRelationWithReq:(JPSRelationdListRep*)req
                                        completeBlock:(JPSApiRequestMangerCompletionBlock) completeBlock;
@end
