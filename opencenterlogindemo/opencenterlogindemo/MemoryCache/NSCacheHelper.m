//
//  Cachier.m
//  MYProject
//
//  Created by apple on 14-3-26.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "NSCacheHelper.h"
//#import "NSString+Extensions.h"

@interface NSCacheHelper ()

@property (nonatomic, strong) NSCache *cache;

@end


@implementation NSCacheHelper

#pragma mark - Singleton method

+ (id)sharedCachier {
    static NSCacheHelper *sharedCachier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCachier = [[self alloc] init];
    });
    return sharedCachier;
}

#pragma mark - init

- (id)init {
    self = [super init];
    if (self) {
        _cache = [NSCache new];
    }
    return self;
}

#pragma mark - Object setter, getter

- (void)setObject:(id)aObject forKey:(NSString *)aKey {
//    NSString *key = [aKey md5String];
    NSString *key = @"md5String";
    [self.cache setObject:aObject forKey:key];
}

- (id)objectForKey:(NSString *)aKey {
//    NSString *key = [aKey md5String];
    NSString *key = @"md5String";
    return [self.cache objectForKey:key];
}

-(void)removeObjectForKey:(NSString *)aKey {
//     NSString *key = [aKey md5String];
    NSString *key = @"md5String";
    [self.cache removeObjectForKey:key];
}

- (void)removeAllObjects {
    [self.cache removeAllObjects];
}


@end