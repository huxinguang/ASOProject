//
//  YbsQACollectionViewCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/31.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsQATableViewCell.h"
#import "YbsSelectedPicCell.h"
#import "YbsVoiceCell.h"
#import "TZImagePickerController.h"
#import "YbsAudioRecordView.h"
#import "YbsPicTextTableViewCell.h"
#import "YbsChoiceCell.h"
#import "YbsQuestionModel.h"
#import "XG_MediaBrowseView.h"
#import "YbsFileManager.h"
#import "YbsQAViewController.h"
#import "YbsLocationManager.h"
#import "UIImage+YbsUtil.h"
#import "lame.h"
#import "SKPreviewer.h"
#import "YbsCameraController.h"
#import "YbsNavigationController.h"
#import <Photos/Photos.h>


#define kMarginLeftRight 10

#define kItemCountAtEachRow 4
#define kMinimumInteritemSpacing 5
#define kMinimumLineSpacing 5

#define kCollectionViewCellHW ((kAppScreenWidth - (kItemCountAtEachRow-1)*kMinimumInteritemSpacing - 2*kMarginLeftRight)/kItemCountAtEachRow)


#define kQLabelTopMargin 18
#define kQLabelBottomMargin 18
#define kQLabelWidth (kAppScreenWidth - kMarginLeftRight - kMarginLeftRight)

#define kExampleLabelHeight                 20
#define kExampleImageBtnHW                  kCollectionViewCellHW
#define kExampleLabelMarginTop              10
#define kExampleImageBtnMarginTop           10
#define kExampleImageBtnMarginBottom        10
#define kExampleViewHeight  (kExampleLabelHeight + kExampleImageBtnHW + kExampleLabelMarginTop + kExampleImageBtnMarginTop + kExampleImageBtnMarginBottom)


@interface YbsQATableViewCell ()

@end

@implementation YbsQATableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.qLabel];
        [self.contentView addSubview:self.exampleView];
        
        self.exampleView.layer.borderColor = kColorHex(@"#D0D0D0").CGColor;
        self.exampleView.layer.borderWidth = 0.5;
        
        [self.exampleView addSubview:self.exampleLabel];
        [self.exampleView addSubview:self.exampleSV];
        
        [self.qLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(kQLabelTopMargin);
            make.left.equalTo(self.contentView).with.offset(kMarginLeftRight);
            make.right.equalTo(self.contentView).with.offset(-kMarginLeftRight);
        }];
        
    }
    return self;
}


-(UILabel *)qLabel{
    if (!_qLabel) {
        _qLabel = [UILabel new];
        _qLabel.textAlignment = NSTextAlignmentLeft;
        _qLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _qLabel.textColor = kColorHex(@"#2F2F2F");
        _qLabel.font = kYbsFontCustom(15);
        _qLabel.numberOfLines = 0;
    }
    return _qLabel;
}

-(UIView *)exampleView{
    if (!_exampleView) {
        _exampleView = [UIView new];
        _exampleView.backgroundColor = [UIColor whiteColor];
    }
    return _exampleView;
}

-(UILabel *)exampleLabel{
    if (!_exampleLabel) {
        _exampleLabel = [UILabel new];
        _exampleLabel.textAlignment = NSTextAlignmentLeft;
        _exampleLabel.font = kYbsFontCustom(16);
        _exampleLabel.text = @"示例图片：";
    }
    return _exampleLabel;
}

-(UIScrollView *)exampleSV{
    if (!_exampleSV) {
        _exampleSV = [[UIScrollView alloc]init];
        _exampleSV.bounces = YES;
        _exampleSV.showsHorizontalScrollIndicator = NO;
        _exampleSV.showsVerticalScrollIndicator = NO;
    }
    return _exampleSV;
}


+ (BOOL)requiresConstraintBasedLayout{
    return YES;
}

