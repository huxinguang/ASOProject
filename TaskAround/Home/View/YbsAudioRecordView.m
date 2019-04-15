//
//  TaskListAudioDetailView.m
//  PatchedTogetherTask
//
//  Created by xinguang hu on 2018/6/11.
//  Copyright © 2018年 chenjianlin. All rights reserved.
//

#import "YbsAudioRecordView.h"
#import "JLRecod.h"
#import "HYCircleProgressView.h"
#import "YbsFileManager.h"
#import "YbsQAViewController.h"
#import "lame.h"
#import "NSTimer+FY.h"


#define kRecordWhiteBgHeight  (261*kAppScreenWidth/375 + kAppTabbarSafeBottomMargin)
#define kBottomLeftBtnSize CGSizeMake(40*kAppScreenWidth/375, 40*kAppScreenWidth/375)
#define kBottomCenterBtnSize CGSizeMake(80*kAppScreenWidth/375, 80*kAppScreenWidth/375)
#define kBottomRightBtnSize CGSizeMake(40*kAppScreenWidth/375, 40*kAppScreenWidth/375)
#define kBottomBtnMargin (kAppScreenWidth - kBottomLeftBtnSize.width - kBottomCenterBtnSize.width - kBottomRightBtnSize.width)/4

#define kMaxRecordSeconds  240

typedef NS_ENUM(NSInteger,BottomCenterBtnState) {
    BottomCenterBtnStateRecord = 0,     //开始录音
    BottomCenterBtnStatePauseRecord,    //结束录音
    BottomCenterBtnStatePlay,           //播放录音
    BottomCenterBtnStatePausePlay       //暂停播放
};

@interface YbsAudioRecordView ()<JLRecodDelegate>

@property (nonatomic, strong) HYCircleProgressView *progressView;
@property (nonatomic, strong) YbsQueModel *qModel;
@property (nonatomic, strong) UIView *whiteBgView;
@property (nonatomic, strong) UIButton *topLeftbtn;
@property (nonatomic, strong) UIButton *topRightBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *bottomLeftBtn;
@property (nonatomic, strong) UILabel *bottomLeftLabel;
@property (nonatomic, strong) UIButton *bottomCenterBtn;
@property (nonatomic, strong) UILabel *bottomCenterLabel;
@property (nonatomic, strong) UIButton *bottomRightBtn;
@property (nonatomic, strong) UILabel *bottomRightLabel;
@property (nonatomic, assign) BottomCenterBtnState bottomCenterBtnState;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval remainingSeconds;
@property (nonatomic, assign) NSTimeInterval voiceSeconds;
@property (nonatomic, strong) YbsQueModel *questionModel;
@property (nonatomic, strong) YbsTaskModel *taskModel;
@property (nonatomic, strong) YbsVoiceModel *voiceModel;




@end

@implementation YbsAudioRecordView

- (instancetype)initWithVoiceModel:(YbsVoiceModel *)vModel
                      quetionModel:(YbsQueModel *)qModel
                         taskModel:(YbsTaskModel *)tModel
                       chooseBlock:(AudioRecordChooseBlock)block{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self buildSubViews];
        [self addConstraits];
        [JLRecod shareManager].delegate = self;
        
        self.chooseBlock = block;
        self.qModel = qModel;
        self.voiceModel = vModel;
        self.questionModel = qModel;
        self.taskModel = tModel;
        if (!vModel.voicePath) {
            self.bottomCenterBtnState = BottomCenterBtnStateRecord;
            self.pathStr = [self getAudioCafPath];
        }else{
            self.bottomCenterBtnState = BottomCenterBtnStatePlay;
            self.pathStr = vModel.voicePath;
        }
        self.timeLabel.hidden = YES;
    }
    return self;
}

- (void)buildSubViews{
    [self addSubview:self.whiteBgView];
    [self.whiteBgView addSubview:self.topLeftbtn];
    [self.whiteBgView addSubview:self.topRightBtn];
    [self.whiteBgView addSubview:self.lineView];
    [self.whiteBgView addSubview:self.timeLabel];
    [self.whiteBgView addSubview:self.bottomLeftBtn];
    [self.whiteBgView addSubview:self.bottomLeftLabel];
    [self.whiteBgView addSubview:self.bottomCenterBtn];
    [self.whiteBgView addSubview:self.bottomCenterLabel];
    [self.whiteBgView addSubview:self.bottomRightBtn];
    [self.whiteBgView addSubview:self.bottomRightLabel];
}

