//
//  LoginViewController.m
//  cocoaPodsTest
//
//  Created by 李慧 on 2017/7/4.
//  Copyright © 2017年 李慧. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "MyTableViewController.h"
#import "RootTabBarViewController.h"
#import <BmobSDK/Bmob.h>

#import "MyTableViewController.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *login;
- (IBAction)forgetPwd:(id)sender;

@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated
{
    // 登录界面先隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
       

    
}
- (void)viewWillDisappear:(BOOL)animated{
    //如果不想隐藏其他页面的导航栏 需要重置
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        //登录按钮
    self.login.backgroundColor=[UIColor orangeColor];
    self.login.layer.cornerRadius=3.0;
    NSLog(@"登录");
    
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"login"]) {
//        MyTableViewController* myVTC = segue.destinationViewController;
//        //[myVTC.usernameButton setTitle:self.phone.text forState:UIControlStateNormal];
//    }
//}


- (IBAction)login:(id)sender {
    [BmobUser loginInbackgroundWithAccount:self.phone.text andPassword:self.pwd.text block:^(BmobUser *bUserLogin, NSError *error)
     {
         
         //有用户
         if (bUserLogin)
         {
             //登陆成功,去主界面
             NSLog(@"登录成功");
             UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"提示" message:@"登录成功" preferredStyle:UIAlertControllerStyleAlert];//初始化
             [alertView addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action)  //创建操作
                                   {
                                    //登录成功到主页面
                                    [self performSegueWithIdentifier:@"login" sender:nil];
                                       
                                           
                                           //将登录视图参数传到主视图
                                           NSDictionary *dataDict=[NSDictionary dictionaryWithObject:self.phone.text forKey:@"username"];
                                           [[NSNotificationCenter defaultCenter]postNotificationName:@"RegisterCompletionNotification" object:nil userInfo:dataDict];
                                           
                                           
                                      
                            }]];
             //显示提示框
             [self presentViewController:alertView animated:YES completion:nil];
         }
         
         else
         {
             NSLog(@"登录失败");
    
             UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"警告" message:@"帐号不存在 或 密码错误" preferredStyle:UIAlertControllerStyleAlert]  ;
             
             [alertView addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action)
                                   {
                                       
                                   }]];
             
             [self presentViewController:alertView animated:true completion:nil];
         }
     }];
    
    
}


- (IBAction)forgetPwd:(id)sender {
    UIAlertController *actionSheetController=[[UIAlertController alloc]init];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        NSLog(@"取消");
    }];
    UIAlertAction *otherAction1=[UIAlertAction actionWithTitle:@"忘记密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self performSegueWithIdentifier:@"password" sender:nil];

        NSLog(@"忘记密码");
    }];
//    UIAlertAction *otherAction=[UIAlertAction actionWithTitle:@"短信验证登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//        [self performSegueWithIdentifier:@"message" sender:nil];
//
//        NSLog(@"短信验证登录");
//    }];
    [actionSheetController addAction:cancelAction];
    [actionSheetController addAction:otherAction1];
    //[actionSheetController addAction:otherAction];
    [self presentViewController:actionSheetController animated:true completion:nil];
    
    

}
@end
