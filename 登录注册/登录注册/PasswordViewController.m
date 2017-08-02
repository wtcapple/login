//
//  PasswordViewController.m
//  cocoaPodsTest
//
//  Created by 李慧 on 2017/7/4.
//  Copyright © 2017年 李慧. All rights reserved.
//

#import "PasswordViewController.h"
#import <BmobSDK/Bmob.h>
@interface PasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordText;//密码
@property (weak, nonatomic) IBOutlet UITextField *resertPassword;//确认密码

@property (weak, nonatomic) IBOutlet UIButton *button;//确定
- (IBAction)button:(id)sender;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)button:(id)sender {
    NSString *smsCode=self.sms;
    NSString *password = self.passwordText.text;
    NSString *verifyPassword = self.resertPassword.text;
    //如果密码，确认密码二者任意一个空
    if (!password || [password isEqualToString:@""] || !verifyPassword || [verifyPassword isEqualToString:@""] || ![password isEqualToString:verifyPassword])
    {
        UIAlertController *tip=[UIAlertController alertControllerWithTitle:@"警告" message:@"密码及确认密码必须相等且不为空" preferredStyle:UIAlertControllerStyleAlert]  ;
        
        [tip addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action)
                        {
                            
                        }]];
        [self presentViewController:tip animated:true completion:nil];
        
    } else {
        //利用短信验证码重置帐号密码，只有填写手机号码的用户可用
        [BmobUser resetPasswordInbackgroundWithSMSCode:smsCode andNewPassword:password block:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                
                UIAlertController *tip=[UIAlertController alertControllerWithTitle:@"恭喜" message:@"重置密码成功" preferredStyle:UIAlertControllerStyleAlert]  ;
                
                [tip addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action)
                                {
                                     [self performSegueWithIdentifier:@"passwordLogin" sender:nil];
                                    
                                }]];
                [self presentViewController:tip animated:true completion:nil];
                
                
            } else {
                UIAlertController *tip=[UIAlertController alertControllerWithTitle:@"错误" message:@"验证码有误" preferredStyle:UIAlertControllerStyleAlert]  ;
                
                [tip addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action)
                                {
                                    
                                }]];
                [self presentViewController:tip animated:true completion:nil];
            }
        }];
    }
    
    
}
@end