- (void)updateConstraints{
    
    if (self.questionModel.exampleImgs && self.questionModel.exampleImgs.count >0 ) {
        [self.exampleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.qLabel.mas_bottom).with.offset(10);
            make.left.equalTo(self.qLabel);
            make.right.equalTo(self.qLabel);
            make.height.mas_equalTo(kExampleViewHeight);
        }];
        
        [self.exampleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.exampleView).with.offset(10);
            make.left.equalTo(self.exampleView).with.offset(10);
            make.height.mas_equalTo(kExampleLabelHeight);
        }];
        
        [self.exampleSV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.exampleLabel.mas_bottom).with.offset(kExampleImageBtnMarginTop);
            make.left.equalTo(self.exampleLabel);
            make.right.equalTo(self.exampleView).with.offset(-10);
            make.height.mas_equalTo(kCollectionViewCellHW);
        }];
        
        
    }else{
        [self.exampleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.qLabel.mas_bottom).with.offset(10);
            make.left.equalTo(self.qLabel);
            make.right.equalTo(self.qLabel);
            make.height.mas_equalTo(0);
        }];
        
        [self.exampleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.exampleView).with.offset(10);
            make.left.equalTo(self.exampleView).with.offset(10);
            make.height.mas_equalTo(0);
        }];
        
        [self.exampleSV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.exampleLabel.mas_bottom).with.offset(kExampleImageBtnMarginTop);
            make.left.equalTo(self.exampleLabel);
            make.right.equalTo(self.exampleView).with.offset(-10);
            make.height.mas_equalTo(0);
        }];
        

    }
    
    [super updateConstraints];
}





+ (NSString *)identifierForCellWithModel:(YbsQueModel *)model{
    switch ([model.type integerValue]) {
        case QuestionTypePicture:
        {
            return NSStringFromClass([PictureCell class]);
        }
            break;
        case QuestionTypeTextPicture:
        {
            return NSStringFromClass([TextPictureCell class]);
        }
            break;
        case QuestionTypeVoice:
        {
            return NSStringFromClass([VoiceCell class]);
        }
            break;
        case QuestionTypeTextInput:
        {
            return NSStringFromClass([TextInputCell class]);
        }
            break;
        case QuestionTypeDirection:
        {
            return NSStringFromClass([DirectionCell class]);
        }
            break;
        
        case QuestionTypeSingleChoice:
        {
            return NSStringFromClass([SingleChoiceCell class]);
        }
            break;
        case QuestionTypeMultipleChoice:
        {
            return NSStringFromClass([MultipleChoiceCell class]);
        }
            break;
        default:
            return NSStringFromClass([DirectionCell class]);
            break;
    }
    
}

