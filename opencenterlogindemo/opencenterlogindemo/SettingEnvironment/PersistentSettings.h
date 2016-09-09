//
//  PersistentSettings.h
//  MYProject
//
//  Created by apple on 14-4-22.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

/////单列，用于添加永久记忆和具有默认值的变量
//@interface PersistentSettings : NSObject {
//
//}
//+ (PersistentSettings *)sharedPersistentSettings;
//@property(nonatomic,assign) BOOL isAutoAddDate;
//@property(nonatomic,assign) BOOL isShowSetFontView;
//@property(nonatomic,assign) BOOL isShowPhotoSpliceSliderAnimate;
//@property(nonatomic,assign) NSInteger originImageLength;
//@property(nonatomic,assign) NSString *saveOldVersions;
//@property(nonatomic,assign) BOOL isShowEffectButtonAnimat;
//@property(nonatomic,assign) NSString *saveHeadImageName;
//@property(nonatomic,assign) BOOL isAutoFilter;
//@property(nonatomic,assign) BOOL isTestBusinessMode;
//@property(nonatomic,assign) BOOL isNeedShowCallBeautyCameraTip;
//@property(nonatomic,assign) BOOL isNeesShowVipMemberTip;
///单列，用于添加永久记忆和具有默认值的变量
@interface PersistentSettings : NSObject {
    
}
+ (PersistentSettings *)sharedPersistentSettings;
@property(nonatomic,assign) BOOL isAutoAddDate;
@property(nonatomic,assign) BOOL isShowSetFontView;
@property(nonatomic,assign) BOOL isShowPhotoSpliceSliderAnimate;
@property(nonatomic,assign) NSInteger originImageLength;
@property(nonatomic,assign) NSString *saveOldVersions;
@property(nonatomic,assign) BOOL isShowEffectButtonAnimat;
@property(nonatomic,assign) NSString *saveHeadImageName;
@property(nonatomic,assign) BOOL isAutoFilter;
@property(nonatomic,assign) BOOL isTestBusinessMode;
@property(nonatomic,assign) BOOL isNeedShowCallBeautyCameraTip;
@property(nonatomic,assign) BOOL isNeesShowVipMemberTip;
@property(nonatomic,assign) BOOL isApiTestMode;
@property(nonatomic,assign) BOOL isAutoRemoveWaterMark;
@property(nonatomic,assign) BOOL isFirstInstall;

@end
