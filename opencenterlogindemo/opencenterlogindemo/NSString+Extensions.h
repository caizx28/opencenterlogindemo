//
//  NSString+Extensions.h
//  MYProject
//
//  Created by apple on 14-3-20.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

+ (NSString *)stringToSha1:(NSString *)str;

+ (NSString*)encodeBase64String:(NSString*)input;
+ (NSString*)decodeBase64String:(NSString*)input;
+ (NSString*)encodeBase64Data:(NSData*)data;
+ (NSString*)decodeBase64Data:(NSData*)data;

- (NSNumber*)stringToNSNumber;
- (BOOL)isEmpty;
- (BOOL)stringContainsSubString:(NSString *)subString;
- (NSString *)stringByReplacingStringsFromDictionary:(NSDictionary *)dict;
- (NSString *)stringByReplacingStringsFromString:(NSString *)string  withReplaceString:(NSString*)replaceString;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (NSString *)URLEncodedStringOnGBK;
- (NSString *)URLDecodedStringOnGBK;

- (NSString *)decodeUnicodeString;
- (NSString *)encodeUnicodeString;
- (NSString *)md5String;




@end
