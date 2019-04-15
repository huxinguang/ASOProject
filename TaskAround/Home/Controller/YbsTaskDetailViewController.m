//
//  YbsTaskDetailViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsTaskDetailViewController.h"
#import "YbsTaskHomeCell.h"
#import <WebKit/WebKit.h>
#import "YbsWebViewController.h"
#import "YbsQAViewController.h"
#import "YbsLoginViewController.h"
#import "YbsNavigationController.h"
#import "YbsFileManager.h"


@interface YbsTaskDetailViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) UIImageView *taskLeftImgView;
@property (nonatomic, strong) UILabel *taskNameLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *navigationLabel;
@property (nonatomic, strong) UIImageView *naviBottomLine;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView  *descriptionBg;
@property (nonatomic, strong) UIImageView  *descriptionLeftImg;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView  *descriptionRightImg;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *startBtn;

@property (nonatomic, strong) YbsTaskModel *detailModel;

@end

@implementation YbsTaskDetailViewController


-(void)configRightBarButtonItem{
    YbsBarButtonConfiguration *config = [[YbsBarButtonConfiguration alloc]init];
    config.type = YbsBarButtonTypeText;
    config.titleString = @"预览";
    self.rightBarButton = [[YbsNavBarButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44) configuration:config];
    [self.rightBarButton addTarget:self action:@selector(onRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBarButton];
}

- (void)onRightBtnClick{
    YbsWebViewController *wvc = [[YbsWebViewController alloc]init];
    wvc.pageTitle = @"任务预览";
    wvc.pageUrl = [NSString stringWithFormat:@"%@%@",[YbsApi taskPreviewUrl],self.detailModel.taskId];
    [self.navigationController pushViewController:wvc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"任务详情"];
    [self loadData];
}

- (void)buildSubViews{
    [self.view addSubview:self.taskLeftImgView];
    [self.view addSubview:self.taskNameLabel];
    [self.view addSubview:self.moneyLabel];
    
    [self.view addSubview:self.lineView];
    
    [self.view addSubview:self.locationImageView];
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.distanceLabel];
    [self.view addSubview:self.navigationLabel];
    [self.view addSubview:self.naviBottomLine];
    
    
    [self.view addSubview:self.shopNameLabel];
    [self.view addSubview:self.timeLabel];
    
    [self.view addSubview:self.descriptionBg];
    [self.descriptionBg addSubview:self.descriptionLeftImg];
    [self.descriptionBg addSubview:self.descriptionLabel];
    [self.descriptionBg addSubview:self.descriptionRightImg];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.startBtn];
    
    [SVProgressHUD show];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailModel.describeHtmlPath]]];
    
}


#pragma mark-setter,getter

- (UIImageView *)taskLeftImgView{
    if (_taskLeftImgView==nil) {
        _taskLeftImgView=[[UIImageView alloc] init];
        _taskLeftImgView.image = kImageNamed(@"task_left_img");
    }
    return _taskLeftImgView;
}

-(UILabel *)taskNameLabel{
    if (_taskNameLabel==nil) {
        _taskNameLabel=[[UILabel alloc] init];
        _taskNameLabel.font=kYbsFontCustomBold(17);
        _taskNameLabel.textColor=kColorHex(@"#2F2F2F");
        _taskNameLabel.numberOfLines = 0;
        _taskNameLabel.text = self.detailModel.taskName;
    }
    return _taskNameLabel;
}

-(UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.textColor = kColorHex(@"#FF2F29");
        NSString *str = [NSString stringWithFormat:@"￥%@",self.detailModel.money];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedString addAttribute:NSFontAttributeName value:kYbsFontCustom(15) range:NSMakeRange(0,1)];
        [attributedString addAttribute:NSFontAttributeName value:kYbsFontCustom(20) range:NSMakeRange(1,str.length-1)];
        _moneyLabel.attributedText = attributedString;
        
    }
    return _moneyLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = kColorHex(@"#D0D0D0");
    }
    return _lineView;
}

