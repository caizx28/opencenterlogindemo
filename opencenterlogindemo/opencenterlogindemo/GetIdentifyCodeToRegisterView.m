//
//  GetIdentifyCodeToRegisterView.m
//  opencenterlogindemo
//
//  Created by 蔡宗杏 on 16/9/4.
//  Copyright © 2016年 蔡宗杏. All rights reserved.
//

#import "GetIdentifyCodeToRegisterView.h"
#import "NSDicCacheHelper.h"
#import "UIImageViewButton.h"


#define APP_SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define IS_IPAD [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad

#define VIEW_RATE ([[UIScreen mainScreen] bounds].size.width / 640.0f)
#define ViewRateBaseOnIP6      [UIScreen mainScreen].bounds.size.width/750.0
#define IS_480_HEIGHT_LOGICPIXEL                ((APP_SCREEN_HEIGHT - 480.0f > -0.01f) && (APP_SCREEN_HEIGHT - 480.0f < 0.01f))
#define IS_568_HEIGHT_LOGICPIXEL                ((APP_SCREEN_HEIGHT - 568.0f > -0.01f) && (APP_SCREEN_HEIGHT - 568.0f < 0.01f))
#define IS_667_HEIGHT_LOGICPIXEL                ((APP_SCREEN_HEIGHT - 667.0f > -0.01f) && (APP_SCREEN_HEIGHT - 667.0f < 0.01f))
#define IS_736_HEIGHT_LOGICPIXEL                ((APP_SCREEN_HEIGHT - 736.0f > -0.01f) && (APP_SCREEN_HEIGHT - 736.0f < 0.01f))
#define IS_1024_HEIGHT_LOGICPIXEL               ((APP_SCREEN_HEIGHT - 1024.0f > -0.01f) && (APP_SCREEN_HEIGHT - 1024.0f < 0.01f))
#define ViewRateBaseOnIP6      [UIScreen mainScreen].bounds.size.width/750.0
@implementation GetIdentifyCodeToRegisterView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self initBg];
        [self initTopBar];
        [self initView];
        
    }
    return self;
}

-(void)initBg
{
    
    self.backgroundColor = [UIColor grayColor];
}
- (void)initTopBar
{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
    backBtn.backgroundColor = [UIColor  redColor];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
}

