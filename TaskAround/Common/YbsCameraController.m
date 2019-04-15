//
//  YbsCameraController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/3/20.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "YbsCameraPreviewVC.h"
#import "UIImage+YbsUtil.h"
#import "YbsLocationManager.h"
#import "YbsFileManager.h"
#import <Photos/Photos.h>
#import "UIButton+Layout.h"

#define kTakeBtnWH              68
#define kTakeBtnBorderWidth     5
#define kTakeBtnCenterImgWH     (kTakeBtnWH - 2*kTakeBtnBorderWidth - 2*3)

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);


@interface YbsCameraController ()<UIGestureRecognizerDelegate,CameraPreviewDelegate>

@property (nonatomic, assign) BOOL flashFlag;
@property (nonatomic, strong) UIButton *flashBtn;
@property (nonatomic, assign) CGFloat effectiveScale;
@property (nonatomic, assign) CGFloat beginGestureScale;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIButton *takeBtn;
@property (nonatomic, strong) UIImageView *takeBtnCenterImg;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIImageView *focusImgView;


@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *rearCaptureDevice;
@property (nonatomic, strong) AVCaptureDevice *frontCaptureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *rearDeviceInput;
@property (nonatomic, strong) AVCaptureDeviceInput *frontDeviceInput;
@property (nonatomic, strong) AVCaptureDeviceInput *currentDeviceInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *captureStillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@end

@implementation YbsCameraController

- (void)configLeftBarButtonItem{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatusBarHidden:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.captureSession startRunning];
    if (self.photos.count > 0) {
        self.imgBtn.hidden = NO;
        [self.imgBtn setBackgroundImage:[self.photos lastObject] forState:UIControlStateNormal];
        [self.imgBtn setTitle:[NSString stringWithFormat:@"%ld",self.photos.count] forState:UIControlStateNormal];
    }else{
        self.imgBtn.hidden = YES;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setStatusBarHidden:NO animated:NO];
    [self.captureSession stopRunning];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.effectiveScale = 1.0f;

    [self addGesture];
    [self buildSubViews];
    [self addConstraints];
    [self configCamera];

}

- (void)addGesture{
    UIPinchGestureRecognizer *pinGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinGes.delegate = self;
    [self.view addGestureRecognizer:pinGes];
    
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapGes];

}

- (void)tapAction:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point device:self.currentDeviceInput.device];
}


- (void)buildSubViews{
    
    NSArray *imgArrNor = @[@"camera_burst",@"camera_switch",@"camera_hidden",@"camera_flash_off"];
    NSArray *imgArrSelected = @[@"camera_burst",@"camera_switch",@"camera_hidden",@"camera_flash_on"];
    NSArray *titleArr = @[@"3s连拍",@"屏幕旋转",@"黑屏拍",@"闪光灯"];
    
    CGFloat marginLeftRight = 15.0;
    CGFloat marginTop = 15.0;
    CGFloat btnH = 40.0;
    CGFloat btnW = (kAppScreenWidth - marginLeftRight*2)/titleArr.count;
    
    for (int i=0; i<titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(marginLeftRight + btnW*i, marginTop, btnW, btnH);
        btn.imageRect = CGRectMake((btnW - 19.0)/2 , 0, 19.0, 19.0);
        btn.titleRect = CGRectMake(0, btnH-15.0, btnW, 15.0);
        [btn setImage:kImageNamed(imgArrNor[i]) forState:UIControlStateNormal];
        [btn setImage:kImageNamed(imgArrSelected[i]) forState:UIControlStateSelected];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = kYbsFontCustom(11);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = i;
        [btn addTarget:self action:@selector(onTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    

    [self.view addSubview:self.imgBtn];
    [self.view addSubview:self.takeBtn];
    [self.view addSubview:self.takeBtnCenterImg];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.focusImgView];
    
    self.takeBtn.layer.cornerRadius = kTakeBtnWH/2;
    self.takeBtn.layer.masksToBounds = YES;
    self.takeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.takeBtn.layer.borderWidth = kTakeBtnBorderWidth;
    
    self.takeBtnCenterImg.layer.cornerRadius = kTakeBtnCenterImgWH/2;
    self.takeBtnCenterImg.layer.masksToBounds = YES;
    
}

- (void)addConstraints{
    [self.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(30);
        make.bottom.equalTo(self.view).with.offset(-44);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.takeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.imgBtn);
        make.size.mas_equalTo(CGSizeMake(kTakeBtnWH, kTakeBtnWH));
    }];
    
    [self.takeBtnCenterImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.takeBtn);
        make.size.mas_equalTo(CGSizeMake(kTakeBtnCenterImgWH, kTakeBtnCenterImgWH));
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-40);
        make.centerY.equalTo(self.imgBtn);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
}