- (void)reloadWithModel:(YbsQueModel *)model{
    self.questionModel = model;
    self.qLabel.text = model.title;
    
    [self.exampleSV removeAllSubviews];
    
    
    
    self.exampleSV.contentSize = CGSizeMake(kCollectionViewCellHW*model.exampleImgs.count + kMinimumInteritemSpacing * (model.exampleImgs.count -1), kCollectionViewCellHW);
    
    for (int i=0; i<model.exampleImgs.count; i++) {
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgBtn setImageWithURL:[NSURL URLWithString:model.exampleImgs[i]] forState:UIControlStateNormal options:YYWebImageOptionProgressive];
        imgBtn.frame = CGRectMake((kCollectionViewCellHW + kMinimumInteritemSpacing) *i, 0, kCollectionViewCellHW, kCollectionViewCellHW);
        [self.exampleSV addSubview:imgBtn];
        [imgBtn addTarget:self action:@selector(exampleImgClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)exampleImgClick:(UIButton *)sender{
    [SKPreviewer previewFromImageView:sender.imageView container:self.qavc.navigationController.view];
}

- (void)prepareForReuse{
    [super prepareForReuse];
//    LoggerApp(1,@"prepareForReuse ==== %@",NSStringFromClass([self class]));
}

@end



@implementation DirectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}


- (void)reloadWithModel:(YbsQueModel *)model{
    [super reloadWithModel:model];

}

@end


@interface SingleChoiceCell ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *tableHeader;

@end

@implementation SingleChoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.exampleView.mas_bottom).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(kMarginLeftRight);
            make.right.equalTo(self.contentView).with.offset(-kMarginLeftRight);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsMultipleSelection = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (void)reloadWithModel:(YbsQueModel *)model{
    [super reloadWithModel:model];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionModel.specAttr.choices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellID";
    YbsChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YbsChoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    YbsQuestionChioce *choice = self.questionModel.specAttr.choices[indexPath.row];
    cell.choiceLabel.text = choice.content;
    
    if (self.questionModel.answerChioces.count > 0) {
        NSInteger selectedIndex = [self.questionModel.answerChioces[0] integerValue];
        if (indexPath.row == selectedIndex) {
            [cell updateCheckBox:YES];
        }else{
            [cell updateCheckBox:NO];
        }
    }else{
        [cell updateCheckBox:NO];
    }
    
    if (self.questionModel.visibleChoices && self.questionModel.visibleChoices.count >0) {
        cell.hidden = YES;
        for (int i=0; i<self.questionModel.visibleChoices.count; i++) {
            if ([self.questionModel.visibleChoices[i] integerValue] == indexPath.row) {
                cell.hidden = NO;
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.questionModel.answerChioces.count > 0) {
        if ([self.questionModel.answerChioces[0] integerValue] == indexPath.row) {
            [self.questionModel.answerChioces removeAllObjects];
        }else{
            [self.questionModel.answerChioces removeAllObjects];
            [self.questionModel.answerChioces addObject:[NSNumber numberWithInteger:indexPath.row]];
        }
    }else{
        [self.questionModel.answerChioces removeAllObjects];
        [self.questionModel.answerChioces addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    
    [tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(quetionLogicDidUpdate)]) {
        [self.delegate quetionLogicDidUpdate];
    }

}

@end



@interface MultipleChoiceCell ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *tableHeader;

@end

@implementation MultipleChoiceCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.exampleView.mas_bottom).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(kMarginLeftRight);
            make.right.equalTo(self.contentView).with.offset(-kMarginLeftRight);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsMultipleSelection = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}


- (void)reloadWithModel:(YbsQueModel *)model{
    [super reloadWithModel:model];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionModel.specAttr.choices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellID";
    YbsChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YbsChoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YbsQuestionChioce *choice = self.questionModel.specAttr.choices[indexPath.row];
    cell.choiceLabel.text = choice.content;
    
    if (self.questionModel.answerChioces.count > 0) {
        BOOL choosed = NO;
        for (int i=0; i<self.questionModel.answerChioces.count; i++) {
            NSInteger index = [self.questionModel.answerChioces[i] integerValue];
            if (indexPath.row == index) {
                choosed = YES;
            }
        }
        if (choosed) {
            [cell updateCheckBox:YES];
        }else{
            [cell updateCheckBox:NO];
        }
    }else{
        [cell updateCheckBox:NO];
    }
    
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL choosed = NO;
    NSInteger indexInAnswerChioces = 0;
    for (int i=0; i<self.questionModel.answerChioces.count; i++) {
        NSInteger index = [self.questionModel.answerChioces[i] integerValue];
        if (indexPath.row == index) {
            choosed = YES;
            indexInAnswerChioces = i;
        }
    }
    if (!choosed) {
        if (self.questionModel.answerChioces.count >= [self.questionModel.specAttr.choiceMax integerValue]) {
            [[UIViewController currentViewController] showMessage:[NSString stringWithFormat:@"最多选%@项",self.questionModel.specAttr.choiceMax] hideDelay:1];
        }else{
            [self.questionModel.answerChioces addObject:[NSNumber numberWithInteger:indexPath.row]];
            
            NSArray *array = self.questionModel.answerChioces.copy;
    
            //对数组进行排序
            NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2]; //升序
            }];
            
            self.questionModel.answerChioces = result.mutableCopy;
        
        }
    }else{
        [self.questionModel.answerChioces removeObjectAtIndex:indexInAnswerChioces];
    }
    [tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(quetionLogicDidUpdate)]) {
        [self.delegate quetionLogicDidUpdate];
    }
    
}

