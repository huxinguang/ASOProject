//
//  YbsUnReviewViewController.h
//  TaskAround
//
//  Created by xinguang hu on 2019/2/22.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsBaseViewController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN



@interface YbsUnReviewViewController : YbsBaseViewController

@end

typedef NS_ENUM(NSInteger,UnReviewSubVcType) {
    UnReviewSubVcLeft = 0,
    UnReviewSubVcRight
};

@interface YbsUnReviewSubVC : YbsBaseViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) UnReviewSubVcType type;

- (void)loadData;
- (void)resetNoDataView;

@end


NS_ASSUME_NONNULL_END
