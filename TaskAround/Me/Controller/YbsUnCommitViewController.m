//
//  YbsUncommitViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/22.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsUnCommitViewController.h"
#import "YbsTaskUncommitCell.h"
#import "YbsQueModel.h"
#import "YbsFileManager.h"
#import "YbsAnswerModel.h"
#import "NSDictionary+YbsObject.h"
#import "QCloudCore.h"
#import <QCloudCOSXML/QCloudCOSXML.h>
#import "UITableView+HD_NoList.h"


@interface YbsUnCommitViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSIndexPath *currentEditIndexPath;


@end

@implementation YbsUnCommitViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (kUserDefaultGet(kYbsUserInfoDicKey)) {
        [self loadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"待提交"];
    self.page = 1;

    [self buildSubViews];

}

- (void)buildSubViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 140;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadData];
        }];
        _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.page++;
            [self loadData];
        }];
    }
    return _tableView;
}

- (void)loadData{
    NSDictionary *parameterDic = @{
                                   @"pageNum":@(self.page),
                                   @"pageSize":@10
                                   };
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi taskUnCommitUrl]
                              parameters:parameterDic
                                 success:^(id  _Nonnull responseObject) {
                                     [SVProgressHUD dismiss];
                                     @strongify(self);
                                     [self.tableView.mj_header endRefreshing];
                                     [self.tableView.mj_footer endRefreshing];
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]) {
                                         if (self.page==1) {
                                             [self.dataArray removeAllObjects];
                                         }
                                         NSArray *arr = [NSArray modelArrayWithClass:[YbsTaskModel class] json:dic[kYbsDataKey][@"list"]];
                                         if (arr.count > 0) {
                                             NSDictionary *userDic = kUserDefaultGet(kYbsUserInfoDicKey);
                                             NSString *userId = userDic[@"userId"];
                                             
                                             for (int i=0; i<arr.count; i++) {
                                                 YbsTaskModel *tm = arr[i];
                                                 NSString *fileName = [NSString stringWithFormat:@"%@_task_%@_%@_archiver",userId,tm.taskId,tm.storeId];
                                                 if ([YFM fileExistAtDocumentSubdirectory:kYbsTaskArchiverDirectory fileName:fileName]) {
                                                     [self.dataArray addObject:tm];
                                                 }
                                                 
                                             }
                                             
                                         }else{
                                             [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                             if (self.page>0) {
                                                 self.page--;
                                             }
                                         }
                                         [self.tableView reloadData];
                                         [self resetNoDataView];
                                         
                                         
                                     }else{
                                         [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                     
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                     [self.tableView.mj_header endRefreshing];
                                     [self.tableView.mj_footer endRefreshing];
                                 }
     ];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UnCommitTaskCell";
    YbsTaskUncommitCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YbsTaskUncommitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    [cell setNeedsUpdateConstraints];
    
    [cell.commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)commitAction:(UIButton *)sender{
    YbsTaskUncommitCell *cell = (YbsTaskUncommitCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.currentEditIndexPath = indexPath;
    YbsTaskModel *model = self.dataArray[indexPath.row];
    NSDictionary *userDic = kUserDefaultGet(kYbsUserInfoDicKey);
    NSString *userId = userDic[@"userId"];
    NSString *fileName = [NSString stringWithFormat:@"%@_task_%@_%@_archiver",userId,model.taskId,model.storeId];
    NSArray *arr = [YFM unarchiveFileInDocumentSubdirectory:kYbsTaskArchiverDirectory fileName:fileName];
    
    [self packData:model array:arr];
    
    self.tableView.userInteractionEnabled = NO;
    
}


- (void)packData:(YbsTaskModel *)taskModel array:(NSArray *)questionArray{
    
    dispatch_queue_t queue = dispatch_queue_create("ybs_task_submit_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    YbsAnswerModel *aModel = [YbsAnswerModel new];
    aModel.taskId = taskModel.taskId;
    aModel.storeId = taskModel.storeId;
    aModel.type = @"0";
    aModel.stayId = taskModel.stayId;
    aModel.answerList = [NSMutableArray array];
    
    for (int i=0; i<questionArray.count; i++) {
        YbsQueModel *qModel = questionArray[i];
        if (qModel.needCommitAnswer) {
            YbsAnswerItem *item = [YbsAnswerItem new];
            item.qid = qModel.qid;
            item.type = qModel.type;
            item.content = [YbsAnswerContent new];
            [aModel.answerList addObject:item];
            
            switch ([qModel.type integerValue]) {
                case QuestionTypePicture:
                {
                    item.content.imgs = [NSMutableArray new];
                    for (int k=0; k<qModel.answerPictures.count; k++) {
                        [item.content.imgs addObject:@"image_placeholder"];
                    }
                    
                    for (int j=0; j<qModel.answerPictures.count; j++) {
                        
                        @weakify(self);
                        dispatch_group_enter(group);
                        dispatch_group_async(group,queue,^{
                            @strongify(self)
                            if (!self) return;
                            QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];

                            NSString *path = [[YFM documentPath] stringByAppendingPathComponent:qModel.answerPictures[j]];
                            NSData *data = [NSData dataWithContentsOfFile:path];
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
                                        self.tableView.userInteractionEnabled = YES;
                                    });
                                    return ;
                                }
                                [item.content.imgs replaceObjectAtIndex:j withObject:outputObject.location];
                                dispatch_group_leave(group);
                            }];
                            [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
                            
                        });
                    }
                    
                }
                    break;
                case QuestionTypeTextPicture:
                {
                    item.content.imgRemarks = [NSMutableArray new];
                    for (int k=0; k<qModel.answerTextPics.count; k++) {
                        [item.content.imgRemarks addObject:[YbsImgRemark new]];
                    }
                    
                    for (int j=0; j<qModel.answerTextPics.count; j++) {
                        
                        @weakify(self);
                        dispatch_group_enter(group);
                        dispatch_group_async(group,queue,^{
                            @strongify(self)
                            if (!self) return;
                            QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
                            NSString *path = [[YFM documentPath] stringByAppendingPathComponent:qModel.answerTextPics[j].pic];
                            NSData *data = [NSData dataWithContentsOfFile:path];
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
                                        self.tableView.userInteractionEnabled = YES;
                                    });
                                    return ;
                                }
                                
                                YbsImgRemark *imgRemark = [YbsImgRemark new];
                                imgRemark.img = outputObject.location;
                                imgRemark.remark = qModel.answerTextPics[j].text;
                                
                                [item.content.imgRemarks replaceObjectAtIndex:j withObject:imgRemark];
                                dispatch_group_leave(group);
                            }];
                            [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
                            
                        });
                    }
                    
                }
                    break;
                case QuestionTypeVoice:
                {
                    item.content.audios = [NSMutableArray new];
                    for (int k=0; k<qModel.answerVoices.count; k++) {
                        [item.content.audios addObject:@"audio_placeholder"];
                    }
                    
                    for (int j=0; j<qModel.answerVoices.count; j++) {
                        
                        @weakify(self);
                        dispatch_group_enter(group);
                        dispatch_group_async(group,queue,^{
                            @strongify(self)
                            if (!self) return;
                            QCloudCOSXMLUploadObjectRequest *put = [QCloudCOSXMLUploadObjectRequest new];
                            NSString *path = [[YFM documentPath] stringByAppendingPathComponent:qModel.answerVoices[j].voicePath];
                            NSData *data = [NSData dataWithContentsOfFile:path];
                            put.object = [NSString stringWithFormat:@"ios/%@_%@_%d.mp3",kCurrentTimestampMillisecond,[NSString randomStringWithLength:6],j];
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
                                        self.tableView.userInteractionEnabled = YES;
                                    });
                                    
                                    return ;
                                }
                                [item.content.audios replaceObjectAtIndex:j withObject:outputObject.location];
                                dispatch_group_leave(group);
                            }];
                            [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
                            
                        });
                    }
                    
                }
                    break;
                case QuestionTypeTextInput:
                {
                    item.content.text = qModel.answerString;
                }
                    break;
                case QuestionTypeDirection:
                {
                    
                }
                    break;
                case QuestionTypeSingleChoice:
                {
                    item.content.choice = qModel.answerChioces[0];
                }
                    break;
                case QuestionTypeMultipleChoice:
                {
                    item.content.choices = qModel.answerChioces;
                }
                    break;
                default:
                    break;
            }
        }
    
    }
    
    @weakify(self);
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        @strongify(self);
        if (!self) return;
        [self submitWithAnswerModel:aModel];
    });
}


