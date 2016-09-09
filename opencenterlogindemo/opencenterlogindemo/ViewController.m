//
//  ViewController.m
//  opencenterlogindemo
//
//  Created by 蔡宗杏 on 16/9/2.
//  Copyright © 2016年 蔡宗杏. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "AfNetworking.h"

static ViewController *shareMainViewContrller = nil;
static dispatch_once_t onceToken;

@interface ViewController ()

@end

@implementation ViewController
+ (ViewController *)shareInstance {
    @synchronized(self)
    {
        dispatch_once(&onceToken, ^{
            shareMainViewContrller = [[super allocWithZone:nil] init];
        });
    }
    return shareMainViewContrller;
}
+ (id)allocWithZone:(NSZone *)zone {
    return [self shareInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [ViewController shareInstance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //监测网络
    AFNetworkReachabilityManager *reac = [AFNetworkReachabilityManager sharedManager];
//    [reac setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        
//    }];
    [reac startMonitoring];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *presonBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 60, 100, 60)];
    [presonBtn setTitle:@"登录界面" forState:UIControlStateNormal];
    presonBtn.backgroundColor = [UIColor orangeColor];
    [presonBtn addTarget:self action:@selector(presentBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:presonBtn];
}
-(void)presentBtn:(UIButton *)sender
{
    
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    
//    [self presentViewController:loginVc animated:YES completion:^{
//        
//    }];
    [self.navigationController pushViewController:loginVc animated:YES];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
