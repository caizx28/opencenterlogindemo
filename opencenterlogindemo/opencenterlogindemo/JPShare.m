//
//  JPShare.m
//  JanePlus
//
//  Created by admin on 15/8/21.
//  Copyright (c) 2015年 Allen Chen. All rights reserved.
//

#import "JPShare.h"
#import "JPShareConstant.h"
#import "AFNetworkReachabilityManager.h"


#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JPShare requires ARC support."
#endif

@interface JPShare ()<JPShareOperationDelegate>
@property (nonatomic,strong) NSMutableDictionary *shareAPIs;
@end

@implementation JPShare

+ (JPShare *)shareObject {
    static JPShare *shareInstance ;
    static dispatch_once_t onceToken ;
    @synchronized (self){
        dispatch_once(&onceToken, ^{
            shareInstance = [[super allocWithZone:nil] init];
        });
    }
    return shareInstance;
}

#pragma mark - public  method 

+ (BOOL)handleOpenURL:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
    
    NSString *urlString = [NSString stringWithFormat:@"%@",url];
    NSArray<JPShareConfiguretion*> * shareConfiguretions = [JPShareConfiguretion shareConfiguretions];
    
    for (JPShareConfiguretion * configuretion in shareConfiguretions) {
        NSRange range = [[urlString lowercaseString] rangeOfString:configuretion.ShareURLIdentify];
        if (range.length != 0) {
            SEL handleOpenURLSelector = NSSelectorFromString(@"handleOpenURL:delegate:");
            SEL applicationSelector = NSSelectorFromString(@"application:openURL:sourceApplication:annotation:");
            if ([configuretion.ShareClass respondsToSelector:handleOpenURLSelector]) {
                return  [configuretion.ShareClass handleOpenURL:url delegate:[[JPShare shareObject].shareAPIs objectForKey:configuretion.SharePlatform]];
            }else if ([configuretion.ShareClass respondsToSelector:applicationSelector]){
                return  [configuretion.ShareClass application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
            }
        }
    }
    return YES;
}

+ (void)registerAppShareConfigWith:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     NSArray<JPShareConfiguretion*> * shareConfiguretions = [JPShareConfiguretion shareConfiguretions];
    SEL aSelector = NSSelectorFromString(@"registerAppShareConfigWith:didFinishLaunchingWithOptions:");
    for (JPShareConfiguretion * configuretion in shareConfiguretions) {
        if ([configuretion.ShareClass respondsToSelector:aSelector]) {
            [configuretion.ShareClass registerAppShareConfigWith:application didFinishLaunchingWithOptions:launchOptions];
        }
    }
}

+ (NSString*)shareFileRootPath {
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentPath = [paths lastObject];
        path = [documentPath stringByAppendingPathComponent:@"JPShare"];
    });
   
    return path;
}

