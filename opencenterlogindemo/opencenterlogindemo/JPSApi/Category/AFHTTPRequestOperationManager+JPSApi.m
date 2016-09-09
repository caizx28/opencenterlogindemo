//
//  AFHTTPRequestOperationManager+JPSApi.m
//  JanePlus
//
//  Created by admin on 16/2/23.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import "AFHTTPRequestOperationManager+JPSApi.h"
#import "AFHTTPRequestOperationManager+JXExtentsion.h"
#import "JPSApiConstant.h"
#import "NSStringAddition.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "AFHTTPRequestOperationManager requires ARC support."
#endif


@implementation AFHTTPRequestOperationManager (JPSApi)


- (AFHTTPRequestOperation *)jps_postReuestOperation:(NSString *)URLString
                                         parameters:(id)parameters
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperation *op = [self POST:[JPSApiConstant requstURLWithSourceURL:URLString]
                                 parameters:[JPSApiConstant requstJsonDictionaryWithDictionary:parameters]
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSString *responseString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
                                        NSDictionary *responseDic = [responseString toJSONObject];
                                        if (success) {
                                            success(operation,responseDic);
                                        }
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failure) {
                                            failure(operation,error);
                                        }
                                    } uploadProgressBlock:nil];
    return op;
}


- (AFHTTPRequestOperation *)jps_POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperation *op = [self POST:[JPSApiConstant requstURLWithSourceURL:URLString]
                                 parameters:[JPSApiConstant requstJsonDictionaryWithDictionary:parameters]
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [responseString toJSONObject];
        if (success) {
            success(operation,responseDic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation,error);
        }
    }];
    return op;
}

- (AFHTTPRequestOperation *)jps_POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
   AFHTTPRequestOperation * op = [self POST:[JPSApiConstant requstURLWithSourceURL:URLString]
                                 parameters:[JPSApiConstant requstJsonDictionaryWithDictionary:parameters]
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
       if (block) {
           block(formData);
       }
   } success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSString *responseString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
       NSDictionary *responseDic = [responseString toJSONObject];
       if (success) {
           success(operation,responseDic);
       }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       if (failure) {
           failure(operation,error);
       }
   }];
   return op;
}



@end
