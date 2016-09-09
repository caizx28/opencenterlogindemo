//
//  LoginView.m
//  opencenterlogindemo
//
//  Created by 蔡宗杏 on 16/9/2.
//  Copyright © 2016年 蔡宗杏. All rights reserved.
//

#import "LoginView.h"
#import "LoginViewController.h"
#import "UIView+MGExtension.h"
#import "UIImageViewButton.h"
#import "UnlockTypeChecker.h"
#import "JPShareConstant.h"


@interface LoginView()

@property (nonatomic,assign) UIImageView *blurimageView;
@property (nonatomic,retain) NSMutableArray *shareBottomSubViewArray;

@end
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
@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor grayColor]];
//        [self initBg];
        [self initTopBar];
        [self initView];
        [self initBottomView];
        
    }
    return self;
}
-(void)initBg
{

    self.backgroundColor = [UIColor whiteColor];
}
- (void)initTopBar
{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
    backBtn.backgroundColor = [UIColor  redColor];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];

}

- (void)backAction:(UIButton *)sender
{

    UIViewController *Vc = [self getCurrentViewController];
    [Vc dismissViewControllerAnimated:YES completion:^{
        NSLog(@"成功返回");
    }];
}
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}



-(void)initView{
    
    
    UIView *allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,  [UIScreen mainScreen].bounds.size.height - 90*ViewRateBaseOnIP6 - 133*ViewRateBaseOnIP6 - 50*ViewRateBaseOnIP6 - 13*ViewRateBaseOnIP6)];
    [self addSubview:allView];
    
    if (IS_IPAD) {
        [allView setFrame:CGRectMake(allView.frame.origin.x, allView.frame.origin.y + 80, allView.width, allView.height)];
    }else{
        [allView setFrame:CGRectMake(allView.frame.origin.x, allView.frame.origin.y + 126*ViewRateBaseOnIP6, allView.width, allView.height)];
    }
    
    
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((allView.frame.size.width  - 186*ViewRateBaseOnIP6)/2, 207*ViewRateBaseOnIP6 - 58*ViewRateBaseOnIP6 - 169*ViewRateBaseOnIP6, 186*ViewRateBaseOnIP6, 169*ViewRateBaseOnIP6)];
    
    if (IS_IPAD) {
        [titleImageView setFrame:CGRectMake((allView.frame.size.width  - (NSInteger)(186*0.8))/2, 207*ViewRateBaseOnIP6 - 58*ViewRateBaseOnIP6 - (NSInteger)(169*0.8) - 60, (NSInteger)(186*0.8), (NSInteger)(169*0.8))];
    }
    
    [titleImageView setBackgroundColor:[UIColor clearColor]];
    titleImageView.image = [UIImage imageNamed:@"JNELoginViewTitle.png"];