- (void)submitWithAnswerModel:(YbsAnswerModel *)answerModel{
    
    NSDictionary *paramDic = [NSDictionary getObjectData:answerModel];
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi taskSubmitUrl]
                              parameters:paramDic
                                 success:^(id  _Nonnull responseObject) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]){
                                         [self showMessage:@"提交成功" hideDelay:1];
                                         [self clearTaskCacheWithAnswerModel:answerModel];
                                         [self deleteDoneTaskArchiver];
                                         
                                         self.tableView.userInteractionEnabled = YES;
                                         [self.dataArray removeObjectAtIndex:self.currentEditIndexPath.row];
                                         [self.tableView reloadData];
                                         [self resetNoDataView];
                                         
                                     }else{
                                         self.tableView.userInteractionEnabled = YES;
                                         [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                     
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                     [self showMessage:@"提交失败" hideDelay:1];
                                 }
     ];
    
    
}


- (void)clearTaskCacheWithAnswerModel:(YbsAnswerModel *)answerModel{
    NSString *dir = [NSString stringWithFormat:@"task_%@_%@_answer",answerModel.taskId,answerModel.storeId];
    NSString *fullDir = [YFM.documentPath stringByAppendingPathComponent:dir];
    [YFM deleteFileInPath:fullDir];
    
}

- (void)deleteDoneTaskArchiver{
    YbsTaskModel *model = self.dataArray[self.currentEditIndexPath.row];
    NSDictionary *userDic = kUserDefaultGet(kYbsUserInfoDicKey);
    NSString *userId = userDic[@"userId"];
    NSString *fileName = [NSString stringWithFormat:@"%@_task_%@_%@_archiver",userId,model.taskId,model.storeId];
    
    if ([YFM fileExistAtDocumentSubdirectory:kYbsTaskArchiverDirectory fileName:fileName]) {
        [YFM deleteFileInDocumentSubdirectory:kYbsTaskArchiverDirectory fileName:fileName];
    }
    
}


#pragma mark - nodata

- (void)resetNoDataView{
    if (self.dataArray.count>0) {
        [self.tableView dismissNoView];
    }else{
        [self.tableView showNoView:@"暂无待提交任务" image:kImageNamed(@"history_no_data") certer:CGPointZero];
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
