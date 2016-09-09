//
//  NSDicCacheHelper.m
//  MYProject
//
//  Created by apple on 14-4-21.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "NSDicCacheHelper.h"
//#import "NSString+Extensions.h"

@interface NSDicCacheHelper ()

@property (nonatomic, strong) NSMutableDictionary *cache;

@end


@implementation NSDicCacheHelper

#pragma mark - Singleton method

+ (id)sharedCachier {
    static NSDicCacheHelper *sharedCachier = nil;
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
        self.cache = [[[NSMutableDictionary alloc] init] autorelease];
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
//    NSString *key = [aKey md5String];
    NSString *key = @"md5String";
    [self.cache removeObjectForKey:key];
}

- (void)removeAllObjects {

    [self.cache removeAllObjects];
}

@end
