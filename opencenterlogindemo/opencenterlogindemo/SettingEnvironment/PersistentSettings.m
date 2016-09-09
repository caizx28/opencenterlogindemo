//
//  PersistentSettings.m
//  MYProject
//
//  Created by apple on 14-4-22.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "PersistentSettings.h"
#import "SINGLETONGCD.h"
//#import "UIPuzzleHelper.h"

@implementation PersistentSettings
SINGLETON_GCD(PersistentSettings)
#pragma mark-
#pragma mark 添加上面类似的属性，具有永久持久化作用

- (BOOL)isAutoAddDate
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return false;
    }
}

- (void)setIsAutoAddDate:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (BOOL)isShowSetFontView
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return true;
    }
}

-(void)setIsShowSetFontView:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (BOOL)isShowPhotoSpliceSliderAnimate
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return true;
    }
}

-(void)setIsShowPhotoSpliceSliderAnimate:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (NSInteger)originImageLength
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT integerForKey:key];
    } else {
//        if ([UIPuzzleHelper isLowiPhone]) {
//            return  640;
//        }
        return 1024;
    }
}

- (void)setOriginImageLength:(NSInteger)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setInteger:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (NSString*)saveOldVersions
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT stringForKey:key];
    } else {
        return [NSString stringWithFormat:@"0"];
    }
}

- (void)setSaveOldVersions:(NSString*)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setObject:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (BOOL)isShowEffectButtonAnimat
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return true;
    }
}

-(void)setIsShowEffectButtonAnimat:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (NSString*)saveHeadImageName
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT stringForKey:key];
    } else {
        return @"昵称";
    }
}

- (void)setSaveHeadImageName:(NSString*)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setObject:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (BOOL)isAutoFilter
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        
//        if ([UIPuzzleHelper isLowiPhone]) {
//            return NO;
//        }
        return YES;
    }
}

- (void)setIsAutoFilter:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}



- (BOOL)isTestBusinessMode
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return NO;
    }
}

- (void)setIsTestBusinessMode:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}


- (BOOL)isNeedShowCallBeautyCameraTip
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return YES;
    }
}

- (void)setIsNeedShowCallBeautyCameraTip:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (BOOL)isNeesShowVipMemberTip
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return YES;
    }
}

- (void)setIsNeesShowVipMemberTip:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (BOOL)isApiTestMode
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return NO;
    }
}

- (void)setIsApiTestMode:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (BOOL)isAutoRemoveWaterMark
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return YES;
    }
}

- (void)setIsAutoRemoveWaterMark:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (BOOL)isFirstInstall
{
    NSString * key = NSStringFromSelector(_cmd);
    BOOL isFirstInstall = TheAppDel.isFirstInstall;
    if (!USER_DEFAULT_ISEXISTKEY(key)&&isFirstInstall) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setIsFirstInstall:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

#pragma mark 私有函数
-(NSString*)PropertyKey:(NSString*)originKey
{
    NSString * firstLetter = [[originKey substringWithRange:NSMakeRange(0, 1)] lowercaseString];
    NSString * letters = [originKey substringFromIndex:1] ;
    NSString * otherLetters = [letters substringToIndex:[letters length]-1];
    NSString * key = [NSString stringWithFormat:@"%@%@",firstLetter,otherLetters];
    return key;
}

/*
- (BOOL)isAutoAddDate
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return false;
    }
}

- (void)setIsAutoAddDate:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (BOOL)isShowSetFontView
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return true;
    }
}

-(void)setIsShowSetFontView:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (BOOL)isShowPhotoSpliceSliderAnimate
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return true;
    }
}

-(void)setIsShowPhotoSpliceSliderAnimate:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (NSInteger)originImageLength
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT integerForKey:key];
    } else {
//        if ([UIPuzzleHelper isLowiPhone]) {
//            return  640;
//        }
        return 1024;
    }
    
}

- (void)setOriginImageLength:(NSInteger)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setInteger:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (NSString*)saveOldVersions
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT stringForKey:key];
    } else {
        return [NSString stringWithFormat:@"0"];
    }
}

- (void)setSaveOldVersions:(NSString*)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setObject:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (BOOL)isShowEffectButtonAnimat
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return true;
    }
}

-(void)setIsShowEffectButtonAnimat:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (NSString*)saveHeadImageName
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT stringForKey:key];
    } else {
        return @"昵称";
    }
}

- (void)setSaveHeadImageName:(NSString*)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setObject:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (BOOL)isAutoFilter
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        
//        if ([UIPuzzleHelper isLowiPhone]) {
//            return NO;
//        }
        return YES;
    }
}

- (void)setIsAutoFilter:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}



- (BOOL)isTestBusinessMode
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return NO;
    }
}

- (void)setIsTestBusinessMode:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}


- (BOOL)isNeedShowCallBeautyCameraTip
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return YES;
    }
}

- (void)setIsNeedShowCallBeautyCameraTip:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

- (BOOL)isNeesShowVipMemberTip
{
    NSString * key = NSStringFromSelector(_cmd);
    if (USER_DEFAULT_ISEXISTKEY(key)) {
        return [USER_DEFAULT boolForKey:key];
    } else {
        return YES;
    }
}

- (void)setIsNeesShowVipMemberTip:(BOOL)flag
{
    NSString * originKey = [NSStringFromSelector(_cmd) substringFromIndex:3];
    [USER_DEFAULT setBool:flag forKey:[self PropertyKey:originKey]];
    [USER_DEFAULT synchronize];
}

#pragma mark-
#pragma mark 添加上面类似的属性，具有永久持久化作用

////////TO DO

#pragma mark 私有函数
-(NSString*)PropertyKey:(NSString*)originKey
{
    NSString * firstLetter = [[originKey substringWithRange:NSMakeRange(0, 1)] lowercaseString];
    NSString * letters = [originKey substringFromIndex:1] ;
    NSString * otherLetters = [letters substringToIndex:[letters length]-1];
    NSString * key = [NSString stringWithFormat:@"%@%@",firstLetter,otherLetters];
    return key;
}
*/
@end
