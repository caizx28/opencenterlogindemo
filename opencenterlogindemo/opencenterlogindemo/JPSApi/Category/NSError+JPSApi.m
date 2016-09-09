//
//  NSError+JPSApi.m
//  JanePlus
//
//  Created by admin on 16/2/24.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import "NSError+JPSApi.h"
#import "JPSApiObject.h"

@implementation NSError (JPSApi)

- (BOOL)isLandExpirationError {
    if (self.code == -4) {
      return  YES;
    }
    return NO;
}

@end
