//
//  YbsCameraPreviewCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/3/20.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsCameraPreviewCell.h"

@interface YbsCameraPreviewCell ()<UIScrollViewDelegate>

@end

@implementation YbsCameraPreviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imgView];
        
    }
    return self;
}

#pragma mark - Getter

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:self.scrollView.bounds];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.contentView.bounds;
        _scrollView.bouncesZoom = YES;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 3;
    }
    return _scrollView;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                                 scrollView.contentSize.height * 0.5 + offsetY);
}



@end