- (void)syncChoices{
    [self.questionModel.answerChioces removeAllObjects];
    NSArray *selectedArr = [self.tableView indexPathsForSelectedRows];
    for (int i=0; i<selectedArr.count; i++) {
        NSIndexPath *ipath = selectedArr[i];
        [self.questionModel.answerChioces addObject:[NSNumber numberWithInteger:ipath.row]];
    }
    
}


@end





typedef void(^ClickPicBlock)(NSInteger);

@interface PictureCell ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, copy  ) ClickPicBlock block;
@property (nonatomic, strong) UIView *collectionHeader;


@end

@implementation PictureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.exampleView.mas_bottom).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(kMarginLeftRight);
            make.right.equalTo(self.contentView).with.offset(-kMarginLeftRight);
            make.bottom.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(kCollectionViewCellHW, kCollectionViewCellHW);
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


- (void)resetHeaderHeight:(CGFloat)height {
    self.collectionView.contentInset = UIEdgeInsetsMake(height, kMarginLeftRight, 0, kMarginLeftRight);
    self.collectionHeader.frame = CGRectMake(0, -height, kAppScreenWidth-2*kMarginLeftRight, height);
}

- (void)reloadWithModel:(YbsQueModel *)model{
    [super reloadWithModel:model];

    [self.collectionView reloadData];
    
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.questionModel.answerPictures.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YbsSelectedPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YbsSelectedPicCell class]) forIndexPath:indexPath];

    if (indexPath.item == self.questionModel.answerPictures.count ) {
        cell.imgView.image = kImageNamed(@"add");
        cell.deleteBtn.hidden = YES;
    }else{
        NSString *imgPath = [[YFM documentPath] stringByAppendingPathComponent:self.questionModel.answerPictures[indexPath.item]];
        cell.imgView.image = [UIImage imageWithContentsOfFile:imgPath];
        cell.deleteBtn.hidden = NO;
    }

    [cell.deleteBtn addTarget:self action:@selector(onDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == self.questionModel.answerPictures.count) {
        
        if ([self.questionModel.specAttr.uploadFromAlbum isEqualToString:@"0"]) {//不允许从相册选取
            [self takePhoto];

        }else{
        
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
        
            [self.qavc presentViewController:actionSheet animated:YES completion:nil];

        }
    
    }else{
        
        XG_MediaBrowseView *v = [[XG_MediaBrowseView alloc] initWithItems:self.questionModel.answerPictures];
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
        
        [self.qavc presentViewController: alertController animated: YES completion: nil];
        
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
    vc.needWatermark = YES;
    vc.initialCount = self.questionModel.answerPictures.count;
    vc.taskModel = self.qavc.taskModel;
    vc.questionModel = self.questionModel;
    __weak typeof (self) weakSelf = self;
    vc.cameraBlock = ^(NSArray *array){
        [weakSelf.collectionView reloadData];
    };
    
    UINavigationController *nav = [[YbsNavigationController alloc] initWithRootViewController:vc];
    [self.qavc presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 从相册选取

- (void)chooseFromAlbum{
    TZImagePickerController *pickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:100 delegate:self];
    pickerVc.allowTakePicture = NO;
    [TZImageManager manager].questionModel = self.questionModel;
    [TZImageManager manager].taskModel = self.qavc.taskModel;
    
    pickerVc.allowPickingOriginalPhoto = NO;
    pickerVc.allowPickingVideo = NO;
    [self.qavc presentViewController:pickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    NSString *answerDirName = [NSString stringWithFormat:@"task_%@_%@_answer",self.questionModel.taskId,self.qavc.taskModel.storeId];
    NSString *dir = [YFM createDirectoryInDocumentWithName:answerDirName];
    
    if (dir) {
        for (int i=0; i<photos.count; i++) {
            NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg",kCurrentTimestampMillisecond,[NSString randomStringWithLength:3]];
            NSString *finalPath = [dir stringByAppendingPathComponent:fileName];
            NSString *finalPathComponent = [answerDirName stringByAppendingPathComponent:fileName];
            NSData *data = UIImageJPEGRepresentation(photos[i], 0.5);
            if (dir) {
                if ([data writeToFile:finalPath atomically:YES]) {
//                    [self.questionModel.answerPictures addObject:finalPath];
                    [self.questionModel.answerPictures addObject:finalPathComponent];
                }
            }
        }
    }
    
    [self.collectionView reloadData];
}


- (void)onDeleteBtnClick:(UIButton *)sender{
    /*
     performBatchUpdates并不会调用代理方法collectionView: cellForItemAtIndexPath，
     如果用删除按钮的tag来标识则tag不会更新,所以此处没有用tag
     */
    YbsSelectedPicCell *cell = (YbsSelectedPicCell *)sender.superview.superview;
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    NSString *imgPath = self.questionModel.answerPictures[indexpath.item];
    NSString *path = [[YFM documentPath] stringByAppendingPathComponent:imgPath];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[indexpath]];
        [YFM deleteFileInPath:path];
        [self.questionModel.answerPictures removeObjectAtIndex:indexpath.item];
        
    } completion:^(BOOL finished) {

    }];
    
}


