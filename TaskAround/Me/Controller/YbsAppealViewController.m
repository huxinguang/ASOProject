//
//  YbsAppealViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/23.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsAppealViewController.h"
#import "YbsSelectedPicCell.h"
#import "TZImagePickerController.h"
#import "XG_MediaBrowseView.h"
#import "QCloudCore.h"
#import <QCloudCOSXML/QCloudCOSXML.h>
#import "YbsCameraController.h"
#import "YbsNavigationController.h"


#define kCollectionViewInsetLeftRight 5
#define kItemCountAtEachRow 4
#define kMinimumInteritemSpacing 5
#define kMinimumLineSpacing 5

@interface YbsAppealViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>


@property (nonatomic, strong) UIImageView *unqualifiedImgView;
@property (nonatomic, strong) UILabel *unqualifiedLabel;
@property (nonatomic, strong) UILabel *reasonLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *illustrationLabel;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) UIView *collectionHeader;

@end


@implementation YbsAppealViewController

//- (instancetype)initWithSuccessBlock
//{
//    self = [super init];
//    if (self) {
//        <#statements#>
//    }
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"申诉"];
    
    [self loadData];
    
}

- (void)buildSubViews{
    [self.view addSubview:self.unqualifiedImgView];
    [self.view addSubview:self.unqualifiedLabel];
    [self.view addSubview:self.reasonLabel];
    [self.view addSubview:self.lineView];
//    [self.view addSubview:self.illustrationLabel];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.commitBtn];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, kCollectionViewInsetLeftRight, 0, kCollectionViewInsetLeftRight);
}

- (void)addConstraints{

    [self.unqualifiedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(22*kAppScreenWidth/375);
        make.size.mas_equalTo(CGSizeMake(74*kAppScreenWidth/375, 74*kAppScreenWidth/375));
    }];
    
    [self.unqualifiedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.unqualifiedImgView.mas_bottom).with.offset(10*kAppScreenWidth/375);
    }];
    
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.unqualifiedLabel.mas_bottom).with.offset(7*kAppScreenWidth/375);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonLabel.mas_bottom).with.offset(29*kAppScreenWidth/375);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(10*kAppScreenWidth/375);
    }];
    
//    [self.illustrationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView.mas_bottom).with.offset(23*kAppScreenWidth/375);
//        make.left.equalTo(self.lineView).with.offset(10);
//    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(70*kYbsRatio);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).with.offset(10);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-kAppTabbarSafeBottomMargin - 40*kYbsRatio);
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.equalTo(self.view);
        make.height.mas_equalTo(40*kYbsRatio);
    }];
    
}


- (NSMutableArray *)photos{
    if (!_photos) {
        _photos = [NSMutableArray array];
//        _photos = @[@"",@"",@"",@"",@""].mutableCopy;
    }
    return _photos;
}

- (UIImageView *)unqualifiedImgView{
    if (!_unqualifiedImgView) {
        _unqualifiedImgView = [UIImageView new];
        _unqualifiedImgView.image = kImageNamed(@"unqualified");
    }
    return _unqualifiedImgView;
}

- (UILabel *)unqualifiedLabel{
    if (!_unqualifiedLabel) {
        _unqualifiedLabel = [UILabel new];
        _unqualifiedLabel.font = kYbsFontCustom(20);
        _unqualifiedLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _unqualifiedLabel;
}

- (UILabel *)reasonLabel{
    if (!_reasonLabel) {
        _reasonLabel = [UILabel new];
        _reasonLabel.text = @"对不起，由于您上传的图片模糊不清无法识别，经审核不合格。";
        _reasonLabel.font = kYbsFontCustom(13);
        _reasonLabel.textAlignment = NSTextAlignmentCenter;
        _reasonLabel.textColor = kColorHex(@"#999999");
        _reasonLabel.numberOfLines = 0;
    }
    return _reasonLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = kColorHex(@"#F1F1F1");
    }
    return _lineView;
}

- (UILabel *)illustrationLabel{
    if (!_illustrationLabel) {
        _illustrationLabel = [UILabel new];
        _illustrationLabel.text = @"申诉说明...";
        _illustrationLabel.font = kYbsFontCustom(15);
        _illustrationLabel.textColor = kColorHex(@"#999999");
    }
    return _illustrationLabel;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = kYbsFontCustom(15);
        _textView.xg_placeholder = @"申诉说明...";
    }
    return _textView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemWH = (kAppScreenWidth - 20 - (kItemCountAtEachRow-1)*kMinimumInteritemSpacing - 2*kCollectionViewInsetLeftRight)/kItemCountAtEachRow;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.minimumInteritemSpacing = kMinimumInteritemSpacing;
        layout.minimumLineSpacing = kMinimumLineSpacing;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[YbsSelectedPicCell class] forCellWithReuseIdentifier:NSStringFromClass([YbsSelectedPicCell class])];
    }
    return _collectionView;
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.backgroundColor = kColorHex(@"#FF2F29");
        [_commitBtn setTitle:@"提交申诉" forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _commitBtn;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YbsSelectedPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YbsSelectedPicCell class]) forIndexPath:indexPath];
    
    if (indexPath.item == self.photos.count ) {
        cell.imgView.image = kImageNamed(@"add");
        cell.deleteBtn.hidden = YES;
    }else{
        cell.imgView.image = self.photos[indexPath.item];
        cell.deleteBtn.hidden = NO;
    }
    
    [cell.deleteBtn addTarget:self action:@selector(onDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == self.photos.count) {
        
        __weak typeof (self) weakSelf = self;
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"选择照片来源" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [weakSelf takePhoto];
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [weakSelf chooseFromAlbum];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [actionSheet addAction:action3];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
        
    }else{
        
        XG_MediaBrowseView *v = [[XG_MediaBrowseView alloc] initWithItems:self.photos];
        [v presentCellImageAtIndexPath:indexPath FromCollectionView:self.collectionView toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
        
    }
}


#pragma mark 打开相机操作
-(void)takePhoto{
    
    AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((cameraStatus == AVAuthorizationStatusRestricted || cameraStatus ==AVAuthorizationStatusDenied)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"提示"                                                                               message: @"您还没有开启相机权限，请到”设置“中开启" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction: [UIAlertAction actionWithTitle: @"去设置" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        
        [self presentViewController: alertController animated: YES completion: nil];
        
    } else if (cameraStatus == AVAuthorizationStatusNotDetermined) {
        //防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self pushCameraVC];
                });
            }
        }];
    } else {
        [self pushCameraVC];
    }
}

