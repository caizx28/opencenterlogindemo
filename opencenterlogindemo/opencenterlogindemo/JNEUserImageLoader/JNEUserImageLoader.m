//
//  JPSUserHomePageImageLoader.m
//  JanePlus
//
//  Created by JiakaiNong on 15/10/13.
//  Copyright © 2015年 Allen Chen. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserImageLoader requires ARC support."
#endif

#import "JNEUserImageLoader.h"
//#import "EGOCache.h"
#import "GCDHelper.h"
#import "AFURLResponseSerialization.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "JPSApiUserManger.h"

@interface JNEUserImageLoader()

@end

@implementation JNEUserImageLoader

NSString * const kHeadKey = @"HeadKey";
NSString * const kCoverKey = @"CoverKey";

inline static NSString* nameForStyleAndURL(NSString* style, NSURL* url) {
    if(style) {
        if (!url) {
            return [NSString stringWithFormat:@"%@", @([style hash])];
        }
        return [NSString stringWithFormat:@"%@-%@", @([style hash]), @([[url description] hash])];
    } else {
        return [NSString stringWithFormat:@"%@", @([[url description] hash])];
    }
}

#pragma mark - Public Method

+ (NSString *)localPathWithURLString:(NSString *)urlString cacheKey:(NSString *)cacheKey {
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *directory = [JPSApiUserManger shareInstance].currentUser.userPath;
    return [NSString stringWithFormat:@"%@/%@",directory,nameForStyleAndURL(cacheKey, url)];
}

+ (void)saveImageToLocalWithImage:(UIImage*)image URLString:(NSString*)URLString cacheKey:(NSString *)cacheKey completion:(completion)completion  {
    NSURL *url = [NSURL URLWithString:URLString];
    [[self class] copyToLocalDirectoryWithURL:url cacheKey:cacheKey image:image completion:completion];
}

+ (UIImage *)cachedImageWithURLString:(NSString *)urlString cachedKey:(NSString *)cachedKey {
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *directory = [JPSApiUserManger shareInstance].currentUser.userPath;
    return [FileOperate readImageWithFile:[NSString stringWithFormat:@"%@/%@",directory,nameForStyleAndURL(cachedKey, url)]];
}

+ (UIImageView *)getRefreshImageViewWithFrame:(CGRect)frame
                                    URLString:(NSString *)URLString
                                     cacheKey:(NSString *)cacheKey
                             placeHolderImage:(UIImage *)placeHolderImage
                                   completion:(completion)completion {
    UIImage *afPlaceHolderImage = placeHolderImage;
    UIImage *cachedImage = [[self class] cachedImageWithCacheKey:cacheKey];
    if (cachedImage) {
        afPlaceHolderImage = cachedImage;
    }
    
    UIImageView *refreshImageView = [[UIImageView alloc]initWithFrame:frame];
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    __weak __typeof(refreshImageView)weakImageView = refreshImageView;
    refreshImageView.imageResponseSerializer = [[self class] imageResponseSerializerWithSerializer:refreshImageView.imageResponseSerializer];
    [refreshImageView setImageWithURLRequest:urlRequest placeholderImage:afPlaceHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (response) {
            [[self class] copyToLocalDirectoryWithURL:url cacheKey:cacheKey image:image completion:completion];
        }
        weakImageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        weakImageView.image = afPlaceHolderImage;
    }];
    return refreshImageView;
}

+ (UIButton *)getRefreshButtonWithFrame:(CGRect)frame
                              URLString:(NSString *)URLString
                               cacheKey:(NSString *)cacheKey
                       placeHolderImage:(UIImage *)placeHolderImage
                             completion:(completion)completion {
    UIImage *afPlaceHolderImage = placeHolderImage;
    UIImage *cachedImage = [[self class] cachedImageWithCacheKey:cacheKey];
    if (cachedImage) {
        afPlaceHolderImage = cachedImage;
    }
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = frame;
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    __weak __typeof(refreshButton)weakButton = refreshButton;
    refreshButton.imageResponseSerializer = [[self class] imageResponseSerializerWithSerializer:refreshButton.imageResponseSerializer];
    [refreshButton setBackgroundImageForState:UIControlStateNormal withURLRequest:urlRequest placeholderImage:afPlaceHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (response) {
            [[self class] copyToLocalDirectoryWithURL:url cacheKey:cacheKey image:image completion:completion];
        }
        [weakButton setBackgroundImage:image forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        [weakButton setBackgroundImage:placeHolderImage forState:UIControlStateNormal];
    }];
    return refreshButton;
}

