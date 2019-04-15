//
//  YbsQAViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/30.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsQAViewController.h"
#import "YbsQuestionViewController.h"
#import "YbsQATableViewCell.h"
#import "YbsQACollectionView.h"
#import "YbsFileManager.h"
#import "YbsAnswerModel.h"
#import "NSDictionary+YbsObject.h"
#import "QCloudCore.h"
#import <QCloudCOSXML/QCloudCOSXML.h>


@interface YbsQAViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate,YbsLogicDelegate>

@property (nonatomic, strong) YYLabel *pageLabel;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) UIButton *previousPageBtn;
@property (nonatomic, strong) UIButton *nextPageBtn;
@property (nonatomic, assign) BOOL submitData;
@property (nonatomic, strong) NSIndexPath *nextIndexPath;
@property (nonatomic, strong) NSIndexPath *previousIndexPath;


@end

@implementation YbsQAViewController


- (void)onLeftBarButtonClick{
    [self saveUndoneTaskArchiver];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configRightBarButtonItem{
    YbsBarButtonConfiguration *config = [[YbsBarButtonConfiguration alloc]init];
    config.type = YbsBarButtonTypeText;
    config.titleString = @"";
    self.rightBarButton = [[YbsNavBarButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44) configuration:config];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBarButton];
}

- (NSArray *)questionArray{
    if (!_questionArray) {
        _questionArray = @[];
    }
    return _questionArray;
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"任务答题"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveAnswer) name:kYbsSaveAnswerNotification object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    [self buildTableView];
    [self buildBottomBtn];
    [self syncNaviRightBtnText];

}


- (void)buildBottomBtn{
    
    self.previousPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previousPageBtn.backgroundColor = [UIColor whiteColor];
    [self.previousPageBtn setTitle:@"上一题" forState:UIControlStateNormal];
    [self.previousPageBtn setTitleColor:kColorHex(@"#0E0E0E") forState:UIControlStateNormal];
    self.previousPageBtn.titleLabel.font = kYbsFontCustom(15);
    [self.previousPageBtn addTarget:self action:@selector(previousPageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.previousPageBtn];
    self.previousPageBtn.hidden = YES;
    [self.previousPageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-104);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-49);
        make.size.mas_equalTo(CGSizeMake(71, 28));
    }];
    
    self.nextPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextPageBtn.backgroundColor = [UIColor whiteColor];
    [self.nextPageBtn setTitle:@"下一题" forState:UIControlStateNormal];
    [self.nextPageBtn setTitleColor:kColorHex(@"#0E0E0E") forState:UIControlStateNormal];
    self.nextPageBtn.titleLabel.font = kYbsFontCustom(15);
    [self.nextPageBtn addTarget:self action:@selector(nextPageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextPageBtn];
    
    [self.nextPageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-14);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-49);
        make.size.mas_equalTo(CGSizeMake(71, 28));
    }];
    
    [self.view layoutIfNeeded];
    
    self.previousPageBtn.layer.borderColor = kColorHex(@"#0E0E0E").CGColor;
    self.previousPageBtn.layer.borderWidth = 1;
    self.previousPageBtn.layer.cornerRadius = 14;
    self.previousPageBtn.layer.masksToBounds = YES;
    
    self.nextPageBtn.layer.borderColor = kColorHex(@"#0E0E0E").CGColor;
    self.nextPageBtn.layer.borderWidth = 1;
    self.nextPageBtn.layer.cornerRadius = 14;
    self.nextPageBtn.layer.masksToBounds = YES;
    
}

