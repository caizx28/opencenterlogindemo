//
//  ProjectDefine.h
//  PocoPuzzle
//
//  Created by lion on 14-4-28.
//  Copyright (c) 2014年 lion. All rights reserved.
//

#ifndef PocoPuzzle_ProjectDefine_h
#define PocoPuzzle_ProjectDefine_h

#pragma mark - 拼图缓存路径 宏

#define APP_SURPORT_DIR [NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"pocoPuzzleSupportDir"]

#define MORE_VIEW_HISTORY_DATA_PATH [NSString stringWithFormat:@"%@/moreViewHistory.rtf",DOWN_MATERIAL_DIR]

#define RETURN_MORE_VIEW_HISTORY_DIC [NSKeyedUnarchiver unarchiveObjectWithFile:MORE_VIEW_HISTORY_DATA_PATH]

#define DOWN_MATERIAL_DIR [NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],@"MaterialDirectory"]

#define DOWN_PUZZLE_MATERIAL_DIR [NSString stringWithFormat:@"%@/%@",DOWN_MATERIAL_DIR, @"puzzleMaterialDirectory"]

#define DOWN_UIFONT_MATERIAL_DIR [NSString stringWithFormat:@"%@/%@",DOWN_MATERIAL_DIR, @"UIFontMaterialDirectory"]

#define DOWN_HOMEPAGESORT_MATERIAL_DIR [NSString stringWithFormat:@"%@/%@",DOWN_MATERIAL_DIR, @"PuzzHomePageSortMaterialDirectory"]

#define DOWN_PUZZLE_MATERIAL_PHOTO_WALL_DIR [NSString stringWithFormat:@"%@/%@", DOWN_PUZZLE_MATERIAL_DIR,@"PhotoWall"]

#define DOWN_PUZZLE_MATERIAL_NOTE_TEMPLATE_DIR [NSString stringWithFormat:@"%@/%@", DOWN_PUZZLE_MATERIAL_DIR,@"NoteTemplate"]

#define DOWN_PUZZLE_MATERIAL_PHOTO_SPLICE_DIR [NSString stringWithFormat:@"%@/%@", DOWN_PUZZLE_MATERIAL_DIR,@"PhotoSplice"]

#define DOWN_PUZZLE_MATERIAL_POSTCARDS_DIR [NSString stringWithFormat:@"%@/%@", DOWN_PUZZLE_MATERIAL_DIR,@"Postcards"]

#define DOWN_PUZZLE_MATERIAL_COVER_TEMPLATE_DIR [NSString stringWithFormat:@"%@/%@", DOWN_PUZZLE_MATERIAL_DIR,@"CoverTemplate"]

#define DOWN_PUZZLE_MATERIAL_VISITING_CARD_DIR [NSString stringWithFormat:@"%@/%@", DOWN_PUZZLE_MATERIAL_DIR,@"VisitingCard"]

#define PUZZLE_DRAFTS_DIR [NSString stringWithFormat:@"%@/%@",DOWN_MATERIAL_DIR, @"PuzzleDraftsDirectory"]

#define PUZZLE_VISITING_CARD_DATA_PATH [NSString stringWithFormat:@"%@/visitingCardItemDataArray.rtf",DOWN_MATERIAL_DIR]

#define PUZZLE_QRCODES_USER_IMAGE_PATH [NSString stringWithFormat:@"%@/QRCodesUserImage.png",DOWN_MATERIAL_DIR]

#define PUZZLE_MATERIAL_UPDATE_DATA_PATH [NSString stringWithFormat:@"%@/puzzleMaterialUpdateDataArray.rtf",DOWN_MATERIAL_DIR]

#define PUZZLE_SAVE_CHOOSE_TEMPLATE_VIEW_OFFSET_PATH [NSString stringWithFormat:@"%@/PuzzleSaveChooseTemplateViewOffsetPath.rtf",DOWN_MATERIAL_DIR]

#define PUZZLE_SIGNATURE_IMAGE_DIR [NSString stringWithFormat:@"%@/%@",DOWN_MATERIAL_DIR, @"PuzzleSignatureImageDirectory"]

//全局通知key

#define NOTIFICATION_REFRESH_DOWN_PUZZLE_MATERIAL_TYPE @"PuzzleUIStateNotification_"
#define NOTIFICATION_CHOOSE_PREVIEW_UIBECOME @"ChoosePreviewUIBecomeNotification"


//升级后要删除原始数据的版本号
#define UPDATA_PUZZLE_MATERIAL_VERSION_PHOTO_WALL @"1.5.9"

#define UPDATA_PUZZLE_MATERIAL_VERSION_NOTE_TEMPLATE @"1.5.9"

#define UPDATA_PUZZLE_MATERIAL_VERSION_PHOTO_SPLICE @"1.5.9"

