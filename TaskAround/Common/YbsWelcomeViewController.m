//
//  YbsWelcomeViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/28.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsWelcomeViewController.h"

@interface YbsWelcomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation YbsWelcomeViewController

- (instancetype)initWithBlock:(StartBlock)block{
    self = [super init];
    if (self) {
        self.startBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildSubViews];
}

- (void)buildSubViews{
    [self.view addSubview:self.scrollView];
    for (NSInteger i = 0; i < 4; i ++) {
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(i * kAppScreenWidth, 0, kAppScreenWidth, kAppScreenHeight);
        imageView.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.f green:arc4random() % 255 / 255.f blue:arc4random() % 255 / 255.f alpha:1];
        [self.scrollView addSubview:imageView];
    }
    [self.scrollView addSubview:self.startBtn];
    [self.view addSubview:self.pageControl];
}


-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kAppScreenWidth * 4, kAppScreenHeight);
    }
    return _scrollView;
}

- (UIButton *)startBtn{
    if (!_startBtn) {
        CGFloat btnW = 120;
        CGFloat btnH = 35;
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.frame = CGRectMake(3 * kAppScreenWidth + (kAppScreenWidth-btnW)/2, kAppScreenHeight - kAppTabbarSafeBottomMargin - 100 - btnH, btnW, btnH);
        [_startBtn setTitle:@"开启旅行" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.numberOfPages = 4;
        CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:4];
        _pageControl.frame = CGRectMake((kAppScreenWidth - pageControlSize.width) / 2, kAppScreenHeight - kAppTabbarSafeBottomMargin - 40 - pageControlSize.height , pageControlSize.width, pageControlSize.height);
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    }
    return _pageControl;
}

- (void)start{
    if (self.startBlock) {
        [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.scrollView.alpha = 0;
        } completion:^(BOOL finished) {
            self.startBlock();
        }];
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point = self.scrollView.contentOffset;
    NSInteger current = point.x / self.view.frame.size.width;
    self.pageControl.currentPage = current;
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
