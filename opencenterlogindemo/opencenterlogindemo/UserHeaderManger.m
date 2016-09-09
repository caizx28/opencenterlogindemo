//
//  UserHeaderManger.m
//  puzzleApp
//
//  Created by admin on 14-9-26.
//  Copyright (c) 2014年 Allen Chen. All rights reserved.
//

#import "UserHeaderManger.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "FileOperate.h"
NSString * const kUserCumtomHeaderName = @"userHeader.jpg";
NSString * const kUserDefaultHeaderName = @"DefaultUserHeader.png";

@interface UserHeaderManger ()
@property (nonatomic,retain) NSMutableDictionary  *  urlMaps;
@property (nonatomic,retain) ASINetworkQueue * loaderQueque;

- (ASIHTTPRequest *)createRequest:(NSString*)url ;
- (void)clearAllProsseViewDelegate;
@end

static UserHeaderManger *shareInstance = nil;
static dispatch_once_t onceToken;

@implementation UserHeaderManger

#pragma mark - life cycle


+ (UserHeaderManger *)shareInstance {
    @synchronized (self){
        dispatch_once(&onceToken, ^{
            shareInstance = [[super allocWithZone:nil] init];
        });
    }
    return shareInstance;
}

+ (id) allocWithZone:(NSZone *)zone{
    return [self shareInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [UserHeaderManger shareInstance];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.loaderQueque = [[[ASINetworkQueue alloc] init] autorelease];
        self.loaderQueque.maxConcurrentOperationCount = 10;
        self.loaderQueque.showAccurateProgress = YES;
        [self.loaderQueque setShouldCancelAllRequestsOnFailure:NO];
        [self.loaderQueque setDelegate:self];
        [self.loaderQueque setRequestDidFailSelector:@selector(requestFailed:)];
        [self.loaderQueque setRequestDidFinishSelector:@selector(requestFinished:)];
        [self.loaderQueque setQueueDidFinishSelector:@selector(queueFinished:)];
        self.urlMaps = [[[NSMutableDictionary alloc] init]autorelease];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
    [self clearAllProsseViewDelegate ];
    self.loaderQueque = nil;
    self.urlMaps = nil;
}

#pragma mark - public  method

- (void)saveUserHeaderToLocal:(UIImage *)image {
    if (image == nil) {
        return;
    }
    NSData * imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString * path = [NSString stringWithFormat:@"%@/%@",DOWN_MATERIAL_DIR,kUserCumtomHeaderName];
    [imageData writeToFile:path atomically:YES];
}




- (UIImage*)userThumbImage {
    NSString * path = [NSString stringWithFormat:@"%@/%@",DOWN_MATERIAL_DIR,kUserCumtomHeaderName];
    UIImage* image =  [UIImage imageWithContentsOfFile:path];
    if (image == nil) {
        return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kUserDefaultHeaderName ofType:nil]];
    }
    return image;
}

#pragma mark - net work call back

- (void)requestFinished:(ASIHTTPRequest *)request {
   
    if ([[self.urlMaps allKeys] containsObject:[[request url] absoluteString]]) {
        NSData * data = [request responseData];
        if ([data length]>100&&data != nil) {
            NSString * path = [NSString stringWithFormat:@"%@/%@",DOWN_MATERIAL_DIR,kUserCumtomHeaderName];
            if (![FileOperate isFileExistWithFilePath:path]) {
                [data writeToFile:path atomically:YES];
            }
        }
        [self.urlMaps removeObjectForKey:[request.url absoluteString]];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [self.urlMaps removeObjectForKey:[request.url absoluteString]];
}

- (void)queueFinished:(ASINetworkQueue *)queue {
    ;
}

#pragma mark - private  method 

- (ASIHTTPRequest *)createRequest:(NSString*)url{
    ASIHTTPRequest *request  = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request setRequestMethod:@"GET"];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return  request;
}

- (void)clearAllProsseViewDelegate {
    NSArray * requests = [self.loaderQueque operations];
    for (ASIHTTPRequest * request in requests) {
        [request setDownloadProgressDelegate:nil];
    }
}


@end
