//
//  YbsTaskMapViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsTaskMapViewController.h"
#import "YbsHomeViewController.h"
#import "YbsLocationManager.h"
#import "YbsSingleTaskAnnotationView.h"
#import "YbsPackageTaskAnnotationView.h"
#import "YbsTaskDetailViewController.h"
#import "YbsTaskModel.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

static void *MapZoomLevelObserverContext = &MapZoomLevelObserverContext;

@interface YbsTaskMapViewController ()<CLLocationManagerDelegate,MAMapViewDelegate,AMapSearchDelegate>

@property (nonatomic, strong) NSMutableArray <YbsTaskModel *> *dataArray;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation YbsTaskMapViewController

- (NSMutableArray<YbsTaskModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMapView];
    [self setUpSearch];
    [self addMapControls];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.flag) {
        [self loadData];
    }
}

- (void)setUpMapView{
    self.mapView = [MAMapView new];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
//    [self customUserLocationRepresentation];
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    self.mapView.rotateEnabled = NO;
    self.mapView.rotateCameraEnabled = NO;
//    self.mapView.showsWorldMap =
    self.mapView.zoomingInPivotsAroundAnchorPoint = YES;//3D地图才有此属性
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)setUpSearch{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

// 自定义定位小蓝点
- (void)customUserLocationRepresentation{
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;
    r.showsHeadingIndicator = NO;
    r.fillColor = [UIColor redColor];///精度圈 填充颜色, 默认 kAccuracyCircleDefaultColor
    r.strokeColor = [UIColor blueColor];///精度圈 边线颜色, 默认 kAccuracyCircleDefaultColor
    r.lineWidth = 2;///精度圈 边线宽度，默认0
    r.image = [UIImage imageNamed:@"你的图片"]; ///定位图标, 与蓝色原点互斥
    [self.mapView updateUserLocationRepresentation:r];
}

- (void)addMapControls{
    
    UIImageView *mapCenterPin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 32.5)];
    mapCenterPin.image = kImageNamed(@"centerlocation");
    [self.view addSubview:mapCenterPin];
    [mapCenterPin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view).centerOffset(CGPointMake(0, -16));
        make.size.mas_equalTo(CGSizeMake(22, 32.5));
    }];
    
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setBackgroundImage:kImageNamed(@"backlocation") forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationButton];
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-200);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setBackgroundImage:kImageNamed(@"locationrefresh") forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshButton];
    
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(locationButton.mas_bottom).with.offset(20);
        make.right.equalTo(locationButton);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    
}

- (void)refreshButtonClick:(UIButton *)sender{
    [self loadData];
}

- (void)locationButtonClick:(UIButton *)sender{
    [self.mapView setCenterCoordinate:[YbsLocationManager shareInstance].location.coordinate animated:YES];
}

#pragma mark - MAMapViewDelegate

- (void)mapInitComplete:(MAMapView *)mapView{
//    LoggerView(2,@"mapInitComplete");
    [mapView setZoomLevel:11.5 animated:YES];
}

-(void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
//    LoggerView(2,@"regionWillChangeAnimated");
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    LoggerView(2,@"regionDidChangeAnimated");
    if (self.flag) {
        [self loadData];
    }
}

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction{
    
    
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    if (wasUserAction) {
//        LoggerView(2,@"mapDidMoveByUser");
    }
}

- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction{
    if (!wasUserAction) {
//        LoggerView(2,@"mapDidZoomByUser not by user");
        self.flag = YES;
        [mapView setCenterCoordinate:[YbsLocationManager shareInstance].location.coordinate animated:YES];
    }
}

- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    //定位蓝点  如果不在此判断 自身的定位点样式会被其他自定义的样式修改
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    
    YbsTaskModel *model = (YbsTaskModel *)annotation;
    
    
    
    NSString *str = [NSString stringWithFormat:@"￥%@",model.money];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSFontAttributeName value:kYbsFontCustom(11) range:NSMakeRange(0,1)];
    [attributedString addAttribute:NSFontAttributeName value:kYbsFontCustom(14) range:NSMakeRange(1,str.length-1)];
    [attributedString addAttribute:NSKernAttributeName value:@0.1 range:NSMakeRange(0,str.length-1)];
    
    static NSString *packageIdentifier = @"PackageTaskAnnotationIdentifier";
    static NSString *singleIdentifier = @"SingleTaskAnnotationIdentifier";
    if ([model.tailStatus isEqualToString:@"1"]) {
        YbsPackageTaskAnnotationView *annotationView = (YbsPackageTaskAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:packageIdentifier];
        if (!annotationView) {
            annotationView = [[YbsPackageTaskAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:packageIdentifier];
        }
        annotationView.annotationTitleLabel.attributedText = attributedString;
        
        return annotationView;
    }else{
        YbsSingleTaskAnnotationView *annotationView = (YbsSingleTaskAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:singleIdentifier];
        if (!annotationView) {
            annotationView = [[YbsSingleTaskAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:singleIdentifier];
        }
        annotationView.annotationTitleLabel.attributedText = attributedString;
        return annotationView;
    }
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    for (MKAnnotationView *view in views) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.fromValue = [NSNumber numberWithFloat:0.3];
        animation.toValue = [NSNumber numberWithFloat:1.0];
        animation.duration = 0.2;
        animation.autoreverses = NO;
        animation.repeatCount = 0;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeRemoved;
        [view.layer addAnimation:animation forKey:@"zoom"];
    }
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if ([view isKindOfClass:[YbsPackageTaskAnnotationView class]]||[view isKindOfClass:[YbsSingleTaskAnnotationView class]]) {
        [mapView deselectAnnotation:view.annotation animated:NO];
        
        YbsTaskModel *model = (YbsTaskModel *)view.annotation;
        YbsTaskDetailViewController *vc = [[YbsTaskDetailViewController alloc]init];
        vc.taskModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
//    if ([YbsLocationManager shareInstance].needReGeocode) {
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc]init];
        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
        regeo.requireExtension = YES;
        [self.search AMapReGoecodeSearch:regeo];
//    }

    if (updatingLocation) {
//        LoggerLocation(2,@"didUpdateUserLocation");
        [YbsLocationManager shareInstance].location = userLocation.location;
    }
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if (response.regeocode != nil){
        [YbsLocationManager shareInstance].formattedAddress = response.regeocode.formattedAddress;
        [YbsLocationManager shareInstance].neighborhood = response.regeocode.addressComponent.neighborhood;

    }
}


- (void)loadData{
    NSDictionary *paramsDic = @{
                                @"longitude":[NSString stringWithFormat:@"%.6f",self.mapView.centerCoordinate.longitude],
                                @"latitude":[NSString stringWithFormat:@"%.6f",self.mapView.centerCoordinate.latitude]
                                };
    
//    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi tasksInMapUrl]
                              parameters:paramsDic
                                 success:^(id  _Nonnull responseObject)
                                    {
                                        @strongify(self);
                                        NSDictionary *dic = responseObject;
                                        if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]) {
                                            [self.mapView removeAnnotations:self.dataArray];
                                            [self.dataArray removeAllObjects];
                                            NSArray *arr = [NSArray modelArrayWithClass:[YbsTaskModel class] json:dic[kYbsDataKey][@"list"]];
                                            if (arr.count > 0) {
                                                [self.dataArray addObjectsFromArray:arr];
                                            }
                                            [self.mapView addAnnotations:self.dataArray];
                                            if (self.mapView.annotations.count ==  0) {
                                                [self showMessage:@"当前区域暂无任务" hideDelay:1];
                                                
                                            }
                                            
                                        }
//                                            [SVProgressHUD dismiss];
                                        } failure:^(NSError * _Nonnull error) {
//                                            [SVProgressHUD dismiss];
                                        }];
    
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
