//
//  GetIdentifyCodeToRegisterViewController.h
//  opencenterlogindemo
//
//  Created by 蔡宗杏 on 16/9/4.
//  Copyright © 2016年 蔡宗杏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertViewAddition.h"
#import "GetIdentifyCodeToRegisterView.h"
@protocol GetIdentifyCodeToRegisterViewControllerDelegate <NSObject>

-(void)goBackToLoginView:(NSString *)textStr;

@end
@interface GetIdentifyCodeToRegisterViewController : UIViewController<GetIdentifyCodeToRegisterViewDelegate,UIAlertViewDelegate>
{
    int _currentCount;
    NSTimer *_timer;
}
@property (nonatomic,strong) GetIdentifyCodeToRegisterView *registerView;
@property (nonatomic,strong) id<GetIdentifyCodeToRegisterViewControllerDelegate>delegate;
@end
