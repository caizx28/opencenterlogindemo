//
//  AFHTTPRequestOperationManager+JXExtentsion.m
//  UnknownApp
//
//  Created by admin on 15/6/25.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "AFHTTPRequestOperationManager+JXExtentsion.h"
#import "NSStringAddition.h"
@implementation AFHTTPRequestOperationManager (JXExtentsion)

+ (instancetype)defaultHTTPRequestOperationManager {
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    return manger;
}

+ (AFHTTPResponseSerializer*)defaultResponseSerializer {
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html",@"application/x-font-truetype",@"text/xml", nil];
    return responseSerializer;
}

+ (float)progressWith:(long long)totalBytesRead totalBytesExpectedToRead:(long long)totalBytesExpectedToRead {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        return p;
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
          downloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))block {
   
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [operation setDownloadProgressBlock:block];
    return operation;
}


- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
             uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock {
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [operation setUploadProgressBlock:uploadProgressBlock];
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
             uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock {
    
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [operation setUploadProgressBlock:uploadProgressBlock];
    return operation;
}

- (void)cancel {
    [self.operationQueue cancelAllOperations];
}

- (void)addHttpOperationWith:(AFHTTPRequestOperation*)op {
    [self.operationQueue addOperation:op];
}

- (NSArray*)operations {
    return self.operationQueue.operations;
}

- (BOOL)isExecuteWith:(AFHTTPRequestOperation*)op {
    for (AFHTTPRequestOperation * operation in self.operationQueue.operations) {
        if ([operation isEqual:op]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isExecuteWithIdentify:(NSString*)identify {
    for (AFHTTPRequestOperation * operation in self.operationQueue.operations) {
        if ([[[[operation request] URL] absoluteString] containString:identify]) {
            return YES;
        }
    }
    return NO;
}

- (NSTimeInterval)timeoutInterval {
    return self.requestSerializer.timeoutInterval;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
     self.requestSerializer.timeoutInterval = timeoutInterval;
}

@end
