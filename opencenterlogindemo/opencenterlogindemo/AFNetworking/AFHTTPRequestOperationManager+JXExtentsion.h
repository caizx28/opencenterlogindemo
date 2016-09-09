//
//  AFHTTPRequestOperationManager+JXExtentsion.h
//  UnknownApp
//
//  Created by admin on 15/6/25.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AFURLResponseSerialization.h"

@interface AFHTTPRequestOperationManager (JXExtentsion)

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

+ (instancetype)defaultHTTPRequestOperationManager;

+ (AFHTTPResponseSerializer*)defaultResponseSerializer;

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
          downloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block;


- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
             uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
             uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block;

- (void)cancel;

- (void)addHttpOperationWith:(AFHTTPRequestOperation*)op;

- (BOOL)isExecuteWith:(AFHTTPRequestOperation*)op;

- (BOOL)isExecuteWithIdentify:(NSString*)identify;

- (NSArray*)operations;

+ (float)progressWith:(long long)totalBytesRead totalBytesExpectedToRead:(long long)totalBytesExpectedToRead;

@end
