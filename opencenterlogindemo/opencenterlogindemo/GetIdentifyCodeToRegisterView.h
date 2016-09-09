//
//  GetIdentifyCodeToRegisterView.h
//  opencenterlogindemo
//
//  Created by 蔡宗杏 on 16/9/4.
//  Copyright © 2016年 蔡宗杏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNEThirdLoginBindPhoneStatus.h"

@protocol GetIdentifyCodeToRegisterViewDelegate <NSObject>
-(void)backAction:(UIButton *)sender;
-(void)chooseCountry;
-(void)getIdentifyingCodeAction:(UIButton *)sender;
-(void)sure_Action:(UIButton *)sender;
-(void)agreeAction:(UIButton *)sender;
@end
@interface GetIdentifyCodeToRegisterView : UIView<UITextFieldDelegate>
{
    UITextField *currentTextField;
}
@property (nonatomic, strong) id<GetIdentifyCodeToRegisterViewDelegate>delegate;
@property (nonatomic,assign) JNEThirdLoginBindPhoneStatus bindPhoneStatus;
@property (nonatomic,strong) UILabel *differentCountryName;
@property (nonatomic,strong) UILabel *areaCodeLbl;
@property (nonatomic,strong) UITextField *phoneNumTxtField;
@property (nonatomic,strong) UITextField *identifyingCodeTxtfield;
@property (nonatomic,strong) UIButton *getIdentifyingCodeBtn;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UIButton *agreeBtn;

@end
