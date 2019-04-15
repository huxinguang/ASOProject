//
//  HHCommonInitial.h
//  BaseTabBar
//
//  Created by 豫风 on 2017/6/27.
//  Copyright © 2017年 豫风. All rights reserved.
//

#ifndef HHCommonInitial_h
#define HHCommonInitial_h


/**双击tabBar的事件协议，需要子控制器遵守协议*/
@protocol DoubleClickProtocol <NSObject>

@optional
- (void)doubleClickActionNeedToDo;
- (BOOL)isNeedPopGestureAction;

@end



#endif /* HHCommonInitial_h */
