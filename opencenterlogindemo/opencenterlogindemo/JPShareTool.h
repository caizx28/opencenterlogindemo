//
//  JPShareTool.h
//  UnknownApp
//
//  Created by admin on 15/8/24.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPShareTool : NSObject
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;
+ (void)cleanCookiesWithTargetURL:(NSArray*)urls;
+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;
+ (NSURL *)smartURLForString:(NSString *)str ;
+ (BOOL)isPureInt:(NSString *)string ;
+ (NSString*)md5Hash:(NSData *)data ;
+ (NSData*)compressedImageWithRate:(CGFloat)rate path:(NSString*)path;
@end

