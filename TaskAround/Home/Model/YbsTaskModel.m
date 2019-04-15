//
//  YbsTaskModel.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/28.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsTaskModel.h"

@implementation YbsTaskModel

- (void)setLatitude:(NSString *)latitude{
    _latitude = latitude;
    _coordinate.latitude = [latitude doubleValue];
}

- (void)setLongitude:(NSString *)longitude{
    _longitude = longitude;
    _coordinate.longitude = [longitude doubleValue];
}


@end
