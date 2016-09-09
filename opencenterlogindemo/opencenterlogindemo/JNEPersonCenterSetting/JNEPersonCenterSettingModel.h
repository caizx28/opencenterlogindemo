//
//  JNePersonCenterSettingModel.h
//  puzzleApp
//
//  Created by admin on 16/4/22.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNEPersonCenterSettingModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) id  content;
@property (nonatomic,assign) BOOL isHeader;
@property (nonatomic,assign) BOOL isSwitch;
@property (nonatomic,copy) NSString * seletorString;
@property (nonatomic,copy) NSString * identify;

+ (instancetype)initWithTitle:(NSString*)title  content:(id)content  isHeader:(BOOL)isHeader isSwitch:(BOOL)isSwitch;

+ (instancetype)initWithTitle:(NSString*)title  content:(id)content  isHeader:(BOOL)isHeader;

+ (instancetype)initWithTitle:(NSString*)title  content:(id)content  ;
@end
