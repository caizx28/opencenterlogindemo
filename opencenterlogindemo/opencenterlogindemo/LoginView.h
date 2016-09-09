//
//  LoginView.h
//  opencenterlogindemo
//
//  Created by 蔡宗杏 on 16/9/2.
//  Copyright © 2016年 蔡宗杏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>
-(void)backAction:(UIButton *)sender;
-(void)chooseCountry;
- (void)passwordHiddenOrVisibleAction:(UIButton *)sender;
-(void)loginAction:(UIButton *)sender;
-(void)forgetPasswordAction:(UIButton *)sender;
-(void)createAccountAction:(UIButton *)sender;
-(void)thirdLoginAction:(UIButton *)sender;
-(void)thirdBtnLongPressAction:(UILongPressGestureRecognizer *)gestureRecognizer;
@end
@interface LoginView : UIView<UITextFieldDelegate>
{
    UITextField * currentTextField;
}
@property (nonatomic,strong) id<LoginViewDelegate>delegate;
@property (nonatomic,strong) UILabel *differentCountryName;
@property (nonatomic,strong) UILabel *areaCodeLbl;
@property (nonatomic,strong) UITextField *cellPhoneTxtField;
@property (nonatomic,strong) UITextField *passwordTxtfield;
@property (nonatomic,strong) UIButton *passwordHiddenOrVisibleBtn;
@property (nonatomic,strong) UIButton *loginBtn;
@end
