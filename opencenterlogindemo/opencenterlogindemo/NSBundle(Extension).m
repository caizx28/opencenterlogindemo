//
//  BundleHelper.m
//  DoubanAlbum
//
//  Created by Tonny on 12-12-12.
//  Copyright (c) 2012年 SlowsLab. All rights reserved.
//

#import "NSBundle(Extension).h"
#import "NSStringAddition.h"

@implementation NSBundle (extension)

+ (NSString *)bundleApplicationId{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
}

//进程的bundle名
+ (NSString *)bundleNameString{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
}

+ (NSString *)materailVersion {
    static NSString *key = @"showVersion";
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
}

//获取程序安装后的名称
+ (NSString *)bundleDisplayNameString{
    static NSString *key = @"CFBundleDisplayName";
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
}

//1.0.0 获取短版本号
+ (NSString *)bundleShortVersionString{
    static NSString *key = @"CFBundleShortVersionString";
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
}

//2938
+ (NSString *)bundleBuildVersionString{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

//获取bundleIdentifier
//com.slowslab.doubanalbum
+ (NSString *)bundleIdentifierString{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
}

//{CFBundleTypeRole:,CFBundleURLIconFile:,CFBundleURLName:,CFBundleURLSchemes:}
+ (NSArray *)bundleURLTypes{
    static NSString *key = @"CFBundleURLTypes";
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
}

////////////////////

//获取版本号
+ (NSString *)bundleUnderlineVersionString{
    
    NSString *version = [NSBundle bundleShortVersionString];
    NSString *underlineVersion = [version replaceDotWithUnderline];
    return underlineVersion;
}

//获取详细版本号
+ (NSString *)bundleFullVersionString{
    NSString *version = [NSBundle bundleShortVersionString];
    NSString *build = [NSBundle  bundleBuildVersionString];
    return [NSString stringWithFormat:@"%@.%@", version, build];
}


+ (NSString*)stringFromBundleFile:(NSString*)fileName
{
    NSString * type = [fileName pathExtension];
    NSString * name = [fileName stringByDeletingPathExtension];
    NSString *file = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:file];
    NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return  string;

}

+ (NSData*)dataFromBundleFile:(NSString*)fileName
{
    NSString * type = [fileName pathExtension];
    NSString * name = [fileName stringByDeletingPathExtension];
    NSString *file = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:file];
    return  data;
}

@end
