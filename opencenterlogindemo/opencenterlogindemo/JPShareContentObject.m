//
//  JPShareContentObject.m
//  JanePlus
//
//  Created by admin on 15/8/21.
//  Copyright (c) 2015年 Allen Chen. All rights reserved.
//

#import "JPShareContentObject.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JPShareContentObject requires ARC support."
#endif

@implementation JPShareContentObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageCompressRate = 1.0;
    }
    return self;
}

@end