- (void)buildTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.pagingEnabled = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = kAppScreenHeight - kAppStatusBarAndNavigationBarHeight;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    [self.tableView registerClass:[PictureCell class] forCellReuseIdentifier:NSStringFromClass([PictureCell class])];
    [self.tableView registerClass:[TextPictureCell class] forCellReuseIdentifier:NSStringFromClass([TextPictureCell class])];
    [self.tableView registerClass:[VoiceCell class] forCellReuseIdentifier:NSStringFromClass([VoiceCell class])];
    [self.tableView registerClass:[TextInputCell class] forCellReuseIdentifier:NSStringFromClass([TextInputCell class])];
    [self.tableView registerClass:[DirectionCell class] forCellReuseIdentifier:NSStringFromClass([DirectionCell class])];
    [self.tableView registerClass:[SingleChoiceCell class] forCellReuseIdentifier:NSStringFromClass([SingleChoiceCell class])];
    [self.tableView registerClass:[MultipleChoiceCell class] forCellReuseIdentifier:NSStringFromClass([MultipleChoiceCell class])];
}

- (void)previousPageAction{
    if ([self.taskModel.prePage isEqualToString:@"0"]) {
        [self showMessage:@"不允许返回上一页" hideDelay:1];
        return;
    }
    
    YbsQueModel *question = self.questionArray[self.currentIndexPath.row];
    NSIndexPath *previousIndexPath = nil;
    
    if (question.logicPreviousIndex) {
        previousIndexPath = [NSIndexPath indexPathForRow:[question.logicPreviousIndex integerValue] inSection:0];
    }else{
        if (self.currentIndexPath.row >= 1) {
            previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row - 1 inSection:0];
        }
    }
    
    if (previousIndexPath) {
        
        question.needCommitAnswer = NO;
        
        [self.tableView scrollToRowAtIndexPath:previousIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        self.currentIndexPath = previousIndexPath;
        if(self.currentIndexPath.row == 0){
            self.previousPageBtn.hidden = YES;
        }else{
            self.previousPageBtn.hidden = NO;
        }
    }
    
    [self quetionLogicDidUpdate];
    
    [self syncNaviRightBtnText];
}

