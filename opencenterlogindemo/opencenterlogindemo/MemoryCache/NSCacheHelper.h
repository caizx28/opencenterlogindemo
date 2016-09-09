//
//  Cachier.h
//  MYProject
//
//  Created by apple on 14-3-26.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheDelegate.h"
///用于缓存某个东西在内存,当内存超过一定数量的时候，会自动删除当中的对象
@interface NSCacheHelper : NSObject<CacheDelegate>

+ (id)sharedCachier;
- (void)setObject:(id)aObject forKey:(NSString *)aKey;
- (id)objectForKey:(NSString *)aKey;
- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;
@end
