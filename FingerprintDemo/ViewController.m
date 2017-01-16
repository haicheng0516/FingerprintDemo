//
//  ViewController.m
//  FingerprintDemo
//
//  Created by 郭健 on 2017/1/13.
//  Copyright © 2017年 海城. All rights reserved.
//

#import "ViewController.h"

#define SCLOG(...) printf("%s\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
@interface ViewController ()
- (IBAction)yanzhengBtn:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)yanzhengBtn:(UIButton *)sender {
    
    LAContext *context = [[LAContext alloc]init];
    
    NSError *error = nil;
    NSString *result = @"需要您的支付密码进行支付";
    context.localizedFallbackTitle = @"快捷支付";
    SCLOG(@"data before authentication == %@",[context evaluatedPolicyDomainState]);
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError * _Nullable error) {
           
            if (success) {
                
                SCLOG(@"验证成功");
                SCLOG(@"data after authentication = %@",[context evaluatedPolicyDomainState]);
            }else{
            
                SCLOG(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                        SCLOG(@"Authentication was cancelled by the system");
                         //切换到其他APP，系统取消验证Touch ID
                        break;
                    case LAErrorUserCancel:
                    {
                        SCLOG(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        SCLOG(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                        }];
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        SCLOG(@"Authentication Failed");
                        break;
                    }
                    case LAErrorTouchIDLockout:
                    {
                        SCLOG(@"TOUCH ID is locked out");
                        break;
                    }
                    case LAErrorAppCancel:
                    {
                        SCLOG(@"app cancle the authentication");
                        break;
                    }
                    case LAErrorInvalidContext:
                    {
                        SCLOG(@"context is invalidated");
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }else{
    
        SCLOG(@"%@",error.localizedDescription);
        //不支持指纹识别，LOG出错误详情
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                SCLOG(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                SCLOG(@"A passcode has not been set");
                break;
            }
            default:
            {
                SCLOG(@"TouchID not available");
                break;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
