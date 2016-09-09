//
//  UnlockTypeChecker.h
//  puzzleApp
//
//  Created by apple on 14-8-26.
//  Copyright (c) 2014年 Allen Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString * const UnlockTypeCheckerUpdateNotification;

typedef NS_ENUM(NSInteger, MaterialUnlockType) {
    MaterialUnlockClose,
    MaterialUnlockOpen,
};

@interface UnlockTypeChecker : NSObject

+ (UnlockTypeChecker *)shareInstance ;

- (id)init;

- (void)start;

- (BOOL)isOpenHomePageRecommendEntry;

- (BOOL)isOpenTemplateShareUnlockEntry;

- (BOOL)isOpenActivityEntry;

- (BOOL)isOpenThirdParnerLoginEntry;

- (BOOL)isOpenSqureEntry;

- (BOOL)isOpenBeautyAppIntroduceEntry;

- (BOOL)isOpenTranlateEntry;

@end