- (void)addConstraits{
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(kRecordWhiteBgHeight);
        make.height.mas_equalTo(kRecordWhiteBgHeight);
    }];
    
    [self.topLeftbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBgView).with.offset(5);
        make.left.equalTo(self.whiteBgView).with.offset(15);
    }];
    
    [self.topRightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBgView).with.offset(5);
        make.right.equalTo(self.whiteBgView).with.offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBgView).with.offset(40);
        make.left.and.right.equalTo(self.whiteBgView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteBgView);
        make.bottom.equalTo(self.bottomCenterBtn.mas_top).with.offset(-15);
    }];
    
    [self.bottomLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomCenterBtn);
        make.right.equalTo(self.bottomCenterBtn.mas_left).with.offset(-kBottomBtnMargin);
        make.size.mas_equalTo(kBottomLeftBtnSize);
    }];
    
    [self.bottomLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomCenterBtn);
        make.right.equalTo(self.bottomCenterBtn.mas_left).with.offset(-kBottomBtnMargin);
        make.size.mas_equalTo(kBottomLeftBtnSize);
    }];
    
    [self.bottomCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset((kRecordWhiteBgHeight - 40 - 80)/2);
        make.centerX.equalTo(self.whiteBgView);
        make.size.mas_equalTo(kBottomCenterBtnSize);
    }];
    
    [self.bottomRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomCenterBtn);
        make.left.equalTo(self.bottomCenterBtn.mas_right).with.offset(kBottomBtnMargin);
        make.size.mas_equalTo(kBottomRightBtnSize);
    }];
    
    [self.bottomLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLeftBtn.mas_bottom);
        make.centerX.equalTo(self.bottomLeftBtn);
    }];
    
    [self.bottomCenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomCenterBtn.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.bottomCenterBtn);
    }];
    
    [self.bottomRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomRightBtn.mas_bottom);
        make.centerX.equalTo(self.bottomRightBtn);
    }];
    
    
}