- (UIImageView *)locationImageView{
    if (_locationImageView==nil) {
        _locationImageView=[[UIImageView alloc] init];
        _locationImageView.image = kImageNamed(@"task_location");
    }
    return _locationImageView;
}

- (UILabel *)addressLabel{
    if (_addressLabel==nil) {
        _addressLabel=[[UILabel alloc] init];
        _addressLabel.font=kYbsFontCustom(16);
        _addressLabel.textColor=kColorHex(@"#2F2F2F");
        _addressLabel.numberOfLines = 2;
        _addressLabel.text = self.detailModel.address;
    }
    return _addressLabel;
}

-(UILabel *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        _distanceLabel.font = kYbsFontCustom(14);
        _distanceLabel.textColor = kColorHex(@"#2F2F2F");
        _distanceLabel.text = self.taskModel.distance;
    }
    return _distanceLabel;
}

-(UILabel *)navigationLabel{
    if (!_navigationLabel) {
        _navigationLabel = [[UILabel alloc] init];
        _navigationLabel.font = kYbsFontCustom(14);
        _navigationLabel.textColor = kColorHex(@"#FFA600");
        _navigationLabel.textAlignment = NSTextAlignmentRight;
//        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"导航" attributes:attribtDic];
//        _navigationLabel.attributedText = attribtStr;
        _navigationLabel.text = @"导航";
        _navigationLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(naviAction)];
        [_navigationLabel addGestureRecognizer:tapGes];
    }
    return _navigationLabel;
}


-(UIImageView *)naviBottomLine{
    if (!_naviBottomLine) {
        _naviBottomLine = [UIImageView new];
        _naviBottomLine.image = kImageNamed(@"navi_bottom_line");
    }
    return _naviBottomLine;
}



-(UILabel *)shopNameLabel{
    if (_shopNameLabel==nil) {
        _shopNameLabel=[[UILabel alloc] init];
        _shopNameLabel.font=kYbsFontCustom(13);
        _shopNameLabel.textColor=kColorHex(@"#999999");
        _shopNameLabel.numberOfLines = 0;
        _shopNameLabel.text = self.detailModel.storeName;
    }return _shopNameLabel;
}


-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kYbsFontCustom(13);
        _timeLabel.textColor = kColorHex(@"#999999");
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.text = self.detailModel.endTime;
    }
    return _timeLabel;
}


- (UIView *)descriptionBg{
    if (!_descriptionBg) {
        _descriptionBg = [UIView new];
        _descriptionBg.backgroundColor = kColorHex(@"#F1F1F1");
    }
    return _descriptionBg;
}

- (UIImageView *)descriptionLeftImg{
    if (_descriptionLeftImg==nil) {
        _descriptionLeftImg=[[UIImageView alloc] init];
        _descriptionLeftImg.image = kImageNamed(@"task_detail_left");
    }
    return _descriptionLeftImg;
}

- (UILabel *)descriptionLabel{
    if (_descriptionLabel==nil) {
        _descriptionLabel=[[UILabel alloc] init];
        _descriptionLabel.text = @"任务描述";
        _descriptionLabel.font=kYbsFontCustom(16);
        _descriptionLabel.textColor=kColorHex(@"#2F2F2F");
        _descriptionLabel.numberOfLines = 2;
    }
    return _descriptionLabel;
}

- (UIImageView *)descriptionRightImg{
    if (_descriptionRightImg==nil) {
        _descriptionRightImg=[[UIImageView alloc] init];
        _descriptionRightImg.image = kImageNamed(@"task_detail_right");
    }
    return _descriptionRightImg;
}

