//
//  YbsLocationManager.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/22.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsLocationManager.h"



static YbsLocationManager *singleton = nil;

@interface YbsLocationManager ()


@end

@implementation YbsLocationManager

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[YbsLocationManager alloc]init];
    });
    return singleton;
}

//-(AMapLocationManager *)lm{
//    if (!_lm) {
//        _lm = [[AMapLocationManager alloc]init];
//        // 带逆地理信息的一次定位（返回坐标和地址信息）
//        [_lm setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
//        //   定位超时时间，最低2s，此处设置为2s
//        _lm.locationTimeout = 2;
//        //   逆地理请求超时时间，最低2s，此处设置为2s
//        _lm.reGeocodeTimeout = 2;
//    }
//    return _lm;
//}





@end
