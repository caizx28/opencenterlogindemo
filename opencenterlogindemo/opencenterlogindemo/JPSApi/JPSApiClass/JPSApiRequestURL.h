//
//  JPSPocoAPIConstant.h
//  JanePlus
//
//  Created by admin on 15/9/25.
//  Copyright © 2015年 Allen Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PocoAppID			@"jianpin_app_iphone"                     //服务器用户判断是哪一个APP登陆

#define JPSRequestPrefix	[JPSApiRequestURL JPSApiRequestURLPrefix]

#pragma mark - 网络接口

#define kRequestRefreshTokenURL					[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=OAuth/RefreshToken"]                  //刷新Token
#define kRequestNewThirdPartPartnerBindURL		[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=TPOAuth/Auth"]                        //新绑定第三方账号的请求接口
#define kRequestGetVertifyCodeURL				[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=MessageVerify/SendSmsVerifyCode"]     //获取验证码（修改密码/注册）
#define kRequestJudgeVertifyCodeURL				[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=MessageVerify/CheckSmsVerifyCode"]    //验证验证码
#define kRequestRegisterURL						[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=OAuth/Register"]                      //注册
#define KRequestRegisterUserInfoURL				[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=OAuth/RegisterUserInfo"]              //填写用户注册信息
#define kRequestLoginURL						[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=OAuth/Login"]                         //登录验证
#define kRequestResetPasswordURL				[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=OAuth/Forget"]                        //忘记密码
#define kRequestUpdateUserInfoURL				[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=User/UpdateUserInfo"]                 //更新用户信息
#define kRequestGetUserInfoURL					[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=User/GetUserInfo"]                    //获取用户信息
#define kRequestUpdateUserPasswordUrl			[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=OAuth/ChangePassword"]                //更新用户密码
#define KReguestBindMobileURL					[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=OAuth/BindMobile"]                    //用户关联手机号
#define kRequestBehaviorActionURL				[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=Credit/Trigger"]                      //触发积分行为
#define kRequestGetBeautyOssUploadToken			[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=Common/GetBeautyOssToken"]            //获取瑞新云服务器授权Token
#define kRequestCreditIncomeURL					[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=Credit/CreditIncome"]                 //积分收入
#define kRequestrCreditConsumerURL				[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=Credit/CreditConsumer"]               //积分消费
#define kRequestPocoIdURL						[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=User/ChangeToPocoID"]                 //美人id 转换POCOid
#define kRequestSendToWorldURL					[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=User/PublishWorldArticle"]            //发布世界作品
#define kRequestAliyunTokenURL					[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=Common/AliyunOSSToken"]               //获取阿里云token（没有用到）
#define kRequestAddRelationURL					[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=Relation/AddRelation"]                //添加关系对象
#define kRequestDelRelationURL					[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=Relation/DelRelation"]                //删除关系对象
#define kRequestDelAllRelationURL				[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=Relation/DelAllRelation"]              //删除所有关系
#define kRequestGetRelationURL					[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=Relation/GetRelation"]                //获取关系对象列表
#define kRequestUpdateURL						[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=Init/UpdateApp"]                      //检查是否更新app

#pragma mark - Web 页面URL
#define kRequestMissonHallURL					[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=WapDuty/list"]        //任务大厅入口
#define kRequestInviteFriendURL					[NSString stringWithFormat:@"%@%@", JPSRequestPrefix, @"r=Invite/InviteFriend"] //邀请好友入口
#define kRequestPlayJanedURL					@"http://wap.adnonstop.com/jane/app_course/index.php?" //玩转简拼入口

#define URL_UPLOAD_USER_HEAD_COVER_HTTPS		@"http://os-upload.poco.cn"         //最新上传头像和封面图片接口
#define URL_UPLOAD_USER_HEAD_COVER_HTTPS_WIFI	@"http://os-upload-wifi.poco.cn"    //最新上传头像和封面图片接口
#define URL_UPLOAD_USER_HEAD_COVER_DIC			@"/poco/upload"                     //最新上传头像和封面图片接口后面的目录

@interface JPSApiRequestURL : NSObject

+ (NSString *)JPSApiRequestURLPrefix; //API版本 中转

@end