- (WKWebView *)webView{
    if (!_webView) {
        self.webView = [[WKWebView alloc]init];
        self.webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIButton *)startBtn{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.backgroundColor = kColorHex(@"#FF2F29");
        [_startBtn setTitle:@"开始任务" forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(startBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}



#pragma mark - Constraints

- (void)addConstraints{
    
    [self.taskLeftImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(15);
        make.left.equalTo(self.view).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    [self.taskNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskLeftImgView).with.offset(-4);
        make.left.equalTo(self.taskLeftImgView.mas_right).with.offset(5);
        make.right.equalTo(self.moneyLabel.mas_left);
    }];
    
    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.taskLeftImgView);
        make.right.equalTo(self.view).with.offset(-16);
        make.width.mas_equalTo(80*kAppScreenWidth/375);
        make.height.mas_equalTo(25);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskNameLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.locationImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(10);
        make.left.equalTo(self.taskLeftImgView);
        make.size.mas_equalTo(CGSizeMake(9.5, 13));
    }];
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationImageView).with.offset(-2);
        make.left.equalTo(self.locationImageView.mas_right).with.offset(3);
        make.right.equalTo(self.taskNameLabel);
    }];
    
    [self.distanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.locationImageView);
        make.right.equalTo(self.view).with.offset(-16);
    }];
    
    [self.navigationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLabel.mas_bottom);
        make.right.equalTo(self.view).with.offset(-16);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    [self.naviBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationLabel.mas_bottom);
        make.right.equalTo(self.navigationLabel);
        make.size.mas_equalTo(CGSizeMake(27, 1.5));
    }];
    
    [self.shopNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationImageView.mas_bottom).with.offset(32);
        make.left.equalTo(self.addressLabel);
        make.right.equalTo(self.timeLabel.mas_left).with.offset(10);
    }];

    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopNameLabel);
        make.right.equalTo(self.view).with.offset(-16);
        make.width.mas_equalTo(150);
    }];
    
    [self.descriptionBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopNameLabel.mas_bottom).with.offset(10);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.descriptionLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.descriptionLabel.mas_left).with.offset(-8);
        make.centerY.equalTo(self.descriptionBg);
        make.size.mas_equalTo(CGSizeMake(10.5, 6));
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.descriptionBg);
    }];
    
    [self.descriptionRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descriptionLabel.mas_right).with.offset(8);
        make.centerY.equalTo(self.descriptionBg);
        make.size.mas_equalTo(CGSizeMake(10.5, 6));
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionBg.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-kAppTabbarSafeBottomMargin - 40);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-kAppTabbarSafeBottomMargin);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - Action

- (void)naviAction{
    
    /*
     iOS开发常用总结三种地图：苹果VS高德VS百度
     
     苹果地图：苹果地图使用地球坐标，除了中国全球通用（国外不用转换）；在中国其使用高德的数据所以要将其转换为火星坐标才能使用不出偏差
     
     高德地图：高德地图使用的火星坐标，已经封装好了，取得就是火星坐标，不用转直接用
     
     百度地图：百度地图使用的是百度坐标，是将火星坐标进行处理；同理也已经封装好了，不用转直接用
     
     链接：https://www.jianshu.com/p/3cd701299cef

     */
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"打开地图导航" preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 高德地图采用了“火星坐标”
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
            
            NSString *appName =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&did=BGVIS2&dlat=%@&dlon=%@&dname=%@&dev=0&t=2",appName,self.detailModel.latitude,self.detailModel.longitude,self.detailModel.address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }else{
            [self showMessage:@"请先安装高德地图" hideDelay:1];
        }
    }];
    
    // 百度地图采用了 “百度坐标”
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
            
            CLLocationCoordinate2D originalLoc = CLLocationCoordinate2DMake([self.detailModel.latitude doubleValue], [self.detailModel.longitude doubleValue]);
            CLLocationCoordinate2D baiduLoc = [self gcj02CoordianteToBD09:originalLoc];
            
//            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=walking&coord_type=bd09", baiduLoc.latitude, baiduLoc.longitude,self.detailModel.address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
            
             NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%@,%@|name=%@&mode=walking&coord_type=bd09&src=ios.yunbangshou.TaskAround", self.detailModel.latitude, self.detailModel.longitude,self.detailModel.address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }else{
            [self showMessage:@"请先安装百度地图" hideDelay:1];
        }
    }];
    
    // 苹果地图(国内)采用了 “火星坐标”
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com"]]){
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([self.detailModel.latitude doubleValue], [self.detailModel.longitude doubleValue]);
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
            toLocation.name=self.detailModel.address;
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,
                                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:NO]}];
            
        }else{
            [self showMessage:@"请先安装苹果地图" hideDelay:1];
        }
        
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    [actionSheet addAction:action4];
    [[UIViewController currentViewController] presentViewController:actionSheet animated:YES completion:nil];
}



