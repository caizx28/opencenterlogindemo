//
//  JPSApiObject.h
//  JanePlus
//
//  Created by admin on 16/2/19.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPShareConstant.h"
#import "JPSAPIConstant.h"
#import "JPShare.h"

FOUNDATION_EXTERN NSString * const JPSApiObjectDomain ;
FOUNDATION_EXTERN NSString * const JPSApiObjectDomainDefaultError ;

#pragma mark - 业务基础模型

@interface JPSApiAccessInfo : NSObject
@property (nonatomic,copy) NSString *accessToken;
@property (nonatomic,copy) NSString *refreshToken;
@property (nonatomic,copy) NSString *addTime;
@property (nonatomic,copy) NSString *addId;
@property (nonatomic,copy) NSString *expireTime;
@property (nonatomic,copy) NSString *updateTime;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString * pwdhash;
@property (nonatomic,assign) JPSApiLoginType type;
@property (nonatomic,assign) JPShareLoginType thirdPanerType;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (BOOL)isValid;
@end

@interface JPSApiUserProfile : NSObject
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *userIcon;
@property (nonatomic,copy) NSString *userSpace;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *zone_num;
@property (nonatomic,copy) NSString *signature;
@property (nonatomic,copy) NSString *birthdayYear;
@property (nonatomic,copy) NSString *birthdayMonth;
@property (nonatomic,copy) NSString *birthdayDay;
@property (nonatomic,copy) NSString *locationIdTree;
@property (nonatomic,copy) NSString *locationId;
@property (nonatomic,copy) NSString *isRubbish;
@property (nonatomic,copy) NSString *isDel;
@property (nonatomic,copy) NSString *isSetIcon;
@property (nonatomic,copy) NSString *freeCredit;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (instancetype)initWithThirdParnerDictionary:(NSDictionary*)dictionary;
- (BOOL)isValid;
@end




