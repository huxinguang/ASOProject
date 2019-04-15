//
//  YbsPersonalInfoController.m
//  XGDemo
//
//  Created by 胡辉 on 2019/2/21.
//  Copyright © 2019 胡辉. All rights reserved.
//

#import "YbsPersonalInfoController.h"
#import "YbsInfoCell.h"
#import "YbsInfoHeaderCell.h"
#import "YbsChangePhoneViewController.h"
#import "TZImagePickerController.h"
#import "QCloudCore.h"
#import <QCloudCOSXML/QCloudCOSXML.h>

#define kDatePickerHeight 216
#define kDatePickerWhiteBgHeight (250 + kAppTabbarSafeBottomMargin)

@interface YbsPersonalInfoController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray *infoArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YbsDatePicker *datePicker;
@property (nonatomic, strong) NSDictionary *userInfoDic;


@end

static NSString *headerCellID = @"YBS_PROFILE_HEADER_CELL";
static NSString *infoCellID = @"YBS_PROFILE_INFO_CELL";

@implementation YbsPersonalInfoController


- (void)viewDidLoad {
    [super viewDidLoad];
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"个人信息"];
    
    self.userInfoDic = kUserDefaultGet(kYbsUserInfoDicKey);
    
    self.infoArr = @[@"昵称",@"手机号码",@"性别",@"出生日期"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YbsInfoCell class] forCellReuseIdentifier:infoCellID];
        [_tableView registerClass:[YbsInfoHeaderCell class] forCellReuseIdentifier:headerCellID];
    }
    return _tableView;
}

- (YbsDatePicker *)datePicker{
    if (!_datePicker) {
        __weak typeof (self) weakSelf = self;
        _datePicker = [[YbsDatePicker alloc]initWithBlock:^(NSString *dateString) {
            [weakSelf updateUserInfo:@{@"birthday":dateString}];
        }];
    }
    return _datePicker;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.infoArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YbsInfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellID];
        if (!cell) {
            cell = [[YbsInfoHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellID];
        }
        cell.titleLabel.text = @"头像";
        NSString *imgUrl = self.userInfoDic[@"headImg"];
        
        [cell.avatarImgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:kImageNamed(@"profile_info_avatar")];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        YbsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellID];
        if (!cell) {
            cell = [[YbsInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCellID];
        }
        cell.titleLabel.text = self.infoArr[indexPath.row];
        if (indexPath.row == 0) {
            NSString *nameStr = self.userInfoDic[@"nickName"];
            if (nameStr.length > 0) {
                cell.infoLabel.text = self.userInfoDic[@"nickName"];
            }else{
                cell.infoLabel.text = @"未设置";
            }

        }else if (indexPath.row == 1){
            NSString *mobile = self.userInfoDic[@"mobile"];
            if (mobile.length > 0) {
                NSMutableString *mutStr = [[NSMutableString alloc]initWithString:mobile];
                [mutStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                cell.infoLabel.text = mutStr;
            }else{
                cell.infoLabel.text = @"未设置";
            }
        
        }else if (indexPath.row == 2){
            if (self.userInfoDic[@"sex"]) {
                if (self.userInfoDic[@"sex"]) {
                    if ([self.userInfoDic[@"sex"] isEqualToString:@"0"]) {
                        cell.infoLabel.text = @"未设置";
                    }else if([self.userInfoDic[@"sex"] isEqualToString:@"1"]){
                        cell.infoLabel.text = @"男";
                    }else{
                        cell.infoLabel.text = @"女";
                    }
                }
            }
            
        }else{
            NSString *birthday = self.userInfoDic[@"birthday"];
            if (birthday && birthday.length > 0) {
                cell.infoLabel.text = self.userInfoDic[@"birthday"];
            }else{
                cell.infoLabel.text = @"未设置";
            }
            
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self avatarClick];
    }else{
        switch (indexPath.row) {
            case 0:
            {
                [self nicknameClick];
            }
                break;
            case 1:
            {
                YbsChangePhoneViewController *vc = [[YbsChangePhoneViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                [self genderClick];
            }
                break;
            case 3:
            {
                [self.datePicker show];
            }
                break;
            default:
                break;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100*kAppScreenWidth/375;
    }else{
        return 50*kAppScreenWidth/375;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 0;
    }
}

#pragma mark - action

- (void)avatarClick{
    
    TZImagePickerController *pickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    
    [TZImageManager manager].questionModel = nil;
    [TZImageManager manager].taskModel = nil;
    
    pickerVc.allowPickingOriginalPhoto = NO;
    pickerVc.allowPickingVideo = NO;
    [self presentViewController:pickerVc animated:YES completion:nil];
    
}


-(void)nicknameClick{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入昵称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *userNameTextField = alertController.textFields.firstObject;
        NSString *nameStr = [userNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (nameStr.length > 0) {
            [self updateUserInfo:@{@"nickName":nameStr}];
        }else{
           [self showMessage:@"昵称不能为空" hideDelay:1];
        }
        
    }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)genderClick{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"选择性别" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self updateUserInfo:@{@"sex":@"1"}];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self updateUserInfo:@{@"sex":@"2"}];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    
    [self presentViewController:actionSheet animated:YES completion:nil];

}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    if (photos.count > 0) {
        QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
        NSData *data = UIImageJPEGRepresentation(photos[0], 0.1);
        put.object = [NSString stringWithFormat:@"ios/%@.jpg",kCurrentTimestampMillisecond];
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
            [self updateUserInfo:@{@"headImg":outputObject.location}];
        }];
        [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    }
    
}


