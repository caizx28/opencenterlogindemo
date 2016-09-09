//
//  JPShareAuthorizeObject.h
//  JanePlus
//
//  Created by admin on 15/8/21.
//  Copyright (c) 2015年 Allen Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPShareConstant.h"
@interface JPShareAuthorizeObject : NSObject<NSCoding,NSCopying>
@property (strong) NSString *userID;//用户授权的唯一id,用于存储 weichat  QQ的openId,sina的userid ,poco的pocoid等值
@property (strong) NSString *token;//用户accesstoken
@property (strong) NSString *tokenSecret; //第三方平台的Secret  或者poco平台的用户密码
@property (strong) NSString *nickName;//昵称
@property (strong) NSDate *expirationDate;//过期时间
@property (strong) NSString *refreshToken;//刷新token
@property (strong) NSString *unionid;//微信才有,微信id
@property (assign) JPShareLoginType type;//授权的是那个平台
@end
