//
//  MainTableViewController.m
//  cocoaPodsTest
//
//  Created by 李慧 on 2017/7/6.
//  Copyright © 2017年 李慧. All rights reserved.
//

#import "MainTableViewController.h"
#import <BmobSDK/Bmob.h>

@interface MainTableViewController ()<UITextFieldDelegate>
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *name;

@property (weak, nonatomic) IBOutlet UITextField *nickname;

@property (weak, nonatomic) IBOutlet UITextField *birthday;

@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *sign;

@property (weak, nonatomic) IBOutlet UITextField *area;
@property (weak, nonatomic) IBOutlet UITextField *college;
@property (weak, nonatomic) IBOutlet UITextField *major;
@property (weak, nonatomic) IBOutlet UITextField *classname;
@property (weak, nonatomic) IBOutlet UITextField *stuID;
@property (weak, nonatomic) IBOutlet UITextField *Instructor;


@property (weak, nonatomic) IBOutlet UITextField *qq;

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *email;


@property (strong,nonatomic) UIDatePicker *datePicker;
@property (strong,nonatomic) NSDateFormatter *dateFormat;








@end

@implementation MainTableViewController

- (void)viewDidLoad {
    self.datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
    self.datePicker.datePickerMode=UIDatePickerModeDate;
    self.datePicker.date=[NSDate date];
    [self.datePicker addTarget:self action:@selector(changes:)forControlEvents:UIControlEventValueChanged];
    //self.datePicker.tag=101;
    self.birthday.inputView=self.datePicker;
    
    //获取经纬度
    [self getLocation];
    
    BmobUser *user=[BmobUser currentUser];
    self.stuID.text=user.username;
    self.phone.text=user.mobilePhoneNumber;
    
    self.stuID.userInteractionEnabled=NO;//用户名文本不可编辑
    self.phone.userInteractionEnabled=NO;
    
   // [self.sex addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];

}
- (void) changes:(id)sender{
    //生日
    NSDate *select  = [self.datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime = [dateFormatter stringFromDate:select];
    self.birthday.text=dateAndTime;
    
    //年龄
    NSDateFormatter*formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy"];
    NSString*dateStr=[formatter1 stringFromDate:_datePicker.date];
    NSString*currentDate=[formatter1 stringFromDate:[NSDate date]];
    int age= (int)[currentDate floatValue]-   [dateStr floatValue];
    //NSLog(@"%d",age);
    self.age.text=[NSString stringWithFormat:@"%d",age];
    
    //星座
    NSDateFormatter*formatter2=[[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"MM"];
    NSString * month=[formatter2 stringFromDate:_datePicker.date];
    int m=[month intValue];
    //NSLog(@"%d",m);
    NSDateFormatter*formatter3=[[NSDateFormatter alloc]init];
    [formatter3 setDateFormat:@"dd"];
    NSString* day=[formatter3 stringFromDate:_datePicker.date];
    int d=[day intValue];
    //NSLog(@"%d",d);
    NSString * astroString = @"摩羯座水瓶座双鱼座白羊座金牛座双子座巨蟹座狮子座处女座天秤座天蝎座射手座摩羯座";
    NSString * astroFormat = @"102123444543";
    NSString * result;
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*3-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*3, 3)]];
    //NSLog(@"星座:%@",result);
    self.sign.text=result;
}

-(void)getLocation
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationmanager = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        [locationmanager requestAlwaysAuthorization];
        currentCity = [NSString new];
        [locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter = 5.0;
        [locationmanager startUpdatingLocation];
    }
}

#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [locationmanager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            
            /*看需求定义一个全局变量来接收赋值*/
          //  NSLog(@"----%@",placeMark.country);//当前国家
            NSLog(@"%@",currentCity);//当前的城市
            self.area.text=currentCity;
//            NSLog(@"%@",placeMark.subLocality);//当前的位置
//            NSLog(@"%@",placeMark.thoroughfare);//当前街道
           //NSLog(@"%@",placeMark.name);//具体地址
            // self.area.text=placeMark.name;
        }
    }];
    
}
-(void)selected:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"男");
    }else if (sender.selectedSegmentIndex == 1){
        NSLog(@"女");
}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)save:(id)sender {
    
    
    
    BmobUser *bUser = [BmobUser currentUser];
     //保存名字
    [bUser setObject:self.name.text forKey:@"name"];
     //保存昵称
    [bUser setObject:self.nickname.text forKey:@"nickname"];
    //保存生日
    NSString *string = self.birthday.text;
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
     NSDate* date = [formater dateFromString:string];
    [bUser setObject:date forKey:@"birthday"];
    //保存年龄
    NSNumber *Age=[NSNumber numberWithInteger:[self.age.text integerValue]];
     [bUser setObject:Age  forKey:@"age"];
     //保存星座
    [bUser setObject:self.sign.text forKey:@"sign"];
     //保存地区
    [bUser setObject:self.area.text forKey:@"area"];
    //保存学院
    [bUser setObject:self.college.text forKey:@"college"];
     //保存专业
    [bUser setObject:self.major.text forKey:@"major"];
    //保存班级
    [bUser setObject:self.classname.text forKey:@"classname"];
    //保存学号
    //[bUser setObject:self.major.text forKey:@"major"];
    //保存辅导员
    [bUser setObject:self.Instructor.text forKey:@"Instructor"];
    //保存QQ
    [bUser setObject:self.qq.text forKey:@"QQ"];
    
    
    if (!self.name.text || [self.name.text isEqualToString:@""] )//判断文本框是否为空，如果有任何一项为空，则弹出警告框
    {
        UIAlertController *tip=[UIAlertController alertControllerWithTitle:@"警告" message:@"不能为空" preferredStyle:UIAlertControllerStyleAlert];//初始化UIAlertController参数，设置警告框内容
        [tip addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action)//创建UIAlertAction对象，相当于一个按钮
                        {
                            
                        }]];
        [self presentViewController:tip animated:true completion:nil];//显示UIAlertController对象
        
    } else {

    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {//如果保存成功，弹出提示框
            UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action)
                                  {
                                      
                                  }]];
            
            [self presentViewController:alertView animated:YES completion:nil];
            
        }
        else{
            //如果保存失败，弹出警告框
            NSString *errorString = error.localizedDescription;
            NSLog(@"%@",errorString);
            NSLog(@"%@",error);
            UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"警告" message:errorString preferredStyle:UIAlertControllerStyleAlert]  ;
            [alertView addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action)
                                  {
                                      // 未能注册成功
                                  }]];
            
            [self presentViewController:alertView animated:true completion:nil];
            
        }
    }];

}

}
@end