//    [titleImageView setImage:[UIImage imageNamed:@"JNELoginViewTitle.png"];
    [allView addSubview:titleImageView];
    
    UIImageViewButton *imgBtn = [[UIImageViewButton alloc] initWithFrame:CGRectMake(87*ViewRateBaseOnIP6, 207*ViewRateBaseOnIP6, [UIScreen mainScreen].bounds.size.width - 87*ViewRateBaseOnIP6*2, 50*ViewRateBaseOnIP6)];
    [imgBtn setBackgroundColor:[UIColor clearColor]];
    [imgBtn addTarget:self action:@selector(chooseCountry) forControlEvents:UIControlEventTouchUpInside];
    [allView addSubview:imgBtn];
    
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
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(imgBtn.frame.size.width - 16*ViewRateBaseOnIP6, 0*ViewRateBaseOnIP6, 10*ViewRateBaseOnIP6, 16*ViewRateBaseOnIP6)] ;
    [arrowImg setImage:[UIImage imageNamed:@"JANLoginPushToRightIcon.png"]];
    [arrowImg setHighlightedImage:[UIImage imageNamed:@"JANLoginPushToRightIcon.png"]];
    [arrowImg setBackgroundColor:[UIColor clearColor]];
    [imgBtn addImageView:arrowImg];
    [arrowImg setFrame:CGRectMake(arrowImg.frame.origin.x, (imgBtn.frame.size.height - arrowImg.frame.size.height)/2.0, arrowImg.frame.size.width, arrowImg.frame.size.height)];
    
    UIImageView *line5 = [[UIImageView alloc] initWithFrame:CGRectMake(71*ViewRateBaseOnIP6, 301*ViewRateBaseOnIP6, [UIScreen mainScreen].bounds.size.width - 71*ViewRateBaseOnIP6*2.0, 1)];
    [line5 setImage:[UIImage imageNamed:@"JNELoginDividingLine"]];
    [allView addSubview:line5];
    
    if(IS_IPAD){
        [imgBtn setFrame:CGRectMake(imgBtn.frame.origin.x, 100*ViewRateBaseOnIP6, imgBtn.frame.size.width, imgBtn.frame.size.height)];
        [line5 setFrame:CGRectMake(line5.frame.origin.x, 140*VIEW_RATE, line5.frame.size.width, line5.frame.size.height)];
    }else if(IS_480_HEIGHT_LOGICPIXEL){
        [imgBtn setFrame:CGRectMake(imgBtn.frame.origin.x, 237*ViewRateBaseOnIP6, imgBtn.frame.size.width, imgBtn.frame.size.height)];
    }else if (IS_667_HEIGHT_LOGICPIXEL){
        [imgBtn setFrame:CGRectMake(imgBtn.frame.origin.x, 238*ViewRateBaseOnIP6, imgBtn.frame.size.width, imgBtn.frame.size.height)];
    }
    
    UIImageView *phoneBgView = [[UIImageView alloc] initWithFrame:CGRectMake(87*ViewRateBaseOnIP6, 333*ViewRateBaseOnIP6, [UIScreen mainScreen].bounds.size.width - 87*ViewRateBaseOnIP6*2, 50*ViewRateBaseOnIP6)];
    phoneBgView.tag = 0;
    [phoneBgView setBackgroundColor:[UIColor clearColor]];
    phoneBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapPhoneBgView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneBgTap:)];
    [phoneBgView addGestureRecognizer:singleTapPhoneBgView];
    [allView addSubview:phoneBgView];
    
    UIImageView *cellPhoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(87*ViewRateBaseOnIP6, 333*ViewRateBaseOnIP6, 40*ViewRateBaseOnIP6, 40*ViewRateBaseOnIP6)];
    [cellPhoneImgView setImage:[UIImage imageNamed:@"JANLoginCellphoneicon.png"]];
    [allView addSubview:cellPhoneImgView];
    
    self.areaCodeLbl = [[UILabel alloc]init];
    self.areaCodeLbl.frame = CGRectMake(87*ViewRateBaseOnIP6 + 40*ViewRateBaseOnIP6 + 10*ViewRateBaseOnIP6, 334*ViewRateBaseOnIP6, 100*ViewRateBaseOnIP6, 50*ViewRateBaseOnIP6);
