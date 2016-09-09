//
//  AppDelegate.m
//  opencenterlogindemo
//
//  Created by 蔡宗杏 on 16/9/2.
//  Copyright © 2016年 蔡宗杏. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "JPShare.h"
#import "JPSApiUserManger.h"
#import "AFNetworking.h"
#import "CLReporting.h"
#import "NSBundle(Extension).h"
#import "PersistentSettings.h"
#import "NSStringAddition.h"
NSString * const kAppPushId = @"120_1";
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.vc];
    [self.window makeKeyAndVisible];
 
    [self configureSystemtServiceWithApplication:application Options:launchOptions];
    [self configureThridSDKWithApplication:application Options:launchOptions];
    [self configuredData];
    return YES;
}
#pragma mark - 配置一些APP的系统服务

- (void)configureSystemtServiceWithApplication:(UIApplication *)application Options:(NSDictionary *)launchOptions  {
    
   
    __unused id path = [[JPSApiUserManger shareInstance] rootPath];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [self configuredReporting];
//    [self configureOfflinePusher];
}
- (void)configuredReporting {
    BOOL backgroundSupported = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        backgroundSupported = YES;
    }
    //	判断是否支持多任务，避免与 - (void)applicationDidBecomeActive:(UIApplication *)application 函数重复统计
    if (!backgroundSupported) {
        [[CLReporting sharedInstance] registerApp:kAppPushId];
    }
}

#pragma mark - 配置素材数据，版本升级，导致的数据更新 
- (void)configuredData {
    
    NSString *showVersion = [NSBundle bundleShortVersionString];
    
    NSString *upDataVersionStr = [NSString stringWithFormat:@"%@",UPDATA_PUZZLE_MATERIAL_VERSION_PHOTO_WALL];
    
    if ([[PersistentSettings sharedPersistentSettings].saveOldVersions versionCompare:upDataVersionStr ] == NSOrderedAscending) {
        [FileOperate removeFile:@"EGOCache" fromDirectory:[NSString stringWithFormat:@"%@/jane/",APP_CACHES_PATH]];
    }
    
    if (![[PersistentSettings sharedPersistentSettings].saveOldVersions isEqualToString:showVersion]) {
//        for (NSString *templateDataManageString in [UIPuzzleHelper templateDataManageClassStringArray]) {
//            JNETemplateDataBaseManage *templateDataManage = [UIPuzzleHelper templateDataManageWithTemplateDataManageString:templateDataManageString];
//            [templateDataManage checkSaveOldMaterialData];
//        }
//        [UIChooseUIFontData checkSaveOldMaterialData];
//        [self versionUpdateActionConfigure];
        
//    }else{
//        [self configuredImportData];
        NSLog(@"%@",showVersion);
    }
    
//    NSDictionary *puzzleSaveChooseTemplateViewOffsetDic = [FileOperate readObjectFromRtfFile:PUZZLE_SAVE_CHOOSE_TEMPLATE_VIEW_OFFSET_PATH];
//    if (puzzleSaveChooseTemplateViewOffsetDic != nil ) {
//        if ([puzzleSaveChooseTemplateViewOffsetDic objectForKey:@"Key"] != nil) {
//            NSChooseTemplateType type = [UIPuzzleHelper chooseTemplateTypeWithMaterialInfoId:[puzzleSaveChooseTemplateViewOffsetDic objectForKey:@"Key"]];
//            if(type == NSChooseTemplateNone){
//                type = NSChooseTemplatePhotoWallType;
//            }
//            NSMutableDictionary *subDic = [[[NSMutableDictionary alloc] init] autorelease];
//            [subDic setObject:[NSString stringWithFormat:@"%@",@(type)] forKey:@"nsChooseTemplateType"];
//            [FileOperate saveObjectToRtfFile:subDic savePath:PUZZLE_SAVE_CHOOSE_TEMPLATE_VIEW_OFFSET_PATH];
//        }else if ([puzzleSaveChooseTemplateViewOffsetDic objectForKey:@"nsChooseTemplateType"] != nil){
//            NSMutableDictionary *subDic = [[[NSMutableDictionary alloc] init] autorelease];
//            [subDic setObject:[puzzleSaveChooseTemplateViewOffsetDic objectForKey:@"nsChooseTemplateType"] forKey:@"nsChooseTemplateType"];
//            [FileOperate saveObjectToRtfFile:subDic savePath:PUZZLE_SAVE_CHOOSE_TEMPLATE_VIEW_OFFSET_PATH];
//        }else{
//            [FileOperate removeFile:PUZZLE_SAVE_CHOOSE_TEMPLATE_VIEW_OFFSET_PATH];
//        }
//    }
}

#pragma mark - 配置第三方SDK

- (void)configureThridSDKWithApplication:(UIApplication *)application Options:(NSDictionary *)launchOptions {
    [self configureShareSDKWithApplication:application Options:launchOptions];
   
}

- (void)configureShareSDKWithApplication:(UIApplication *)application Options:(NSDictionary *)launchOptions {
    [JPShare registerAppShareConfigWith:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