-(void)initView{
    UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake(50*ViewRateBaseOnIP6,100*ViewRateBaseOnIP6, [UIScreen mainScreen].bounds.size.width - 100*ViewRateBaseOnIP6, 80*ViewRateBaseOnIP6)];
    [tipLbl setBackgroundColor:[UIColor clearColor]];
    tipLbl.textAlignment = NSTextAlignmentCenter;
    tipLbl.lineBreakMode = NSLineBreakByWordWrapping;
    tipLbl.numberOfLines = 2;
    tipLbl.textColor = [UIColor whiteColor];
    [tipLbl setFont:[UIFont systemFontOfSize:30*ViewRateBaseOnIP6]];
    tipLbl.transform = CGAffineTransformMakeScale(1.0, 1.0);
    tipLbl.alpha = 1.0;
    [self addSubview:tipLbl];
    
    NSString *result = [[NSDicCacheHelper sharedCachier] objectForKey:@"JNEThirdLoginBindPhoneStatus"];
    if([result isEqualToString:@"ThirdLoginUserNoBindPhoneForCloudAlbum"]){//云相册
        self.bindPhoneStatus = ThirdLoginUserNoBindPhoneForCloudAlbum;
        tipLbl.text = NSLocalizedString(@"使用云相册需绑定美人通行证",nil);
    }else if([result isEqualToString:@"ThirdLoginUserNoBindPhoneForCellPhoneNumber"]){//设置里头手机号码
        self.bindPhoneStatus = ThirdLoginUserNoBindPhoneForCellPhoneNumber;
        tipLbl.text = NSLocalizedString(@"绑定手机后可用手机号登录",nil);
    }else  {
        self.bindPhoneStatus = NomalRegistrationProcess;
        tipLbl.text = @"";
    }
    
    UIImageViewButton *imgBtn = [[UIImageViewButton alloc] initWithFrame:CGRectMake(87*ViewRateBaseOnIP6, 207*ViewRateBaseOnIP6, [UIScreen mainScreen].bounds.size.width - 87*ViewRateBaseOnIP6*2, 50*ViewRateBaseOnIP6)];
    [imgBtn setBackgroundColor:[UIColor clearColor]];
    [imgBtn addTarget:self action:@selector(chooseCountry) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imgBtn];
    
    UILabel *countryLbl = [[UILabel alloc] initWithFrame:CGRectMake(0*ViewRateBaseOnIP6, 0*ViewRateBaseOnIP6, 0, 0)];
    UIFont *countryLblFont = [UIFont systemFontOfSize:32*ViewRateBaseOnIP6];
    [countryLbl setFont:countryLblFont];
    [countryLbl setText:NSLocalizedString(@"国家/地区",nil)];
    [countryLbl sizeToFit];
    [countryLbl setTextColor:[UIColor whiteColor]];
    [countryLbl setBackgroundColor:[UIColor clearColor]];
    [countryLbl setHighlightedTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
    [imgBtn addLableText:countryLbl];
    
    self.differentCountryName = [[UILabel alloc] initWithFrame:CGRectMake(countryLbl.frame.size.width + 60*ViewRateBaseOnIP6, 0, 0, 0)];
    UIFont *differentCountryNameFont = [UIFont systemFontOfSize:32*ViewRateBaseOnIP6];
    [self.differentCountryName setFont:differentCountryNameFont];
    [self.differentCountryName setText:NSLocalizedString(@"中国",nil)];
    [self.differentCountryName sizeToFit];
    [self.differentCountryName setTextColor:[UIColor whiteColor]];
    [self.differentCountryName setBackgroundColor:[UIColor clearColor]];
    [self.differentCountryName setHighlightedTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
    [imgBtn addLableText:self.differentCountryName];
    [imgBtn setFrame:CGRectMake(imgBtn.frame.origin.x, imgBtn.frame.origin.y, imgBtn.frame.size.width, self.differentCountryName.frame.size.height)];
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(imgBtn.frame.size.width - 16*ViewRateBaseOnIP6, 0*ViewRateBaseOnIP6, 10*ViewRateBaseOnIP6, 16*ViewRateBaseOnIP6)];
    [arrowImg setImage:[UIImage imageNamed:@"JANLoginPushToRightIcon.png"]];
    [arrowImg setHighlightedImage:[UIImage imageNamed:@"JANLoginPushToRightIcon.png"]];
    [arrowImg setBackgroundColor:[UIColor clearColor]];
    [imgBtn addImageView:arrowImg];
    [arrowImg setFrame:CGRectMake(arrowImg.frame.origin.x, (imgBtn.frame.size.height - arrowImg.frame.size.height)/2.0, arrowImg.frame.size.width, arrowImg.frame.size.height)];
    
    UIImageView *line5 = [[UIImageView alloc] initWithFrame:CGRectMake(71*ViewRateBaseOnIP6, 301*ViewRateBaseOnIP6, [UIScreen mainScreen].bounds.size.width - 71*ViewRateBaseOnIP6*2.0, 1)];
    [line5 setImage:[UIImage imageNamed:@"JNELoginDividingLine"]];
    [self addSubview:line5];
    
    if (IS_667_HEIGHT_LOGICPIXEL){
        [imgBtn setFrame:CGRectMake(imgBtn.frame.origin.x, 238*ViewRateBaseOnIP6, imgBtn.frame.size.width, imgBtn.frame.size.height)];
    }
    
    UIImageView *cellPhoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(87*ViewRateBaseOnIP6, 333*ViewRateBaseOnIP6, 40*ViewRateBaseOnIP6, 40*ViewRateBaseOnIP6)];
    [cellPhoneImgView setImage:[UIImage imageNamed:@"JANLoginCellphoneicon.png"]];
    [self addSubview:cellPhoneImgView];
    
    self.areaCodeLbl = [[UILabel alloc] initWithFrame:CGRectMake(87*ViewRateBaseOnIP6 + 40*ViewRateBaseOnIP6 + 10*ViewRateBaseOnIP6, 329*ViewRateBaseOnIP6, 100*ViewRateBaseOnIP6, 50*ViewRateBaseOnIP6)];
    UIFont *areaCodeFont = [UIFont systemFontOfSize:32*ViewRateBaseOnIP6];
    [self.areaCodeLbl setFont:areaCodeFont];
    [self.areaCodeLbl setText:@"+86"];
    
    self.areaCodeLbl.textAlignment = NSTextAlignmentRight;
    [self.areaCodeLbl setTextColor:[UIColor whiteColor]];
    [self.areaCodeLbl setBackgroundColor:[UIColor clearColor]];
    [self.areaCodeLbl setHighlightedTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
    [self addSubview:self.areaCodeLbl];
    
    self.phoneNumTxtField = [[UITextField alloc] initWithFrame:CGRectMake(219*ViewRateBaseOnIP6 + 40*ViewRateBaseOnIP6 + 28*ViewRateBaseOnIP6, 329*ViewRateBaseOnIP6, 350*ViewRateBaseOnIP6, 50*ViewRateBaseOnIP6)];
    self.phoneNumTxtField.backgroundColor = [UIColor clearColor];
    self.phoneNumTxtField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"请输入手机号码",nil)];
    self.phoneNumTxtField.text = @"";
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        self.phoneNumTxtField.tintColor = [UIColor redColor];
    }
    [self.phoneNumTxtField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneNumTxtField setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [self.phoneNumTxtField setFont:[UIFont systemFontOfSize:30*ViewRateBaseOnIP6]];
    self.phoneNumTxtField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneNumTxtField.tag = 0;
    self.phoneNumTxtField.clearButtonMode = UITextFieldViewModeAlways;
    [self.phoneNumTxtField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneNumTxtField.delegate = self;
    
    [self addSubview:self.phoneNumTxtField];
    
    if(IS_667_HEIGHT_LOGICPIXEL){
        [self.phoneNumTxtField setFrame:CGRectMake(self.phoneNumTxtField.frame.origin.x, self.phoneNumTxtField.frame.origin.y, 391*ViewRateBaseOnIP6, self.phoneNumTxtField.frame.size.height)];
        [self.areaCodeLbl setFrame:CGRectMake(self.areaCodeLbl.frame.origin.x, 330*ViewRateBaseOnIP6, self.areaCodeLbl.frame.size.width, self.areaCodeLbl.frame.size.height)];
    }else if (IS_480_HEIGHT_LOGICPIXEL){
        [self.areaCodeLbl setFrame:CGRectMake(self.areaCodeLbl.frame.origin.x, 326*ViewRateBaseOnIP6, self.areaCodeLbl.frame.size.width, self.areaCodeLbl.frame.size.height)];
        
    }
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(71*ViewRateBaseOnIP6, 400*ViewRateBaseOnIP6, [UIScreen mainScreen].bounds.size.width - 71*ViewRateBaseOnIP6*2.0, 1)];
    [line1 setImage:[UIImage imageNamed:@"JNELoginDividingLine"]];
    [self addSubview:line1];
    
    UIImageView *identifyCodeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(87*ViewRateBaseOnIP6, 434*ViewRateBaseOnIP6, 40*ViewRateBaseOnIP6, 40*ViewRateBaseOnIP6)];
    [identifyCodeImgView setImage:[UIImage imageNamed:@"JANLoginIdentifyCodeicon.png"]];
    [self addSubview:identifyCodeImgView];
    
    self.identifyingCodeTxtfield = [[UITextField alloc] initWithFrame:CGRectMake(219*ViewRateBaseOnIP6 + 40*ViewRateBaseOnIP6 + 28*ViewRateBaseOnIP6, 430*ViewRateBaseOnIP6, 250*ViewRateBaseOnIP6, 50*ViewRateBaseOnIP6)];
    self.identifyingCodeTxtfield.backgroundColor = [UIColor clearColor];
    self.identifyingCodeTxtfield.placeholder = [NSString stringWithFormat:NSLocalizedString(@"验证码",nil)];
    self.identifyingCodeTxtfield.keyboardType = UIKeyboardTypeDefault;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        self.identifyingCodeTxtfield.tintColor = [UIColor orangeColor];
    }
    [self.identifyingCodeTxtfield setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    [self.identifyingCodeTxtfield setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [self.identifyingCodeTxtfield setFont:[UIFont systemFontOfSize:30*ViewRateBaseOnIP6]];
    self.identifyingCodeTxtfield.delegate = self;
    self.identifyingCodeTxtfield.tag = 1;
    self.identifyingCodeTxtfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.identifyingCodeTxtfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.identifyingCodeTxtfield];
    
//    if ([[JXLanguangeManger sharedInstance] currentLanguageType] == JXLanguageInEnglish){
//        [self.identifyingCodeTxtfield setFrame:CGRectMake(200*ViewRateBaseOnIP6, self.identifyingCodeTxtfield.origin.y, self.identifyingCodeTxtfield.size.width, self.identifyingCodeTxtfield.frame.size.height )];
//    }
    
    UIImageView *verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(114*ViewRateBaseOnIP6 + 40*ViewRateBaseOnIP6 + 28*ViewRateBaseOnIP6 + 270*ViewRateBaseOnIP6, 437*ViewRateBaseOnIP6, 1, 36*ViewRateBaseOnIP6)];
    [verticalLine setImage:[UIImage imageNamed:@"JANLoginVerticalDividingLine.png"]];
    [self addSubview:verticalLine];
    
    self.getIdentifyingCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(164*ViewRateBaseOnIP6 + 40*ViewRateBaseOnIP6 + 28*ViewRateBaseOnIP6 + 238*ViewRateBaseOnIP6, 430*ViewRateBaseOnIP6, 160*ViewRateBaseOnIP6, 50*ViewRateBaseOnIP6)];
    [self.getIdentifyingCodeBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"获取验证码",nil)] forState:UIControlStateNormal];
    [self.getIdentifyingCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:26*ViewRateBaseOnIP6]];
    [self.getIdentifyingCodeBtn setBackgroundColor:[UIColor clearColor]];
    [self.getIdentifyingCodeBtn addTarget:self action:@selector(getIdentifyingCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.getIdentifyingCodeBtn];
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(71*ViewRateBaseOnIP6, 500*ViewRateBaseOnIP6, [UIScreen mainScreen].bounds.size.width - 71*ViewRateBaseOnIP6*2.0, 1)];
    [line2 setImage:[UIImage imageNamed:@"JNELoginDividingLine"]];
    [self addSubview:line2];
    
    self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(70*ViewRateBaseOnIP6, line2.frame.origin.y+line2.frame.size.height+60*ViewRateBaseOnIP6, [UIScreen mainScreen].bounds.size.width - 140*ViewRateBaseOnIP6, 102*ViewRateBaseOnIP6)];//130  102
    [self.sureBtn setBackgroundColor:[UIColor clearColor]];
    [self.sureBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"确定",nil)] forState:UIControlStateNormal];
    UIImage *rawEntryBackground = [UIImage imageNamed:@"JANLoginCompleteIcon"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:65.0/2.0 topCapHeight:rawEntryBackground.size.height/2.0 ];
    [self.sureBtn setBackgroundImage:entryBackground forState:UIControlStateNormal];
    
    UIImage *tntryBackground = [UIImage imageNamed:@"JANLoginCompleteIcon_hover"];
    UIImage *ptryBackground = [tntryBackground stretchableImageWithLeftCapWidth:65.0/2.0 topCapHeight:tntryBackground.size.height/2.0 ];
    [self.sureBtn setBackgroundImage:ptryBackground forState:UIControlStateHighlighted];
    
    [self.sureBtn.titleLabel setFont:[UIFont systemFontOfSize:38*ViewRateBaseOnIP6]];
    [self.sureBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sure_Action:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sureBtn];
    self.sureBtn.enabled = YES;
    self.sureBtn.alpha = 1.0;
    
    self.agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0*ViewRateBaseOnIP6, 715*ViewRateBaseOnIP6, APP_SCREEN_WIDTH, 28*ViewRateBaseOnIP6)];
    [self.agreeBtn setBackgroundColor:[UIColor clearColor]];
    [self.agreeBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"注册即表示同意《美人信息用户协议》",nil)] forState:UIControlStateNormal];
    [self.agreeBtn.titleLabel setFont:[UIFont systemFontOfSize:22*ViewRateBaseOnIP6]];
    [self.agreeBtn addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.agreeBtn];
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [currentTextField resignFirstResponder];
}
#pragma mark Action
-(void)backAction:(UIButton *)sender{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(backAction:)])
    {[self.delegate performSelector:@selector(backAction:) withObject:sender];}
}

