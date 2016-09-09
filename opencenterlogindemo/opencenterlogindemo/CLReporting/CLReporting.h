//
//  CLReporting.h
//  Corellis_iPhone_Analytics_Reporting
//
//  Created by Antoine Poupel on 04/05/09.
//  Copyright 2009 Corellis, Applications et Innovations NTIC. All rights reserved.

// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

/**
 @mainpage CiReports, Corellis iPhone for Analytics and Reporting
 
 Created by Antoine Poupel on 04/05/09.
 Copyright 2009 Corellis, Applications et Innovations NTIC. All rights reserved.
 
 CiReports is a free software which can provide statistics about your iphone or ipod applications.
 
 CiReports is designed for iphone or ipod developers that want custom reporting, audience measurements, 
 usage or device statistics, troubleshooting helper and more.
 
 Features 
 @li Precise usage statistics over a period of time (day/week/month/year)
 @li Usage Frequency: new users, regular (known) users, and how often users use your application.
 @li Geographical and language statistics: Classification by country.
 @li Technical Device Configuration Statistics: Device System, Operating System version, Orientation, etc.
 @li Learn about users interests through custom tagging and user input monitoring
 @li Collect troubleshooting data to help solve bugs such as memory warnings, exceptions… and so much more.
 
 How do I start?<br>
 1 - Sign up and register your app to get an unique app key..<br>
 2 - Download the latest CiReports archive and extract it.<br>
 3 - Adding the CiReports library reference to your own project.<br>
 4 - Adding the header search path to your own project.<br>
 5 - In your AppDelegate implementation file (.m) write the following.<br>
 @code 
 - (void)applicationDidFinishLaunching:(UIApplication *)application {
		[[CLReporting sharedInstance] registerApp:@"X-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"];
		[[CLReporting sharedInstance] startSession];  
 }
 
 - (void)applicationWillTerminate:(UIApplication *)application
 {
		[[CLReporting sharedInstance] endSession];
 }
 
// To track memory warnings, juste paste this code
 - (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
 {
		[[CLReporting sharedInstance] addMemoryWarning];
 }
 @endcode

 6-Build and run and you are done!
 
 @see http://forge.corellis.eu/iphone_reports/ 
 
 
 
 */

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CFNetwork/CFHTTPStream.h>
#import <CFNetwork/CFSocketStream.h>
#import <CFNetwork/CFHTTPMessage.h>

__attribute__((used)) static NSString *offLineReportServiceURL = @"http://phtjp.poco.cn/phone_tj_post.php";
__attribute__((used)) static NSString *kCiReportServiceURL = @"http://phtj.poco.cn/phone_tj.php";
__attribute__((used)) static NSString *kCiReportServiceHost = @"phtjp.poco.cn";

__attribute__((used)) static NSString *offLineReportServiceURL_WIFI = @"http://phtjp.poco.cn/phone_tj_post.php";
__attribute__((used)) static NSString *kCiReportServiceURL_WIFI = @"http://phtj.poco.cn/phone_tj.php";
__attribute__((used)) static NSString *kCiReportServiceHost_WIFI = @"phtjp.poco.cn";

@class CLLocation;
#ifndef PUZZLE_APP
//@class BS_base_class;
#endif
/**
 @brief The Reporting Controller
 */
@interface CLReporting : NSObject{
	NSString*			uniqueIdentifier;
	NSString*           uniqueIdentifierChonying;
	NSString*			appKey;
	NSString*			currentLocale;
	NSString*			currentSystemName;
	NSString*			currentSystemVersion;
	NSString*			currentModel;
	NSString*			currentScreen;
    NSString*			bundleVersion;
	int					currentOrientation;
	float				currentBatteryLevel;
	int					currentBatteryState;
	NSString*           platformString;
	int                 writefilenum;//计算触发多少次统计，满十次写入磁盘
    NSMutableString*           writefilestring;//计算触发多少次统计，满十次写入磁盘
    NSString*           rmid;   //来源模版id 用于yueyue的模版统计
    NSString *          did;    //广告id
    NSString *          uid;    //用户id
}


@property (retain) NSString*           platformString;
@property (retain) NSString*			uniqueIdentifier;
@property (retain) NSString*            uniqueIdentifierChonying;
@property (retain) NSString*			appKey;
@property (retain) NSString*			currentLocale;
@property (retain) NSString*			currentSystemName;
@property (retain) NSString*			currentSystemVersion;
@property (retain) NSString*			currentModel;
@property (retain) NSString*			bundleVersion;
@property (retain) NSString*			currentScreen;
@property (assign) int			writefilenum;
@property (retain) NSMutableString*			writefilestring;
@property (atomic, retain)    NSString *rmid;
@property (atomic ,retain)    NSString *did;
@property (atomic, retain)    NSString * uid;
+ (CLReporting *)sharedInstance;

/** Registers app with App Key. Generate your appKey at  http://forge.corellis.eu/iphone_reports/ */
- (void)registerApp:(NSString*) appKey;
/** Starts session */
- (void)startSession;
/** Ends session */
- (void)endSession;
/** Reports a tag  */
- (void)reportTag:(NSString*) aTag;
/** Reports a user input (like a search)  */
- (void)reportUserInput:(NSString*) anUserInput;
/** Reports a location (like user location)  */
- (void)reportUserLocation:(CLLocation *)alocation;
/** Reports device orientation  */
- (void)reportDeviceOrientation;
/** Reports a memory warning  */
- (void)reportMemoryWarning;
/** Reports an exception  */
- (void)reportException:(NSException*)exception;
/** Opens the resource at the specified URL and report it  */
- (void)openURL:(NSURL *)url;
-(void)resetUniqueIdentifierChonying;
/** Reports user event  */
- (void)reportEvents;
- (void)pushEvent:(int)eventId paraString:(NSString *)str;
- (void)pushEvent:(int)eventId paraDictionary:(NSDictionary *)paras;
- (void)pushEventNoAppId:(int)eventId paraString:(NSString *)str;
- (void)reportStartInfo;
- (NSString *)getWritableFilename;
- (NSArray *)getReportingFiles;
- (int)getFilesizeAtItemPath:(NSString *)itemPath;
- (void)removeEventFileAtItemPath:(NSString *)itemPath;
- (void)reportMemoryWarningInfo:(NSString *)warn;
-(NSString*) _createUUID;
- (NSString *)getCurrentTime;

//for yueyue
//- (void)pushClick:(id)pobject
//              mid:(NSString *)mid
//              did:(NSString *)pdid
//              vid:(NSString *)vid
//              jid:(NSString *)jid
//           remark:(NSString *)rm;

////统计
//- (void)pushStatisticsWithPageId:(NSString *)page_id
//                   mid:(NSString *)mid
//                  dmid:(NSString *)dmid
//                userid:(NSString *)userid
//                   vid:(NSString *)vid
//                   jid:(NSString *)jid
//                remark:(NSString *)rm;
//新统计
- (void)pushStatisticsWithPageId:(NSString *)page_id
                             mid:(NSString *)mid
                            dmid:(NSString *)dmid
                          userid:(NSString *)userid
                             vid:(NSString *)vid
                             jid:(NSString *)jid
                          remark:(NSString *)rm
                            rmid:(NSString*)rmid;
@end
