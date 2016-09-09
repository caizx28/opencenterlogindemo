//
//  GCDHelper.m
//  DoubanAlbum
//
//  Created by Tonny on 12-12-12.
//  Copyright (c) 2012年 SlowsLab. All rights reserved.
//

#import "GCDHelper.h"

static dispatch_queue_t load_cached_image_queue;
dispatch_queue_t load_cached_image_processing_queue() {
    if (load_cached_image_queue == NULL) {
        load_cached_image_queue = dispatch_queue_create("com.slowslab.load.cached.image.processing", 0);
    }
    
    return load_cached_image_queue;
}

static dispatch_queue_t advertisement_queue;
dispatch_queue_t load_cached_advertisement_queue() {
    if (advertisement_queue == NULL) {
        advertisement_queue = dispatch_queue_create("com.slowslab.advertisement.processing", 0);
    }
    
    return advertisement_queue;
}

static dispatch_queue_t bussiness_queue;
dispatch_queue_t load_cached_bussiness_queue() {
    if (bussiness_queue == NULL) {
        bussiness_queue = dispatch_queue_create("com.slowslab.bussiness_queue.processing", 0);
    }
    
    return bussiness_queue;
}

static dispatch_queue_t template_info_queue;
dispatch_queue_t load_cached_template_info_queue() {
    if (template_info_queue == NULL) {
        template_info_queue = dispatch_queue_create("com.slowslab.template_info.processing", 0);
    }
    
    return template_info_queue;
}

@implementation GCDHelper

+ (void)dispatchBlockInTemplateInfoQueue:(SLBlock)block completion:(SLBlock)completion{
    dispatch_async(load_cached_template_info_queue(), ^{
        @autoreleasepool {
            if(block){
                block();
            }
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
            
        }
    });
}

+ (void)dispatchBlockInBussinessQueue:(SLBlock)block completion:(SLBlock)completion{
    dispatch_async(load_cached_bussiness_queue(), ^{
        @autoreleasepool {
            if(block){
                block();
            }
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
            
        }
    });
}

+ (void)dispatchBlockInAdvertisementQueue:(SLBlock)block completion:(SLBlock)completion{
    dispatch_async(load_cached_advertisement_queue(), ^{
        @autoreleasepool {
            if(block){
                block();
            }
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
            
        }
    });
}


+ (void)saveCachedImage:(SLBlock)block completion:(SLBlock)completion{
    dispatch_async(load_cached_image_processing_queue(), ^{
        @autoreleasepool {
            if(block){
                block();
            }
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }

        }
    });
}


+ (void)repeatBlockInGroup:(NSArray*)blocks {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    for(id obj in blocks)
        dispatch_group_async(group, queue, ^{
            SLBlock block = (SLBlock)obj;
            if(block){
                block();
            }
        });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //dispatch_release(group);
}

+ (void)repeatBlock:(SLBlock)block withCount:(NSUInteger)count{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_apply(count, queue, ^(size_t index){
            if(block){
                block();
            }
        });
    });
}

+ (void)dispatchBlock:(SLBlock)block completion:(SLBlock)completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            if(block){
                block();
            }
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
        }
    });
}


+ (void)dispatchMainQueueBlock:(SLBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}





@end