- (void)nextPageAction{
    
    YbsQueModel *question = self.questionArray[self.currentIndexPath.row];
    
    if (![self judgeWithQuestion:question]) {
        return;
    }
    
    question.needCommitAnswer = YES;
    
    if ([self.nextPageBtn.titleLabel.text isEqualToString:@"提交"]) {
        
        if (self.submitData) {
            [self submit];
        }else{
            __weak typeof (self) weakSelf = self;
            [self showMessage:@"本次答题结束" hideDelay:2 complete:^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
        
    }else{
        
        self.previousPageBtn.hidden = NO;
        
        if (!self.nextIndexPath) {
            if (self.currentIndexPath.row < self.questionArray.count - 1) {
                self.nextIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row + 1 inSection:0];
            }
        }
        
        self.questionArray[self.nextIndexPath.row].logicPreviousIndex = [NSString stringWithFormat:@"%d",(int)self.currentIndexPath.row];
        
        [self.tableView scrollToRowAtIndexPath:self.nextIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        self.currentIndexPath = self.nextIndexPath;
        
        if (self.currentIndexPath.row == self.questionArray.count - 1) {
            [self.nextPageBtn setTitle:@"提交" forState:UIControlStateNormal];
        }
        
        [self quetionLogicDidUpdate];
        
    }
    
    [self syncNaviRightBtnText];
}




#pragma mark - YbsLogicDelegate

- (void)quetionLogicDidUpdate{
    
    YbsQueModel *question = self.questionArray[self.currentIndexPath.row];
    
    if (question.logics && question.logics.count > 0 ) {
    
         YbsQuestionLogic *eligibleLogic = nil; //符合条件的 Logic

        if ([question.type isEqualToString:@"3"]) {//文本输入题
            if (question.answerString && question.answerString.length >0) {
                
                for (int i=0; i<question.logics.count; i++) {
                    YbsQuestionLogic *logic = question.logics[i];
                    NSArray<YbsLogicCondition *> *conditions = logic.condition;
                    for (int j=0; j<conditions.count; j++) {
                        YbsLogicCondition *condition = conditions[j];
                        if ([condition.textRule isEqualToString:@"1"]) {
                            if ([question.answerString isAmount]) {
                                if ([question.answerString doubleValue] == [condition.textRuleNum1 doubleValue]) {
                                    eligibleLogic = logic;
                                    goto breakLabel;
                                }
                            }
                            
                        }else if ([condition.textRule isEqualToString:@"2"]){
                            
                            if ([question.answerString isAmount]) {
                                if ([question.answerString doubleValue] != [condition.textRuleNum1 doubleValue]) {
                                    eligibleLogic = logic;
                                    goto breakLabel;
                                }
                            }
                            
                        }else if ([condition.textRule isEqualToString:@"3"]){
                            
                            if ([question.answerString isAmount]) {
                                if ([question.answerString doubleValue] > [condition.textRuleNum1 doubleValue]) {
                                    eligibleLogic = logic;
                                    goto breakLabel;
                                }
                            }
                            
                        }else if ([condition.textRule isEqualToString:@"4"]){
                            
                            if ([question.answerString isAmount]) {
                                if ([question.answerString doubleValue] >= [condition.textRuleNum1 doubleValue]) {
                                    eligibleLogic = logic;
                                    goto breakLabel;
                                }
                            }
                            
                        }else if ([condition.textRule isEqualToString:@"5"]){
                            
                            if ([question.answerString isAmount]) {
                                if ([question.answerString doubleValue] < [condition.textRuleNum1 doubleValue]) {
                                    eligibleLogic = logic;
                                    goto breakLabel;
                                }
                            }
                            
                        }else if ([condition.textRule isEqualToString:@"6"]){
                            
                            if ([question.answerString isAmount]) {
                                if ([question.answerString doubleValue] <= [condition.textRuleNum1 doubleValue]) {
                                    eligibleLogic = logic;
                                    goto breakLabel;
                                }
                            }
                            
                        }else if ([condition.textRule isEqualToString:@"7"]){
                            
                            if ([question.answerString isAmount]) {
                                if ([question.answerString doubleValue] > [condition.textRuleNum1 doubleValue] && [question.answerString doubleValue] < [condition.textRuleNum2 doubleValue]) {
                                    eligibleLogic = logic;
                                    goto breakLabel;
                                }
                            }
                            
                        }
                    }
                    
                }
            }else{
                goto breakLabel;
            }
            
            
        }else if ([question.type isEqualToString:@"5"]){//单选题
            
            if (question.answerChioces && question.answerChioces.count > 0) {
                
                NSInteger answerIndex = [question.answerChioces[0] integerValue];
                for (int i=0; i<question.logics.count; i++) {
                    YbsQuestionLogic *logic = question.logics[i];
                    NSArray<YbsLogicCondition *> *conditions = logic.condition;
                    for (int j=0; j<conditions.count; j++) {
                        YbsLogicCondition *condition = conditions[j];
                        if ([condition.choiceType isEqualToString:@"1"]) {//任意选中其一
                            
                            for (int k=0; k < condition.choices.count; k++) {
                                NSInteger chioceIndex = [condition.choices[k] integerValue];
                                if (answerIndex == chioceIndex) {
                                    eligibleLogic = logic;
                                    goto breakLabel;
                                }
                            }
                            
                        }else{//只选中
                            if (condition.choices.count > 0) {
                                NSInteger chioceIndex = [condition.choices[0] integerValue];
                                if (chioceIndex == answerIndex) {
                                    eligibleLogic = logic;
                                    goto breakLabel;
                                }
                            }
                            
                        }
                    }
                }
            }else{
                goto breakLabel;
            }
            
            
        }else if ([question.type isEqualToString:@"6"]){//多选题
            if (question.answerChioces && question.answerChioces.count > 0) {
                
                for (int i=0; i<question.logics.count; i++) {
                    YbsQuestionLogic *logic = question.logics[i];
                    NSArray<YbsLogicCondition *> *conditions = logic.condition;
                    for (int j=0; j<conditions.count; j++) {
                        YbsLogicCondition *condition = conditions[j];
                        if ([condition.choiceType isEqualToString:@"1"]) {//任意选中其一
                            
                            for (int k=0; k<question.answerChioces.count; k++) {
                                NSInteger chIndex = [question.answerChioces[k] integerValue];
                                for (int q=0; q<condition.choices.count; q++) {
                                    if (chIndex == [condition.choices[q] integerValue]) {
                                        eligibleLogic = logic;
                                        goto breakLabel;
                                    }
                                }
                            }
                            
                        }else{//只选中
                            
                            if (question.answerChioces.count == condition.choices.count) {
                                NSString *answerStr = [question.answerChioces componentsJoinedByString:@","];
                                NSString *conditionStr = [condition.choices componentsJoinedByString:@","];
                                if ([answerStr isEqualToString:conditionStr]) {
                                    eligibleLogic = logic;
                                    goto breakLabel;
                                }
                            }
                            
                        }
                    }
                }
            }else{
                goto breakLabel;
            }
            
        }
        
        breakLabel:{
                
                if (eligibleLogic != nil) {
                    if ([eligibleLogic.jump.type isEqualToString:@"1"] || [eligibleLogic.jump.type isEqualToString:@"2"]) {
                        NSIndexPath *jumpToIndexPath = nil;
                        for (int i=0; i<self.questionArray.count; i++) {
                            if ([self.questionArray[i].qid isEqualToString:eligibleLogic.jump.jumpToQid]) {
                                jumpToIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                            }
                        }
                        
                        self.nextIndexPath = jumpToIndexPath;
                        
                        if ([eligibleLogic.jump.type isEqualToString:@"1"]) {// 跳转至
                            [self.nextPageBtn setTitle:@"下一题" forState:UIControlStateNormal];
                        }else{// 选项显示
                            YbsQueModel *jumpToQuestion = self.questionArray[jumpToIndexPath.row];
                            [self.nextPageBtn setTitle:@"下一题" forState:UIControlStateNormal];
                            jumpToQuestion.visibleChoices = eligibleLogic.jump.choices;
                        }
                        
                    }else if ([eligibleLogic.jump.type isEqualToString:@"3"]){// 结束问卷计入结果
                        [self.nextPageBtn setTitle:@"提交" forState:UIControlStateNormal];
                        self.submitData = YES;
                        
                    }else if ([eligibleLogic.jump.type isEqualToString:@"4"]){// 结束问卷不计入结果
                        [self.nextPageBtn setTitle:@"提交" forState:UIControlStateNormal];
                        self.submitData = NO;
                    }else{
                        
                    }
                    
                }else{
                    
                    self.submitData = YES;
                    if (self.currentIndexPath.row == self.questionArray.count-1) {
                        [self.nextPageBtn setTitle:@"提交" forState:UIControlStateNormal];
                    }else{
                        [self.nextPageBtn setTitle:@"下一题" forState:UIControlStateNormal];
                        if (self.currentIndexPath.row < self.questionArray.count-1) {
                            self.nextIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row + 1 inSection:0];
                        }
                    }
                    
                }
            
        }

    
    }else{
        
        if (self.currentIndexPath.row < self.questionArray.count - 1) {
            self.nextIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row + 1 inSection:0];
            [self.nextPageBtn setTitle:@"下一题" forState:UIControlStateNormal];
        }else{
            [self.nextPageBtn setTitle:@"提交" forState:UIControlStateNormal];
        }
        
        self.submitData = YES;
    }
    
    
}