- (void)startBtnAction{
    if (![self ifLogin]) {
        return;
    }
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi taskQuestionUrl]
                              parameters:@{@"taskId":self.detailModel.taskId,
                                           @"storeId":self.detailModel.storeId
                                           }
                                 success:^(id  _Nonnull responseObject) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]){
                                         
                                         NSDictionary *userDic = kUserDefaultGet(kYbsUserInfoDicKey);
                                         NSString *userId = userDic[@"userId"];
                                         NSString *fileName = [NSString stringWithFormat:@"%@_task_%@_%@_archiver",userId,self.taskModel.taskId,self.taskModel.storeId];
                                         
                                         NSArray *queArr = nil;
                                         
                                         if ([YFM fileExistAtDocumentSubdirectory:kYbsUndoneTaskArchiverDirectory fileName:fileName]) {
                                             
                                             queArr = [YFM unarchiveFileInDocumentSubdirectory:kYbsUndoneTaskArchiverDirectory fileName:fileName];
                                             
                                         }else{
                                             queArr = [NSArray modelArrayWithClass:[YbsQueModel class] json:dic[kYbsDataKey]];
                                         }
                                         
                                         YbsQAViewController *vc = [YbsQAViewController new];
                                         vc.taskModel = self.detailModel;
                                         vc.questionArray = queArr;
                                         
                                         [self.navigationController pushViewController:vc animated:YES];
                                     }else{
                                         [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                     
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                 }
     ];
    
    
}

- (BOOL)ifLogin{
    
    if (!kUserDefaultGet(kYbsUserInfoDicKey)) {
        YbsLoginViewController *vc = [[YbsLoginViewController alloc]init];
        __weak typeof (vc) weakVC = vc;
        vc.successBlock = ^{
            [weakVC dismissViewControllerAnimated:YES completion:^{
                
            }];
        };
        
        vc.visitorBlock = ^{
            [weakVC dismissViewControllerAnimated:YES completion:^{
                
            }];
        };
        UINavigationController *nav = [[YbsNavigationController alloc] initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
    }else{
        return YES;
    }
    
}


#pragma mark - Coordinate transition

// 将GCJ-02坐标(火星坐标)转换为BD-09(百度)坐标
- (CLLocationCoordinate2D)gcj02CoordianteToBD09:(CLLocationCoordinate2D)gdCoordinate
{
    double x_PI = M_PI * 3000.0 /180.0;
    double gd_lat = gdCoordinate.latitude;
    double gd_lon = gdCoordinate.longitude;
    double z = sqrt(gd_lat * gd_lat + gd_lon * gd_lon) + 0.00002 * sin(gd_lat * x_PI);
    double theta = atan2(gd_lat, gd_lon) + 0.000003 * cos(gd_lon * x_PI);
    return CLLocationCoordinate2DMake(z * sin(theta) + 0.006, z * cos(theta) + 0.0065);
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [SVProgressHUD dismiss];

//    [self.webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#DC143C'"completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [SVProgressHUD dismiss];
}


#pragma mark - Data

- (void)loadData{
    NSDictionary *paramsDic = @{
                                @"longitude":self.taskModel.longitude,
                                @"latitude":self.taskModel.latitude,
                                @"taskId": self.taskModel.taskId,
                                @"storeId":self.taskModel.storeId
                                };
    
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi taskDetailUrl]
                              parameters:paramsDic
                                 success:^(id  _Nonnull responseObject)
                                     {
                                         @strongify(self);
                                         [SVProgressHUD dismiss];
                                         NSDictionary *dic = responseObject;
                                         if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]) {
                                             self.detailModel = [YbsTaskModel modelWithJSON:dic[kYbsDataKey]];
                                             [self buildSubViews];
                                             [self addConstraints];
                                         }
                                         
                                     } failure:^(NSError * _Nonnull error) {
                                         [SVProgressHUD dismiss];
                                     }
     ];
    
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