@end



@interface TextPictureCell ()<UITableViewDelegate, UITableViewDataSource,TZImagePickerControllerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSIndexPath *editingIndexPath;
@property (nonatomic, strong) UIView *tableHeader;

@end

@implementation TextPictureCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.exampleView.mas_bottom).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(kMarginLeftRight);
            make.right.equalTo(self.contentView).with.offset(-kMarginLeftRight);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

-(UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = kCollectionViewCellHW + 5*2;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (void)reloadWithModel:(YbsQueModel *)model{
    [super reloadWithModel:model];
    
    [self.tableView reloadData];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionModel.answerTextPics.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellID";
    YbsPicTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YbsPicTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == self.questionModel.answerTextPics.count) {
        [cell.imgBtn setImage:kImageNamed(@"add") forState:UIControlStateNormal];
        cell.textView.text = @"";
        cell.deleteBtn.hidden = YES;
        cell.textView.editable = NO;
    }else{
        YbsPicText *pt = self.questionModel.answerTextPics[indexPath.row];
        NSString *imgPath = [[YFM documentPath] stringByAppendingPathComponent:pt.pic];
        [cell.imgBtn setImage:[UIImage imageWithContentsOfFile:imgPath] forState:UIControlStateNormal];
        cell.textView.text = pt.text;
        cell.deleteBtn.hidden = NO;
        cell.textView.editable = YES;
    }
    
    [cell.imgBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(onDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.textView.delegate = self;
    
    cell.textView.tag = indexPath.row;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)btnClick:(UIButton *)sender{
    YbsPicTextTableViewCell *cell = (YbsPicTextTableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.editingIndexPath = indexPath;
    
    if ([self.questionModel.specAttr.uploadFromAlbum isEqualToString:@"0"]){
        if (indexPath.row == self.questionModel.answerTextPics.count) {
            [self takePhoto];
        }else{
            [SKPreviewer previewFromImageView:sender.imageView container:self.qavc.navigationController.view];
        }
        
    }else{
        
        if (indexPath.row == self.questionModel.answerTextPics.count) {
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
            
            [self.qavc presentViewController:actionSheet animated:YES completion:nil];
        }else{
            [SKPreviewer previewFromImageView:sender.imageView container:self.qavc.navigationController.view];
        }
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
        
        [self.qavc presentViewController: alertController animated: YES completion: nil];
        
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
    vc.needWatermark = YES;
    vc.initialCount = self.questionModel.answerTextPics.count;
    vc.taskModel = self.qavc.taskModel;
    vc.questionModel = self.questionModel;
    __weak typeof (self) weakSelf = self;
    vc.cameraBlock = ^(NSArray *array){
        [weakSelf.tableView reloadData];
    };
    
    UINavigationController *nav = [[YbsNavigationController alloc] initWithRootViewController:vc];
    [self.qavc presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 从相册选取

- (void)chooseFromAlbum{
    TZImagePickerController *pickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:100 delegate:self];
    pickerVc.allowTakePicture = NO;
    [TZImageManager manager].questionModel = self.questionModel;
    [TZImageManager manager].taskModel = self.qavc.taskModel;
    
    pickerVc.allowPickingOriginalPhoto = NO;
    pickerVc.allowPickingVideo = NO;
    [self.qavc presentViewController:pickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    NSString *answerDirName = [NSString stringWithFormat:@"task_%@_%@_answer",self.questionModel.taskId,self.qavc.taskModel.storeId];
    NSString *dir = [YFM createDirectoryInDocumentWithName:answerDirName];
    
    if (dir) {
        for (int i=0; i<photos.count; i++) {
            NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg",kCurrentTimestampMillisecond,[NSString randomStringWithLength:3]];
            NSString *finalPath = [dir stringByAppendingPathComponent:fileName];
            NSString *finalPathComponent = [answerDirName stringByAppendingPathComponent:fileName];
            NSData *data = UIImageJPEGRepresentation(photos[i], kYbsCompressionQuality);
            if (dir) {
                if ([data writeToFile:finalPath atomically:YES]) {
                    YbsPicText *pt = [YbsPicText new];
//                    pt.pic = finalPath;
                    pt.pic = finalPathComponent;
                    [self.questionModel.answerTextPics addObject:pt];
                }
            }
        }
    }
    
    [self.tableView reloadData];
    
}

- (void)onDeleteBtnClick:(UIButton *)sender{
    YbsPicTextTableViewCell *cell = (YbsPicTextTableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSString *imgPath = self.questionModel.answerTextPics[indexPath.row].pic;
    NSString *path = [[YFM documentPath] stringByAppendingPathComponent:imgPath];
    [YFM deleteFileInPath:path];
    [self.questionModel.answerTextPics removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView{
    YbsPicTextTableViewCell *cell = (YbsPicTextTableViewCell *)textView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YbsPicText *pt = self.questionModel.answerTextPics[indexPath.row];
    pt.text = textView.text;
    
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.tag == self.questionModel.answerTextPics.count) {
        
    }else{
        self.questionModel.answerTextPics[textView.tag].text = textView.text;
    }
    
}


@end


@interface VoiceCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIView *collectionHeader;

@end

@implementation VoiceCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionView];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.exampleView.mas_bottom).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(kMarginLeftRight);
            make.right.equalTo(self.contentView).with.offset(-kMarginLeftRight);
            make.bottom.equalTo(self.contentView);
        }];
    
    }
    return self;
}

- (UIView *)collectionHeader{
    if (!_collectionHeader) {
        _collectionHeader = [UIView new];
        [self.collectionView addSubview:self.collectionHeader];
    }
    return _collectionHeader;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemWH = (kAppScreenWidth - (kItemCountAtEachRow-1)*kMinimumInteritemSpacing - 2*kMarginLeftRight)/kItemCountAtEachRow;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.minimumInteritemSpacing = kMinimumInteritemSpacing;
        layout.minimumLineSpacing = kMinimumLineSpacing;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[YbsVoiceCell class] forCellWithReuseIdentifier:NSStringFromClass([YbsVoiceCell class])];
    }
    return _collectionView;
}