- (void)pushCameraVC{
    YbsCameraController *vc = [[YbsCameraController alloc]init];
    vc.needWatermark = NO;
    vc.initialCount = self.photos.count;
    __weak typeof (self) weakSelf = self;
    vc.cameraBlock = ^(NSArray *array){
        [weakSelf.photos addObjectsFromArray:array];
        [weakSelf.collectionView reloadData];
    };
    
    UINavigationController *nav = [[YbsNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 从相册选取

- (void)chooseFromAlbum{
    TZImagePickerController *pickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:100 delegate:self];
    pickerVc.allowTakePicture = NO;
    pickerVc.allowPickingOriginalPhoto = NO;
    pickerVc.allowPickingVideo = NO;
    [self presentViewController:pickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    [self.photos addObjectsFromArray:photos];
    [self.collectionView reloadData];
}

#pragma mark - Action

- (void)onDeleteBtnClick:(UIButton *)sender{
    /*
     performBatchUpdates并不会调用代理方法collectionView: cellForItemAtIndexPath，
     如果用删除按钮的tag来标识则tag不会更新,所以此处没有用tag
     */
    YbsSelectedPicCell *cell = (YbsSelectedPicCell *)sender.superview.superview;
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[indexpath]];
        [self.photos removeObjectAtIndex:indexpath.item];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)commitBtnAction{
    
    if (self.textView.text.length == 0) {
        [self showMessage:@"请添加申诉说明" hideDelay:1];
        return;
    }
    
    if (self.photos.count == 0) {
        [self showMessage:@"请添加图片" hideDelay:1];
        return;
    }
    
    [self packData];

}


#pragma mark - data

- (void)loadData{
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi unqualifiedReasonUrl]
                              parameters:@{@"paperId":self.paperId}
                                 success:^(id  _Nonnull responseObject) {
                                     [SVProgressHUD dismiss];
                                     @strongify(self);
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]) {
                                         
                                         [self buildSubViews];
                                         [self addConstraints];
                                         NSString *title = dic[kYbsDataKey][@"title"];
                                         self.unqualifiedLabel.text = title?title:@"";
                                         self.reasonLabel.text = dic[kYbsDataKey][@"content"];
                                     }else{
                                         [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                     
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                     [self showMessage:kYbsRequestFailed hideDelay:1];
                                 }
     ];
    
}


- (void)packData{
    
    
    dispatch_queue_t queue = dispatch_queue_create("ybs_appeal_submit_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    NSMutableArray *imgs = [NSMutableArray new];
    for (int k=0; k<self.photos.count; k++) {
        [imgs addObject:@"image_placeholder"];
    }
    
    for (int j=0; j<self.photos.count; j++) {
        
        @weakify(self);
        dispatch_group_enter(group);
        dispatch_group_async(group,queue,^{
            @strongify(self)
            if (!self) return;
            QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
            
            NSData *data = UIImageJPEGRepresentation(self.photos[j], 1);
            put.object = [NSString stringWithFormat:@"ios/%@_%@_%d.jpg",kCurrentTimestampMillisecond,[NSString randomStringWithLength:6],j];
            if ([[YbsApi baseUrl] isEqualToString:[YbsApi baseReleaseUrl]]) {
                put.bucket = kQCloudBucket;
            }else{
                put.bucket = kQCloudTestBucket;
            }
            put.body = data;
            [put setFinishBlock:^(QCloudUploadObjectResult *outputObject, NSError* error) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showMessage:@"网络不佳，请重新上传" hideDelay:1];
                    });
                    return ;
                }
                [imgs replaceObjectAtIndex:j withObject:outputObject.location];
                dispatch_group_leave(group);
            }];
            [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
            
        });
    }
    
    @weakify(self);
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        @strongify(self);
        if (!self) return;
        
        NSDictionary *dic = @{
                              @"paperId":self.paperId,
                              @"appealReason":self.textView.text,
                              @"appealImgs":imgs
                              };
        
        [self submitWithDic:dic];
    });
    
}


- (void)submitWithDic:(NSDictionary *)dic{
    
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi appealUrl]
                              parameters:dic
                                 success:^(id  _Nonnull responseObject) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]){
                                         
                                         [self showMessage:@"提交申诉成功" hideDelay:2 complete:^{
                                             
                                             UIViewController *vc = [self getViewControllerThatPushMe];
                                             vc.appearedNeedRefresh = YES;
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
                                         
                                     }else{
                                         [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                     
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                     [self showMessage:kYbsRequestFailed hideDelay:1];
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
