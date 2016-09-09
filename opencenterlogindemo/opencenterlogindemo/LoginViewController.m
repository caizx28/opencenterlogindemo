//
//  LoginViewController.m
//  opencenterlogindemo
//
//  Created by 蔡宗杏 on 16/9/2.
//  Copyright © 2016年 蔡宗杏. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "CLReporting.h"
#import "NSDicCacheHelper.h"
#import "GetIdentifyCodeToRegisterViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "JPSApiRep.h"
#import "JPSApiUserManger.h"

@interface LoginViewController ()
@property (nonatomic,strong)LoginView *loginView;
@end

@implementation LoginViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setFrame:[[UIScreen mainScreen] bounds]];
    }


    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoginView];
}


-(void)showLoginView{
    self.loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.loginView.delegate = self;
    
    [self.view addSubview:self.loginView];
}

-(void)showWhichCountry{
    self.loginView.differentCountryName.text = NSLocalizedString(@"中国",nil);
    self.loginView.areaCodeLbl.text = @"+86";
    
    [self.loginView.differentCountryName sizeToFit];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - alertView
- (void)showAlert:(NSString *)title withMessage:(NSString *)message withBtnTitle:(NSString *)btnTitle
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:btnTitle otherButtonTitles:nil,nil];
    alert.tag = 41785;
    [alert show];
}

//点击登陆
-(void)loginAction:(UIButton *)sender{
    [[CLReporting sharedInstance] pushEventNoAppId:1200496 paraString:nil];
    if ([self.loginView.cellPhoneTxtField isFirstResponder]) {
        [self.loginView.cellPhoneTxtField resignFirstResponder];
    }
    
    if([self.loginView.passwordTxtfield isFirstResponder]){
        [self.loginView.passwordTxtfield resignFirstResponder];
    }
    
    if(self.loginView.cellPhoneTxtField.text.length == 0) {

        [self showAlert:nil withMessage:@"请输入手机号" withBtnTitle:@"确定"];
        return;
    }
    
    if(self.loginView.cellPhoneTxtField.text.length == 1) {
         [self showAlert:nil withMessage:@"手机号gges" withBtnTitle:@"确定"];
        return;
    }
    NSLog(@"判断网络状态=====+%d",![AFNetworkReachabilityManager sharedManager].isReachable);
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        [self showAlert:nil withMessage:@"网络不行" withBtnTitle:@"确定"];
        return ;
    }
    
    if(self.loginView.passwordTxtfield.text.length == 0) {
        [self showAlert:nil withMessage:@"请输入密码" withBtnTitle:@"确定"];
        return;
    }
    
    [self.loginView.cellPhoneTxtField resignFirstResponder];
    [self.loginView.passwordTxtfield resignFirstResponder];
    
    NSString *cellPhoneStr = [NSString stringWithFormat:@"%@", self.loginView.cellPhoneTxtField.text];
    NSString *passwordStr = [NSString stringWithFormat:@"%@", self.loginView.passwordTxtfield.text];
    
    
    NSString *zoneNumStr = self.loginView.areaCodeLbl.text;
    NSString *zoneNumCut = [zoneNumStr substringFromIndex:1];
    
    JPSApiMobileSignInRep *rep = [[JPSApiMobileSignInRep alloc] init];
    rep.phoneNumber = cellPhoneStr;
    rep.password = passwordStr;
    rep.area = zoneNumCut;
//    [JNELoginCustomWaitingStateView addCustomWaitingStateView:self.view];
    UIView *loginBunSuperView =  self.loginView.loginBtn.superview;