#pragma mark - data

- (void)updateUserInfo:(NSDictionary *)infoDic{
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi updateUserInfoUrl]
                              parameters:infoDic
                                 success:^(id  _Nonnull responseObject) {
                                     [SVProgressHUD dismiss];
                                     @strongify(self);
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]){
                                         
                                         NSMutableDictionary *userDic = [[NSMutableDictionary alloc]initWithDictionary:kUserDefaultGet(kYbsUserInfoDicKey)];
                                         [userDic setObject:infoDic.allValues[0] forKey:infoDic.allKeys[0]];
                                         kUserDefaultSet(userDic, kYbsUserInfoDicKey);
                                         kUserDefaultSynchronize;
                                         self.userInfoDic = userDic;
                                         [self.tableView reloadData];
                                         [self showMessage:@"修改成功" hideDelay:1.0];
                                         
                                     } else{
                                         [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                     [self showMessage:kYbsRequestFailed hideDelay:1.0];
                                 }
     ];
    
}



@end




@interface YbsDatePicker ()

@property (nonatomic, strong) UIView *whiteBgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UIDatePicker *picker;

@end


@implementation YbsDatePicker

- (instancetype)initWithBlock:(ChooseBlock)block;
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.chooseBlock = block;
        [self buildSubViews];
        [self addConstraints];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)buildSubViews{
    [self addSubview:self.whiteBgView];
    [self.whiteBgView addSubview:self.cancelBtn];
    [self.whiteBgView addSubview:self.okBtn];
    [self.whiteBgView addSubview:self.picker];
    
}

- (void)addConstraints{
    
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(kDatePickerWhiteBgHeight);
        make.height.mas_equalTo(kDatePickerWhiteBgHeight);
    }];
    
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBgView).with.offset(5);
        make.left.equalTo(self.whiteBgView).with.offset(10);
    }];
    
    [self.okBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBgView).with.offset(5);
        make.right.equalTo(self.whiteBgView).with.offset(-10);
    }];
    
    [self.picker mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.equalTo(self.whiteBgView);
        make.bottom.equalTo(self.whiteBgView).with.offset(-kAppTabbarSafeBottomMargin);
        make.height.mas_equalTo(kDatePickerHeight);
    }];
}

- (UIView *)whiteBgView{
    if (!_whiteBgView) {
        _whiteBgView = [UIView new];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBgView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kYbsFontCustom(17);
        [_cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        _okBtn.titleLabel.font = kYbsFontCustom(17);
        [_okBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
    
}

- (UIDatePicker *)picker{
    if (!_picker) {
        _picker = [[UIDatePicker alloc]init];
        _picker.datePickerMode = UIDatePickerModeDate;
        [_picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _picker;
}


#pragma mark - action

- (void)cancel{
    [self hide];
}

- (void)ok{
    if (self.chooseBlock) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:self.picker.date];
        self.chooseBlock(dateStr);
    }
    [self hide];
}

- (void)show{
    UIView *superView = [UIViewController currentViewController].navigationController.view;
    
    if (![superView.subviews containsObject:self]) {
        [superView addSubview:self];
        self.frame = CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight);
    }
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
        [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(kDatePickerWhiteBgHeight);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
    
    
}
- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self).with.offset(kDatePickerWhiteBgHeight);
            make.height.mas_equalTo(kDatePickerWhiteBgHeight);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


- (void)pickerChanged:(UIDatePicker *)picker{
    
    
}

@end