- (void)reloadWithModel:(YbsQueModel *)model{
    [super reloadWithModel:model];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.questionModel.answerVoices.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YbsVoiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YbsVoiceCell class]) forIndexPath:indexPath];
    
    if (indexPath.item == self.questionModel.answerVoices.count ) {
        cell.deleteBtn.hidden = YES;
        cell.addIcon.hidden = NO;
        cell.container.hidden = YES;
    }else{
        cell.deleteBtn.hidden = NO;
        cell.addIcon.hidden = YES;
        cell.container.hidden = NO;
        cell.backgroundColor = kColorHex(@"#FF9E00");
        YbsVoiceModel *vm = self.questionModel.answerVoices[indexPath.item];
        cell.timeLabel.text = [self formatTimeLength:vm.timeLength];
    }
    [cell.deleteBtn addTarget:self action:@selector(onDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSString *originalPath = nil;
    YbsVoiceModel *voiceModel = nil;
    
    if (indexPath.item == self.questionModel.answerVoices.count) {
        originalPath = @"";
        voiceModel = [YbsVoiceModel new];
    }else{
        originalPath = self.questionModel.answerVoices[indexPath.item].voicePath;
        voiceModel = self.questionModel.answerVoices[indexPath.item];
    }
    
    @weakify(self);

    
    YbsAudioRecordView *ard = [[YbsAudioRecordView alloc]initWithVoiceModel:voiceModel quetionModel:self.questionModel taskModel:self.qavc.taskModel chooseBlock:^(YbsVoiceModel *vm) {
        @strongify(self);
        if (indexPath.item == self.questionModel.answerVoices.count) {
            if (vm && vm.voicePath.length > 0) {
                [self.questionModel.answerVoices addObject:vm];
            }
        }else{
            if (!vm || vm.voicePath.length == 0) {
                [self.questionModel.answerVoices removeObjectAtIndex:indexPath.item];
            }else{
                [self.questionModel.answerVoices replaceObjectAtIndex:indexPath.item withObject:vm];
            }
        }
        
        [self.collectionView reloadData];
        
    }];
    
    
//    YbsAudioRecordView *ard = [[YbsAudioRecordView alloc]initWithVoiceModel:voiceModel quetionModel:self.questionModel chooseBlock:^(YbsVoiceModel *vm) {
//        @strongify(self);
//        if (indexPath.item == self.questionModel.answerVoices.count) {
//            if (vm && vm.voicePath.length > 0) {
//                [self.questionModel.answerVoices addObject:vm];
//            }
//        }else{
//            if (!vm || vm.voicePath.length == 0) {
//                [self.questionModel.answerVoices removeObjectAtIndex:indexPath.item];
//            }else{
//                [self.questionModel.answerVoices replaceObjectAtIndex:indexPath.item withObject:vm];
//            }
//        }
//
//        [self.collectionView reloadData];
//
//    }];
//
    
    
    [ard show];

}

- (void)onDeleteBtnClick:(UIButton *)sender{
    /*
     performBatchUpdates并不会调用代理方法collectionView: cellForItemAtIndexPath，
     如果用删除按钮的tag来标识则tag不会更新,所以此处没有用tag
     */
    YbsVoiceCell *cell = (YbsVoiceCell *)sender.superview.superview;
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    NSString *audioPath = self.questionModel.answerVoices[indexpath.item].voicePath;
    NSString *path = [[YFM documentPath] stringByAppendingPathComponent:audioPath];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[indexpath]];
        [YFM deleteFileInPath:path];
        [self.questionModel.answerVoices removeObjectAtIndex:indexpath.item];
    } completion:^(BOOL finished) {
//        [self.voiceArray removeObjectAtIndex:indexpath.item-1];
    }];
    
    
}

