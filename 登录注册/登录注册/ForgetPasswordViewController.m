//
//  ForgetPasswordViewController.m
//  cocoaPodsTest
//
//  Created by 李慧 on 2017/7/11.
//  Copyright © 2017年 李慧. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "PasswordViewController.h"
#import <BmobSDK/Bmob.h>
@interface ForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextField *smsCodeText;
@property (weak, nonatomic) IBOutlet UIButton *smsCode;
- (IBAction)smsCode:(id)sender;
- (IBAction)nextButton:(id)sender;

@property (strong,nonatomic) NSTimer *countDownTimer;        // 计时器
@property unsigned secondsCountDown;      // 倒计时数

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)smsCode:(id)sender {
    //请求验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneText.text andTemplate:@"account" resultBlock:^(int number, NSError *error)
     {
         if (error) {
             NSLog(@"%@",error);
         } else {
             // 获得smsID
             NSLog(@"sms ID：%d",number);
             // 设置不可点击
             [self setRequestSmsCodeBtnCountDown];
             
         }
     }];
    

}

- (IBAction)nextButton:(id)sender {
     NSString *smsCode = self.smsCodeText.text;
    if (!smsCode || [smsCode isEqualToString:@""] ){
        UIAlertController *tip=[UIAlertController alertControllerWithTitle:@"警告" message:@"验证码不能为空" preferredStyle:UIAlertControllerStyleAlert]  ;
        
        [tip addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action)
                        {
                            
                        }]];
        [self presentViewController:tip animated:true completion:nil];
        
    } else {
    }
    
}
#pragma mark - 获取验证码的计时器
-(void)setRequestSmsCodeBtnCountDown{
    [self.smsCode setEnabled:NO];//手势不可用
    self.smsCode.backgroundColor = [UIColor grayColor];//设置验证码的背景颜色为灰色
    self.secondsCountDown = 60;//设置倒数计时60
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimeWithSeconds:) userInfo:nil repeats:YES]; //创建返回一个新的NSTimer对象和时间表，在当前的默认模式下循环调用@selector(countDownTimeWithSeconds:)实例方法。
    [self.countDownTimer fire];//立即触发计时器方法
}
-(void)countDownTimeWithSeconds:(NSTimer*)timerInfo{
    if (self.secondsCountDown == 0) {//当倒数计时器为0的时候
        [self.smsCode setEnabled:YES];//”验证“手势可用
        self.smsCode.backgroundColor = [UIColor redColor];//此时”获取验证码“的背景颜色为红色
        [self.smsCode setTitle:@"获取验证码" forState:UIControlStateNormal];//设置button标题“获取验证码”
        [self.countDownTimer invalidate];//强制刷新计时器
    } else {
        [self.smsCode setTitle:[[NSNumber numberWithInt:self.secondsCountDown] description] forState:UIControlStateNormal];//设置button在“把int类型强制转换成NSNumber类型”的标题
        self.secondsCountDown--;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sender"]) {
        PasswordViewController * myVTC = segue.destinationViewController;
        myVTC.sms=self.smsCodeText.text;
        }
}


@end
