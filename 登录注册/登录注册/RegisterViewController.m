//
//  RegisterViewController.m
//  cocoaPodsTest
//
//  Created by 李慧 on 2017/7/4.
//  Copyright © 2017年 李慧. All rights reserved.
//

#import "RegisterViewController.h"
#import "RootTabBarViewController.h"
#import <BmobSDK/Bmob.h>
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phonetxt;//输入11位手机号
@property (weak, nonatomic) IBOutlet UITextField *codetxt;//输入6位密码
@property (weak, nonatomic) IBOutlet UITextField *usertxt;//输入学号
@property (weak, nonatomic) IBOutlet UIButton *registerBut;//注册按钮
- (IBAction)registerBut:(id)sender;




@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //注册按钮
    self.registerBut.backgroundColor=[UIColor orangeColor];//“注册”按钮的背景颜色为橙色
    self.registerBut.layer.cornerRadius=3.0;//设置圆角为3
    
   
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


- (IBAction)registerBut:(id)sender {
    BmobUser *bUserRegister = [[BmobUser alloc] init];
    bUserRegister.username = self.usertxt.text;
    bUserRegister.mobilePhoneNumber = self.phonetxt.text;
    bUserRegister.password=self.codetxt.text;
   //后台注册,返回注册结果
    [bUserRegister signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded ) {
            //初始化操作
            UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
            //取消按键
            [alertView addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action)
                                  {
                                      //注册成功进入主页面
                                      [self performSegueWithIdentifier:@"registerLogin" sender:nil];
                                      NSDictionary *dataDict=[NSDictionary dictionaryWithObject:self.phonetxt.text forKey:@"username"];
                                      [[NSNotificationCenter defaultCenter]postNotificationName:@"RegisterCompletionNotification" object:nil userInfo:dataDict];
                                  }]];
            [self presentViewController:alertView animated:YES completion:nil];
        }
        else {
            NSString *errorString = error.localizedDescription;
            
            NSLog(@"%@",errorString);
            NSLog(@"%@",error);
            UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"警告" message:errorString preferredStyle:UIAlertControllerStyleAlert]  ;
            [alertView addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action)
                                  {
                                      // 未能注册成功
                                  }]];
            //显示警告视图
            [self presentViewController:alertView animated:true completion:nil];
            
        }
    }];

}

@end