#define UPDATA_PUZZLE_MATERIAL_VERSION_POSTCARDS @"1.5.9"

#define UPDATA_PUZZLE_MATERIAL_VERSION_COVER_TEMPLATE @"1.5.9"

#define UPDATA_PUZZLE_MATERIAL_VERSION_VISITING_CARD @"1.5.9"

#define UPDATA_UIFONT_MATERIAL_VERSION @"1.0"

//老拼图的KEY

#define TEMPLATEFILEPATH [NSString stringWithFormat:@"%@/template.rtf",DOCUMENTPATH]

#define RETURNTEMPLATEDIC [NSKeyedUnarchiver unarchiveObjectWithFile:TEMPLATEFILEPATH]

//老拼图的KEY
#define APP_CACHES_PATH             [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#pragma mark - 系统帮助宏

#define USER_DEFAULT                [NSUserDefaults standardUserDefaults]

#define NOTIFICATION_CENTER         [NSNotificationCenter defaultCenter]

#define USER_DEFAULT_ISEXISTKEY(key)   [FileOperate isExistValueOnUserDefautlForKey:key]

# define TEMPROYPATH  [FileOperate getTemporaryPath]

# define DOCUMENTPATH [FileOperate getDocumentPath]

# define CACHEPATH [FileOperate getCachePath]

#define APP_SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height

#define APP_SCREEN_CONTENT_HEIGHT   ([UIScreen mainScreen].bounds.size.height-20.0)

#define STATUS_BAR_HEIGHT               [[UIApplication sharedApplication] statusBarFrame].size.height

#define IS_480_HEIGHT_LOGICPIXEL                ((APP_SCREEN_HEIGHT - 480.0f > -0.01f) && (APP_SCREEN_HEIGHT - 480.0f < 0.01f))
#define IS_568_HEIGHT_LOGICPIXEL                ((APP_SCREEN_HEIGHT - 568.0f > -0.01f) && (APP_SCREEN_HEIGHT - 568.0f < 0.01f))
#define IS_667_HEIGHT_LOGICPIXEL                ((APP_SCREEN_HEIGHT - 667.0f > -0.01f) && (APP_SCREEN_HEIGHT - 667.0f < 0.01f))
#define IS_736_HEIGHT_LOGICPIXEL                ((APP_SCREEN_HEIGHT - 736.0f > -0.01f) && (APP_SCREEN_HEIGHT - 736.0f < 0.01f))
#define IS_1024_HEIGHT_LOGICPIXEL               ((APP_SCREEN_HEIGHT - 1024.0f > -0.01f) && (APP_SCREEN_HEIGHT - 1024.0f < 0.01f))
#define ViewRateBaseOnIP6      [UIScreen mainScreen].bounds.size.width/750.0

#define VIEW_MATERIAL_BASE_RATE               (((IS_480_HEIGHT_LOGICPIXEL)||(IS_568_HEIGHT_LOGICPIXEL)||(IS_667_HEIGHT_LOGICPIXEL)||(IS_736_HEIGHT_LOGICPIXEL))?0.5:([UIScreen mainScreen].bounds.size.width / 640.0))

#define kiPadScale (IS_IPAD?1.5:1.0)
#define IOS_VERSION_8_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
#define COLOR_RGB_255(r,g,b)        [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#if __has_feature(objc_arc)
#define STRONG strong
#else
#define STRONG retain
#endif

#define RGBCOLOR(r,g,b)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGBASTRINGCOLOR(COLORSTRING)    [UIColor colorWithRGBHexString:COLORSTRING]

#define pi 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)
#define MATERIALBASERATE 0.5
#define MATERAILZOOMINRATE 0.6








#define TheApp           ([UIApplication sharedApplication])
#define TheAppDel        ((AppDelegate*)TheApp.delegate)

#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

#pragma mark -  分享相关 宏

#define AboutDefaultShare @"【限时推荐】简拼APP - 提升照片格调、极简风格的拼图"
#define AboutDefaultShareUrl @"http://a.app.qq.com/o/simple.jsp?pkgname=cn.poco.jane"

#define TwitterShareURL  @"http://jk.poco.cn/app/jane/share.php?download=1"


#define APPSTOREID @"891640660"

#define ISBUSSINESSMODE @"testModel_business"//BOOL 是否处于测试模式

#define ISBUSSINESSVERSION @"test_bussiness_version"  //商业测试连接


#define kStatusBarTappedNotification   @"StatusBarTappedNotification"

#define kJPSUserLoginSuccessNotification @"JPSUserLoginSuccessNotification"

#define kJPSUserCloudAlbumBindPhoneToLoginViewBackActionNotification @"JPSUserCloudAlbumBindPhoneToLoginViewBackActionNotification"

#define JPSDEBUG

#ifdef JPSDEBUG
#   define JPSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define JPSLog(...)
#endif

#endif
