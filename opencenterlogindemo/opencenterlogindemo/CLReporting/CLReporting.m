//
//  CLReporting.m
//  Corellis_iPhone_Analytics_Reporting
//
//  Created by Antoine Poupel on 04/05/09.
//  Copyright 2009 Corellis, Applications et Innovations NTIC. All rights reserved.
//

#import "CLReporting.h"
//#import "JRLog.h"
#import "ASIFormDataRequest.h"
#include <execinfo.h>
#import "NetworkUnit.h"
#import "SFHFKeychainUtils.h"
#import <mach/mach.h> 
#include <stdlib.h>
#import "UIDevice-Hardware.h"
#import <AdSupport/ASIdentifierManager.h>
#define MIME_BOUNDARY "----16c17a9ea1d7b327e7489190e394d411----"
#define CONTENT_TYPE "multipart/form-data; boundary=" MIME_BOUNDARY
#define KEYCHAIN_SERVICE_NAME @"POCO_SERVICE"
#define INDIVIDUAL_CHONGYING_KEY @"individual_chongying_key_info"
@interface CLReporting (Private)
- (void)_pushData:(NSString*) commandString;
- (void)_pushDataThread:(NSString*) commandString;
- (void)_postData:(NSDictionary*) params;
- (void)_postDataThread:(NSDictionary*) params;
-(void)_initDevice;
-(void)_updateDevice;
- (NSString *)decodedExceptionStackTrace:(NSException *)exception;
- (NSString *)decodedStackTraceFromReturnAddresses:(NSException *)exception;

- (void)_initAppStartTime;
- (void)_initAppUsedTimes;
@end

void exceptionHandler(NSException *exception) {
//	NSLog(@"%@", [[CLReporting sharedInstance] decodedExceptionStackTrace:exception]);
	[[CLReporting sharedInstance] reportException:exception];
}


// This is a singleton class, see below

static CLReporting *_sharedInstance = nil;
@implementation CLReporting
@synthesize writefilenum;
@synthesize writefilestring;
@synthesize uniqueIdentifier, appKey, currentLocale, currentSystemName, currentSystemVersion, currentModel, bundleVersion,currentScreen;
@synthesize platformString;
@synthesize uniqueIdentifierChonying;
@synthesize  rmid;
@synthesize  did;
@synthesize uid;

+ (CLReporting *)sharedInstance
{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (_sharedInstance == nil) {
            _sharedInstance = [[[CLReporting alloc] init] retain];
            _sharedInstance.writefilenum = 0;
            NSMutableString *tmp = [[NSMutableString alloc]init];
            _sharedInstance.writefilestring = tmp;
            [tmp release];
            [_sharedInstance _initDevice];
        }
    });

    
    return _sharedInstance;
}

- (void)registerApp:(NSString*) anAppKey
{
	appKey = anAppKey;
	[self _initDevice];	
	
	[self _initAppStartTime];	///时间
	[self _initAppUsedTimes];	///次数
	
//	[self _pushData:[NSString stringWithFormat:@"type=registerApp&anAppKey=%@", anAppKey]];
}

//启动时间
- (void)_initAppStartTime
{
	if (![[NSUserDefaults standardUserDefaults] objectForKey:@"app-start-time"]) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"app-start-time"];
	}
	NSUInteger time = (NSUInteger)[[NSDate date] timeIntervalSince1970];
	NSNumber *num = [NSNumber numberWithInt:time];
	[[NSUserDefaults standardUserDefaults] setObject:num forKey:@"app-start-time"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

//计算次数
- (void)_initAppUsedTimes
{
    NSString *usedtimes=[SFHFKeychainUtils getPasswordForUsername:@"POCO_USEDTIMES" andServiceName:KEYCHAIN_SERVICE_NAME error:NULL];
    NSLog(@"key chain used times:%@",usedtimes);
    if (usedtimes) {
        int times = [usedtimes intValue];
        times ++;
        NSString *s_time=[NSString stringWithFormat:@"%d", times];
        [SFHFKeychainUtils storeUsername:@"POCO_USEDTIMES" andPassword:s_time forServiceName:KEYCHAIN_SERVICE_NAME updateExisting:YES error:nil];
    }else {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"app-used-times"]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"app-used-times"];
        }
        int times = [[[NSUserDefaults standardUserDefaults] objectForKey:@"app-used-times"] intValue] +1;
        NSString *s_time=[NSString stringWithFormat:@"%d",times];
        [SFHFKeychainUtils storeUsername:@"POCO_USEDTIMES" andPassword:s_time forServiceName:KEYCHAIN_SERVICE_NAME updateExisting:YES error:nil];
    }
    /*
	if (![[NSUserDefaults standardUserDefaults] objectForKey:@"app-used-times"]) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"app-used-times"];
	}
	int times = [[[NSUserDefaults standardUserDefaults] objectForKey:@"app-used-times"] intValue] +1;
	NSNumber *num = [NSNumber numberWithInt:times];
	[[NSUserDefaults standardUserDefaults] setObject:num forKey:@"app-used-times"];
	[[NSUserDefaults standardUserDefaults] synchronize];*/
}

- (void)startSession
{
	[self _updateDevice];
	[self _pushData:[NSString stringWithFormat:@"type=startSession&appKey=%@&bundleVersion=%@&uniqueIdentifier=%@&currentLocale=%@&currentSystemName=%@&currentSystemVersion=%@&currentModel=%@&currentOrientation=%d", appKey, bundleVersion, uniqueIdentifier, currentLocale, currentSystemName, currentSystemVersion, currentModel, currentOrientation]];
}

- (void)endSession
{
	// synchro with main thread because call are done in applicationWillTerminate
	[self _pushDataThread:[NSString stringWithFormat:@"type=endSession&appKey=%@&uniqueIdentifier=%@", appKey, uniqueIdentifier]];
}

- (void)reportMemoryWarning
{
	[self _pushData:[NSString stringWithFormat:@"type=addMemoryWarning&=%@&=%@&=%@&=%@&=%@&=%@&=%@&=%d", appKey, bundleVersion, uniqueIdentifier, currentLocale, currentSystemName, currentSystemVersion, currentModel, currentOrientation]];
}

- (void)reportTag:(NSString*) aTag
{
	[self _pushData:[NSString stringWithFormat:@"type=addTag&appKey=%@&bundleVersion=%@&uniqueIdentifier=%@&tag=%@", appKey, bundleVersion, uniqueIdentifier, aTag]];	
}

