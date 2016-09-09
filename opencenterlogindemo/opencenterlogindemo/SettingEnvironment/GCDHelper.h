//
//  GCDHelper.h
//  DoubanAlbum
//
//  Created by Tonny on 12-12-12.
//  Copyright (c) 2012年 SlowsLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "blocktypedef.h"
@interface GCDHelper : NSObject

+ (void)repeatBlockInGroup:(NSArray*)blocks ;

+ (void)saveCachedImage:(SLBlock)block completion:(SLBlock)completion;

+ (void)dispatchBlockInAdvertisementQueue:(SLBlock)block completion:(SLBlock)completion;

+ (void)dispatchBlockInBussinessQueue:(SLBlock)block completion:(SLBlock)completion;

+ (void)repeatBlock:(SLBlock)block withCount:(NSUInteger)count;

+ (void)dispatchBlock:(SLBlock)block completion:(SLBlock)completion;

+ (void)dispatchMainQueueBlock:(SLBlock)block;

+ (void)dispatchBlockInTemplateInfoQueue:(SLBlock)block completion:(SLBlock)completion;

@end