- (void)syncNaviRightBtnText{
    [self.rightBarButton setTitleStr:[NSString stringWithFormat:@"%d/%d",(int)self.currentIndexPath.item+1,(int)self.questionArray.count]];
}

- (BOOL)judgeWithQuestion:(YbsQueModel *)question{
    switch ([question.type integerValue]) {
        case QuestionTypeDirection:
        {
            return YES;
        }
            break;
        case QuestionTypeSingleChoice:
        {
            if (question.mustAnswer ) {
                if (question.answerChioces.count == 0) {
                    [self showMessage:@"必答题" hideDelay:1];
                    return NO;
                }
                
                return YES;
            }
            return YES;
        }
            break;
        case QuestionTypeMultipleChoice:
        {
            if (question.mustAnswer) {
                if (question.answerChioces.count < [question.specAttr.choiceMin integerValue]) {
                    [self showMessage:[NSString stringWithFormat:@"最少选%@项",question.specAttr.choiceMin] hideDelay:1];
                    return NO;
                }
                
                if (question.answerChioces.count > [question.specAttr.choiceMax integerValue]) {
                    [self showMessage:[NSString stringWithFormat:@"最多选%@项",question.specAttr.choiceMin] hideDelay:1];
                    return NO;
                }
                
                return YES;
                
            }
            
            return YES;
        
        }
            break;
        case QuestionTypePicture:
        {
            if (question.mustAnswer) {
                if (question.answerPictures.count < [question.specAttr.uploadLeast integerValue]) {
                    [self showMessage:[NSString stringWithFormat:@"最少提交%@张图片",question.specAttr.uploadLeast] hideDelay:1];
                    return NO;
                }
                return YES;
            }
            
            return YES;
        }
            break;
        case QuestionTypeTextPicture:
        {
            if (question.mustAnswer) {
                if (question.answerTextPics.count < [question.specAttr.uploadLeast integerValue]) {
                    [self showMessage:[NSString stringWithFormat:@"最少提交%@张图片",question.specAttr.uploadLeast] hideDelay:1];
                    return NO;
                }
                return YES;
            }
                
            return YES;
        }
            break;
        case QuestionTypeVoice:
        {
            if (question.mustAnswer) {
                if (question.answerVoices.count < [question.specAttr.uploadLeast integerValue]) {
                    [self showMessage:[NSString stringWithFormat:@"最少提交%@个录音",question.specAttr.uploadLeast] hideDelay:1];
                    return NO;
                }
                return YES;
            }
            
            return YES;
        }
            break;
        case QuestionTypeTextInput:
        {
            if (question.mustAnswer) {
                if (question.answerString.length == 0) {
                    [self showMessage:@"必答题" hideDelay:1];
                    return NO;
                }
                return YES;
            }
            
            return YES;
        }
            break;
            
        default:
            return YES;
            break;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [YbsQATableViewCell identifierForCellWithModel:self.questionArray[indexPath.row]];
    YbsQATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSClassFromString(identifier) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    cell.qavc = self;
    [cell reloadWithModel:self.questionArray[indexPath.row]];
    [cell setNeedsUpdateConstraints];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self quetionLogicDidUpdate];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (![gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - Data

- (void)loadData{
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi taskQuestionUrl]
                              parameters:@{@"taskId":self.taskModel.taskId,
                                           @"storeId":self.taskModel.storeId
                                           }
                                 success:^(id  _Nonnull responseObject) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]){
                                         NSArray *queArr = [NSArray modelArrayWithClass:[YbsQueModel class] json:dic[kYbsDataKey]];
                                         self.questionArray = queArr;
                                         [self buildTableView];
                                         [self buildBottomBtn];
                                         [self syncNaviRightBtnText];
                                         
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



#pragma mark - 提交

- (void)submit{
    
//    float fileSize = [self getTotalFileSize];
//
//    if (fileSize > 5) {
//        NSString *alertTitle = [NSString stringWithFormat:@"上传内容为 %.2fM",fileSize];
//
//        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//            if (status == AFNetworkReachabilityStatusNotReachable||status==AFNetworkReachabilityStatusUnknown) {
//                [self showMessage:@"请检查您的网络" hideDelay:1.0];
//            }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
//                UIAlertController * alertController = [UIAlertController alertControllerWithTitle: alertTitle                                                                               message: @"您此时为移动网络，建议WiFi环境进行提交" preferredStyle:UIAlertControllerStyleAlert];
//
//                [alertController addAction: [UIAlertAction actionWithTitle: @"保存任务" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                    NSString *fileName = [NSString stringWithFormat:@"task_%@_%@_archiver",self.taskModel.taskId,self.taskModel.storeId];
//
//                    if ([YFM createDirectoryInDocumentWithName:kYbsTaskArchiverDirectory]) {
//                        if ([YFM archiveToDocument:self.questionArray inSubdirectory:kYbsTaskArchiverDirectory fileName:fileName]) {
//                            [self submitLater];
//                        }
//                    }else{
//                        [self showMessage:@"任务保存失败" hideDelay:1];
//                    }
//
//                }]];
//
//                [alertController addAction: [UIAlertAction actionWithTitle: @"继续提交" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                    [self packData];
//                }]];
//
//                [self presentViewController: alertController animated: YES completion: nil];
//
//            }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
//                [self packData];
//            }
//        }];
//
//        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
//    }else{
//        [self packData];
//    }
    
    
    
    if ([self.taskModel.afterSubmit isEqualToString:@"0"]) {//不允许稍后提交
        [self packData];
    }else{//允许稍后提交
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"提交"                                                                               message: @"建议立即提交。如选择稍后提交，请尽快到我的-待提交中完成提交。\n任务到期或其它用户抢先完成提交，您的任务将自动失效。" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction: [UIAlertAction actionWithTitle: @"稍后提交" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSDictionary *userDic = kUserDefaultGet(kYbsUserInfoDicKey);
            NSString *userId = userDic[@"userId"];
            NSString *fileName = [NSString stringWithFormat:@"%@_task_%@_%@_archiver",userId,self.taskModel.taskId,self.taskModel.storeId];
            
            if ([YFM createDirectoryInDocumentWithName:kYbsTaskArchiverDirectory]) {
                if ([YFM archiveToDocument:self.questionArray inSubdirectory:kYbsTaskArchiverDirectory fileName:fileName]) {
                    [self submitLater];
                }
            }else{
                [self showMessage:@"任务保存失败" hideDelay:1];
            }
            
        }]];
        
        [alertController addAction: [UIAlertAction actionWithTitle: @"立即提交" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self packData];
        }]];

        [self presentViewController: alertController animated: YES completion: nil];
        
        
    }

    
}