- (void)configCamera{
    //默认闪光灯关闭
    [self changeRearDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
        if ([captureDevice hasFlash]) {
            [captureDevice setFlashMode:AVCaptureFlashModeOff];
        }
    }];
    
    [self changeFrontDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
    }];
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        
        if ([self.captureSession canAddInput:self.rearDeviceInput]) {
            self.currentDeviceInput = self.rearDeviceInput;
            [self.captureSession addInput:self.currentDeviceInput];
        }
    }else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
        
        if ([self.captureSession canAddInput:self.frontDeviceInput]) {
            self.currentDeviceInput = self.frontDeviceInput;
            [self.captureSession addInput:self.currentDeviceInput];
        }
    }else{
        kShow_Alert(@"照相机不可用!");
    }
    
    if ([self.captureSession canAddOutput:self.captureStillImageOutput]) {
        [self.captureSession addOutput:self.captureStillImageOutput];
    }
    [self.view.layer insertSublayer:self.captureVideoPreviewLayer atIndex:0];
}


#pragma mark - getter

- (AVCaptureSession *)captureSession{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

- (AVCaptureStillImageOutput *)captureStillImageOutput{
    if (!_captureStillImageOutput) {
        _captureStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        [_captureStillImageOutput setOutputSettings:@{AVVideoCodecKey:AVVideoCodecJPEG}];
    }
    return _captureStillImageOutput;
}

- (AVCaptureVideoPreviewLayer *)captureVideoPreviewLayer{
    if (!_captureVideoPreviewLayer) {
        _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        _captureVideoPreviewLayer.frame = self.view.bounds;
        _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _captureVideoPreviewLayer;
}

- (AVCaptureDeviceInput *)rearDeviceInput{
    if (!_rearDeviceInput) {
        _rearDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.rearCaptureDevice error:nil];
    }
    return _rearDeviceInput;
}

- (AVCaptureDeviceInput *)frontDeviceInput{
    if (!_frontDeviceInput) {
        _frontDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.frontCaptureDevice error:nil];
    }
    return _frontDeviceInput;
}

- (AVCaptureDevice *)rearCaptureDevice{
    if (!_rearCaptureDevice) {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if (device.position == AVCaptureDevicePositionBack) {
                _rearCaptureDevice = device;
            }
        }
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceSubjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:_rearCaptureDevice];
    }
    return _rearCaptureDevice;
}

- (AVCaptureDevice *)frontCaptureDevice{
    if (!_frontCaptureDevice) {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if (device.position == AVCaptureDevicePositionFront) {
                _frontCaptureDevice = device;
            }
        }
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceSubjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:_frontCaptureDevice];
    }
    return _frontCaptureDevice;
}


-(NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _dateFormatter;
}

- (NSMutableArray *)photos{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (UIButton *)imgBtn{
    if (!_imgBtn) {
        _imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imgBtn.titleLabel.font = kYbsFontCustomBold(21);
        [_imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_imgBtn addTarget:self action:@selector(onImgBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _imgBtn.hidden = YES;
    }
    return _imgBtn;
}

- (UIButton *)takeBtn{
    if (!_takeBtn) {
        _takeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _takeBtn.backgroundColor = [UIColor clearColor];
        [_takeBtn addTarget:self action:@selector(onTakeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takeBtn;
}

- (UIImageView *)takeBtnCenterImg{
    if (!_takeBtnCenterImg) {
        _takeBtnCenterImg = [UIImageView new];
        _takeBtnCenterImg.backgroundColor = [UIColor whiteColor];
    }
    return _takeBtnCenterImg;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:kImageNamed(@"camera_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(onCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIImageView *)focusImgView{
    if (!_focusImgView) {
        _focusImgView = [UIImageView new];
        _focusImgView.image = kImageNamed(@"camera_focus");
        _focusImgView.center = self.view.center;
        _focusImgView.size = CGSizeMake(60, 60);
        _focusImgView.hidden = YES;
    }
    return _focusImgView;
}

#pragma mark - action

- (void)onTopBtnClick:(UIButton *)sender{
    if (sender.tag == 1) {
        [self changeDevicePosition];
    }else if (sender.tag == 3){
        [self changeFlashMode:sender];
    }
}

- (void)onImgBtnClick{
    YbsCameraPreviewVC *vc = [[YbsCameraPreviewVC alloc]init];
    vc.delegate = self;
    vc.quetionModel = self.questionModel;
    vc.photos = self.photos;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTakeBtnClick{
    
    PHAuthorizationStatus albumStatus = [PHPhotoLibrary authorizationStatus];
    if (albumStatus == PHAuthorizationStatusRestricted || albumStatus == PHAuthorizationStatusDenied) {

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"提示"                                                                               message: @"您还没有开启相册权限，请到”设置“中开启" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction: [UIAlertAction actionWithTitle: @"去设置" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        }]];

        [self presentViewController: alertController animated: YES completion: nil];

    }else if (albumStatus == PHAuthorizationStatusNotDetermined){
        
        __weak typeof (self) weakSelf = self;
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf takePhoto];
                });
            }
        }];
    }else{
        [self takePhoto];
    }
    
}