//    self.areaCodeLbl = [[UILabel alloc] initWithFrame:CGRectMake(87*ViewRateBaseOnIP6 + 40*ViewRateBaseOnIP6 + 10*ViewRateBaseOnIP6, 334*ViewRateBaseOnIP6, 100*ViewRateBaseOnIP6, 50*ViewRateBaseOnIP6)];
    UIFont *areaCodeFont = [UIFont systemFontOfSize:32*ViewRateBaseOnIP6];
    [self.areaCodeLbl setFont:areaCodeFont];
    [self.areaCodeLbl setText:@"+86"];
    self.areaCodeLbl.textAlignment = NSTextAlignmentRight;
    [self.areaCodeLbl sizeToFit];
    [self.areaCodeLbl setTextColor:[UIColor whiteColor]];
    [self.areaCodeLbl setBackgroundColor:[UIColor clearColor]];
    [self.areaCodeLbl setHighlightedTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
    [allView addSubview:self.areaCodeLbl];
    
    self.cellPhoneTxtField = [[UITextField alloc] initWithFrame:CGRectMake(87*ViewRateBaseOnIP6 + 40*ViewRateBaseOnIP6 + 160*ViewRateBaseOnIP6, 329*ViewRateBaseOnIP6, 350*ViewRateBaseOnIP6, 50*ViewRateBaseOnIP6)];
    self.cellPhoneTxtField.backgroundColor = [UIColor clearColor];
    self.cellPhoneTxtField.keyboardType = UIKeyboardTypePhonePad;
    self.cellPhoneTxtField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"请输入手机号码",nil)];
    self.cellPhoneTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.cellPhoneTxtField.text = @"";
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        self.cellPhoneTxtField.tintColor = [UIColor redColor];
    }
    [self.cellPhoneTxtField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    self.cellPhoneTxtField.delegate = self;
    [self.cellPhoneTxtField setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [self.cellPhoneTxtField setFont:[UIFont systemFontOfSize:30*ViewRateBaseOnIP6]];
    self.cellPhoneTxtField.tag = 0;
    [self.cellPhoneTxtField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [allView addSubview:self.cellPhoneTxtField];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(71*ViewRateBaseOnIP6, 400*ViewRateBaseOnIP6, [UIScreen mainScreen].bounds.size.width - 71*ViewRateBaseOnIP6*2, 1)];
    [line1 setImage:[UIImage imageNamed:@"JNELoginDividingLine"]];
    [allView addSubview:line1];
    
    if(IS_IPAD){
        [cellPhoneImgView setFrame:CGRectMake(cellPhoneImgView.frame.origin.x, 200*ViewRateBaseOnIP6, cellPhoneImgView.frame.size.width, cellPhoneImgView.frame.size.height)];
        [self.areaCodeLbl setFrame:CGRectMake(self.areaCodeLbl.frame.origin.x, 201*ViewRateBaseOnIP6, self.areaCodeLbl.frame.size.width, self.areaCodeLbl.frame.size.height)];
        [self.cellPhoneTxtField setFrame:CGRectMake(self.cellPhoneTxtField.frame.origin.x, 196*ViewRateBaseOnIP6, self.cellPhoneTxtField.frame.size.width, self.cellPhoneTxtField.frame.size.height)];
        [line1 setFrame:CGRectMake(line1.frame.origin.x, 270*ViewRateBaseOnIP6, line1.frame.size.width, line1.frame.size.height)];
    }else if (IS_667_HEIGHT_LOGICPIXEL){
        [self.areaCodeLbl setFrame:CGRectMake(self.areaCodeLbl.frame.origin.x, 330*ViewRateBaseOnIP6, self.areaCodeLbl.frame.size.width, self.areaCodeLbl.frame.size.height)];
    }else if (IS_480_HEIGHT_LOGICPIXEL){
        [self.areaCodeLbl setFrame:CGRectMake(self.areaCodeLbl.frame.origin.x, 326*ViewRateBaseOnIP6, self.areaCodeLbl.frame.size.width, self.areaCodeLbl.frame.size.height)];
        [self.cellPhoneTxtField setFrame:CGRectMake(self.cellPhoneTxtField.frame.origin.x, 328*ViewRateBaseOnIP6, self.cellPhoneTxtField.frame.size.width, self.cellPhoneTxtField.frame.size.height)];
    }else if (IS_736_HEIGHT_LOGICPIXEL){
        [self.areaCodeLbl setFrame:CGRectMake(self.areaCodeLbl.frame.origin.x, 326*ViewRateBaseOnIP6, self.areaCodeLbl.frame.size.width, self.areaCodeLbl.frame.size.height)];
    }
    
    UIImageView *pwdBgView = [[UIImageView alloc] initWithFrame:CGRectMake(87*ViewRateBaseOnIP6, 434*ViewRateBaseOnIP6, [UIScreen mainScreen].bounds.size.width - 87*ViewRateBaseOnIP6*2, 50*ViewRateBaseOnIP6)];
    pwdBgView.tag = 1;
    [pwdBgView setBackgroundColor:[UIColor clearColor]];
    pwdBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapPWDBgView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneBgTap:)];
    [pwdBgView addGestureRecognizer:singleTapPWDBgView];
    [allView addSubview:pwdBgView];
    
    
    UIImageView *pwImgView = [[UIImageView alloc] initWithFrame:CGRectMake(87*ViewRateBaseOnIP6, 434*ViewRateBaseOnIP6, 40*ViewRateBaseOnIP6, 40*ViewRateBaseOnIP6)];
    [pwImgView setImage:[UIImage imageNamed:@"JANLoginPasswordicon.png"]];
    [allView addSubview:pwImgView];
    
    self.passwordTxtfield = [[UITextField alloc] initWithFrame:CGRectMake(87*ViewRateBaseOnIP6 + 40*ViewRateBaseOnIP6 + 160*ViewRateBaseOnIP6, 430*ViewRateBaseOnIP6, 300*ViewRateBaseOnIP6, 50*ViewRateBaseOnIP6)];
    self.passwordTxtfield.backgroundColor = [UIColor clearColor];
    self.passwordTxtfield.keyboardType = UIKeyboardTypeDefault;
    self.passwordTxtfield.secureTextEntry = YES;
    self.passwordTxtfield.placeholder = [NSString stringWithFormat:NSLocalizedString(@"请输入密码",nil)];
    self.passwordTxtfield.text = @"";
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        self.passwordTxtfield.tintColor = [UIColor orangeColor];
    }
    [self.passwordTxtfield setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    self.passwordTxtfield.delegate = self;
    [self.passwordTxtfield setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [self.passwordTxtfield setFont:[UIFont systemFontOfSize:30*ViewRateBaseOnIP6]];
    self.passwordTxtfield.tag = 1;
    [self.cellPhoneTxtField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [allView addSubview:self.passwordTxtfield];
    
        self.passwordTxtfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordHiddenOrVisibleBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 30, 30)];
//    self.passwordHiddenOrVisibleBtn = [[UIButton alloc] initWithFrame:CGRectMake(600*ViewRateBaseOnIP6, 430*ViewRateBaseOnIP6, 44*ViewRateBaseOnIP6, 44*ViewRateBaseOnIP6)];
    [self.passwordHiddenOrVisibleBtn setBackgroundImage:[UIImage imageNamed:@"JANLoginHiddenPwdIcon.png"] forState:UIControlStateNormal];
    [self.passwordHiddenOrVisibleBtn setBackgroundImage:[UIImage imageNamed:@"JANLoginHiddenPwdIcon_hover.png"] forState:UIControlStateHighlighted];
    //    [passwordHiddenOrVisibleBtn setBackgroundColor:[UIColor grayColor]];
    [self.passwordHiddenOrVisibleBtn addTarget:self action:@selector(passwordHiddenOrVisibleAction:) forControlEvents:UIControlEventTouchUpInside];
    [allView addSubview:self.passwordHiddenOrVisibleBtn];
//
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(71*ViewRateBaseOnIP6, 500*ViewRateBaseOnIP6, [UIScreen mainScreen].bounds.size.width - 71*ViewRateBaseOnIP6*2, 1)];
    [line2 setImage:[UIImage imageNamed:@"JNELoginDividingLine"]];
    [allView addSubview:line2];
    
    if(IS_IPAD){
        [pwImgView setFrame:CGRectMake(pwImgView.frame.origin.x, 310*ViewRateBaseOnIP6, pwImgView.frame.size.width, pwImgView.frame.size.height)];
        [self.passwordTxtfield setFrame:CGRectMake(287*ViewRateBaseOnIP6, 306*ViewRateBaseOnIP6, 320*ViewRateBaseOnIP6, self.passwordTxtfield.frame.size.height)];
        [self.passwordHiddenOrVisibleBtn setFrame:CGRectMake(630*ViewRateBaseOnIP6, 306*ViewRateBaseOnIP6, 44*ViewRateBaseOnIP6, 44*ViewRateBaseOnIP6)];
        [line2 setFrame:CGRectMake(line2.frame.origin.x, 380*ViewRateBaseOnIP6, line2.frame.size.width, line2.frame.size.height)];
    }else if (IS_667_HEIGHT_LOGICPIXEL){
        [self.passwordTxtfield setFrame:CGRectMake(self.passwordTxtfield.frame.origin.x, self.passwordTxtfield.frame.origin.y, 310*ViewRateBaseOnIP6, self.passwordTxtfield.frame.size.height)];
    }else if (IS_480_HEIGHT_LOGICPIXEL){
        [self.passwordTxtfield setFrame:CGRectMake(self.passwordTxtfield.frame.origin.x, self.passwordTxtfield.frame.origin.y, 410*ViewRateBaseOnIP6, self.passwordTxtfield.frame.size.height)];
    }
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(70*ViewRateBaseOnIP6, line2.frame.origin.y+line2.frame.size.height+60*ViewRateBaseOnIP6, [UIScreen mainScreen].bounds.size.width - 140*ViewRateBaseOnIP6, 102*ViewRateBaseOnIP6)];
    [self.loginBtn setBackgroundColor:[UIColor clearColor]];
        [self.loginBtn setImage:[UIImage imageNamed:@"JANLoginCompleteBtnIcon.png"] forState:UIControlStateNormal];
        [self.loginBtn setImage:[UIImage imageNamed:@"JANLoginCompleteBtnIcon_hover.png"] forState:UIControlStateHighlighted];
    UIImage *rawEntryBackground = [UIImage imageNamed:@"JANLoginCompleteIcon"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:65.0/2.0 topCapHeight:rawEntryBackground.size.height/2.0 ];
    [self.loginBtn setBackgroundImage:entryBackground forState:UIControlStateNormal];
    UIImage *tntryBackground = [UIImage imageNamed:@"JANLoginCompleteIcon_hover"];
    UIImage *ptryBackground = [tntryBackground stretchableImageWithLeftCapWidth:65.0/2.0 topCapHeight:tntryBackground.size.height/2.0 ];
    [self.loginBtn setBackgroundImage:ptryBackground forState:UIControlStateHighlighted];
    [self.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.enabled = YES;
    self.loginBtn.alpha = 1.0;
    [self.loginBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"登录",nil)] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:38*ViewRateBaseOnIP6];
    [self.loginBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [allView addSubview:self.loginBtn];
    
    UIButton *forgetPasswordBtn = [[UIButton alloc] initWithFrame:CGRectMake(120*ViewRateBaseOnIP6, self.loginBtn.frame.origin.y+self.loginBtn.frame.size.height+39*ViewRateBaseOnIP6, 110*ViewRateBaseOnIP6, 28*ViewRateBaseOnIP6)];
    [forgetPasswordBtn setBackgroundColor:[UIColor clearColor]];
    [forgetPasswordBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"忘记密码?",nil)] forState:UIControlStateNormal];
    [forgetPasswordBtn.titleLabel setFont:[UIFont systemFontOfSize:22*ViewRateBaseOnIP6]];
