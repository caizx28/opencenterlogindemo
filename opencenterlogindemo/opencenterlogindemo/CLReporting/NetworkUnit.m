//
//  NetworkUnit.m
//  PocoCamera2
//
//  Created by Chengl on 11-7-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkUnit.h"
//#import "JRLog.h"

@implementation NetworkUnit

@synthesize wifiReach;
@synthesize hostReach;
@synthesize internetReach;

static NetworkUnit *_sharedInstance = nil;

+ (NetworkUnit *)sharedInstance
{
    if (_sharedInstance == nil) {
		_sharedInstance = [[NetworkUnit alloc] init];
    }
    return _sharedInstance;
}

-(void)restartNotififier
{
    [internetReach stopNotifier];
    [wifiReach stopNotifier];
    [internetReach startNotifier];
    [wifiReach startNotifier];
}

-(id)init{
	if (self  =[super init]) {
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
        /*
		hostReach = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
		[hostReach startNotifier];
		*/
		internetReach = [[Reachability reachabilityForInternetConnection] retain];
		[internetReach startNotifier];
		
		wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
		[wifiReach startNotifier];
	}
	return self;
}


//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	NSLog(@"reachabilityChanged");
	//Reachability *curReach = [note object];
    NSLog(@"reachabilityChanged class %@",[Reachability class] );
	//NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	//[self updateInterfaceWithReachability: curReach];
	NSLog(@"network status is chang");
}

- (BOOL) isHostReach
{
	//[hostReach startNotifier];
	BOOL connectionRequired= [hostReach connectionRequired];
	
	if(connectionRequired)
	{
        NSLog(@"Cellular data network is available.\n  Internet traffic will be routed through it after a connection is established.");
//		JRLogDebug(@"Cellular data network is available.\n  Internet traffic will be routed through it after a connection is established.");
	}
	else
	{
        NSLog(@"Cellular data network is active.\n  Internet traffic will be routed through it.");
//		JRLogDebug(@"Cellular data network is active.\n  Internet traffic will be routed through it.");
	}
	return connectionRequired;
}

- (BOOL) isWifiEnable
{
    //[wifiReach startNotifier];
	NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
	
	BOOL connectionRequired= [wifiReach connectionRequired];
	if(connectionRequired)
	{
		//statusString= [NSString stringWithFormat: @"%@, Connection Required", statusString];
	}
	
	BOOL is_wifi_enable=FALSE;
	switch (netStatus)
    {
        case NotReachable:
        {			
			is_wifi_enable = FALSE;
            break;
        }
            
        case ReachableViaWWAN:
        {
			//statusString = @"Reachable WWAN";
            //imageView.image = [UIImage imageNamed: @"WWAN5.png"];
			is_wifi_enable = FALSE;
            break;
        }
        case ReachableViaWiFi:
        {
			//statusString= @"Reachable WiFi";
            //imageView.image = [UIImage imageNamed: @"Airport.png"];
			is_wifi_enable = TRUE;
            break;
		}
    }
	return is_wifi_enable;
}

- (BOOL) isNetworkDisable
{
    //[internetReach startNotifier];
    //return FALSE;
	NetworkStatus netStatus = [internetReach currentReachabilityStatus];
	BOOL is_network_disable=FALSE;
	switch (netStatus)
    {
        case NotReachable:
        {	
			is_network_disable = TRUE;
            break;
        }
            
        case ReachableViaWWAN:
        {
			//statusString = @"Reachable WWAN";
            //imageView.image = [UIImage imageNamed: @"WWAN5.png"];
			is_network_disable = FALSE;
            break;
        }
        case ReachableViaWiFi:
        {
			//statusString= @"Reachable WiFi";
            //imageView.image = [UIImage imageNamed: @"Airport.png"];
			is_network_disable = FALSE;
            break;
		}
    }
	return is_network_disable;
}

- (void)dealloc{
	[wifiReach release];
	[hostReach release];
	[internetReach release];
    [super dealloc];
}
	 
@end