- (void)reportUserInput:(NSString*) anUserInput
{
	[self _pushData:[NSString stringWithFormat:@"type=addUserInput&appKey=%@&bundleVersion=%@&uniqueIdentifier=%@&input=%@", appKey, bundleVersion, uniqueIdentifier, anUserInput]];		
}
/*
- (void)reportUserLocation:(CLLocation *)alocation
{
	if( alocation==nil)
		return;
	
	// Reverse geocode, detecte nearest city -> send city coordinate
	MKReverseGeocoder *reverse = [[MKReverseGeocoder alloc] initWithCoordinate:alocation.coordinate];
	[reverse setDelegate:self];
	[reverse start];
	
}
 */

- (void)reportDeviceOrientation
{
	[self _updateDevice];
	[self _pushData:[NSString stringWithFormat:@"type=addDeviceOrientation&appKey=%@&bundleVersion=%@&uniqueIdentifier=%@&currentOrientation=%d", appKey, bundleVersion, uniqueIdentifier, currentOrientation]];		
}

- (void)reportException:(NSException*)exception
{
	@try {
		NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys: 
		     [[NSString alloc] initWithFormat:@"addException&=%@&=%@&=%@&=%@&=%@&=%@&=%@&=%@&=%@&=%d", appKey, bundleVersion,  uniqueIdentifier, [exception name], [exception description], currentLocale, currentSystemName, currentSystemVersion, currentModel, currentOrientation], @"url", 
			 [self decodedExceptionStackTrace:exception], @"stacktrace", nil];
        NSLog(@"exception:%@",params);
		[self _postDataThread:params];
        
	}@catch (NSException * e) {
		// ignore this one
	}
}

- (void)openURL:(NSURL *)url
{
	[self _pushData:[NSString stringWithFormat:@"addURL&=%@&=%@&=%@&=%@", appKey, bundleVersion, uniqueIdentifier, [url absoluteString]]];	
}

-(NSString*) _createUUID
{
	CFUUIDRef uuidRef = CFUUIDCreate(NULL);
	CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
	CFRelease(uuidRef);
	NSString *aa=NSMakeCollectable(uuidStringRef);
	//CFRelease(uuidStringRef);
	NSString *ret_str=[[NSString alloc]initWithString:aa];
	[aa release];
	return [ret_str autorelease]; 
}

- (NSString *)getCurrentTime{
	NSDateFormatter *inputFormat = [[[NSDateFormatter alloc] init] autorelease];
	NSLocale *local_EN = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
	[inputFormat setLocale:local_EN];
	[inputFormat setDateFormat:@"yyyyMMddHHmmss"];//dd MMM yyyy HH:mm:ss
	NSDate *nowDate = [NSDate date];
	NSString *nowDateStr = [inputFormat stringFromDate:nowDate];
	return nowDateStr;
}

-(BOOL)_isValidUUId:(NSString *)uuidString
{
    int len=[uuidString length];
    if (len<10) {
        return FALSE;
    }
    if ([[uuidString substringWithRange:NSMakeRange(len-10-1, 10)] isEqualToString:@"0000000000"]) {
        return FALSE;
    }
    if ([[uuidString substringWithRange:NSMakeRange(len-9-1, 9)] isEqualToString:@"111111111"]) {
        return FALSE;
    }
    return TRUE;
}

- (NSString *)self_create_uuid {
    NSMutableString *t_uuid = [NSMutableString stringWithFormat:@""];
    int num_count[5] = {8, 4, 4, 4, 12};
    char key[36] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
    
    for(int i = 0; i < 5; i++) {
        if(i != 0)
            [t_uuid appendString:@"-"];
        
        for(int j = 0; j < num_count[i]; j++) {
            [t_uuid appendFormat:@"%c", key[arc4random() % 36]];
        }
    }
    
    return t_uuid;
}

