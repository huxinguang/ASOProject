//
//  YbsMLBaseViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/23.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsMLBaseViewController.h"
#import "YbsLocationManager.h"
#import "YbsHomeViewController.h"

@interface YbsMLBaseViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation YbsMLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLocation];
}

-(void)getLocation{
    //不能使用局部变量
    self.locationManager = [[CLLocationManager alloc]init];
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocationDistance distance = 10;
    self.locationManager.distanceFilter = distance;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:{
            [self showPlaceholderViewWithType:YbsPlaceholderTypeButton
                                      imgName:@"userlocation"
                                     btnTitle:@"去设置"
                                      message:@"我们需要通过您的地理位置信息\n获取您周边的相关数据"
                                   clickBlock:^{
                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                   }];
            
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:{
            [self dismissPlaceholderView];
        }
            break;
        default:
            break;
    }
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