//    [JNELoginCustomWaitingStateView changewaitingImgViewFrame:loginBunSuperView.frame.origin.y + self.loginView.loginBtn.frame.origin.y + 30*ViewRateBaseOnIP6];
    [self.loginView.loginBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [[JPSApiUserManger shareInstance] signInWithMobieRep:rep completionBlock:^(id result, NSError *error) {
        if (error) {
            NSString *errorMsg = [error.userInfo objectForKey:@"message"];
            [self showAlert:nil withMessage:errorMsg withBtnTitle:@"确定"];
//            [JNELoginCustomWaitingStateView removeCustomWaitingStateView];
            [self.loginView.loginBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            return ;
        }else {
            [[JPSApiUserManger shareInstance].currentUser obtainSqureIdWithCompletionBlock:^(id result, NSError *error) {
                [[JPSApiUserManger shareInstance].currentUser obtainUserInfoWithCompletionBlock:^(id result, NSError *error) {
                    NSLog(@"block传回登陆控制器的用户信息%@",result);
//                    [JNELoginCustomWaitingStateView removeCustomWaitingStateView];
                    [self.loginView.loginBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kJPSUserLoginSuccessNotification
                                                                        object:nil];
                    
                    NSString *bindStatusResult = [[NSDicCacheHelper sharedCachier] objectForKey:@"JNEThirdLoginBindPhoneStatus"];
                    JNEThirdLoginBindPhoneStatus bindPhoneStatus = NomalRegistrationProcess;
                    if([bindStatusResult isEqualToString:@"ThirdLoginUserNoBindPhoneForCloudAlbum"]){
                        bindPhoneStatus = ThirdLoginUserNoBindPhoneForCloudAlbum;
                        [[NSDicCacheHelper sharedCachier] setObject:[NSString stringWithFormat:@"NomalRegistrationProcess"] forKey:@"JNEThirdLoginBindPhoneStatus"];
                        
//                        if (self.navigationController.transitioningDelegate) {
//                            JNESwipeTransitionDelegate *transitionDelegate = self.navigationController.transitioningDelegate;
//                            transitionDelegate.targetEdge = UIRectEdgeLeft;
//                        }
//                        [self.navigationController dismissViewControllerAnimated:YES completion:^{
//                            nil;
//                        }];
                        
                    }else  {
                        [[NSDicCacheHelper sharedCachier] removeObjectForKey:@"JNEThirdLoginBindPhoneStatus"];
                        bindPhoneStatus = NomalRegistrationProcess;
                        [self.navigationController popViewControllerAnimated:YES];
                         NSLog(@"登陆成功");
                    }
                    
                }];
                
            }];
        }
    }];
}

//创建账号，弹去注册界面
-(void)createAccountAction:(UIButton *)sender{
    [[NSDicCacheHelper sharedCachier] removeObjectForKey:@"JNEThirdLoginBindPhoneStatus"];
    [[CLReporting sharedInstance] pushEventNoAppId:1200494 paraString:nil];
    GetIdentifyCodeToRegisterViewController *getIdentifyCodeToRegisterViewController = [[GetIdentifyCodeToRegisterViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:getIdentifyCodeToRegisterViewController animated:YES];
}
-(void)thirdLoginAction:(UIButton *)sender{
    NSUInteger tag = sender.tag;
    
    NSDictionary * mappingDictionary = @{@(0):@"1200497",
                                         @(1):@"1200498"
                                         };
    
    
    NSString * message = [mappingDictionary objectForKey:@(tag)];
    [[CLReporting sharedInstance] pushEventNoAppId:message paraString:nil];
    
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        [self showAlert:nil withMessage:@"网络不行" withBtnTitle:@"确定"];
        return ;
    }
    
    switch (tag) {
        case 0:
            [[JPSApiUserManger shareInstance] signInWithThirdParnerType:JPShareLoginTypeWechat delegate:self];
            break;
        case 1:
            [[JPSApiUserManger shareInstance] signInWithThirdParnerType:JPShareLoginTypeSina delegate:self];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark JPSApiUserThirdParnerAuthorizeDelegate

- (void)user:(JPSApiUser*)user  beginThirdParnerAuthorize:(id<JPShareAPI>)share{
    
}
- (void)user:(JPSApiUser*)user  thirdParnerAuthorizeCodeSuccess:(id<JPShareAPI>)share{
    
//    [JNELoginCustomWaitingStateView addCustomWaitingStateView:self.view];
    UIView *loginBunSuperView =  self.loginView.loginBtn.superview;
//    [JNELoginCustomWaitingStateView changewaitingImgViewFrame:loginBunSuperView.frame.origin.y + self.loginView.loginBtn.frame.origin.y + 30*ViewRateBaseOnIP6];
    
    [self.loginView.loginBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}
- (void)user:(JPSApiUser*)user  successedThirdParnerAuthorize:(id<JPShareAPI>)share{
    
//    [JNELoginCustomWaitingStateView addCustomWaitingStateView:self.view];
    
    UIView *loginBunSuperView =  self.loginView.loginBtn.superview;
//    [JNELoginCustomWaitingStateView changewaitingImgViewFrame:loginBunSuperView.frame.origin.y + self.loginView.loginBtn.frame.origin.y + 30*ViewRateBaseOnIP6];
    [self.loginView.loginBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}
- (void)user:(JPSApiUser*)user  failThirdParnerAuthorize:(id<JPShareAPI>)share{
    
//    [JNELoginCustomWaitingStateView removeCustomWaitingStateView];
    [self.loginView.loginBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}

- (void)user:(JPSApiUser*)user  successAuthorize:(NSDictionary*)userInfo{
    [[JPSApiUserManger shareInstance].currentUser obtainSqureIdWithCompletionBlock:^(id result, NSError *error) {
        [[JPSApiUserManger shareInstance].currentUser obtainUserInfoWithCompletionBlock:^(id result, NSError *error) {
            if (error) {
                ;
            } else {
                ;
            }
//            [JNELoginCustomWaitingStateView removeCustomWaitingStateView];
            [self.loginView.loginBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter] postNotificationName:kJPSUserLoginSuccessNotification
                                                                object:nil];
            
        }];
        [[JPSApiUserManger shareInstance].currentUser actionBehaviorWithBehaviorId:kJPSApiUserThirdParnerSignInActionID];
    }];
}

- (void)user:(JPSApiUser*)user  failAuthorize:(NSError*)error{
    NSError *eror = error;
    if(eror){
        NSString *code = [NSString stringWithFormat:@"%@",@(error.code)];
        if ([code isEqualToString:@"-4"]) {//是删除用户，强制退出
            [self showAlert:nil withMessage:@"抱歉，您的账号已受限制，无法登录" withBtnTitle:@"确定"];

        }
    }
    
//    [JNELoginCustomWaitingStateView removeCustomWaitingStateView];
    [self.loginView.loginBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 500) {
        if (buttonIndex == 0) {
            self.loginView.passwordTxtfield.text = nil;
        }
    }
}

#pragma mark -
#pragma mark JPSLoginCustomUIAlertViewDelegate



@end