-(void)_initDevice
{
	//NSSetUncaughtExceptionHandler(&exceptionHandler);
    @synchronized(self){
        NSUserDefaults *stand = [NSUserDefaults standardUserDefaults];
        NSDictionary* infoDic = [[NSBundle mainBundle] infoDictionary];
        [self setBundleVersion:[infoDic objectForKey:@"tj_version"]];
        //self bundleVersion = [infoDic objectForKey:@"tj_version"];
         NSString *serviceName = KEYCHAIN_SERVICE_NAME;
        @try {
            do {
                 NSString *uuidStr=[SFHFKeychainUtils getPasswordForUsername:@"POCO_UUID" andServiceName:serviceName error:NULL];
                NSString *uuidStr2=[SFHFKeychainUtils getPasswordForUsername:@"POCO_UUID_CHONGYING" andServiceName:serviceName error:NULL];
                if (uuidStr2 && [uuidStr2 length]>0 && [self _isValidUUId:uuidStr2]) {
                    [self setUniqueIdentifierChonying:uuidStr2];
                }
                if (uuidStr && [uuidStr length]>0 && [self _isValidUUId:uuidStr]) {
                    [self setUniqueIdentifier:uuidStr];
                    if (self.uniqueIdentifierChonying==nil ||[self.uniqueIdentifierChonying length]<=1) {
                        NSString *str_tmp2=[[NSString alloc] initWithFormat:@"%@%ld-%@", [self getCurrentTime],random()%1000000,uuidStr];
                        [self setUniqueIdentifierChonying:str_tmp2];
                        if (self.uniqueIdentifierChonying&& [[self uniqueIdentifierChonying] length]>0) {
                            [SFHFKeychainUtils storeUsername:@"POCO_UUID_CHONGYING" andPassword:self.uniqueIdentifierChonying forServiceName:serviceName updateExisting:YES error:nil];
                        }
                        [str_tmp2 release];
                    }
                    
                    break;
                }
    //            NSUUID *uuid=[[ASIdentifierManager sharedManager] advertisingIdentifier];
    //            NSString *str_tmp=[[NSString alloc] initWithFormat:@"%@%ld-%@", [self getCurrentTime],random()%1000000,[uuid UUIDString]];
    //            [self setUniqueIdentifier:str_tmp];
    //            [self setUniqueIdentifierChonying:str_tmp];
    //            [str_tmp release];
    //            if (self.uniqueIdentifier && [[self uniqueIdentifier] length]>0) {
    //                [SFHFKeychainUtils storeUsername:@"POCO_UUID" andPassword:self.uniqueIdentifier forServiceName:serviceName updateExisting:YES error:nil];
    //            }
    //            if (self.uniqueIdentifierChonying&& [[self uniqueIdentifierChonying] length]>0) {
    //                [SFHFKeychainUtils storeUsername:@"POCO_UUID_CHONGYING" andPassword:self.uniqueIdentifierChonying forServiceName:serviceName updateExisting:YES error:nil];
    //            }
            } while (FALSE);
            
        }
        @catch (NSException *exception) {
            NSLog(@"_initDevice fail!");
        }

        //[self setUniqueIdentifier:[NSString stringWithString:[[UIDevice currentDevice] identifierForVendor]]];
        //self.uniqueIdentifier = [NSString stringWithString:[[UIDevice currentDevice] uniqueIdentifier]];
        //NSLog(@"clreporting [UIDevice currentDevice] uniqueIdentifier] :%@",self.uniqueIdentifier);
        if ([self uniqueIdentifier]==nil ||[[self uniqueIdentifier] length]<=0 || ![self _isValidUUId:[self uniqueIdentifier]]) {
            NSString *uuid=[SFHFKeychainUtils getPasswordForUsername:@"POCO_UUID" andServiceName:serviceName error:NULL];
            
            if (uuid && [self _isValidUUId:uuid]) {
    //            NSLog(@"clreporting use exist uuid:%@",uuid);
                [self setUniqueIdentifier:uuid];
                NSString *str_tmp2=[[NSString alloc] initWithFormat:@"%@%ld-%@", [self getCurrentTime],random()%1000000,self.uniqueIdentifier];
                [self setUniqueIdentifierChonying:str_tmp2];
                if (self.uniqueIdentifierChonying&& [[self uniqueIdentifierChonying] length]>0) {
                    [SFHFKeychainUtils storeUsername:@"POCO_UUID_CHONGYING" andPassword:self.uniqueIdentifierChonying forServiceName:serviceName updateExisting:YES error:nil];
                }
                [str_tmp2 release];
                //self.uniqueIdentifier = uuid;
            }else {
                self.uniqueIdentifier = [self _createUUID];
    //            NSLog(@"clreporting use new uuid:%@",[self uniqueIdentifier]);
                [SFHFKeychainUtils storeUsername:@"POCO_UUID" andPassword:self.uniqueIdentifier forServiceName:serviceName updateExisting:YES error:nil];
                NSString *str_tmp2=[[NSString alloc] initWithFormat:@"%@%ld-%@", [self getCurrentTime],random()%1000000,self.uniqueIdentifier];
                [self setUniqueIdentifierChonying:str_tmp2];
                if (self.uniqueIdentifierChonying&& [[self uniqueIdentifierChonying] length]>0) {
                    [SFHFKeychainUtils storeUsername:@"POCO_UUID_CHONGYING" andPassword:self.uniqueIdentifierChonying forServiceName:serviceName updateExisting:YES error:nil];
                }
                [str_tmp2 release];

            }
        }
        
        NSLog(@"%@", [self self_create_uuid]);
        if ([self uniqueIdentifierChonying]==nil ||[[self uniqueIdentifierChonying] length]<=0 || ![self _isValidUUId:[self uniqueIdentifierChonying]]){
            NSString *str_tmp2=[[NSString alloc] initWithFormat:@"%@%ld-%@", [self getCurrentTime],random()%1000000,[self _createUUID]];
            [self setUniqueIdentifierChonying:str_tmp2];
            if (self.uniqueIdentifierChonying&& [[self uniqueIdentifierChonying] length]>0) {
                [SFHFKeychainUtils storeUsername:@"POCO_UUID_CHONGYING" andPassword:self.uniqueIdentifierChonying forServiceName:serviceName updateExisting:YES error:nil];
            }
            [str_tmp2 release];
        }
        
        if([stand objectForKey:INDIVIDUAL_CHONGYING_KEY]) {
            self.uniqueIdentifierChonying = [stand objectForKey:INDIVIDUAL_CHONGYING_KEY];
        }else {
            if(self.uniqueIdentifierChonying == nil) {
                NSString *uuid = [self _createUUID];
                
                if(uuid)
                    self.uniqueIdentifierChonying = [[[NSString alloc] initWithFormat:@"%@%ld-%@", [self getCurrentTime],random()%1000000, uuid] autorelease];
                else
                    self.uniqueIdentifierChonying = [[[NSString alloc] initWithFormat:@"%@%ld-%@", [self getCurrentTime],random()%1000000, [self self_create_uuid]] autorelease];
                
                [SFHFKeychainUtils storeUsername:@"POCO_UUID_CHONGYING" andPassword:self.uniqueIdentifierChonying forServiceName:serviceName updateExisting:YES error:nil];
            }
            
            [stand setObject:self.uniqueIdentifierChonying forKey:INDIVIDUAL_CHONGYING_KEY];
            [stand synchronize];
        }
        
        self.currentLocale = [[NSLocale currentLocale] localeIdentifier];
        self.currentSystemName = [NSString stringWithString:[[UIDevice currentDevice] systemName]];
        self.currentSystemVersion =  [NSString stringWithString:[[UIDevice currentDevice] systemVersion]];
        self.currentModel =  [NSString stringWithString:[[UIDevice currentDevice] model]];
        
        CGRect screen = [[UIScreen mainScreen] bounds];
        self.currentScreen = [NSString stringWithFormat:@"%d*%d",(int)screen.size.width,(int)screen.size.height];
        self.platformString = [[UIDevice currentDevice] platformString];
        [self _updateDevice];
    }
}

-(void)resetUniqueIdentifierChonying
{
    NSString *serviceName = KEYCHAIN_SERVICE_NAME;
    NSString *str_tmp2=[[NSString alloc] initWithFormat:@"%@%ld-%@", [self getCurrentTime],random()%1000000,[self _createUUID]];
    [self setUniqueIdentifierChonying:str_tmp2];
    if (self.uniqueIdentifierChonying&& [[self uniqueIdentifierChonying] length]>0) {
        [SFHFKeychainUtils storeUsername:@"POCO_UUID_CHONGYING" andPassword:self.uniqueIdentifierChonying forServiceName:serviceName updateExisting:YES error:nil];
    }
    [str_tmp2 release];
}

-(void)_updateDevice
{
	currentOrientation =  [[UIDevice currentDevice] orientation];
	
	/* v3.0 */
	//currentBatteryLevel =  [[UIDevice currentDevice] batteryLevel];
	//currentBatteryState =  [[UIDevice currentDevice] batteryState];
}

- (void)_initScreen
{
	CGRect screen = [[UIScreen mainScreen] bounds];
	self.currentScreen = [NSString stringWithFormat:@"%f*%f",screen.size.width,screen.size.height];
}

- (void)_pushData:(NSString*) commandString
{
	[NSThread detachNewThreadSelector:@selector(_pushDataThread:) toTarget:self withObject:commandString];
    [NSThread detachNewThreadSelector:@selector(_pushDataThread2:) toTarget:self withObject:commandString];
}

