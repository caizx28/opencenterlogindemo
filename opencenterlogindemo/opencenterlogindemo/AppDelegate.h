//
//  AppDelegate.h
//  opencenterlogindemo
//
//  Created by 蔡宗杏 on 16/9/2.
//  Copyright © 2016年 蔡宗杏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *vc;

@property (nonatomic,assign) BOOL isFirstInstall;
@end