+ (id<JPShareContentObjectTranslater>)contentObjectTranslaterWithType:(JPShareContentObjectTranslaterType)type {
    switch (type) {
        case JPShareContentObjectTranslaterTypeOfDefault:
            return [[JPShareBaseObjectTranslater alloc] init];
        case JPShareContentObjectTranslaterTypeOfAppRecommond:
            return [[JPShareContentObjectAppRecommondTranslater alloc] init];
        default:
            return [[JPShareBaseObjectTranslater alloc] init];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
       
        if (![[NSFileManager defaultManager] fileExistsAtPath:[JPShare shareFileRootPath]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[JPShare shareFileRootPath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSArray<JPShareConfiguretion*> * shareConfiguretions = [JPShareConfiguretion shareConfiguretions];
        self.shareAPIs = [NSMutableDictionary dictionary];
        
        for (JPShareConfiguretion * configuretion in shareConfiguretions) {
            id<JPShareAPI> shareEngine = (id<JPShareAPI>) [[[configuretion ShareClass] alloc] init];
            [self.shareAPIs setObject:shareEngine forKey:configuretion.SharePlatform];
        }
        for (id<JPShareAPI> shareEngine  in [self.shareAPIs allValues]) {
            shareEngine.delegate = self;
        }
       self.contentObjectTranslater = [JPShare contentObjectTranslaterWithType:JPShareContentObjectTranslaterTypeOfDefault];
    }
    return self;
}

- (void)loginWithType:(JPShareLoginType)type {
    id<JPShareAPI> shareEngine = self.shareAPIs[[NSString stringWithFormat:@"%lu",(unsigned long)type]];
    [shareEngine logIn];
}

- (void)logoutWithType:(JPShareLoginType)type {
    id<JPShareAPI> shareEngine = self.shareAPIs[[NSString stringWithFormat:@"%lu",(unsigned long)type]];
    [shareEngine logOut];
}

- (void)logoutAllSharePlatform {
    for (id<JPShareAPI> shareEngine in [self.shareAPIs allValues]) {
        [shareEngine logOut];
    }
}

- (void)sendWithContentObject:(JPShareContentObject*)object {
    [self sendWithContentObject:object contentObjectTranslater:self.contentObjectTranslater];
}

- (void)sendWithContentObject:(JPShareContentObject*)object contentObjectTranslater:(id<JPShareContentObjectTranslater>)contentObjectTranslater {
    NSDictionary * shareEngineKeys = @{[NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeWechatSession]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeWechat],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeWechatTimeline]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeWechat],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeSina]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeSina],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeQQZone]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeQQ],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeQQ]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeQQ],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeFaceBook]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeFaceBook],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeTwitter]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeTwitter],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeInstagram]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeInstagram]};
    
    id<JPShareAPI> shareEngine = self.shareAPIs[shareEngineKeys[[NSString stringWithFormat:@"%lu",(unsigned long)object.type]]];
    [shareEngine sendContentWithObject:[contentObjectTranslater tranlateWithContentObject:object]];
}

- (BOOL)isLogineWithType:(JPShareLoginType)type {
    id<JPShareAPI> shareEngine = self.shareAPIs[[NSString stringWithFormat:@"%lu",(unsigned long)type]];
    return [shareEngine isLogined];
}

- (JPShareAuthorizeObject*)authorizeObjectWithType:(JPShareLoginType)type {
   id<JPShareAPI> shareEngine = self.shareAPIs[[NSString stringWithFormat:@"%lu",(unsigned long)type]];
    JPShareAuthorizeObject *authorizeObject = [shareEngine.object copy];
    return authorizeObject;
}

- (id<JPShareAPI>)shareEngineWithType:(JPShareLoginType)type {
    return self.shareAPIs[[NSString stringWithFormat:@"%lu",(unsigned long)type]];
}

+ (JPShareLoginType)shareTypeConvertToLoginTypeWith:(JPShareType)type {
    NSDictionary * shareEngineKeys = @{[NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeWechatSession]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeWechat],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeWechatTimeline]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeWechat],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeSina]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeSina],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeQQZone]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeQQ],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeQQ]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeQQ],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeFaceBook]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeFaceBook],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeTwitter]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeTwitter],
                                       [NSString stringWithFormat:@"%ld",(unsigned long)JPShareTypeInstagram]:[NSString stringWithFormat:@"%lu",(unsigned long)JPShareLoginTypeInstagram]};
    NSUInteger tag = [[shareEngineKeys objectForKey:[NSString stringWithFormat:@"%ld",(unsigned long)type]] integerValue];
    return tag;
}

+ (CGFloat)shareImageCompressRateWithType:(JPShareType)type {
    if (type == JPShareTypeTwitter) {
        return 0.8;
    }else if (type == JPShareTypeQQZone) {
        return 0.9;
    }else {
        return [self weiboCompressByNetWorkState];
    }
}

- (BOOL)isInstallNativeAppWithType:(JPShareLoginType)type {
    id<JPShareAPI> shareEngine = self.shareAPIs[[NSString stringWithFormat:@"%lu",(unsigned long)type]];
    return [shareEngine isInstallNativeApp];
}