//    if ([JXLanguangeManger sharedInstance].currentLanguageType  == JXLanguageInEnglish) {
//        [forgetPasswordBtn.titleLabel setFont:[UIFont systemFontOfSize:22*ViewRateBaseOnIP6]];
//    }else {
//        [forgetPasswordBtn.titleLabel setFont:[UIFont systemFontOfSize:24*ViewRateBaseOnIP6]];
//    }
    [forgetPasswordBtn addTarget:self action:@selector(forgetPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [allView addSubview:forgetPasswordBtn];
    
    UIButton *createAccountBtn = [[UIButton alloc] initWithFrame:CGRectMake(forgetPasswordBtn.frame.origin.x + forgetPasswordBtn.frame.size.width + 300*ViewRateBaseOnIP6, self.loginBtn.frame.origin.y+self.loginBtn.frame.size.height+39*ViewRateBaseOnIP6, 98*ViewRateBaseOnIP6, 28*ViewRateBaseOnIP6)];
    [createAccountBtn setBackgroundColor:[UIColor clearColor]];
    [createAccountBtn setTitle:[NSString stringWithFormat:NSLocalizedString(@"创建账号",nil)] forState:UIControlStateNormal];
    [createAccountBtn.titleLabel setFont:[UIFont systemFontOfSize:24*ViewRateBaseOnIP6]];
    [createAccountBtn addTarget:self action:@selector(createAccountAction:) forControlEvents:UIControlEventTouchUpInside];
    [allView addSubview:createAccountBtn];
    
    [forgetPasswordBtn setFrame:CGRectMake(120*ViewRateBaseOnIP6, self.loginBtn.frame.origin.y+self.loginBtn.frame.size.height+39*ViewRateBaseOnIP6, 200*ViewRateBaseOnIP6, 28*ViewRateBaseOnIP6)];
    //        [createAccountBtn setFrame:CGRectMake(535*ViewRateBaseOnIP6, createAccountBtn.frame.origin.y, createAccountBtn.frame.size.width, createAccountBtn.frame.size.height)];
//    if ([[JXLanguangeManger sharedInstance] currentLanguageType] == JXLanguageInEnglish){
//        [forgetPasswordBtn setFrame:CGRectMake(120*ViewRateBaseOnIP6, self.loginBtn.frame.origin.y+self.loginBtn.frame.size.height+39*ViewRateBaseOnIP6, 200*ViewRateBaseOnIP6, 28*ViewRateBaseOnIP6)];
//        [createAccountBtn setFrame:CGRectMake(535*ViewRateBaseOnIP6, createAccountBtn.frame.origin.y, createAccountBtn.frame.size.width, createAccountBtn.frame.size.height)];
//    }
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [currentTextField resignFirstResponder];
}

-(void)setViewInt:(UIView*)intView{
    [intView setFrame:CGRectMake((NSInteger) intView.frame.origin.x, (NSInteger) intView.frame.origin.y, (NSInteger) intView.width, (NSInteger) intView.height)];
}

-(void)initBottomView{
    if (!self.shareBottomSubViewArray) {
        self.shareBottomSubViewArray = [[NSMutableArray alloc] init];
    }
    
    for (UIView *subView in self.shareBottomSubViewArray) {
        [subView removeFromSuperview];
    }
    
    NSArray * parners  = nil;
    if ([[UnlockTypeChecker shareInstance] isOpenThirdParnerLoginEntry]) {
        parners =  @[@(JPShareLoginTypeWechat),@(JPShareLoginTypeSina),@(JPShareLoginTypeQQ),@(JPShareLoginTypeFaceBook)];
    }
    
    if (parners == nil || parners.count == 0 || parners.count > 4) {
        return;
    }
    
    NSMutableDictionary *shareButtonDic = [[NSMutableDictionary alloc] init];
    
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - (116*ViewRateBaseOnIP6*4 + 49*ViewRateBaseOnIP6*3))/2.0, [UIScreen mainScreen].bounds.size.height - 83*ViewRateBaseOnIP6 - 133*ViewRateBaseOnIP6 - 50*ViewRateBaseOnIP6 - 1, 198*ViewRateBaseOnIP6 + (116*ViewRateBaseOnIP6*4 + 49*ViewRateBaseOnIP6*3 - 540*ViewRateBaseOnIP6)/2.0, 1)];
    [line3 setImage:[UIImage imageNamed:@"JNELoginDividingLine"]];
    [self addSubview:line3];
    [self.shareBottomSubViewArray addObject:line3];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 124*ViewRateBaseOnIP6)/2.0, [UIScreen mainScreen].bounds.size.height - 90*ViewRateBaseOnIP6 - 133*ViewRateBaseOnIP6 - 50*ViewRateBaseOnIP6 - 13*ViewRateBaseOnIP6, 124*ViewRateBaseOnIP6, 36*ViewRateBaseOnIP6)];
    lbl.text = NSLocalizedString(@"其他方式登录",nil);
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setFont:[UIFont systemFontOfSize:20*ViewRateBaseOnIP6]];
    [lbl setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8]];
    lbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lbl];
    [self.shareBottomSubViewArray addObject:lbl];
    
    UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - line3.frame.origin.x - 198*ViewRateBaseOnIP6 - (116*ViewRateBaseOnIP6*4 + 49*ViewRateBaseOnIP6*3 - 540*ViewRateBaseOnIP6)/2.0, [UIScreen mainScreen].bounds.size.height - 83*ViewRateBaseOnIP6 - 133*ViewRateBaseOnIP6 - 50*ViewRateBaseOnIP6 - 1, 198*ViewRateBaseOnIP6 + (116*ViewRateBaseOnIP6*4 + 49*ViewRateBaseOnIP6*3 - 540*ViewRateBaseOnIP6)/2.0, 1)];
    [line4 setImage:[UIImage imageNamed:@"JNELoginDividingLine"]];
    [self addSubview:line4];
    [self.shareBottomSubViewArray addObject:line4];
    
    if(IS_568_HEIGHT_LOGICPIXEL){
        [line3 setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 540*ViewRateBaseOnIP6 - 71*ViewRateBaseOnIP6)/2.0, line3.frame.origin.y, 233.5*ViewRateBaseOnIP6, line3.frame.size.height)];
        [line4 setFrame:CGRectMake(line4.frame.origin.x, line4.frame.origin.y, 233.5*ViewRateBaseOnIP6, line4.frame.size.height)];
    }
    
    UIButton *weixinLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - (116*ViewRateBaseOnIP6*2 + 98*ViewRateBaseOnIP6))/2.0 ,[UIScreen mainScreen].bounds.size.height - 78*ViewRateBaseOnIP6 - 116*ViewRateBaseOnIP6 ,116*ViewRateBaseOnIP6 ,116*ViewRateBaseOnIP6 )];
    [weixinLoginBtn setBackgroundColor:[UIColor clearColor]];
    weixinLoginBtn.tag = 0;
    [weixinLoginBtn setImage:[UIImage imageNamed:@"JANLoginWechatIcon.png"] forState:UIControlStateNormal];
    [weixinLoginBtn setImage:[UIImage imageNamed:@"JANLoginWechatIcon_hover.png"] forState:UIControlStateHighlighted];
    [weixinLoginBtn addTarget:self action:@selector(thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:weixinLoginBtn];
//    [shareButtonDic setObject:weixinLoginBtn forKey:@(JPShareLoginTypeWechat)];
    
    UIButton *weiboLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(weixinLoginBtn.frame.origin.x + weixinLoginBtn.frame.size.width + 98*ViewRateBaseOnIP6 ,[UIScreen mainScreen].bounds.size.height - 78*ViewRateBaseOnIP6 - 116*ViewRateBaseOnIP6 ,116*ViewRateBaseOnIP6 ,116*ViewRateBaseOnIP6 )];
    [weiboLoginBtn setBackgroundColor:[UIColor clearColor]];
    weiboLoginBtn.tag = 1;
    [weiboLoginBtn setImage:[UIImage imageNamed:@"JANLoginWeiboIcon.png"] forState:UIControlStateNormal];
    [weiboLoginBtn setImage:[UIImage imageNamed:@"JANLoginWeiboIcon_hover.png"] forState:UIControlStateHighlighted];
    [weiboLoginBtn addTarget:self action:@selector(thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:weiboLoginBtn];
//    [shareButtonDic setObject:weiboLoginBtn forKey:@(JPShareLoginTypeSina)];
    
    NSInteger firstOrigrt = ([UIScreen mainScreen].bounds.size.width - (116*ViewRateBaseOnIP6*2 + 98*ViewRateBaseOnIP6))/2.0;
    for (NSInteger shareIndex = 0; shareIndex < parners.count; shareIndex++) {
        UIButton *shareButton = [shareButtonDic objectForKey:[parners objectAtIndex:shareIndex]];
        if (shareButton) {
            [shareButton setFrame:CGRectMake(firstOrigrt + shareIndex*(98*ViewRateBaseOnIP6 + 116*ViewRateBaseOnIP6) , shareButton.frame.origin.y, shareButton.frame.size.width, shareButton.frame.size.height)];
            [self setViewInt:shareButton];
            [self addSubview:shareButton];
            [self.shareBottomSubViewArray addObject:shareButton];
        }
    }
}