- (float)getTotalFileSize{
    float  fileSize = 0.0;
    for (int i=0; i<self.questionArray.count; i++) {
        YbsQueModel *qModel = self.questionArray[i];
        if ([qModel.type isEqualToString:@"0"]) { //图片题
            for (int j=0; j<qModel.answerPictures.count; j++) {
                NSData *data = [NSData dataWithContentsOfFile:qModel.answerPictures[j]];
                fileSize += (data.length/1024.0/1024.0);
            }
        }else if ([qModel.type isEqualToString:@"1"]){//图片文本题
            for (int j=0; j<qModel.answerTextPics.count; j++) {
                NSData *data = [NSData dataWithContentsOfFile:@""];
                fileSize += (data.length/1024.0/1024.0);
            }
            
        }else if ([qModel.type isEqualToString:@"2"]){//声音题
            for (int j=0; j<qModel.answerVoices.count; j++) {
                NSData *data = [NSData dataWithContentsOfFile:qModel.answerVoices[j].voicePath];
                fileSize += (data.length/1024.0/1024.0);
            }
        }
    }
    return fileSize;
}

// 稍后提交
- (void)submitLater{
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi taskSubmitLaterUrl]
                              parameters:@{@"taskId":self.taskModel.taskId,
                                           @"storeId":self.taskModel.storeId
                                           }
                                 success:^(id  _Nonnull responseObject) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]){
                                         [self deleteUndoneTaskArchiver];
                                         [self showMessage:@"已加入待提交列表" hideDelay:1.5 complete:^{
                                             [self.navigationController popToRootViewControllerAnimated:YES];
                                         }];
                                     }else{
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

- (void)packData{
    
    dispatch_queue_t queue = dispatch_queue_create("ybs_task_submit_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();

    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];

    YbsAnswerModel *aModel = [YbsAnswerModel new];
    aModel.taskId = self.taskModel.taskId;
    aModel.storeId = self.taskModel.storeId;
    aModel.type = @"1";
    aModel.stayId = @"";
    aModel.answerList = [NSMutableArray array];
    
    for (int i=0; i<self.questionArray.count; i++) {

        YbsQueModel *qModel = self.questionArray[i];
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
                            //                        UIImage *image = [UIImage imageWithContentsOfFile:qModel.answerPictures[j]];
                            //                        NSData *data = UIImageJPEGRepresentation(image, 0.5);
                            
                            NSString *imgPath = [[YFM documentPath] stringByAppendingPathComponent:qModel.answerPictures[j]];
                            NSData *data = [NSData dataWithContentsOfFile:imgPath];
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
                            
                            //                        UIImage *image = [UIImage imageWithContentsOfFile:qModel.answerTextPics[j].pic];
                            //                        NSData *data = UIImageJPEGRepresentation(image, 0.5);
                            
                            NSString *imgPath = [[YFM documentPath] stringByAppendingPathComponent:qModel.answerTextPics[j].pic];
                            NSData *data = [NSData dataWithContentsOfFile:imgPath];
                            
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
                                         [self deleteUndoneTaskArchiver];
                                         [self clearTaskCacheWithAnswerModel:answerModel];
                                         [self.navigationController popToRootViewControllerAnimated:YES];
                                     }else{
                                         if ([dic[kYbsCodeKey] isEqualToString:@"6004"] || [dic[kYbsCodeKey] isEqualToString:@"6005"]) {
                                             
                                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:dic[kYbsMsgKey] preferredStyle:UIAlertControllerStyleAlert];
                                             [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                 [self.navigationController popToRootViewControllerAnimated:YES];
                                                 
                                             }]];
                                             
                                             [self presentViewController:alertController animated:YES completion:nil];
                                             
                                         }else{
                                             [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                         }
                                         
                                         
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


- (void)saveUndoneTaskArchiver{
    NSDictionary *userDic = kUserDefaultGet(kYbsUserInfoDicKey);
    NSString *userId = userDic[@"userId"];
    NSString *fileName = [NSString stringWithFormat:@"%@_task_%@_%@_archiver",userId,self.taskModel.taskId,self.taskModel.storeId];
    if ([YFM createDirectoryInDocumentWithName:kYbsUndoneTaskArchiverDirectory]) {
        if ([YFM fileExistAtDocumentSubdirectory:kYbsUndoneTaskArchiverDirectory fileName:fileName]) {
            [YFM deleteFileInDocumentSubdirectory:kYbsUndoneTaskArchiverDirectory fileName:fileName];
        }
        [YFM archiveToDocument:self.questionArray inSubdirectory:kYbsUndoneTaskArchiverDirectory fileName:fileName];
    }
}

- (void)deleteUndoneTaskArchiver{
    
    NSDictionary *userDic = kUserDefaultGet(kYbsUserInfoDicKey);
    NSString *userId = userDic[@"userId"];
    NSString *fileName = [NSString stringWithFormat:@"%@_task_%@_%@_archiver",userId,self.taskModel.taskId,self.taskModel.storeId];
    
    if ([YFM fileExistAtDocumentSubdirectory:kYbsUndoneTaskArchiverDirectory fileName:fileName]) {
        [YFM deleteFileInDocumentSubdirectory:kYbsUndoneTaskArchiverDirectory fileName:fileName];
    }

}


#pragma mark - Notification

- (void)saveAnswer{
    [self saveUndoneTaskArchiver];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