#pragma mark -  JPShareOperationDelegate

- (void)share:(id<JPShareAPI>)share AuthorizeCodeSuccess:(NSString*)userInfo {
  
    if (self.delegate&&[self.delegate respondsToSelector:@selector(share:AuthorizeCodeSuccess:)]) {
        [self.delegate share:share AuthorizeCodeSuccess:nil];
    }
}

- (void)share:(id<JPShareAPI>)share AuthorizeSuccessed:(NSDictionary*)userInfo {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(share:AuthorizeSuccessed:)]) {
        [self.delegate share:share AuthorizeSuccessed:nil];
    }
}

- (void)share:(id<JPShareAPI>)share AuthorizeFail:(NSDictionary*)userInfo {
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(share:AuthorizeFail:)]) {
        [self.delegate share:share AuthorizeFail:nil];
    }
}

- (void)share:(id<JPShareAPI>)share AuthorizeCancel:(NSDictionary*)userInfo {
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(share:AuthorizeCancel:)]) {
        [self.delegate share:share AuthorizeCancel:nil];
    }
}

- (void)share:(id<JPShareAPI>)share ShareContentSuccessed:(NSDictionary*)userInfo {
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(share:ShareContentSuccessed:)]) {
        [self.delegate share:share ShareContentSuccessed:nil];
    }
}

- (void)share:(id<JPShareAPI>)share ShareContentFail:(NSDictionary*)userInfo {
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(share:ShareContentFail:)]) {
        [self.delegate share:share ShareContentFail:nil];
    }
}

- (void)share:(id<JPShareAPI>)share ShareContentCancel:(NSDictionary*)userInfo {
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(share:ShareContentCancel:)]) {
        [self.delegate share:share ShareContentCancel:nil];
    }
}

- (void)share:(id<JPShareAPI>)share logOutSuccess:(NSDictionary*)userInfo {
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(share:logOutSuccess:)]) {
        [self.delegate share:share logOutSuccess:nil];
    }
}

- (void)share:(id<JPShareAPI>)share requestOauthTokenStart:(NSDictionary*)userInfo {
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(share:requestOauthTokenStart:)]) {
        [self.delegate share:share requestOauthTokenStart:nil];
    }
}

- (void)share:(id<JPShareAPI>)share requestOauthTokenEnd:(NSDictionary*)userInfo {
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(share:requestOauthTokenEnd:)]) {
        [self.delegate share:share requestOauthTokenEnd:nil];
    }
}

- (void)share:(id<JPShareAPI>)share notInstallNativeApp:(NSDictionary*)userInfo {
    NSDictionary * mappingDictionary = @{@(JPShareLoginTypeSina):NSLocalizedString(@"您没有安装新浪客户端或者版本太低",nil),
                                         @(JPShareLoginTypeWechat):NSLocalizedString(@"您没有安装微信客户端或者版本太低",nil),
                                         @(JPShareLoginTypeQQ):NSLocalizedString(@"您没有安装QQ客户端或者版本太低",nil),
                                         @(JPShareLoginTypeInstagram):NSLocalizedString(@"您没有安装Instagram客户端或者版本太低",nil),
                                         @(JPShareLoginTypeTwitter):NSLocalizedString(@"您没有安装Twitter客户端或者版本太低",nil),
                                         @(JPShareLoginTypeFaceBook):NSLocalizedString(@"您没有安装Facebook客户端或者版本太低",nil)
                                         };
    
    NSString * message = [mappingDictionary objectForKey:@(share.object.type)];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil];
    alertView.tag = share.object.type;
    alertView.delegate = self;
    [alertView show];
    
}

#pragma mark - private method 

+ (float)weiboCompressByDeviceTypeOnNoWifi {
    return 0.8;
}

+ (float)weiboCompressByDeviceTypeOnWifi {
    return 0.88f;
}