+ (void)refreshImageWithImageView:(UIImageView *)imageView
                        URLString:(NSString *)URLString
                         cacheKey:(NSString *)cacheKey
                       completion:(completion)completion {
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    __weak __typeof(imageView)weakImageView = imageView;
    imageView.imageResponseSerializer = [[self class] imageResponseSerializerWithSerializer:imageView.imageResponseSerializer];
    [imageView setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (response) {
            [[self class] copyToLocalDirectoryWithURL:url cacheKey:cacheKey image:image completion:completion];
        }
        weakImageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
}

+ (void)refreshImageWithButton:(UIButton *)button
                         state:(UIControlState)state
                     URLString:(NSString *)URLString
                      cacheKey:(NSString *)cacheKey
                    completion:(completion)completion {
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    __weak __typeof(button)weakButton = button;
    button.imageResponseSerializer = [[self class] imageResponseSerializerWithSerializer:button.imageResponseSerializer];
    [button setBackgroundImageForState:state withURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (response) {
            [[self class] copyToLocalDirectoryWithURL:url cacheKey:cacheKey image:image completion:completion];
        }
        [weakButton setBackgroundImage:image forState:state];
    } failure:^(NSError *error) {
        JPSLog(@".............\n%@", error);
    }];
}

#pragma mark - Private Method

+ (void)copyToLocalDirectoryWithURL:(NSURL*)URL cacheKey:(NSString *)cacheKey image:(UIImage*)image completion:(completion)completion {
    [GCDHelper saveCachedImage:^(void){
        NSString *directory = [JPSApiUserManger shareInstance].currentUser.userPath;
        NSArray * allFilePath = [FileOperate contentsOfFileFromDirectory:directory];
        for (NSInteger i = 0; i<[allFilePath count]; i++) {
            NSString * lastPathComponent = [[allFilePath objectAtIndex:i] lastPathComponent];
            if ([lastPathComponent hasPrefix:nameForStyleAndURL(cacheKey, nil)]) {
                [FileOperate removeFile:[NSString stringWithFormat:@"%@/%@",directory,[allFilePath objectAtIndex:i]]];
            }
        }
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[NSString stringWithFormat:@"%@/%@",directory,nameForStyleAndURL(cacheKey, URL)] atomically:YES];
    }completion:completion];
}

+ (UIImage *)cachedImageWithCacheKey:(NSString *)cacheKey {
    NSString *directory = [JPSApiUserManger shareInstance].currentUser.userPath;
    NSArray * allFilePath = [FileOperate contentsOfFileFromDirectory:directory];
    for (NSInteger i = 0; i<[allFilePath count]; i++) {
        NSString * lastPathComponent = [[allFilePath objectAtIndex:i] lastPathComponent];
        if ([lastPathComponent hasPrefix:nameForStyleAndURL(cacheKey, nil)]) {
            return [FileOperate readImageWithFile:[NSString stringWithFormat:@"%@/%@",directory,[allFilePath objectAtIndex:i]]];
        }
    }
    return nil;
}

+ (id <AFURLResponseSerialization>)imageResponseSerializerWithSerializer:(id <AFURLResponseSerialization>)serializer {
    AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer = serializer;
    NSMutableSet *set = [responseSerializer.acceptableContentTypes mutableCopy];
    [set addObject:@"image/jpg"];
    responseSerializer.acceptableContentTypes = set;
    
    return responseSerializer;
}

@end
