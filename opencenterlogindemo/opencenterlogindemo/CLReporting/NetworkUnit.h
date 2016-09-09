//
//  NetworkUnit.h
//  PocoCamera2
//
//  Created by Chengl on 11-7-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
//#import "JRLog.h"

#define URL_POCO_WIFI @"http://img-wifi2.poco.cn/mypoco/mtmpfile/MobileAPI"
#define URL_POCO_NO_WIFI @"http://img-m.poco.cn/mypoco/mtmpfile/MobileAPI"

#define URL_POCO_BABY_WIFI @"http://img-wifi.poco.cn/mypoco/mtmpfile/MobileAPI"
#define URL_POCO_BABY_NO_WIFI @"http://img-m.poco.cn/mypoco/mtmpfile/MobileAPI"

#define URL_POCO_WIFI_HEAD @"http://img-wifi.poco.cn/mypoco/mtmpfile/API"
#define URL_POCO_NO_WIFI_HEAD @"http://img-m.poco.cn/mypoco/mtmpfile/API"

#define URL_POCO_WIFI_UP @"http://img-wifiup.poco.cn/mypoco/mtmpfile/MobileAPI"
#define URL_POCO_NO_WIFI_UP @"http://img-mup.poco.cn/mypoco/mtmpfile/MobileAPI"

//轻应用
#define URL_POCO_WIFI_UP_light @"http://img-wifi-l-up.poco.cn/mypoco/mtmpfile/MobileAPI"
#define URL_POCO_NO_WIFI_UP_light @"http://img-m-l-up.poco.cn/mypoco/mtmpfile/MobileAPI"

#define URL_TOPIC_CALLBACK_WIFI @"http://img-wifi.poco.cn/mypoco/mtmpfile/API/share_agent/callback_keywords.php"
#define URL_TOPIC_CALLBACK_NO_WIFI @"http://img-m.poco.cn/mypoco/mtmpfile/API/share_agent/callback_keywords.php"

#define URL_SHARE_KEYWORD_LIST_WIFI @"http://img-wifi.poco.cn/mypoco/mtmpfile/API/poco_camera/get_share_keyword_list_iphone.php"
#define URL_SHARE_KEYWORD_LIST_NO_WIFI @"http://img-m.poco.cn/mypoco/mtmpfile/API/poco_camera/get_share_keyword_list_iphone.php"


#define safe_release(obj) if(obj != nil && obj !=NULL){ \
[obj release]; \
obj = nil;\
}

//#define DOCUMENTDIR [NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES) objectAtIndex:0]]
//#define DOCUMENTDIR NSTemporaryDirectory()
#define DOCUMENTDIR [NSString stringWithFormat:@"%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
#define APP_CACHE_DIR [NSString stringWithFormat:@"%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
@interface NetworkUnit : NSObject {
	Reachability *wifiReach;
	Reachability *hostReach;
}

@property (nonatomic, retain) Reachability *wifiReach;
@property (nonatomic, retain) Reachability *hostReach;
@property (nonatomic, retain) Reachability *internetReach;
+ (NetworkUnit *)sharedInstance;
- (void) initStatus;
- (void) reachabilityChanged: (NSNotification* )note;
- (BOOL) isWifiEnable;
- (BOOL) isNetworkDisable;
-(void)restartNotififier;
@end