-(void)chooseCountry{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(chooseCountry)])
    {
        [self.delegate performSelector:@selector(chooseCountry)];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if(self.identifyingCodeTxtfield.text.length>6){
        NSString *identifyCodeStr = self.identifyingCodeTxtfield.text;
        if (identifyCodeStr.length > 6) {
            identifyCodeStr = [identifyCodeStr substringToIndex:6];
            self.identifyingCodeTxtfield.text = identifyCodeStr;
        }
    }
    
    BOOL canLogin = false;
    
    if (self.identifyingCodeTxtfield.text.length >= 1 && self.phoneNumTxtField.text.length >= 1){
        canLogin = true;
    }
    
    self.sureBtn.enabled = YES;
    self.sureBtn.alpha = 1.0;
    
}
-(void)getIdentifyingCodeAction:(UIButton *)sender{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(getIdentifyingCodeAction:)])
    {[self.delegate performSelector:@selector(getIdentifyingCodeAction:) withObject:sender];}
}

-(void)sure_Action:(UIButton *)sender{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(sure_Action:)])
    {[self.delegate performSelector:@selector(sure_Action:) withObject:sender];}
}

-(void)agreeAction:(UIButton *)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(agreeAction:)]) {
        [self.delegate performSelector:@selector(agreeAction:) withObject:sender];
    }
}


@end
