//
//  JPShareAuthorizeObject.m
//  JanePlus
//
//  Created by admin on 15/8/21.
//  Copyright (c) 2015年 Allen Chen. All rights reserved.
//

#import "JPShareAuthorizeObject.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JPShareAuthorizeObject requires ARC support."
#endif

@implementation JPShareAuthorizeObject

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{   
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.token forKey:@"token"];
    
    [aCoder encodeObject:self.tokenSecret forKey:@"tokenSecret"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    
    [aCoder encodeObject:self.expirationDate forKey:@"expirationDate"];
    [aCoder encodeObject:self.refreshToken forKey:@"refreshToken"];
    
    [aCoder encodeObject:self.unionid forKey:@"unionid"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.tokenSecret = [aDecoder decodeObjectForKey:@"tokenSecret"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.expirationDate = [aDecoder decodeObjectForKey:@"expirationDate"];
        self.refreshToken = [aDecoder decodeObjectForKey:@"refreshToken"];
        self.unionid = [aDecoder decodeObjectForKey:@"unionid"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
    }
    return self;
}

#pragma mark - NScopy
- (id)copyWithZone:(NSZone *)zone {
    JPShareAuthorizeObject *authorizeObject = [[[self class] allocWithZone:zone] init];
    authorizeObject.token = self.token;
    authorizeObject.tokenSecret = self.tokenSecret;
    authorizeObject.refreshToken =self.refreshToken;
    authorizeObject.unionid = self.unionid;
    authorizeObject.expirationDate = self.expirationDate;
    authorizeObject.nickName = self.nickName;
    authorizeObject.userID = self.userID;
    authorizeObject.type = self.type;
    return authorizeObject;
}

- (NSString*)description{
    return [NSString stringWithFormat:@"JPShareAuthorizeObject = token=%@,useId=%@,tokenSecret=%@",self.token,self.userID,self.tokenSecret];
}


@end
