//
//  YbsTaskModel.h
//  TaskAround
//
//  Created by xinguang hu on 2019/2/28.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YbsTaskModel : NSObject<MAAnnotation>

@property (nonatomic, copy  ) NSString *taskId;
@property (nonatomic, copy  ) NSString *taskName;
@property (nonatomic, copy  ) NSString *storeId;
@property (nonatomic, copy  ) NSString *storeName;
@property (nonatomic, copy  ) NSString *address;
@property (nonatomic, copy  ) NSString *endTime;
@property (nonatomic, copy  ) NSString *money;
@property (nonatomic, copy  ) NSString *tailStatus;
@property (nonatomic, copy  ) NSString *longitude;
@property (nonatomic, copy  ) NSString *latitude;
@property (nonatomic, copy  ) NSString *distance;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate; //map protocal

@property (nonatomic, copy  ) NSString *describeHtmlPath;
@property (nonatomic, copy  ) NSString *prePage;
@property (nonatomic, copy  ) NSString *advance;
@property (nonatomic, copy  ) NSString *afterSubmit;
@property (nonatomic, copy  ) NSString *storeCode;
@property (nonatomic, copy  ) NSString *storeStatus;


// 历史任务
@property (nonatomic, copy  ) NSString *paperId;
@property (nonatomic, copy  ) NSString *userId;
@property (nonatomic, copy  ) NSString *status;
@property (nonatomic, copy  ) NSString *payMoney;

//稍后提交
@property (nonatomic, copy  ) NSString *stayId;




@end

NS_ASSUME_NONNULL_END