- (void)takePhoto{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self startBtnAnimation];
    self.view.userInteractionEnabled = NO;// 阻断按钮响应者链,否则会造成崩溃
    AVCaptureConnection *captureConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [captureConnection setVideoScaleAndCropFactor:self.effectiveScale];
    if (captureConnection) {
        __weak typeof (self) weakSelf = self;
        [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            if (self.needWatermark) {
                image = [weakSelf handleImage:image];
            }
            
            [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
                 [PHAssetChangeRequest creationRequestForAssetFromImage:image];
             } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    if (self.questionModel && self.taskModel) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *answerDirName = [NSString stringWithFormat:@"task_%@_%@_answer",self.questionModel.taskId,self.taskModel.storeId];
                            NSString *dir = [YFM createDirectoryInDocumentWithName:answerDirName];
                            
                            if (dir) {
                                NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg",kCurrentTimestampMillisecond,[NSString randomStringWithLength:3]];
                                NSString *finalPath = [dir stringByAppendingPathComponent:fileName];
                                NSString *finalPathComponent = [answerDirName stringByAppendingPathComponent:fileName];
                                
                                NSData *data = UIImageJPEGRepresentation(image, 0.5);
                                if (dir) {
                                    if ([data writeToFile:finalPath atomically:YES]) {
                                        if ([self.questionModel.type isEqualToString:@"0"]) {//图片题
//                                            [self.questionModel.answerPictures addObject:finalPath];
                                            [self.questionModel.answerPictures addObject:finalPathComponent];
                                            
                                        }else if ([self.questionModel.type isEqualToString:@"1"]){//图片备注题
                                            YbsPicText *pt = [YbsPicText new];
//                                            pt.pic = finalPath;
                                            pt.pic = finalPathComponent;
                                            [self.questionModel.answerTextPics addObject:pt];
                                        }
                                        
                                        [weakSelf.photos addObject:image];
                                        weakSelf.imgBtn.hidden = NO;
                                        [weakSelf.imgBtn setBackgroundImage:image forState:UIControlStateNormal];
                                        [weakSelf.imgBtn setTitle:[NSString stringWithFormat:@"%ld",weakSelf.photos.count] forState:UIControlStateNormal];
                                        weakSelf.view.userInteractionEnabled = YES;
                                    }
                                }
                            }
                        });

                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.photos addObject:image];
                            weakSelf.imgBtn.hidden = NO;
                            [weakSelf.imgBtn setBackgroundImage:image forState:UIControlStateNormal];
                            [weakSelf.imgBtn setTitle:[NSString stringWithFormat:@"%ld",weakSelf.photos.count] forState:UIControlStateNormal];
                            weakSelf.view.userInteractionEnabled = YES;
                            
                        });
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.view.userInteractionEnabled = YES;
                    });
                }

            }];
            
        }];
    }else{
        kShow_Alert(@"拍照失败!")
    }
}

- (UIImage *)handleImage:(UIImage *)originalImage{
    UIImage *image = [originalImage fixOrientation];
    NSString *dateString = [self.dateFormatter stringFromDate:[NSDate date]];
    NSMutableString *markStringM = [NSMutableString string];
    if ([self.questionModel.specAttr.watermark isEqualToString:@"1"]) {
        [markStringM appendString:dateString];
        [markStringM appendString:@"  "];
    }
    
    if (self.taskModel.storeName) {
        [markStringM appendString:self.taskModel.storeName];
    }
    
    if ([self.questionModel.specAttr.positionWatermark isEqualToString:@"1"]) {//实际地址水印
        [markStringM appendString:@"\n"];
        [markStringM appendString:[YbsLocationManager shareInstance].formattedAddress];
    }else if([self.questionModel.specAttr.positionWatermark isEqualToString:@"2"]){//门店地址
        [markStringM appendString:@"\n"];
        if (self.taskModel.address) {
            [markStringM appendString:self.taskModel.address];
        }
    }
    
    NSString *locationStr = [NSString stringWithFormat:@"%@\n经度：%@  纬度：%@",markStringM,self.taskModel.longitude,self.taskModel.latitude];
    
    CGFloat leftMargin = 10.0;
    CGFloat bottomMargin = 2.0;
    CGFloat leftMarginInImage = leftMargin * image.size.width/kAppScreenWidth;
    CGFloat bottomMarginInImage = bottomMargin * image.size.width/kAppScreenWidth;
    
    CGFloat fontSize = 10;
    CGFloat fontSizeInImage = fontSize*image.size.width/kAppScreenWidth;
    CGFloat strHeight = [locationStr heightForFont:kYbsFontCustom(fontSize) width:kAppScreenWidth-2*leftMargin] + 5;
    CGFloat strHeightInImage = strHeight * image.size.width/kAppScreenWidth;
    
    image = [image imageWaterMarkWithString:locationStr rect:CGRectMake(leftMarginInImage, image.size.height - strHeightInImage - bottomMarginInImage, image.size.width - 2*leftMarginInImage, strHeightInImage) attribute:@{NSFontAttributeName:kYbsFontCustom(fontSizeInImage),NSForegroundColorAttributeName:[UIColor redColor]}];
    return image;
}

