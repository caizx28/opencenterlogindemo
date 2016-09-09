//
//  GetIdentifyCodeToRegisterViewController.m
//  opencenterlogindemo
//
//  Created by 蔡宗杏 on 16/9/4.
//  Copyright © 2016年 蔡宗杏. All rights reserved.
//

#import "GetIdentifyCodeToRegisterViewController.h"
#import "JPSApiRep.h"
#import "JPSApiRequestManger.h"
#import "JPSApiResp.h"
#import "LoginViewController.h"
#import "JPSApiUserManger.h"
@interface GetIdentifyCodeToRegisterViewController ()

@end

@implementation GetIdentifyCodeToRegisterViewController

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
    [self showRegisterView];
    
    
}

-(void)showRegisterView{
    self.registerView = [[GetIdentifyCodeToRegisterView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.registerView.delegate = self;
    [self.view addSubview:self.registerView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - alertView
- (void)showAlert:(NSString *)title withMessage:(NSString *)message withBtnTitle:(NSString *)btnTitle
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:btnTitle otherButtonTitles:nil,nil];
    alert.tag = 41785;
    [alert show];
}
-(void)getIdentifyingCodeAction:(UIButton *)sender{
    if ([self.registerView.phoneNumTxtField isFirstResponder]) {
        [self.registerView.phoneNumTxtField resignFirstResponder];
    }
    
    self.registerView.getIdentifyingCodeBtn.enabled = NO;
    if(self.registerView.phoneNumTxtField.text.length == 0){

         [self showAlert:nil withMessage:@"请输入手机号！" withBtnTitle:@"确定"];
        self.registerView.getIdentifyingCodeBtn.enabled = YES;
        return;
    }
    
    [self.registerView.getIdentifyingCodeBtn setTitle:NSLocalizedString(@"获取中",nil) forState:UIControlStateDisabled];
    self.view.userInteractionEnabled = NO;
    [self.registerView.phoneNumTxtField resignFirstResponder];
    
    NSString *phoneNum_str = [NSString stringWithFormat:@"%@", self.registerView.phoneNumTxtField.text];
    NSString *zoneNumStr = self.registerView.areaCodeLbl.text;
    NSString *zoneNumCut = [zoneNumStr substringFromIndex:1];
    NSLog(@"选择的地区%@",zoneNumCut);
    
    JPSApiGetVerificationCodeRep *parameterRep = [[JPSApiGetVerificationCodeRep alloc] init];
    parameterRep.phoneNumber = phoneNum_str;
    parameterRep.area = zoneNumCut;
    if (self.registerView.bindPhoneStatus == ThirdLoginUserNoBindPhoneForCloudAlbum || self.registerView.bindPhoneStatus == ThirdLoginUserNoBindPhoneForCellPhoneNumber){
        parameterRep.type = @"bind_mobile";
    }else{
        parameterRep.type = @"register";
    }
    [JPSApiRequestManger requestGetVerificationCodeWithObject:parameterRep completeBlock:^(JPSGetVerificationCodeResp *result, NSError *error, AFHTTPRequestOperation *op) {
        
        if (error||0) {
            self.view.userInteractionEnabled = YES;
            self.registerView.getIdentifyingCodeBtn.enabled = YES;
             NSLog(@"什么什么的好风景%ld",(long)[result.retCode integerValue]);
            if([result.retCode integerValue] == 10100){
                if (self.registerView.bindPhoneStatus == ThirdLoginUserNoBindPhoneForCloudAlbum){
                    

                    [self showAlert:nil withMessage:@"该手机号码已注册美人通行证,去登录。。" withBtnTitle:@"确定"];
                    [[JPSApiUserManger shareInstance] signOutCurrenUser];
                    LoginViewController *loginVieWController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
                    [self.navigationController pushViewController:loginVieWController animated:YES];
                    }else{

                    [self showAlert:nil withMessage:@"该手机号码已注册美人通行证,去登录。。" withBtnTitle:@"确定"];
                    LoginViewController *loginVieWController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
                    [self.navigationController pushViewController:loginVieWController animated:YES];
                    
                }
            }else{
                NSError * localError = error?[JPSApiRequestManger defaultError] : [result localError];
                NSString *errorMsg = [localError.userInfo objectForKey:@"message"];
                NSLog(@"报错信息%@",errorMsg);
 
            }
        } else {
            self.view.userInteractionEnabled = YES;
            JPSApiCheckVerificationCodeRep *rep = [[JPSApiCheckVerificationCodeRep alloc] init];
            rep.verifyCode = result.verifyCode;
            [JPSApiUserManger shareInstance].checkVerifyCodeResult = rep;
            _currentCount = 60;
            if (_timer) {
                //取消定时器
                [_timer invalidate];
                _timer = nil;
            }
            _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function) userInfo:nil repeats:YES];//每1秒运行一次function方法。
        }
    }];
    
}


