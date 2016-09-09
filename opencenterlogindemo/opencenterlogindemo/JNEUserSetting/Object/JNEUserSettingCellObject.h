//
//  UserSettingCellObject.h
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/15.
//  Copyright © 2016年 poco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ExcuteBlock)();

@interface JNEUserSettingCellObject : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *userIcon;
@property (nonatomic, strong) NSString *userSpace;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, copy) ExcuteBlock excuteBlock;
@property (nonatomic, assign, getter = shouldHideSeparatorLine) BOOL hideSeparatorLine;

+ (instancetype)objectWithCellIdentifier:(NSString *)identifier
                                   title:(NSString *)title
                                  detail:(NSString *)detail
                             excuteBlock:(ExcuteBlock)block;

+ (instancetype)objectWithCellIdentifier:(NSString *)identifier
                                   title:(NSString *)title
                                  detail:(NSString *)detail;

@end
