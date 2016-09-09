//
//  NSString+Extensions.m
//  MYProject
//
//  Created by apple on 14-3-20.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "NSString+Extensions.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
#import "GTMDefines.h"
@implementation NSString (Extensions)

+ (NSString*)stringToSha1:(NSString*)str {
    const char *s = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    // This is the destination
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    // This one function does an unkeyed SHA1 hash of your hash data
    CC_SHA1(keyData.bytes, keyData.length, digest);
    // Now convert to NSData structure to make it usable again
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [out description];
    NSCharacterSet *doNotWants = [NSCharacterSet characterSetWithCharactersInString:@"<> "];
    hash = [[hash componentsSeparatedByCharactersInSet:doNotWants] componentsJoinedByString:@""];
    return hash;
}

#pragma mark - base64 encode 

+ (NSString*)encodeBase64String:(NSString* )input {
    NSData*data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString*base64String = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease] ;
    return base64String;
}

+ (NSString*)decodeBase64String:(NSString* )input {
    NSData*data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString*base64String = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease] ;
    return base64String;
}

+ (NSString*)encodeBase64Data:(NSData*)data {
    data = [GTMBase64 encodeData:data];
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData*)data {
    data = [GTMBase64 decodeData:data];
    NSString*base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    return base64String;
}

- (NSNumber*)stringToNSNumber {
    NSNumberFormatter* tmpFormatter = [[NSNumberFormatter alloc] init];
    [tmpFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber* theNumber = [tmpFormatter numberFromString:self];
    [tmpFormatter release];
    return theNumber;
}

- (BOOL)isEmpty {
    if ([self length] <= 0 || self == (id)[NSNull null] || self == nil) {
        return YES;
    }
    return NO;
}

- (BOOL)stringContainsSubString:(NSString *)subString {
    NSRange aRange = [self rangeOfString:subString];
    if (aRange.location == NSNotFound) {
        return NO;
    }
    return YES;
}

- (NSString*)stringByReplacingStringsFromDictionary:(NSDictionary*)dict {
    NSMutableString* string = [[self mutableCopy] autorelease];
    for (NSString* target in dict) {
        [string replaceOccurrencesOfString:target withString:[dict objectForKey:target] options:0 range:NSMakeRange(0, [string length])];
    }
    return string;
}

- (NSString *)stringByReplacingStringsFromString:(NSString *)string  withReplaceString:(NSString*)replaceString{
    NSMutableString* mutalbeString = [NSMutableString stringWithString:self];
   [mutalbeString replaceOccurrencesOfString:string withString:replaceString options:0 range:NSMakeRange(0, [mutalbeString length])];
    return mutalbeString;
}

- (NSString *)URLEncodedString {
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

- (NSString*)URLDecodedString {
    NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (CFStringRef)self,
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

- (NSString *)URLEncodedStringOnGBK {
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingGB_18030_2000);
    [result autorelease];
    return result;
}

- (NSString *)URLDecodedStringOnGBK {
    NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (CFStringRef)self,
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingGB_18030_2000);
    [result autorelease];
    return result;
}

- (NSString *)decodeUnicodeString {
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

- (NSString *)encodeUnicodeString {
    NSUInteger length = [self length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++)
    {
        unichar _char = [self characterAtIndex:i];
        if (_char <= '9' && _char >= '0')
        {
            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i, 1)]];
        }
        else if(_char >= 'a' && _char <= 'z'){
            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i, 1)]];
        }
        else if(_char >= 'A' && _char <= 'Z'){
            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i, 1)]];
        }
        else{
            [s appendFormat:@"\\u%x",[self characterAtIndex:i]];
        }
    }
    return s;
}


-(NSString *)md5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