-(void)_pushDataThread2:(NSString*) commandString
{
    @try {
#ifdef USEPOSTTHREAD2


    
        NSAutoreleasePool *subPool = [[NSAutoreleasePool alloc] init];
        NSString *tjUrlStr = [BS_base_class getADCommonURL];
        if (tjUrlStr) {
            NSURL *tjurl = [[NSURL alloc] initWithString:tjUrlStr];
            
            NSString *returnString = [[NSString alloc] initWithContentsOfURL:tjurl];
            [returnString release];
            [tjurl release];
        }
        [subPool release];

#endif
    }
    @catch (NSException *exception) {
        
    }
    
		
    
}

-(void)_pushDataThread:(NSString*) commandString
{
	NSLog(@"_pushDataThread %@", commandString);
//	return ;
	@try {
		
		NSAutoreleasePool *subPool = [[NSAutoreleasePool alloc] init];
		
		NSString *urlString =  nil;
		if ([[NetworkUnit sharedInstance] isWifiEnable]) {
			urlString = [[NSString stringWithFormat:
						  @"%@?%@", 
						  kCiReportServiceURL_WIFI,
						  commandString]
						 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		}else {
			urlString = [[NSString stringWithFormat:
			  @"%@?%@", 
			  kCiReportServiceURL,
			  commandString]
			 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		}

		
//		NSLog(@"CIReports reports with URL : %@", urlString);
		NSURL *url = [[NSURL alloc] initWithString:urlString];
		NSString *returnString = [[NSString alloc] initWithContentsOfURL:url];	
//		if (returnString != nil && [returnString length] >0) 
//		{
//			NSLog(@"return: %@", returnString);
//		}
		[returnString release];
		[url release];
        //@try {
            
        //}
        //@catch (NSException * e) {
        //}
		[subPool release];
	}
	@catch (NSException * e) {
		// ignore this one	
	}
}

- (void)_postData:(NSDictionary*) params
{
	[NSThread detachNewThreadSelector:@selector(_postDataThread:) toTarget:self withObject:params];
}


- (void)_postDataThread:(NSDictionary*) params
{	
	@try {	
		NSAutoreleasePool *subPool = [[NSAutoreleasePool alloc] init];
		
		NSString *urlString =  [[NSString stringWithFormat:@"%@?%@", 
								 kCiReportServiceURL,
								 [params objectForKey:@"url"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		NSMutableDictionary* paramsCopy = [NSMutableDictionary dictionaryWithDictionary:params];	
		[paramsCopy removeObjectForKey:@"url"];	
		
		NSMutableData *body = [[NSMutableData alloc] initWithLength: 0];
		[body appendData: [[[[NSString alloc] initWithFormat: @"--%@\r\n", @MIME_BOUNDARY] autorelease] dataUsingEncoding: NSUTF8StringEncoding]];
		
		id key = nil;
		NSEnumerator *enumerator = [paramsCopy keyEnumerator];
		while(key = [enumerator nextObject]) {
			id val = [paramsCopy objectForKey: key];
			id keyHeader = nil;
			
			keyHeader = [NSString stringWithFormat: @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
			[body appendData: [keyHeader dataUsingEncoding: NSUTF8StringEncoding]];
			[body appendData: [val dataUsingEncoding: NSUTF8StringEncoding]];
			[body appendData: [[NSString stringWithFormat: @"\r\n--%@\r\n", @MIME_BOUNDARY] dataUsingEncoding: NSUTF8StringEncoding]];
		}	
		
		[body appendData: [@"--\r\n" dataUsingEncoding: NSUTF8StringEncoding]];
		long bodyLength = [body length];
		
		CFURLRef uploadURL = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef) urlString, NULL);
		CFHTTPMessageRef _request = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), uploadURL, kCFHTTPVersion1_1);
		CFRelease(uploadURL);
		uploadURL = NULL;
		
		CFHTTPMessageSetHeaderFieldValue(_request, CFSTR("Content-Type"), CFSTR(CONTENT_TYPE));
		if ([[NetworkUnit sharedInstance]isWifiEnable]) {
			CFHTTPMessageSetHeaderFieldValue(_request, CFSTR("Host"), (CFStringRef) kCiReportServiceHost);
		}else {
			CFHTTPMessageSetHeaderFieldValue(_request, CFSTR("Host"), (CFStringRef) kCiReportServiceHost_WIFI);
		}

		
		CFHTTPMessageSetHeaderFieldValue(_request, CFSTR("Content-Length"), (CFStringRef)[NSString stringWithFormat: @"%ld", bodyLength]);
		CFHTTPMessageSetBody(_request, (CFDataRef)body);
		[body release];
		
		CFReadStreamRef _readStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, _request);
		CFReadStreamOpen(_readStream);
		
		CFIndex numBytesRead;
		long bytesWritten, previousBytesWritten = 0;
		UInt8 buf[1024];
		BOOL doneUploading = NO;
		
		while (!doneUploading) {
			CFNumberRef cfSize = CFReadStreamCopyProperty(_readStream, kCFStreamPropertyHTTPRequestBytesWrittenCount);
			CFNumberGetValue(cfSize, kCFNumberLongType, &bytesWritten);
			CFRelease(cfSize);
			cfSize = NULL;
			if (bytesWritten > previousBytesWritten) {
				previousBytesWritten = bytesWritten;
			}
			
			if (!CFReadStreamHasBytesAvailable(_readStream)) {
				//usleep(3200);
				[NSThread sleepForTimeInterval:3200];
				continue;
			}
			
			numBytesRead = CFReadStreamRead(_readStream, buf, 1024);
			fprintf(stderr, "%s", buf);
			fflush(stderr);
			
			if (CFReadStreamGetStatus(_readStream) == kCFStreamStatusAtEnd) doneUploading = YES;
		}
		CFHTTPMessageRef _responseHeaderRef = (CFHTTPMessageRef)CFReadStreamCopyProperty(_readStream, kCFStreamPropertyHTTPResponseHeader);
		CFRelease(_responseHeaderRef);
		_responseHeaderRef = NULL;
		
		CFReadStreamClose(_readStream);
		CFRelease(_request);
		_request = NULL;
		CFRelease(_readStream);
		_readStream = NULL;
		
		[subPool release];
	}
	@catch (NSException * e) {
		// ignore this one		
	}
	return;
}



-(void) dealloc
{
	[bundleVersion release];	
	[uniqueIdentifier release];	
	[appKey release];
	[currentLocale release];
	[currentSystemName release];
	[currentSystemVersion release];
	[currentModel release];
	[currentScreen release];
	[super dealloc];
}

- (NSString *)decodedExceptionStackTrace:(NSException *)exception {
	NSString *trace = nil;
	if (!trace) { trace = [self decodedStackTraceFromReturnAddresses:exception]; }
	return trace;
}

- (NSString *)decodedStackTraceFromReturnAddresses:(NSException *)exception {
	
	int i = 0;
	int count = [[exception callStackReturnAddresses] count];
	void *frames[count];
	
	// build frame pointers
	NSEnumerator *addresses = [[exception callStackReturnAddresses] objectEnumerator];
	NSNumber *address;
	while (address = [addresses nextObject]) {
		frames[i++] = (void *)[address unsignedIntegerValue];
	}
	
	// Get symbols for the backtrace addresses
	char **frameStrings = backtrace_symbols(frames, count);
	
	NSMutableString *backtrace = [NSMutableString string];
	
	if (frameStrings) {
		for(i = 0; i < count; i++) {
			if(frameStrings[i]) {
				[backtrace appendFormat:@"%s\n", frameStrings[i]];
			}
		}
	}
	
	return backtrace;
}

- (void)reportStartInfo
{
	//使用时间
	NSUInteger initTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"app-start-time"] intValue];
	NSUInteger endTime = (NSUInteger)[[NSDate date] timeIntervalSince1970];
	NSUInteger run_interval = endTime - initTime;
