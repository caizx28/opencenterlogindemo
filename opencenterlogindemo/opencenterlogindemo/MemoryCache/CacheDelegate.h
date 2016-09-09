//
//  CacheDelegate.h
//  MYProject
//
//  Created by apple on 14-4-21.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CacheDelegate <NSObject>

@required

+ (id)sharedCachier;
- (void)setObject:(id)aObject forKey:(NSString *)aKey;
- (id)objectForKey:(NSString *)aKey;
- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;

@end