+ (CGFloat)weiboCompressByNetWorkState {
    if(![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi){
        return [self weiboCompressByDeviceTypeOnNoWifi];
    }else{
        return [self weiboCompressByDeviceTypeOnWifi];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(share:notInstallNativeApp:)]) {
        [self.delegate share:self notInstallNativeApp:nil];
    }
}

@end

#pragma mark - JPShareConfiguretion

@interface JPShareConfiguretion ()
@property (nonatomic,assign) Class  ShareClass;
@property (nonatomic,copy) NSString * ShareAppKey;
@property (nonatomic,copy) NSString * ShareAppSecret;
@property (nonatomic,copy) NSString * ShareAppRedirectURI;
@property (nonatomic,copy) NSString * ShareAuthorizeFile;
@property (nonatomic,copy) NSString * SharePlatform;
@property (nonatomic,copy) NSString * ShareURLIdentify;
@end


@implementation JPShareConfiguretion

+ (Class)shareClassWithPlatformString:(NSString*)platformString {
    
    if ([platformString isEqualToString:@""]||!platformString) {
        nil;
    }
    
    NSDictionary * mappingDictionary = @{@"0":@"JPShareSina",
                                         @"3":@"JPShareWeChat",
                                         @"2":@"JPShareQQ",
                                         @"7":@"JPShareInstagram",
                                         @"6":@"JPShareTwitter",
                                         @"5":@"JPShareFaceBook"};
    
    NSString * classString = mappingDictionary[platformString];
    
    if (classString) {
        return NSClassFromString(classString);
    }
    
    return nil;
    
}

+ (NSArray<JPShareConfiguretion*> *)shareConfiguretions {
    
    static NSArray<JPShareConfiguretion*> * shareConfiguretions;
    static dispatch_once_t onceToken ;
    @synchronized (self){
        dispatch_once(&onceToken, ^{
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"JPShareConfiguration" ofType:@"plist"];
            NSMutableArray *shareInformations = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
            NSMutableArray<JPShareConfiguretion*> *configuretions = [NSMutableArray<JPShareConfiguretion*> array];
            
            for (NSDictionary * shareInformation in shareInformations) {
                JPShareConfiguretion * configuretion = [JPShareConfiguretion configuretionWithDictionary:shareInformation];
                [configuretions addObject:configuretion];
            }
            shareConfiguretions = [NSArray<JPShareConfiguretion*> arrayWithArray:configuretions];
        });
    }
    
    return shareConfiguretions;
}

+ (JPShareConfiguretion * )configuretionWithDictionary:(NSDictionary*)dictionary {
    JPShareConfiguretion * configuretion = [[JPShareConfiguretion alloc] init];
    NSString * sharePlatform = (NSString* )dictionary[@"SharePlatform"];
    configuretion.ShareClass = [self shareClassWithPlatformString:sharePlatform];
    configuretion.ShareAppKey = dictionary[@"ShareAppKey"];
    configuretion.ShareAppSecret = dictionary[@"ShareAppSecret"];
    configuretion.ShareAppRedirectURI = dictionary[@"ShareAppRedirectURI"];
    configuretion.ShareAuthorizeFile = dictionary[@"ShareAuthorizeFile"];
    configuretion.SharePlatform = sharePlatform;
    configuretion.ShareURLIdentify = dictionary[@"ShareAppKey"];
    return  configuretion;
}

+ (JPShareConfiguretion *)configuretionWithType:(JPShareLoginType)type {
    
    NSArray<JPShareConfiguretion*> * shareConfiguretions = [JPShareConfiguretion shareConfiguretions];
    NSString * key = [NSString stringWithFormat:@"%lu",(unsigned long)type];
    for (JPShareConfiguretion * configuretion in shareConfiguretions) {
        if ([configuretion.SharePlatform  isEqualToString:key]) {
            return configuretion;
        }
    }
    return nil;
}

@end

