//
//  JPSUserHomePageImageLoader.h
//  JanePlus
//
//  Created by JiakaiNong on 15/10/13.
//  Copyright © 2015年 Allen Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString * const kHeadKey;
FOUNDATION_EXTERN NSString * const kCoverKey;

typedef void(^completion)(void);

@interface JNEUserImageLoader : NSObject

@property (nonatomic, strong) NSString *style;

+ (NSString *)localPathWithURLString:(NSString *)urlString
                            cacheKey:(NSString *)cacheKey;

+ (void)saveImageToLocalWithImage:(UIImage*)image
                        URLString:(NSString*)URLString
                         cacheKey:(NSString *)cacheKey
                       completion:(completion)completion;

+ (UIImage *)cachedImageWithURLString:(NSString *)urlString
                            cachedKey:(NSString *)cachedKey;

+ (UIImageView *)getRefreshImageViewWithFrame:(CGRect)frame
                                    URLString:(NSString *)URLString
                                     cacheKey:(NSString *)cacheKey
                             placeHolderImage:(UIImage *)placeHolderImage
                                   completion:(completion)completion;

+ (UIButton *)getRefreshButtonWithFrame:(CGRect)frame
                              URLString:(NSString *)URLString
                               cacheKey:(NSString *)cacheKeyqi
                       placeHolderImage:(UIImage *)placeHolderImage
                             completion:(completion)completion;

+ (void)refreshImageWithImageView:(UIImageView *)imageView
                        URLString:(NSString *)URLString
                         cacheKey:(NSString *)cacheKey
                       completion:(completion)completion;

+ (void)refreshImageWithButton:(UIButton *)button
                         state:(UIControlState)state
                     URLString:(NSString *)URLString
                      cacheKey:(NSString *)cacheKey
                    completion:(completion)completion;

@end