-(void)sure_Action:(UIButton *)sender{
    if ([self.registerView.phoneNumTxtField isFirstResponder]) {
        [self.registerView.phoneNumTxtField resignFirstResponder];
    }
    
    if ([self.registerView.identifyingCodeTxtfield isFirstResponder]) {
        [self.registerView.identifyingCodeTxtfield resignFirstResponder];
    }
    
    if (self.registerView.phoneNumTxtField.text.length == 0) {
        [self showAlert:nil withMessage:@"请输入手机号" withBtnTitle:@"确定"];
        return;
    }
    
    if(self.registerView.identifyingCodeTxtfield.text.length == 0){
        [self showAlert:nil withMessage:@"请输入认证码" withBtnTitle:@"确定"];
        return;
    }
    [self.registerView.phoneNumTxtField resignFirstResponder];
    [self.registerView.identifyingCodeTxtfield resignFirstResponder];
    NSString *phoneNum_str = [NSString stringWithFormat:@"%@",self.registerView.phoneNumTxtField.text];
    
    NSString *zoneNumStr = self.registerView.areaCodeLbl.text;
    NSString *zoneNumCut = [zoneNumStr substringFromIndex:1];
    
//    [JNELoginCustomWaitingStateView addCustomWaitingStateView:self.view];
//    [JNELoginCustomWaitingStateView changewaitingImgViewFrame:self.registerView.sureBtn.frame.origin.y + 30*ViewRateBaseOnIP6];
    [self.registerView.sureBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    JPSApiCheckVerificationCodeRep *rep = [[JPSApiCheckVerificationCodeRep alloc] init];
    rep.phoneNumber = phoneNum_str;
    rep.area = zoneNumCut;
    rep.verifyCode = self.registerView.identifyingCodeTxtfield.text;
    if (self.registerView.bindPhoneStatus == ThirdLoginUserNoBindPhoneForCloudAlbum || self.registerView.bindPhoneStatus == ThirdLoginUserNoBindPhoneForCellPhoneNumber){
        rep.type = @"bind_mobile";
    }else{
        rep.type = @"register";
    }
    [[JPSApiUserManger shareInstance] confirmVerifyCodeForRegisterWithRep:rep completionBlock:^(id result, NSError *error) {
        if (error) {
            NSString *msg = [error.userInfo objectForKey:@"message"];
//            JPSLoginCustomUIAlertViewWithOneButton *customAlertView = [[[JPSLoginCustomUIAlertViewWithOneButton alloc] initWithFrame:SCREEN_BOUNDS] autorelease];
//            [customAlertView customAlertViewshow];
//            [customAlertView setTipContent:msg sureContent:NSLocalizedString(@"确认",nil)];
//            [self.view addSubview:customAlertView];
             [self showAlert:nil withMessage:msg withBtnTitle:@"确定"];
//            [JNELoginCustomWaitingStateView removeCustomWaitingStateView];
            [self.registerView.sureBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            return;
        }else{
            JPSCheckVerificationCodeResp *resp = result;
            
            if (self.registerView.bindPhoneStatus == ThirdLoginUserNoBindPhoneForCloudAlbum || self.registerView.bindPhoneStatus == ThirdLoginUserNoBindPhoneForCellPhoneNumber) {
                //////========设置密码＝＝＝＝＝＝＝/////
//                JNESetPasswordForNoBindUserViewController *passwordViewController = [[[JNESetPasswordForNoBindUserViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//                [self.navigationController pushViewController:passwordViewController animated:YES];
            }else{
//                SetNicknameAndPasswordViewController  *nickViewController = [[[SetNicknameAndPasswordViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//                [self.navigationController pushViewController:nickViewController animated:YES];
            }
            
//            [JNELoginCustomWaitingStateView removeCustomWaitingStateView];
            [self.registerView.sureBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            
        }
    }];
}

-(void)agreeAction:(UIButton *)sender{
    NSLog(@"同意书");
//    JPSUserLicenseAgreementViewController *agreeController = [[[JPSUserLicenseAgreementViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//    [self.navigationController pushViewController:agreeController animated:YES];
}
#pragma mark -
#pragma mark nstimer_Change
-(void)function{
    _currentCount--;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.registerView.getIdentifyingCodeBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"%d秒",nil), _currentCount] forState:UIControlStateDisabled];
        if (_currentCount == 0) {
            self.registerView.getIdentifyingCodeBtn.enabled = YES;
            [self.registerView.getIdentifyingCodeBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"重新获取",nil)] forState:UIControlStateNormal];
            if(_timer){
                [_timer invalidate];
                _timer = nil;
            }
        }
    });
}


@end
