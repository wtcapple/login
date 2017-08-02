//
//  ViewController.m
//  登录注册
//
//  Created by 李慧 on 2017/8/2.
//  Copyright © 2017年 李慧. All rights reserved.
//

#import "ViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>

@interface ViewController ()

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
    // 登录界面先隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    BmobUser *bUser = [BmobUser currentUser];
    if (bUser) {
        // 直接进入主界面
        NSLog(@"直接进入主界面");
        NSLog(@"%@",bUser);
        
        [self performSegueWithIdentifier:@"send" sender:nil];
        //        RootTabBarViewController* rootTabBarViewController;
        //       [self showViewController:rootTabBarViewController sender:nil];
        
    }
    //    else{
    //        //对象为空时，可打开用户注册界面
    //    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    //如果不想隐藏其他页面的导航栏 需要重置
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