- (void)startBtnAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.8];
    animation.duration = 0.25;
    animation.autoreverses = YES;
    animation.repeatCount = 0;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [self.takeBtnCenterImg.layer addAnimation:animation forKey:@"zoom"];
}

- (void)onCloseBtnClick{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.cameraBlock) {
            self.cameraBlock(self.photos);
        }
    }];
}

- (void)changeFlashMode:(UIButton *)sender{
    self.flashFlag = !self.flashFlag;
    __weak typeof (self) weakSelf = self;
    __block UIButton *btn = sender;
    [self changeRearDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice hasFlash]) {
            if (weakSelf.flashFlag) {
                [captureDevice setFlashMode:AVCaptureFlashModeOn];
            }else{
                [captureDevice setFlashMode:AVCaptureFlashModeOff];
            }
        }
        btn.selected = weakSelf.flashFlag;
    }];
}

- (void)changeRearDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.rearDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

- (void)changeFrontDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.frontDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

- (void)changeDevicePosition{
    AVCaptureDeviceInput *deviceInput;
    if (self.currentDeviceInput.device.position == AVCaptureDevicePositionBack) {
        deviceInput = self.frontDeviceInput;
    }else{
        deviceInput = self.rearDeviceInput;
    }
    
    [self.captureSession beginConfiguration];
    [self.captureSession removeInput:self.currentDeviceInput];
    if ([self.captureSession canAddInput:deviceInput]) {
        [self.captureSession addInput:deviceInput];
        self.currentDeviceInput = deviceInput;
        if ([self.currentDeviceInput.device hasFlash]) {
            _flashBtn.hidden = NO;
        }else{
            _flashBtn.hidden = YES;
        }
    }else{
        if ([self.captureSession canAddInput:self.currentDeviceInput]) {
            [self.captureSession addInput:self.currentDeviceInput];
        }
    }
    [self.captureSession commitConfiguration];
    
}

- (void)deviceSubjectAreaDidChange:(NSNotification *)notification{
    AVCaptureDevice *device = notification.object;
    //先进行判断是否支持控制对焦
    if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error = nil;
        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问，
        [device lockForConfiguration:&error];
        [device setFocusMode:AVCaptureFocusModeAutoFocus];
        [self focusAtPoint:self.view.center device:device];
        //操作完成后，记得进行unlock。
        [device unlockForConfiguration];
    }
    
}

- (void)focusAtPoint:(CGPoint)point device:(AVCaptureDevice *)device{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [device setFocusPointOfInterest:focusPoint];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        [device unlockForConfiguration];
    }
    [self setFocusCursorWithPoint:point];
}

-(void)setFocusCursorWithPoint:(CGPoint)point{
    //下面是手触碰屏幕后对焦的效果
    self.focusImgView.center = point;
    self.focusImgView.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.focusImgView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.focusImgView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.focusImgView.hidden = YES;
        }];
    }];
    
}


//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for (i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.view];
        CGPoint convertedLocation = [self.captureVideoPreviewLayer convertPoint:location fromLayer:self.captureVideoPreviewLayer.superlayer];
        if (![self.captureVideoPreviewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if (allTouchesAreOnThePreviewLayer) {
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
    
        CGFloat maxScaleAndCropFactor = [[self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}


#pragma mark - CameraPreviewDelegate

- (void)deletePhotosAtIndex:(NSInteger)index{
    
    if ([self.questionModel.type isEqualToString:@"0"]) {//图片题
        NSString *filePath = self.questionModel.answerPictures[self.initialCount + index];
        NSString *path = [[YFM documentPath] stringByAppendingPathComponent:filePath];
        [YFM deleteFileInPath:path];
        [self.questionModel.answerPictures removeObjectAtIndex:self.initialCount + index];
    }else if ([self.questionModel.type isEqualToString:@"1"]){//图片备注题
        YbsPicText *pt = self.questionModel.answerTextPics[self.initialCount + index];
        NSString *path = [[YFM documentPath] stringByAppendingPathComponent:pt.pic];
        [YFM deleteFileInPath:path];
        [self.questionModel.answerTextPics removeObjectAtIndex:self.initialCount + index];
    }
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
