//
//  JPShareContentObjectTranslater.h
//  JanePlus
//
//  Created by admin on 15/12/21.
//  Copyright © 2015年 beautyInformation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JPShareContentObject;

typedef NS_ENUM(NSUInteger, JPShareContentObjectTranslaterType) {
    JPShareContentObjectTranslaterTypeOfDefault = 0,   //默认转换类型,
    JPShareContentObjectTranslaterTypeOfAppRecommond  
};


/**
 *  实现该协议，对需要进行信息加工的的平台，进行原始分享内容对象的，信息加工。
 */

@protocol JPShareContentObjectTranslater <NSObject>
- (JPShareContentObject*)tranlateWithContentObject:(JPShareContentObject*)contentObject;
@end

@interface JPShareBaseObjectTranslater : NSObject<JPShareContentObjectTranslater>
- (JPShareContentObject*)tranlateWithContentObject:(JPShareContentObject*)contentObject;
@end

@interface JPShareContentObjectAppRecommondTranslater : JPShareBaseObjectTranslater
- (JPShareContentObject*)tranlateWithContentObject:(JPShareContentObject*)contentObject;
@end