-(void)phoneBgTap:(UITapGestureRecognizer *)gestureRecognizer{
    UIView *viewTaped=[gestureRecognizer view];
    if (viewTaped.tag == 0) {
        [self.cellPhoneTxtField becomeFirstResponder];
    }else if(viewTaped.tag == 1)
    {
        [self.passwordTxtfield becomeFirstResponder];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

-(void)hiddenKeyBoard{
    if ([self.cellPhoneTxtField isFirstResponder]) {
        [self.cellPhoneTxtField resignFirstResponder];
    }
    
    if ([self.passwordTxtfield isFirstResponder]) {
        [self.passwordTxtfield resignFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        currentTextField = self.cellPhoneTxtField;
    }else {
        currentTextField = self.passwordTxtfield;
        
        if(self.cellPhoneTxtField.text.length == 0){
            [self performSelector:@selector(hiddenKeyBoard) withObject:nil afterDelay:0.01];
            //            JPSLoginCustomUIAlertViewWithOneButton *customAlertView = [[[JPSLoginCustomUIAlertViewWithOneButton alloc] initWithFrame:SCREEN_BOUNDS] autorelease];
            //            [customAlertView customAlertViewshow];
            [self showAlert:nil withMessage:@"请输入手机号！" withBtnTitle:@"确定"];
            //            [customAlertView setTipContent:NSLocalizedString(@"请输入手机号！",nil) sureContent:NSLocalizedString(@"确认",nil)];
            //            [self addSubview:customAlertView];
        }
    }
}
#pragma mark - alertView
- (void)showAlert:(NSString *)title withMessage:(NSString *)message withBtnTitle:(NSString *)btnTitle
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:btnTitle otherButtonTitles:nil,nil];
    alert.tag = 41785;
    [alert show];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL can_login = false;
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return false;
    }
    
    if (textField == self.cellPhoneTxtField) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890\n"] invertedSet];
        NSString *filtered_Str = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL canInput = [string isEqualToString:filtered_Str];
        if (!canInput) {
            return canInput;
        }
    }
    if(textField == self.cellPhoneTxtField){
        if (self.passwordTxtfield.text.length>=8 && self.cellPhoneTxtField.text.length>=1) {
            //        if (self.passwordTxtfield.text.length>=8 && ((range.location == 10 && range.length == 0) || (range.location == 11 && range.length == 1))) {
            can_login = YES;
        }
    }
    if (textField  == self.passwordTxtfield) {
        if (self.cellPhoneTxtField.text.length >= 1 && ((range.location >= 7 && range.length == 0) || (range.location >= 8 && range.length == 1))) {
            //        if (self.cellPhoneTxtField.text.length == 11 && ((range.location >= 7 && range.length == 0) || (range.location >= 8 && range.length == 1))) {
            can_login = true;
        }
    }
    if(can_login){
        self.loginBtn.enabled = YES;
        self.loginBtn.alpha = 1.0;
    }else{
        self.loginBtn.enabled = YES;
        self.loginBtn.alpha = 1.0;
    }
    return true;
}

