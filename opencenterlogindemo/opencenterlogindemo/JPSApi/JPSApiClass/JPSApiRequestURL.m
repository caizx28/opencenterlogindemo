//
//  JPSPocoAPIConstant.m
//  JanePlus
//
//  Created by admin on 15/9/25.
//  Copyright © 2015年 Allen Chen. All rights reserved.
//

#import "JPSApiRequestURL.h"
#import "PersistentSettings.h"

@implementation JPSApiRequestURL

+ (NSString*)JPSApiRequestURLPrefix {
    if([PersistentSettings sharedPersistentSettings].isApiTestMode) {
        return @"http://open.adnonstop.com/jane/biz/beta/api/public/index.php?";
    }
    return @"http://open.adnonstop.com/jane/biz/prod/api/public/index.php?";
}

@end
