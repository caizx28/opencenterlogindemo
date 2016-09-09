//
//  NSStrinAddition.h
//  DoubanAlbum
//
//  modify from Three20 by Tonny on 6/5/11.
//  Copyright 2012 SlowsLab. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreLocation/CLLocation.h>
//字符的比较
@interface NSString (Addition)

@property (nonatomic, readonly) NSString* md5Hash;

- (BOOL)isWhitespaceAndNewlines;

- (BOOL)isEmptyOrWhitespace;

- (BOOL)isEmail;

- (BOOL)isLegalPrice;

- (BOOL)isNumber;

- (BOOL)isLegalName;

- (BOOL)isOnlyContainNumberOrLatter;

- (BOOL)isCharSafe:(unichar)ch;

- (BOOL)isPureInt;

- (BOOL)isChinese;

//- (BOOL)isInternetURL;
//
//- (BOOL)isQQNumber;

- (BOOL)isTelephoneNumber;

- (BOOL)isMobileTelephoneNumber;

- (BOOL)containString:(NSString *)string;

- (unichar) intToHex:(int)n;

- (NSString *)removeSpace;

- (NSString *)encodeString;

- (NSString *)replaceSpaceWithUnderline;

- (NSString *)replaceDotWithUnderline;

- (NSString *)trimmedWhitespaceString;

- (NSString *)trimmedWhitespaceAndNewlineString;

- (NSString *)getValueStringFromUrlForParam:(NSString *)param;

// date
+ (NSDate *)dateFromString:(NSString *)string;

- (NSDictionary *)parseURLParams;

- (NSDate *)date;

- (NSComparisonResult)versionCompare:(NSString *)other;

- (NSComparisonResult)versionStringCompare:(NSString *)other;

- (NSInteger)bytesLength;

- (NSString *)subStringWithMaxBytesLen:(NSInteger)MaxBytesLen;

- (id)toJSONObject;


@end
