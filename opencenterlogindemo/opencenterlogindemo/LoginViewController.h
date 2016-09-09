//
//  LoginViewController.h
//  opencenterlogindemo
//
//  Created by 蔡宗杏 on 16/9/2.
//  Copyright © 2016年 蔡宗杏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
@interface LoginViewController : UIViewController<LoginViewDelegate,UIAlertViewDelegate>
{
    BOOL isaddProgressView;
}

@property (nonatomic,retain) UIView *bigWaitingView;
@property (nonatomic,retain) UIImageView *waitingImgView;
@end