//	NSLog(@"run_interval %d - %d = %d", endTime, initTime, run_interval);
	
	//使用次数	
	int run_num = 1;
    NSString *usedtimes=[SFHFKeychainUtils getPasswordForUsername:@"POCO_USEDTIMES" andServiceName:KEYCHAIN_SERVICE_NAME error:NULL];
    if (usedtimes) {
        run_num = [usedtimes intValue];
    }
    NSLog(@"reportStartInfo usedtimes:%d",run_num);
//	NSLog(@"run_num %d", run_interval);
	
	[self _pushData:[NSString stringWithFormat:@"tj_ver=2&sub_type=env&client_ver=%@&client_id=%@&uid=%@&os=%@&os_ver=%@&screen=%@&run_interval=%d&run_num=%d&phone_type=%@", 
					 self.bundleVersion, 
					 self.appKey, 
					 self.uniqueIdentifier,
					 currentSystemName, 
					 currentSystemVersion,
					 currentScreen,
					 run_interval,
					 run_num,
                     self.platformString
					 ]];
//	[self _pushData:[NSString stringWithFormat:@"type=startSession&appKey=%@&bundleVersion=%@&uniqueIdentifier=%@&currentLocale=%@&currentSystemName=%@&currentSystemVersion=%@&currentModel=%@&currentOrientation=%d", appKey, bundleVersion, uniqueIdentifier, currentLocale, currentSystemName, currentSystemVersion, currentModel, currentOrientation]];
}

// 获取当前任务所占用的内存（单位：MB）

- (double)usedMemory

{
    
    task_basic_info_data_t taskInfo;
    
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         
                                         TASK_BASIC_INFO,
                                         
                                         (task_info_t)&taskInfo,
                                         
                                         &infoCount);
    
    
    
    
    if (kernReturn != KERN_SUCCESS
        
        ) {
        
        return NSNotFound;
        
    }
    
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
    
}

-(void)reportMemoryWarningInfo:(NSString *)warn
{
	//使用时间
	NSUInteger initTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"app-start-time"] intValue];
	NSUInteger endTime = (NSUInteger)[[NSDate date] timeIntervalSince1970];
	NSUInteger run_interval = endTime - initTime;
    //	NSLog(@"run_interval %d - %d = %d", endTime, initTime, run_interval);
	
	//使用次数
	int run_num = 1;
    NSString *usedtimes=[SFHFKeychainUtils getPasswordForUsername:@"POCO_USEDTIMES" andServiceName:KEYCHAIN_SERVICE_NAME error:NULL];
    if (usedtimes) {
        run_num = [usedtimes intValue];
    }
    NSLog(@"reportStartInfo usedtimes:%d",run_num);
    //	NSLog(@"run_num %d", run_interval);
    
    [self _pushData:[NSString stringWithFormat:@"tj_ver=2&sub_type=%@&client_ver=%@&client_id=%@&uid=%@&os=%@&os_ver=%@&screen=%f&run_interval=%lu&run_num=%d&phone_type=%@",
                     warn,
                     self.bundleVersion,
                     self.appKey,
                     self.uniqueIdentifier,
                     currentSystemName,
                     currentSystemVersion,
                     [self usedMemory],
                     (unsigned long)run_interval,
					 run_num,
                     self.platformString
					 ]];
    //	[self _pushData:[NSString stringWithFormat:@"type=startSession&appKey=%@&bundleVersion=%@&uniqueIdentifier=%@&currentLocale=%@&currentSystemName=%@&currentSystemVersion=%@&currentModel=%@&currentOrientation=%d", appKey, bundleVersion, uniqueIdentifier, currentLocale, currentSystemName, currentSystemVersion, currentModel, currentOrientation]];
}