#pragma mark -
#pragma mark Action
//-(void)backAction:(UIButton *)sender{
//    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(backAction:)])
//    {[self.delegate performSelector:@selector(backAction:) withObject:sender];}
//}

-(void)chooseCountry{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(chooseCountry)])
    {
        [self.delegate performSelector:@selector(chooseCountry)];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    //    if ([textField isEqual:self.cellPhoneTxtField]) {
    //        if (textField.text.length > 11) {
    //            textField.text = [textField.text substringToIndex:11];
    //        }
    //    }
    BOOL canLogin = false;
    if (self.passwordTxtfield.text.length>=6 && self.cellPhoneTxtField.text.length >= 1){
        //    if (self.passwordTxtfield.text.length>=6 && self.cellPhoneTxtField.text.length == 11){
        canLogin = true;
    }
    
    if(canLogin){
        self.loginBtn.enabled = YES;
        self.loginBtn.alpha = 1.0;
    }else{
        self.loginBtn.enabled = YES;
        self.loginBtn.alpha = 1.0;
    }
}

- (void)passwordHiddenOrVisibleAction:(UIButton *)sender{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(passwordHiddenOrVisibleAction:)])
    {
        [self.delegate performSelector:@selector(passwordHiddenOrVisibleAction:) withObject:sender];
    }
}

-(void)loginAction:(UIButton *)sender{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(loginAction:)])
    {[self.delegate performSelector:@selector(loginAction:) withObject:sender];}
}

-(void)forgetPasswordAction:(UIButton *)sender{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(forgetPasswordAction:)])
    {[self.delegate performSelector:@selector(forgetPasswordAction:) withObject:sender];}
}

-(void)createAccountAction:(UIButton *)sender{
    NSLog(@"代理是否为%@",self.delegate);
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(createAccountAction:)])
    {
        [self.delegate performSelector:@selector(createAccountAction:) withObject:sender];
    }
}

-(void)thirdLoginAction:(UIButton *)sender{
    if (self.delegate !=nil && [self.delegate respondsToSelector:@selector(thirdLoginAction:)])
    {
        [sender removeTarget:self action:@selector(thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
        [self performSelector:@selector(senderButonYesToEnabled:) withObject:sender afterDelay:2];
        [self.delegate performSelector:@selector(thirdLoginAction:) withObject:sender];
    }
}

-(void)senderButonYesToEnabled:(UIButton*)sender{
    [sender addTarget:self action:@selector(thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
}


@end
