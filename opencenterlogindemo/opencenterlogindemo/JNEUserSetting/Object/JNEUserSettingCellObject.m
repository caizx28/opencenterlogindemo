//
//  UserSettingCellObject.m
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/15.
//  Copyright © 2016年 poco. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserSettingCellObject requires ARC support."
#endif

#import "JNEUserSettingCellObject.h"

@implementation JNEUserSettingCellObject

- (instancetype)initWithCellIdentifier:(NSString *)identifier
                                 title:(NSString *)title
                                detail:(NSString *)detail
                           excuteBlock:(ExcuteBlock)block {
    if (self = [super init]) {
        self.identifier = identifier;
        self.title = title;
        self.detail = detail;
        self.hideSeparatorLine = NO;
        self.excuteBlock = [block copy];
    }
    return self;
}

+ (instancetype)objectWithCellIdentifier:(NSString *)identifier
                                   title:(NSString *)title
                                  detail:(NSString *)detail {
    return [[[self class] alloc] initWithCellIdentifier:identifier
                                                  title:title
                                                 detail:detail
                                            excuteBlock:nil];
}

+ (instancetype)objectWithCellIdentifier:(NSString *)identifier
                                   title:(NSString *)title
                                  detail:(NSString *)detail
                             excuteBlock:(ExcuteBlock)block {
    return [[[self class] alloc] initWithCellIdentifier:identifier
                                            title:title
                                           detail:detail
                                            excuteBlock:block];
}

@end
