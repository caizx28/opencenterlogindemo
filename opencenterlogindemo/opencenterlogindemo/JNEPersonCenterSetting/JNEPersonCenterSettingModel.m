//
//  JNePersonCenterSettingModel.m
//  puzzleApp
//
//  Created by admin on 16/4/22.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#import "JNEPersonCenterSettingModel.h"

@implementation JNEPersonCenterSettingModel

+ (instancetype)initWithTitle:(NSString*)title  content:(id)content  isHeader:(BOOL)isHeader isSwitch:(BOOL)isSwitch {
    JNEPersonCenterSettingModel * model = [[[JNEPersonCenterSettingModel alloc] init] autorelease];
    model.title = title;
    model.content = content;
    model.isHeader = isHeader;
    model.isSwitch = isSwitch;
    return model;
}

+ (instancetype)initWithTitle:(NSString*)title  content:(id)content  isHeader:(BOOL)isHeader {
    return [self initWithTitle:title content:content isHeader:isHeader isSwitch:NO];
}

+ (instancetype)initWithTitle:(NSString*)title  content:(id)content  {
    return [self initWithTitle:title content:content isHeader:NO];
}

- (void)dealloc {
    self.title = nil;
    self.content = nil;
    self.seletorString = nil;
    self.identify = nil;
    [super dealloc];
}
@end
