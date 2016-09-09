//
//  JPShareContentObject.h
//  JanePlus
//
//  Created by admin on 15/8/21.
//  Copyright (c) 2015年 Allen Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JPShareConstant.h"

@interface JPShareContentObject : NSObject

@property (assign) JPShareType type;
@property (assign) JPShareMediaType mediaType; //分享类型  shareVideo shareWeb shareurl 不能为空！
@property (strong) NSString *shareContent; //分享文案
@property (strong) NSString *contentPath; //分享图片路径
@property (strong) NSString *shareURL; //分享内容的URL
@property (strong) NSString *latitude;//纬度
@property (strong) NSString *longitude;//经度
@property (strong) NSString *location;//地址
@property (strong) UIImage *thumbImage;//图标
@property (strong) NSString *thumbImageURL;//网络 图标URL
@property (strong) NSData  *shareData;//分享的数据
@property (strong) NSString *Title;//分享链接时需填title QQ空间也需要填写 ,sina也需要
@property (assign) CGFloat imageCompressRate;

- (instancetype)init;

@end
