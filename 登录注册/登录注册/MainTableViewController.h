//
//  MainTableViewController.h
//  cocoaPodsTest
//
//  Created by 李慧 on 2017/7/6.
//  Copyright © 2017年 李慧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MainTableViewController : UITableViewController<CLLocationManagerDelegate>
{
    CLLocationManager *locationmanager;//定位服务
    NSString *currentCity;//当前城市
    NSString *strlatitude;//经度
    NSString *strlongitude;//纬度
}

@end
