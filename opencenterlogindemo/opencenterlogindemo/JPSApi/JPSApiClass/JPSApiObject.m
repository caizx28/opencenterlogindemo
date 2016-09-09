//
//  JPSApiObject.m
//  JanePlus
//
//  Created by admin on 16/2/19.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import "JPSApiObject.h"
#import "NSStringAddition.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
  #error " JPSApiObject.h (JPSApi_EasyCopy) requires ARC support."
#endif

NSString *const JPSApiObjectDomain = @"JPSApiRequestMangerDomain";
NSString *const JPSApiObjectDomainDefaultError = @"网络数据出错";

#pragma mark - 业务基础模型
@implementation JPSApiAccessInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];

	if (self) {
		if (dictionary) {
			self.accessToken = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"access_token"]];
			self.addTime = [[dictionary objectForKey:@"add_time"] stringValue];
			self.addId = [[dictionary objectForKey:@"app_id"] stringValue];
			self.expireTime = [[dictionary objectForKey:@"expire_time"] stringValue];
			self.refreshToken = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"refresh_token"]];
			self.updateTime = [[dictionary objectForKey:@"update_time"] stringValue];
			self.userId = [[dictionary objectForKey:@"user_id"] stringValue];
			self.thirdPanerType = JPShareLoginTypeSina;
		}
	}

	return self;
}

- (BOOL)isValid {
	if ([self.accessToken isEmptyOrWhitespace] ||
		(self.accessToken == nil) ||
		[self.userId isEmptyOrWhitespace] ||
		(self.userId == nil) ||
		[self.refreshToken isEmptyOrWhitespace] ||
		(self.refreshToken == nil) ||
		[self.expireTime isEmptyOrWhitespace] ||
		(self.expireTime == nil)) {
		return NO;
	}
	return YES;
}

@end

@implementation JPSApiUserProfile

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];

	if (self) {
		if (dictionary) {
			self.userId = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"user_id"]];
			self.nickName = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"nickname"]];
			self.userIcon = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"user_icon"]];
			self.userSpace = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"user_space"]];
			self.sex = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"sex"]];
			self.mobile = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"mobile"]];
			self.zone_num = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"zone_num"]];
			self.signature = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"signature"]];
			self.birthdayYear = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"birthday_year"]];
			self.birthdayMonth = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"birthday_month"]];
			self.birthdayDay = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"birthday_day"]];
			self.locationIdTree = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"location_id_tree"]];
			self.locationId = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"location_id"]];
			self.isRubbish = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"is_rubbish"]];
			self.isDel = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"is_del"]];
			self.isSetIcon = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"is_set_icon"]];
			self.freeCredit = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"free_credit"]];
		}
	}

	return self;
}

- (instancetype)initWithThirdParnerDictionary:(NSDictionary *)dictionary {
	self = [super init];

	if (self) {
		if (dictionary) {
			self.userId = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"user_id"]];
			self.nickName = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"nickname"]];
			self.userIcon = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"user_icon"]];
			self.userSpace = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"user_space"]];
			self.sex = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"sex"]];
			self.mobile = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"mobile"]];
			self.zone_num = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"zone_num"]];
			self.signature = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"signature"]];
			self.birthdayYear = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"birthday_year"]];
			self.birthdayMonth = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"birthday_month"]];
			self.birthdayDay = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"birthday_day"]];
			self.locationIdTree = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"location_id_tree"]];
			self.locationId = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"location_id"]];
			self.isRubbish = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"is_rubbish"]];
			self.isDel = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"is_del"]];
			self.isSetIcon = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"is_set_icon"]];
			self.freeCredit = [JPSApiConstant filterNullWithValue:[dictionary objectForKey:@"free_credit"]];
		}
	}

	return self;
}

- (BOOL)isValid {
	return YES;
}

@end