- (NSString *)formatTimeLength:(NSTimeInterval)time{
    int tl = round(time);
    if (tl < 10) {
        return [NSString stringWithFormat:@"0:0%d",tl];
    }else if (tl >= 10 && tl < 60) {
        return [NSString stringWithFormat:@"0:%d",tl];
    }else if (tl >= 60 && tl < 10*60){
        int minute = tl/60;
        int seconds = tl%60;
        if (seconds < 10) {
            return [NSString stringWithFormat:@"%d:0%d",minute,seconds];
        }else{
            return [NSString stringWithFormat:@"%d:%d",minute,seconds];
        }
    }else{
        return @"";
    }
}

@end

@interface TextInputCell ()<UITextViewDelegate>

@end


@implementation TextInputCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.exampleView.mas_bottom).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(kMarginLeftRight);
            make.right.equalTo(self.contentView).with.offset(-kMarginLeftRight);
            make.height.mas_equalTo(100);
        }];
        
  
    }
    return self;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = kYbsFontCustom(15);
        _textView.xg_placeholder = @"请输入内容...";
        _textView.delegate = self;
    }
    return _textView;
}


- (void)reloadWithModel:(YbsQueModel *)model{
    [super reloadWithModel:model];
    self.textView.text = model.answerString;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    self.questionModel.answerString = textView.text;
    
    if ([self.delegate respondsToSelector:@selector(quetionLogicDidUpdate)]) {
        [self.delegate quetionLogicDidUpdate];
    }
}



@end


