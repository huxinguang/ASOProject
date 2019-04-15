//
//  YbsLocationManager.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/22.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YbsLocationManager : NSObject

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, copy  ) NSString *formattedAddress;
@property (nonatomic, copy  ) NSString *neighborhood;
@property (nonatomic, assign) BOOL needReGeocode;//标识是否需要对当前位置进行逆地理编码

+ (instancetype)shareInstance;


@end

NS_ASSUME_NONNULL_END
