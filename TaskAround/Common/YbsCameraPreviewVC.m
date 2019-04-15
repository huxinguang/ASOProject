//
//  YbsCameraPreviewVC.m
//  TaskAround
//
//  Created by xinguang hu on 2019/3/20.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsCameraPreviewVC.h"
#import "YbsCameraPreviewCell.h"

@interface YbsCameraPreviewVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentItem;

@end

@implementation YbsCameraPreviewVC


-(void)configRightBarButtonItem{
    YbsBarButtonConfiguration *config = [[YbsBarButtonConfiguration alloc]init];
    config.type = YbsBarButtonTypeImage;
    config.normalImageName = @"camera_preview_delete";
    self.rightBarButton = [[YbsNavBarButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44) configuration:config];
    [self.rightBarButton addTarget:self action:@selector(onRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBarButton];
}

- (void)onRightBtnClick{
    [self.photos removeObjectAtIndex:self.currentItem];
    
    if ([self.delegate respondsToSelector:@selector(deletePhotosAtIndex:)]) {
        [self.delegate deletePhotosAtIndex:self.currentItem];
    }
    
    [self.collectionView reloadData];

    NSInteger currentPage = (self.currentItem == self.photos.count ? self.currentItem : self.currentItem + 1);
    
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:[NSString stringWithFormat:@"%d/%ld",(int)currentPage ,self.photos.count]];
    
    if (self.photos.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;//让view从0开始
    
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:[NSString stringWithFormat:@"1/%ld",self.photos.count]];
    
    self.currentItem = 0;
    [self addGesture];
    [self.view addSubview:self.collectionView];

}


- (void)addGesture{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];

}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = [UIScreen mainScreen].bounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[YbsCameraPreviewCell class] forCellWithReuseIdentifier:NSStringFromClass([YbsCameraPreviewCell class])];
    }
    return _collectionView;
}


- (YbsCameraPreviewCell *)currentCell{
    return (YbsCameraPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentItem inSection:0]];
}

- (NSInteger)currentItem{
    CGPoint point = self.collectionView.contentOffset;
    NSInteger current = point.x / self.collectionView.width;
    return current;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YbsCameraPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YbsCameraPreviewCell class]) forIndexPath:indexPath];
//    NSString *path = self.photos[indexPath.item];
//    cell.imgView.image = [UIImage imageWithContentsOfFile:path];
    cell.imgView.image = self.photos[indexPath.item];
    return cell;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:[NSString stringWithFormat:@"%d/%ld",(int)self.currentItem + 1,self.photos.count]];
    
}

#pragma mark - action

- (void)singleTapAction{
    BOOL hidden = self.navigationController.navigationBar.hidden;
    [self setStatusBarHidden:!hidden animated:YES];
    [self.navigationController setNavigationBarHidden:!hidden animated:YES];
    
}

- (void)doubleTapAction:(UITapGestureRecognizer *)gesture{
    YbsCameraPreviewCell *cell = [self currentCell];
    if (cell.scrollView.zoomScale > 1) {
        [cell.scrollView setZoomScale:1 animated:YES];
    } else {
        CGPoint touchPoint = [gesture locationInView:cell.imgView];
        CGFloat newZoomScale = cell.scrollView.maximumZoomScale;
        CGFloat xsize = kAppScreenWidth / newZoomScale;
        CGFloat ysize = kAppScreenHeight / newZoomScale;
        [cell.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
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