- (NSString *)getAudioCafPath{
    return [[self getAnswerDirName] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",kCurrentTimestampMillisecond]];
}

- (NSString *)getAnswerDirName{
    return [NSString stringWithFormat:@"task_%@_%@_answer",self.questionModel.taskId,self.taskModel.storeId];
}


#pragma mark - setter

- (void)setRemainingSeconds:(NSTimeInterval)remainingSeconds{
    _remainingSeconds = remainingSeconds;
    NSTimeInterval seconds = kMaxRecordSeconds - remainingSeconds;
    self.timeLabel.text = [self formatTimeLength:seconds];
}

- (void)setBottomCenterBtnState:(BottomCenterBtnState)bottomCenterBtnState{
    _bottomCenterBtnState = bottomCenterBtnState;
    switch (bottomCenterBtnState) {
        case BottomCenterBtnStateRecord:
        {
            self.bottomCenterLabel.text = @"开始录音";
            [self.bottomCenterBtn setImage:kImageNamed(@"task_btn_record") forState:UIControlStateNormal];
        }
            break;
        case BottomCenterBtnStatePauseRecord:
        {
            self.bottomCenterLabel.text = @"结束录音";
            [self.bottomCenterBtn setImage:kImageNamed(@"task_btn_pause") forState:UIControlStateNormal];
        }
            break;
        case BottomCenterBtnStatePlay:
        {
            self.bottomCenterLabel.text = @"播放";
            [self.bottomCenterBtn setImage:kImageNamed(@"task_btn_play") forState:UIControlStateNormal];
        }
            break;
        case BottomCenterBtnStatePausePlay:
        {
            self.bottomCenterLabel.text = @"暂停";
            [self.bottomCenterBtn setImage:kImageNamed(@"task_btn_pause") forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }

}

#pragma mark - getter

- (UIView *)whiteBgView{
    if (!_whiteBgView) {
        _whiteBgView = [UIView new];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBgView;
}

- (UIButton *)topLeftbtn{
    if (!_topLeftbtn) {
        _topLeftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topLeftbtn setTitle:@"取消" forState:UIControlStateNormal];
        _topLeftbtn.titleLabel.font = kYbsFontCustom(17);
        [_topLeftbtn setTitleColor:kColorHex(@"#2F2F2F") forState:UIControlStateNormal];
        [_topLeftbtn addTarget:self action:@selector(topLeftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topLeftbtn;
}

- (UIButton *)topRightBtn{
    if (!_topRightBtn) {
        _topRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topRightBtn setTitle:@"完成" forState:UIControlStateNormal];
        _topRightBtn.titleLabel.font = kYbsFontCustom(17);
        [_topRightBtn setTitleColor:kColorHex(@"#FF2F29") forState:UIControlStateNormal];
        [_topRightBtn addTarget:self action:@selector(topRightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topRightBtn;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = kColorHex(@"#D0D0D0");
    }
    return _lineView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kYbsFontCustom(15);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _timeLabel;
}


- (UIButton *)bottomLeftBtn{
    if (!_bottomLeftBtn) {
        _bottomLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomLeftBtn setImage:kImageNamed(@"task_btn_cancel_hover") forState:UIControlStateNormal];
        [_bottomLeftBtn addTarget:self action:@selector(bottomLeftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomLeftBtn;
}

- (UILabel *)bottomLeftLabel{
    if (!_bottomLeftLabel) {
        _bottomLeftLabel = [[UILabel alloc] init];
        _bottomLeftLabel.text = @"取消";
        _bottomLeftLabel.font = kYbsFontCustom(13);
        _bottomLeftLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLeftLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _bottomLeftLabel;
}

- (UIButton *)bottomCenterBtn{
    if (!_bottomCenterBtn) {
        _bottomCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomCenterBtn setImage:kImageNamed(@"task_btn_record") forState:UIControlStateNormal];
        [_bottomCenterBtn addTarget:self action:@selector(bottomCenterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomCenterBtn;
}

- (UILabel *)bottomCenterLabel{
    if (!_bottomCenterLabel) {
        _bottomCenterLabel = [[UILabel alloc] init];
        _bottomCenterLabel.text = @"开始录制";
        _bottomCenterLabel.font = kYbsFontCustom(15);
        _bottomCenterLabel.textAlignment = NSTextAlignmentCenter;
        _bottomCenterLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _bottomCenterLabel;
}

- (UIButton *)bottomRightBtn{
    if (!_bottomRightBtn) {
        _bottomRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomRightBtn setImage:kImageNamed(@"task_btn_refresh_hover") forState:UIControlStateNormal];
        [_bottomRightBtn addTarget:self action:@selector(bottomRightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomRightBtn;
}

- (UILabel *)bottomRightLabel{
    if (!_bottomRightLabel) {
        _bottomRightLabel = [[UILabel alloc] init];
        _bottomRightLabel.text = @"重录";
        _bottomRightLabel.font = kYbsFontCustom(13);
        _bottomRightLabel.textAlignment = NSTextAlignmentCenter;
        _bottomRightLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _bottomRightLabel;
}

#pragma mark - Action

- (void)topLeftAction{
    [[JLRecod shareManager] audioRecorderStop];
    [[JLRecod shareManager] audioStop];
    
    if (self.voiceModel.voicePath) {//点击查看
        if ([self.voiceModel.voicePath isEqualToString:self.pathStr]) {//没有重录
            
        }else{//重录
            //删除重录的
            
            NSString *noExtensionPath = [self.pathStr stringByDeletingPathExtension];
            NSString *mp3PathStr = [noExtensionPath stringByAppendingPathExtension:@"mp3"];
            NSString *finalPath = [[YFM documentPath] stringByAppendingPathComponent:mp3PathStr];
            [YFM deleteFileInPath:finalPath];
        }
    }else{//新录制
        
    }
    
    [self dismiss];
}

- (void)topRightAction{
    [[JLRecod shareManager] audioRecorderStop];
    [[JLRecod shareManager] audioStop];
    
    if (self.voiceModel.voicePath) {//点击查看
        if ([self.voiceModel.voicePath isEqualToString:self.pathStr]) {//没有重录
            
        }else{//重录
            //删除原来的
            NSString *finalPath = [[YFM documentPath] stringByAppendingPathComponent:self.voiceModel.voicePath];
            [YFM deleteFileInPath:finalPath];
        }
    }else{//新录制
        
    }
    
    NSString *noExtensionPath = [self.pathStr stringByDeletingPathExtension];
    NSString *mp3PathStr = [noExtensionPath stringByAppendingPathExtension:@"mp3"];
    NSString *finalPath = [[YFM documentPath] stringByAppendingPathComponent:mp3PathStr];
    NSTimeInterval time = [[JLRecod shareManager] durationAudioRecorderWithFilePath:finalPath];
    if (time > 0) {
        YbsVoiceModel *vm = [YbsVoiceModel new];
        vm.voicePath = mp3PathStr;
        vm.timeLength = round(time);
        
        if (self.chooseBlock) {
            self.chooseBlock(vm);
        }
    }
    
    [self dismiss];

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

- (void)bottomLeftAction{
    [self topLeftAction];
//    [[JLRecod shareManager] audioRecorderStop];
//    [[JLRecod shareManager] audioStop];
//
//    [self dismiss];
}

- (void)bottomCenterAction{
    
    switch (self.bottomCenterBtnState) {
        case BottomCenterBtnStateRecord:
        {
            int ppt=[self judge];
            // 授权
            if (ppt==2) {
                // 未授权
            }else if (ppt==0){
                
                return;
                //没有询问是否开启麦克风
            }else if (ppt==1){
                [ self AuthorityToJudge];
                return;
            }
            self.bottomCenterBtnState = BottomCenterBtnStatePauseRecord;
            
            NSString *dir = [YFM createDirectoryInDocumentWithName:[self getAnswerDirName]];
            if (dir) {
                self.pathStr = [self getAudioCafPath];
            }else{
                YbsQAViewController *vc = (YbsQAViewController *)[UIViewController currentViewController];
                [vc showMessage:@"录音失败" hideDelay:1];
                return;
            }
            NSString *finalPath = [[YFM documentPath] stringByAppendingPathComponent:self.pathStr];
            
            [[JLRecod shareManager] audioRecorderStartWithFilePath:finalPath];
            
            [self.progressView setProgressStrokeColor:[UIColor whiteColor]];
            
            self.voiceSeconds = 0;
            self.remainingSeconds = kMaxRecordSeconds;
            self.timeLabel.hidden = NO;
            
            self.timer = [NSTimer fy_timerWithTimeInterval:1 target:self selector:@selector(handleTimer) userInfo:nil runLoopMode:NSRunLoopCommonModes repeats:YES];
            
            [self.progressView setProgress:1 animated:YES];
            self.progressView.longTime = [NSString stringWithFormat:@"%d",kMaxRecordSeconds];
            [self.progressView setProgress:1 animated:YES];;
            
        }
            break;
        case BottomCenterBtnStatePauseRecord:
        {
            self.bottomCenterBtnState = BottomCenterBtnStatePlay;
            [self.progressView stopProgress];
            [self.timer invalidate];
            self.timer = nil;
            
            [[JLRecod shareManager] audioRecorderStop];
        }
            break;
        case BottomCenterBtnStatePlay:
        {
            self.bottomCenterBtnState = BottomCenterBtnStatePausePlay;
            
            NSString *noExtensionPath = [self.pathStr stringByDeletingPathExtension];
            NSString *mp3PathStr = [noExtensionPath stringByAppendingPathExtension:@"mp3"];
            NSString *finalPath = [[YFM documentPath] stringByAppendingPathComponent:mp3PathStr];
            
            NSTimeInterval ii = [[JLRecod shareManager] durationAudioRecorderWithFilePath:finalPath];
            self.progressView.longTime=[NSString stringWithFormat:@"%f",ii];
            
            [[JLRecod shareManager] audioPlayWithFilePath:finalPath];
            
        }
            break;
        case BottomCenterBtnStatePausePlay:
        {
            self.bottomCenterBtnState = BottomCenterBtnStatePlay;
            [[JLRecod shareManager] audioStop];
            [self.progressView stopProgress];
            [[JLRecod shareManager] audioStop];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)bottomRightAction{
    self.bottomCenterBtnState = BottomCenterBtnStateRecord;
    [self.timer invalidate];
    self.timer = nil;
    [self.progressView stopProgress];
    [[JLRecod shareManager] audioStop];
    [ self.progressView setProgressStrokeColor:[UIColor clearColor]];
    
    [self bottomCenterAction];
    
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
            make.height.mas_equalTo(kRecordWhiteBgHeight);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.progressView = [[HYCircleProgressView alloc]initWithFrame:self.bottomCenterBtn.frame];
        self.progressView.userInteractionEnabled = NO;
        self.progressView.step=1;
        [self.whiteBgView addSubview: self.progressView];
        [ self.progressView setBackgroundStrokeColor:kColorHex(kYbsNavigationBarColor)];
        [ self.progressView setProgressStrokeColor:[UIColor clearColor]];
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        [self.whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self).with.offset(kRecordWhiteBgHeight);
            make.height.mas_equalTo(kRecordWhiteBgHeight);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)handleTimer{
    if (self.remainingSeconds == 0) {
        self.bottomCenterBtnState = BottomCenterBtnStatePlay;
        [self.progressView stopProgress];
        [self.timer invalidate];
        self.timer = nil;
        
    }else{
        self.voiceSeconds = self.voiceSeconds + 1;
        self.remainingSeconds = self.remainingSeconds - 1;
    }
}

- (int )judge{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    int  flag;
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启麦克风
            flag = 1;
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
            flag = 0;
            break;
        case AVAuthorizationStatusDenied:
            //玩家未授权
            flag = 0;
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
            flag = 2;
            break;
        default:
            break;
    }
    return flag;
}

- (void)AuthorityToJudge
{
    __weak __typeof(self) weakSelf = self;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (!granted) {
            [weakSelf PermissionToRequest];
        }
    }];
}
- (void)PermissionToRequest
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"读取麦克风权限" message:@"拼任务需要您开启麦克风权限,您是否允许" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"禁止" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            [[UIApplication sharedApplication] openURL:url];
        }
    }]];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - JLRecodDelegate

- (void)audioRecorderDidFinishRecording{
    self.bottomCenterBtnState = BottomCenterBtnStatePlay;
}

- (void)audioPlayerDidFinishPlaying{
    self.bottomCenterBtnState = BottomCenterBtnStatePlay;
}

- (void)dealloc
{
    NSLog(@"销毁了录音视图");
}


@end
