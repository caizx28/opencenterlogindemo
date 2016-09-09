//
//  UnlockTypeChecker.m
//  puzzleApp
//
//  Created by apple on 14-8-26.
//  Copyright (c) 2014年 Allen Chen. All rights reserved.
//

#import "UnlockTypeChecker.h"
#import "NetworkUnit.h"
#import "ASIHTTPRequest.h"
#import "PersistentSettings.h"
#import "NSStringAddition.h"
#import "GCDHelper.h"

NSString *const UnlockTypeCheckerUpdateNotification = @"UnlockTypeCheckerUpdateNotification";
NSString *const kUnlockTypeCheckerPrefix = @"UnlockTypeCheckerPrefix";
NSString *const kUnlockTypeCheckeCameraType = @"jianpin/ad/get_ads2.php?";
NSString *const kUnlockTypeCheckerURL = @"http://img-wifi.poco.cn/mypoco/mtmpfile/API/jianpin/unlock/iphone.php";
NSString *const kUnlockTypeCheckerFile = @"UnlockTypeCheckerFile";
NSString *const kUnlockTypeCheckerCacheDirectory = @"UnlockTypeCheckerCacheDirectory";

static UnlockTypeChecker *shareInstance = nil;
static dispatch_once_t onceToken = nil;
NSString *const materLockKey = @"shareToWX_JIANYUE";

@interface UnlockTypeChecker ()

@property (nonatomic, assign) BOOL isRefreshedType;
@property (atomic, retain) NSArray *unlockList;
@property (atomic, assign) BOOL isRequesting;

- (NSString *)createRequestURL;

@end

@implementation UnlockTypeChecker

#pragma mark -
#pragma mark shareInstance

+ (UnlockTypeChecker *)shareInstance {
	@synchronized(self)
	{
		dispatch_once(&onceToken, ^{
			shareInstance = [[super allocWithZone:nil] init];
		});
	}
	return shareInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
	return [self shareInstance];
}

- (id)copyWithZone:(NSZone *)zone {
	return [UnlockTypeChecker shareInstance];
}

- (id)init {
	self = [super init];

	if (self) {
		self.isRequesting = false;
		[FileOperate createDirectoryWithName:kUnlockTypeCheckerCacheDirectory toDirectory:DOWN_MATERIAL_DIR];
		self.unlockList = [self deserializeAdvertisementWithKey:kUnlockTypeCheckerFile];
	}

	return self;
}

- (void)dealloc {
	self.unlockList = nil;
	[super dealloc];
}

#pragma mark - operater

- (void)start {
	if ([[NetworkUnit sharedInstance] isNetworkDisable] || self.isRequesting) {
		return;
	}

	self.isRequesting = true;
	NSString *bundleVersion = [self bundleVersion];
	NSString *URLString = [NSString stringWithFormat:@"%@?version=%@", kUnlockTypeCheckerURL, bundleVersion];
	ASIHTTPRequest *tmp_req = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:URLString]] autorelease];
	[tmp_req addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	[tmp_req setTimeOutSeconds:8];
	[tmp_req setDelegate:self];
	[tmp_req setDidFinishSelector:@selector(reqUnlockTypeFinish:)];
	[tmp_req setDidFailSelector:@selector(reqUnlockTypeFail:)];
	[tmp_req startAsynchronous];
}

- (BOOL)isOpenHomePageRecommendEntry {
	return [self searchEntyrLockStateWithKey:@"1" defaultState:NO];
}

- (BOOL)isOpenTemplateShareUnlockEntry {
	return [self searchEntyrLockStateWithKey:@"2" defaultState:NO];
}

- (BOOL)isOpenActivityEntry {
	return [self searchEntyrLockStateWithKey:@"3" defaultState:NO];
}

- (BOOL)isOpenSqureEntry {
	return [self searchEntyrLockStateWithKey:@"4" defaultState:NO];
}

- (BOOL)isOpenThirdParnerLoginEntry {
	return [self searchEntyrLockStateWithKey:@"5" defaultState:NO];
}

- (BOOL)isOpenBeautyAppIntroduceEntry {
	return [self searchEntyrLockStateWithKey:@"6" defaultState:NO];
}

- (BOOL)isOpenTranlateEntry {
	return [self searchEntyrLockStateWithKey:@"7" defaultState:NO];
}

#pragma mark - ASIHTTPRequest delegate

- (void)reqUnlockTypeFinish:(ASIHTTPRequest *)req {
	self.isRequesting = false;
	int ret_code = [req responseStatusCode];
	NSData *req_data = [req responseData];

	if (ret_code == 200 && [req_data length] > 0) {
		NSArray *unlockList = [[[NSJSONSerialization JSONObjectWithData:[req responseData] options:NSJSONReadingMutableContainers error:nil] copy] autorelease];

		if ([unlockList count] > 0) {
			BOOL success = [self serializeAdvertisementWithKey:kUnlockTypeCheckerFile info:unlockList];

			if (success) {
				self.unlockList = unlockList;
				[GCDHelper dispatchMainQueueBlock:^{
					[[NSNotificationCenter defaultCenter] postNotificationName:UnlockTypeCheckerUpdateNotification object:nil];
				}];
			}
		}
	}
}

- (void)reqUnlockTypeFail:(ASIHTTPRequest *)req {
	self.isRequesting = false;
}

#pragma mark - private   method

- (BOOL)searchEntyrLockStateWithKey:(NSString *)key defaultState:(BOOL)defaultState {
	for (NSDictionary *unlockInformation  in self.unlockList) {
		NSString *unlockId = [unlockInformation objectForKey:@"id"];

		if ([unlockId  isEqualToString:key]) {
			NSString *unlockState = [unlockInformation objectForKey:@"unlock"];

			if ([unlockState  isEqualToString:@"no"]) {
				return NO;
			} else {
				return YES;
			}
		}
	}

	return defaultState ? YES : NO;
}

- (NSArray *)deserializeAdvertisementWithKey:(NSString *)key {
	NSString *path = [self cachePathWithKey:key];

	if ([FileOperate isFileExistWithFilePath:path]) {
		NSArray *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
		return dic;
	}

	return [[[NSArray alloc] init] autorelease];
}

- (BOOL)serializeAdvertisementWithKey:(NSString *)key info:(id)info {
	NSString *path = [self cachePathWithKey:key];
	BOOL success = [NSKeyedArchiver archiveRootObject:info toFile:path];

	return success;
}

- (NSString *)cachePathWithKey:(NSString *)key {
	return [NSString stringWithFormat:@"%@/%@/%@", DOWN_MATERIAL_DIR, [NSString stringWithFormat:@"%@", kUnlockTypeCheckerCacheDirectory], key];
}

- (NSString *)bundleVersion {
	NSString *bundleVersion = nil;

	if ([PersistentSettings sharedPersistentSettings].isTestBusinessMode) {
		bundleVersion = @"88.8.8";
	} else {
		bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	}

	return bundleVersion;
}

@end
