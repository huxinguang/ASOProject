//
//  XG_MediaCell.h
//  MyApp
//
//  Created by huxinguang on 2018/10/30.
//  Copyright © 2018年 huxinguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XG_MediaCell : UICollectionViewCell

@property (nonatomic, strong) id item;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *mediaContainerView;//用于动画
@property (nonatomic, strong) UIImageView *imageView;

- (void)resizeSubviewSize;

@end