//用户evnet
- (void)reportEvents
{
//	NSLog(@"reportEvents");
//	return ;
	//内容需要带客户端的版本，用户id，客户端guid等可以唯一标识使用用户的字段
	NSArray *reportingFiles = [self getReportingFiles];
	int count = [reportingFiles count];
	if (count > 0) {
		for (int i=0; i<count; i++) {
			NSString *filename = [reportingFiles objectAtIndex:i];
			
			NSString *urlString = nil;
			if ([[NetworkUnit sharedInstance] isWifiEnable]) {
				urlString = [[NSString stringWithFormat:@"%@", 
							  offLineReportServiceURL_WIFI] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			}else{
				urlString = [[NSString stringWithFormat:@"%@", 
				  offLineReportServiceURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			}
			
			NSURL *finalURL = [[NSURL alloc] initWithString:urlString];
			ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:finalURL];
			[request setTimeOutSeconds:3];
			
			NSMutableData *eventsData = [[NSMutableData alloc] init];
			[eventsData appendData: [[NSString stringWithFormat: @"tj_ver=2&sub_type=use&client_ver=%@&client_id=%@&uid=%@&phone_type=%@\r\n", self.bundleVersion, self.appKey, self.uniqueIdentifier ,self.platformString] dataUsingEncoding: NSUTF8StringEncoding]];
			NSData *userData = [[NSData alloc] initWithContentsOfFile:filename];
			[eventsData appendData: userData];
			[userData release];
			NSString *postFilename = [NSString stringWithFormat:@"events-%@-%f.txt", appKey,[[NSDate date] timeIntervalSince1970]];
			[request setData:eventsData withFileName:postFilename andContentType:@"text/plain" forKey:@"tongji"];
			[eventsData release];
			[request setRequestMethod:@"POST"];
			[request startSynchronous];
			NSError *error = [request error];
			if (!error && [request responseStatusCode] == 200) {
				[self removeEventFileAtItemPath:filename];
			}
			[finalURL release];
		}
	}
}

- (void)pushEvent:(int)eventId paraString:(NSString *)str
{
    NSLog(@"tjID:%d",eventId);
//    JRLogDebug(@"tjID:%d",eventId);
	/*NSString *filename = [self getWritableFilename];
	NSString *events = @"";
	if([[NSFileManager defaultManager] fileExistsAtPath:filename]){
		NSString *tmp = [[NSString alloc] initWithContentsOfFile:filename];
		events = [events stringByAppendingString:tmp];
		[tmp release];
	}
	*/
	NSString *eventString =nil;
	if (str) {
		eventString= [[NSString alloc] initWithFormat:@"event_id=%d&event_time=%lu&%@\r\n", eventId, (unsigned long)[[NSDate date] timeIntervalSince1970],str];
	}else {
		eventString= [[NSString alloc] initWithFormat:@"event_id=%d&event_time=%lu\r\n", eventId, (unsigned long)[[NSDate date] timeIntervalSince1970]];
	}
    _sharedInstance.writefilenum++;
    [_sharedInstance.writefilestring appendString:eventString];
#ifdef ART_CAMERA
    if (_sharedInstance.writefilenum > 0) {
#else
        if (_sharedInstance.writefilenum == 10) {
#endif
       // NSLog(@"pushEvent FINISH writefilenum:%d",_sharedInstance.writefilenum);
        NSString *filename = [self getWritableFilename];
        NSString *events = @"";
        if([[NSFileManager defaultManager] fileExistsAtPath:filename]){
            NSString *tmp = [[NSString alloc] initWithContentsOfFile:filename];
            events = [events stringByAppendingString:tmp];
            [tmp release];
        }
        events = [events stringByAppendingString:_sharedInstance.writefilestring];
        [eventString release];
        [events writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSRange ran;
        ran.location = 0;
        ran.length = _sharedInstance.writefilestring.length;
        [_sharedInstance.writefilestring deleteCharactersInRange:ran];
        _sharedInstance.writefilenum = 0;
    }else{
        [eventString release];
    }
    //NSLog(@"pushEvent writefilenum:%d writefilestring:%@",_sharedInstance.writefilenum,_sharedInstance.writefilestring);
    //NSLog(@"pushEvent retaincount:%d",[_sharedInstance.writefilestring retainCount]);
	//events = [events stringByAppendingString:eventString];
	//[eventString release];
	//[events writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)pushEventNoAppId:(int)eventId paraString:(NSString *)str
{
    NSLog(@"tjID:%d",eventId);
//    JRLogDebug(@"tjID:%d",eventId);
    bool fourbit=FALSE;
    if (eventId >999999) {
        eventId = eventId%10000;
        fourbit = TRUE;
    }else{
        eventId = eventId%1000;
    }
	//NSString *filename = [self getWritableFilename];
//	NSString *events = @"";
//	if([[NSFileManager defaultManager] fileExistsAtPath:filename]){
//		NSString *tmp = [[NSString alloc] initWithContentsOfFile:filename];
//		events = [events stringByAppendingString:tmp];
//		[tmp release];
//	}
	int new_ev_id=eventId;
	NSArray *ar_id=[appKey componentsSeparatedByString:@"_"];
	if (ar_id) {
		NSString *app_id=[ar_id objectAtIndex:0];
		if (app_id) {
            if (fourbit){
                new_ev_id = [app_id intValue]*10000+eventId;
            }else{
                new_ev_id = [app_id intValue]*1000+eventId;
            }
		}
	}
	//NSLog(@"evid:%d",new_ev_id);
	NSString *eventString =nil;
	if (str) {
		eventString= [[NSString alloc] initWithFormat:@"event_id=%d&event_time=%lu&%@\r\n", new_ev_id, (unsigned long)[[NSDate date] timeIntervalSince1970],str];
	}else {
		eventString= [[NSString alloc] initWithFormat:@"event_id=%d&event_time=%lu\r\n", new_ev_id, (unsigned long)[[NSDate date] timeIntervalSince1970]];
	}
	_sharedInstance.writefilenum++;
   [_sharedInstance.writefilestring appendString:eventString];
#ifdef ART_CAMERA
     if (_sharedInstance.writefilenum > 0) {
#else
    if (_sharedInstance.writefilenum == 10) {
#endif
       // NSLog(@"FINISH writefilenum:%d",_sharedInstance.writefilenum);
        NSString *filename = [self getWritableFilename];
        NSString *events = @"";
        if([[NSFileManager defaultManager] fileExistsAtPath:filename]){
            NSString *tmp = [[NSString alloc] initWithContentsOfFile:filename];
            events = [events stringByAppendingString:tmp];
            [tmp release];
        }
        events = [events stringByAppendingString:_sharedInstance.writefilestring];
        [eventString release];
        [events writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSRange ran;
        ran.location = 0;
        ran.length = _sharedInstance.writefilestring.length;
        [_sharedInstance.writefilestring deleteCharactersInRange:ran];
        _sharedInstance.writefilenum = 0;
    }else{
        [eventString release];
    }
    //NSLog(@"writefilenum:%d writefilestring:%@",_sharedInstance.writefilenum,_sharedInstance.writefilestring);
    //NSLog(@"retaincount:%d Range:%d %d",[_sharedInstance.writefilestring retainCount],NSRangeFromString(_sharedInstance.writefilestring).length,NSRangeFromString(_sharedInstance.writefilestring).location);
}

//paras里的对像必须为NSString类型
- (void)pushEvent:(int)eventId paraDictionary:(NSDictionary *)paras
{
     NSLog(@"tjID:%d",eventId);
//    JRLogDebug(@"tjID:%d",eventId);
	NSString *filename = [self getWritableFilename];
	NSMutableData *events = [[NSMutableData alloc] init];
	if([[NSFileManager defaultManager] fileExistsAtPath:filename]){
		NSData *tmp = [[NSMutableData alloc] initWithContentsOfFile:filename];
		[events appendData: tmp];
		[tmp release];
	}
	id key = nil;
	NSMutableData *eventsData = [[NSMutableData alloc] init];
	[eventsData appendData: [[NSString stringWithFormat: @"event_id=%d", eventId] dataUsingEncoding: NSUTF8StringEncoding]];
	[eventsData appendData: [[NSString stringWithFormat: @"&event_time=%d", (NSUInteger)[[NSDate date] timeIntervalSince1970]] dataUsingEncoding: NSUTF8StringEncoding]];
	
	NSMutableDictionary* parasCopy = [NSMutableDictionary dictionaryWithDictionary:paras];
	NSEnumerator *enumerator = [parasCopy keyEnumerator];
	while(key = [enumerator nextObject]) {
		id val = [parasCopy objectForKey: key];
		id keyHeader = nil;
		keyHeader = [NSString stringWithFormat: @"&%@=", key];
		[eventsData appendData: [keyHeader dataUsingEncoding: NSUTF8StringEncoding]];
		[eventsData appendData: [val dataUsingEncoding: NSUTF8StringEncoding]];
	}	
	[eventsData appendData: [[NSString stringWithFormat: @"\r\n"] dataUsingEncoding: NSUTF8StringEncoding]];
	[events appendData:eventsData];
	[eventsData release];
	[events writeToFile:filename atomically:YES];
	[events release];
}

    
- (void)pushStatisticsWithPageId:(NSString *)page_id
                    mid:(NSString *)mid
                    dmid:(NSString *)dmid
                    userid:(NSString *)userid
                    vid:(NSString *)vid
                    jid:(NSString *)jid
                    remark:(NSString *)rm
                        
{
    //NSLog(@"evid:%d",new_ev_id);
    NSString *eventString =nil;
    if(self.rmid == nil){
        self.rmid = @"";
    }
    if(dmid != nil &&[dmid length]>0){
        self.did = dmid;
    }
//    NSString *page_id=@"";
//    if ([pobject respondsToSelector:@selector(pageId)]){
//        page_id = [pobject performSelector:@selector(pageId) withObject:nil];
//    }else{
//        assert(false);
//        page_id =  [pobject classNameForClass:[pobject class]];
//    }
    NSString *tmpvid=@"";
    if (vid !=nil && [vid length]>0) tmpvid=vid;
    NSString *tmpjid=@"";
    if (jid !=nil && [jid length]>0) tmpjid=jid;
    NSString *tmpUserId = @"";
    if (userid && userid.length>0){
        tmpUserId = userid;
    }
    if (rm) {
        eventString= [[NSString alloc] initWithFormat:@"mid=%@&rmid=%@&did=%@&pid=%@&uid=%@&vid=%@&jid=%@&add_time=%d&rm=%@\r\n", mid,
                      self.rmid,
                      self.did,
                      page_id,
                      tmpUserId,
                      tmpvid,
                      tmpjid,
                      (NSUInteger)[[NSDate date] timeIntervalSince1970],rm];
    }else {
        eventString= [[NSString alloc] initWithFormat:@"mid=%@&rmid=%@&did=%@&pid=%@&uid=%@&vid=%@&jid=%@&add_time=%d&rm=\"\"\r\n", mid,
                      self.rmid,
                      self.did,
                      page_id,
                      tmpUserId,
                      tmpvid,
                      tmpjid,
                      (NSUInteger)[[NSDate date] timeIntervalSince1970]];
        
    }
    NSLog(@"eventString: %@" ,eventString);
    self.rmid = mid;
    _sharedInstance.writefilenum++;
    [_sharedInstance.writefilestring appendString:eventString];
    
    if (_sharedInstance.writefilenum > 0) {
        
        // NSLog(@"FINISH writefilenum:%d",_sharedInstance.writefilenum);
        NSString *filename = [self getWritableFilename];
        NSString *events = @"";
        if([[NSFileManager defaultManager] fileExistsAtPath:filename]){
            //NSString *tmp = [[NSString alloc] initWithContentsOfFile:filename];
            NSData *tmpData=[[NSData alloc] initWithContentsOfFile:filename];
            NSString *tmp=[[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
            events = [events stringByAppendingString:tmp];
            [tmp release];
            [tmpData release];
        }
        events = [events stringByAppendingString:_sharedInstance.writefilestring];
        //[eventString release];
        [events writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSRange ran;
        ran.location = 0;
        ran.length = _sharedInstance.writefilestring.length;
        [_sharedInstance.writefilestring deleteCharactersInRange:ran];
        _sharedInstance.writefilenum = 0;
    }else{
        
    }
    [eventString release];
}

- (void)pushStatisticsWithPageId:(NSString *)page_id
    mid:(NSString *)mid
    dmid:(NSString *)dmid
    userid:(NSString *)userid
    vid:(NSString *)vid
    jid:(NSString *)jid
    remark:(NSString *)rm
    rmid:(NSString*)rmid
{
    
    NSString *eventString =nil;
    
    
//    if(dmid != nil &&[dmid length]>0){
//        self.did = dmid;
//    }
   
    NSString *tmpvid=@"";
    if (vid !=nil && [vid length]>0) tmpvid=vid;
    NSString *tmpjid=@"";
    if (jid !=nil && [jid length]>0) tmpjid=jid;
    NSString *tmpUserId = @"";
    if (userid && userid.length>0){
        tmpUserId = userid;
    }
    if (rm) {
        eventString= [[NSString alloc] initWithFormat:@"mid=%@&rmid=%@&did=%@&pid=%@&uid=%@&vid=%@&jid=%@&add_time=%d&rm=%@\r\n",
                      mid,
                      rmid,
                      dmid,
                      page_id,
                      tmpUserId,
                      tmpvid,
                      tmpjid,
                      (NSUInteger)[[NSDate date] timeIntervalSince1970],rm];
    }else {
        eventString= [[NSString alloc] initWithFormat:@"mid=%@&rmid=%@&did=%@&pid=%@&uid=%@&vid=%@&jid=%@&add_time=%d&rm=\"\"\r\n",
                      mid,
                      rmid,
                      dmid,
                      page_id,
                      tmpUserId,
                      tmpvid,
                      tmpjid,
                      (NSUInteger)[[NSDate date] timeIntervalSince1970]];
        
    }
    NSLog(@"eventString: %@" ,eventString);
//    self.rmid = mid;
    _sharedInstance.writefilenum++;
    [_sharedInstance.writefilestring appendString:eventString];
    
    if (_sharedInstance.writefilenum > 0) {
        
        // NSLog(@"FINISH writefilenum:%d",_sharedInstance.writefilenum);
        NSString *filename = [self getWritableFilename];
        NSString *events = @"";
        if([[NSFileManager defaultManager] fileExistsAtPath:filename]){
            //NSString *tmp = [[NSString alloc] initWithContentsOfFile:filename];
            NSData *tmpData=[[NSData alloc] initWithContentsOfFile:filename];
            NSString *tmp=[[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
            events = [events stringByAppendingString:tmp];
            [tmp release];
            [tmpData release];
        }
        events = [events stringByAppendingString:_sharedInstance.writefilestring];
        //[eventString release];
        [events writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSRange ran;
        ran.location = 0;
        ran.length = _sharedInstance.writefilestring.length;
        [_sharedInstance.writefilestring deleteCharactersInRange:ran];
        _sharedInstance.writefilenum = 0;
    }else{
        
    }
    [eventString release];
}
    
//
//
//=======
//- (void)pushClick:(id)pobject
//                mid:(NSString *)mid
//                did:(NSString *)pdid
//                vid:(NSString *)vid
//                jid:(NSString *)jid
//                remark:(NSString *)rm
//{
//    
//    
//    //NSLog(@"evid:%d",new_ev_id);
//    NSString *eventString =nil;
//    if(self.rmid == nil){
//        self.rmid = @"";
//    }
//    if(pdid != nil &&[pdid length]>0){
//        self.did = pdid;
//    }
//    NSString *page_id=@"";
//    if ([pobject respondsToSelector:@selector(pageId)]){
//        page_id = [pobject performSelector:@selector(pageId) withObject:nil];
//    }else{
//        assert(false);
//        page_id =  [pobject classNameForClass:[pobject class] ];
//    }
//    NSString *tmpvid=@"";
//    if (vid !=nil && [vid length]>0) tmpvid=vid;
//    NSString *tmpjid=@"";
//    if (jid !=nil && [jid length]>0) tmpjid=jid;
//    if (rm) {
//        eventString= [[NSString alloc] initWithFormat:@"mid=%@&rmid=%@&did=%@&pid=%@&uid=%@&vid=%@&jid=%@&add_time=%d&%@\r\n", mid,
//                            self.rmid,
//                            self.did,
//                            page_id,
//                            self.uid,
//                            tmpvid,
//                            tmpjid,
//                            (NSUInteger)[[NSDate date] timeIntervalSince1970],rm];
//    }else {
//        eventString= [[NSString alloc] initWithFormat:@"mid=%@&rmid=%@&did=%@&pid=%@&uid=%@&vid=%@&jid=%@&add_time=%d&rm=\"\"\r\n", mid,
//                      self.rmid,
//                      self.did,
//                      page_id,
//                      self.uid,
//                      tmpvid,
//                      tmpjid,
//                      (NSUInteger)[[NSDate date] timeIntervalSince1970]];
//
//    }
//    self.rmid = mid;
//    _sharedInstance.writefilenum++;
//    [_sharedInstance.writefilestring appendString:eventString];
//
//    if (_sharedInstance.writefilenum > 0) {
//        
//        // NSLog(@"FINISH writefilenum:%d",_sharedInstance.writefilenum);
//        NSString *filename = [self getWritableFilename];
//        NSString *events = @"";
//        if([[NSFileManager defaultManager] fileExistsAtPath:filename]){
//            //NSString *tmp = [[NSString alloc] initWithContentsOfFile:filename];
//            NSData *tmpData=[[NSData alloc] initWithContentsOfFile:filename];
//            NSString *tmp=[[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
//            events = [events stringByAppendingString:tmp];
//            [tmp release];
//            [tmpData release];
//        }
//        events = [events stringByAppendingString:_sharedInstance.writefilestring];
//        //[eventString release];
//        [events writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        NSRange ran;
//        ran.location = 0;
//        ran.length = _sharedInstance.writefilestring.length;
//        [_sharedInstance.writefilestring deleteCharactersInRange:ran];
//        _sharedInstance.writefilenum = 0;
//    }else{
//        
//    }
//    [eventString release];
//}
//    
//        
//    
//>>>>>>> .r20229
//返回可写入文件
- (NSString *)getWritableFilename
{
	//NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *documents = NSTemporaryDirectory();
	NSString *filePath = [NSString stringWithFormat:@"%@/reporting", documents];
	if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	NSString *filename;
	int fileIndex = 0;
	BOOL is = YES;
	do {
		NSString *tmpFilename = [NSString stringWithFormat:@"reporting-%d", fileIndex];
		filename = [NSString stringWithFormat:@"%@/%@", filePath, tmpFilename];

		int filesize = [self getFilesizeAtItemPath:filename];
		if (filesize/(1024*1024)<2) {
			is =  NO;
		} else {
			fileIndex++;
		}
	} while (is);
	return filename;
}

- (NSArray *)getReportingFiles
{
	
	NSMutableArray *files = [[[NSMutableArray alloc] init] autorelease];
	//NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *documents = NSTemporaryDirectory();
	NSString *filePath = [NSString stringWithFormat:@"%@/reporting", documents];
	if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	int fileIndex = 0;
	BOOL is = NO;
	do {
		NSString *tmpFilename = [NSString stringWithFormat:@"reporting-%d", fileIndex];
		NSString *filename = [[NSString alloc] initWithFormat:@"%@/%@", filePath, tmpFilename];

		if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
			[files addObject:filename];
			int filesize = [self getFilesizeAtItemPath:filename];
			if (filesize/(1024*1024)==2 || filesize/(1024*1024)>2 ) {
				is =  YES;
				fileIndex++;
			} else {
				is =  NO;
			}
		} else {
			is =  NO;
		}

		[filename release];
	}while (is);
	
	return files;
}

- (int)getFilesizeAtItemPath:(NSString *)itemPath
{
	NSDictionary* attr =[[NSFileManager defaultManager] attributesOfItemAtPath:itemPath error:nil];
	return [[attr objectForKey:NSFileSize] intValue];
}

- (void)removeEventFileAtItemPath:(NSString *)itemPath
{
	[[NSFileManager defaultManager] removeItemAtPath:itemPath error:nil];
}

#pragma mark -
#pragma mark MKReverseGeocoderDelegate
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	[self _pushData:[NSString stringWithFormat:@"type=addUserLocation&appKey=%@&bundleVersion=%@&uniqueIdentifier=%@&latitude=%lf&longitude=%lf&locality=%@&country=%@", appKey, bundleVersion, uniqueIdentifier, geocoder.coordinate.latitude, geocoder.coordinate.longitude, placemark.locality, placemark.countryCode]];	
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	[self _pushData:[NSString stringWithFormat:@"type=addUserLocation&appKey=%@&bundleVersion=%@&uniqueIdentifier=%@&latitude=%lf&longitude=%lf&locality=%@&country=%@", appKey, bundleVersion, uniqueIdentifier, geocoder.coordinate.latitude, geocoder.coordinate.longitude, @"Unknown locality", @"Unknown country"]];	
}

#pragma mark -


@end
