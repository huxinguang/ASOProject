//
//  JLRecod.m
//  PatchedTogetherTask
//
//  Created by 陈建林 on 2018/4/18.
//  Copyright © 2018年 chenjianlin. All rights reserved.
//

#import "JLRecod.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import "YbsFileManager.h"

@interface JLRecod () <AVAudioRecorderDelegate,AVAudioPlayerDelegate>
@property (nonatomic, strong) NSTimer *audioRecorderTimer;               // 录音音量计时器
@property (nonatomic, strong) NSMutableDictionary *audioRecorderSetting; // 录音设置
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;            // 录音
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;                // 播放
@property (nonatomic, assign) double audioRecorderTime;                  // 录音时长
@property (nonatomic, strong) UIView *imgView;                           // 录音音量图像父视图
@property (nonatomic, strong) UIImageView *audioRecorderVoiceImgView;    // 录音音量图像

@property (nonatomic, copy  ) NSString *audioFilePath;

@end

@implementation JLRecod

- (instancetype)init{
    self = [super init];
    if (self)
    {
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
        //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        
        //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
        [recordSetting setValue:[NSNumber numberWithFloat:22000] forKey:AVSampleRateKey];
        
        //线性采样位数  8、16、24、32
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        
        //录音通道数  1 或 2
        [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        
        //录音的质量
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
        
        self.audioRecorderSetting = [NSMutableDictionary dictionaryWithDictionary:recordSetting];
        
    }
    
    return self;
}

/// 实例化单例
+ (JLRecod *)shareManager{
    static JLRecod *staticAudioRecorde;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        staticAudioRecorde = [[self alloc] init];
    });
    
    return staticAudioRecorde;
}
#pragma mark - 音频处理-录音

/// 开始录音
- (void)audioRecorderStartWithFilePath:(NSString *)filePath
{
    self.audioFilePath = filePath;
    // 生成录音文件
    NSURL *urlAudioRecorder = [NSURL fileURLWithPath:filePath];
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:urlAudioRecorder settings:self.audioRecorderSetting error:nil];
    
    // 开启音量检测
    [self.audioRecorder setMeteringEnabled:YES];
    [self.audioRecorder setDelegate:self];
    
    if (self.audioRecorder)
    {
        // 录音时设置audioSession属性，否则不兼容Ios7
        AVAudioSession *recordSession = [AVAudioSession sharedInstance];
        [recordSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [recordSession setActive:YES error:nil];
        
        if ([self.audioRecorder prepareToRecord])
        {
            self.isRecording = YES;
            [self.audioRecorder record];
        }
    }
}



/// 停止录音
- (void)audioRecorderStop{
    if (self.audioRecorder){
        if ([self.audioRecorder isRecording]){
            // 获取录音时长
            self.audioRecorderTime = [self.audioRecorder currentTime];
            [self.audioRecorder stop];
            [self convertCafToMp3:self.audioFilePath];
            NSLog(@"#################%@",self.audioFilePath);
            self.isRecording = NO;
            // 停止录音后释放掉
            self.audioRecorder = nil;
        }
    }
    
}

/// 录音时长
- (NSTimeInterval)durationAudioRecorderWithFilePath:(NSString *)filePath
{
    NSURL *urlFile = [NSURL fileURLWithPath:filePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlFile error:nil];
    NSTimeInterval time = self.audioPlayer.duration;
    self.audioPlayer = nil;
    return time;
}

#pragma mark - 音频处理-播放/停止

/// 音频开始播放或停止
- (void)audioPlayWithFilePath:(NSString *)filePath
{
    if (self.audioPlayer)
    {
        // 判断当前与下一个是否相同
        // 相同时，点击时要么播放，要么停止
        // 不相同时，点击时停止播放当前的，开始播放下一个
        NSString *currentStr = [self.audioPlayer.url relativeString];
        NSRange range = [currentStr rangeOfString:filePath];
        if (range.location != NSNotFound)
        {
            if ([self.audioPlayer isPlaying])
            {
                [self.audioPlayer stop];
                self.audioPlayer = nil;
            }
            else
            {
                self.audioPlayer = nil;
                [self audioPlayerPlay:filePath];
            }
        }
        else
        {
            [self audioPlayerStop];
            [self audioPlayerPlay:filePath];
        }
    }
    else
    {
        [self audioPlayerPlay:filePath];
    }
    
}

/// 音频播放停止
- (void)audioStop{
    [self audioPlayerStop];
}

/// 音频播放器开始播放
- (void)audioPlayerPlay:(NSString *)filePath
{
    // 判断将要播放文件是否存在
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!isExist){
        return;
    }
    NSURL *urlFile = [NSURL fileURLWithPath:filePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlFile error:nil];
    self.audioPlayer.delegate = self;
    if (self.audioPlayer){
        if ([self.audioPlayer prepareToPlay]){
            // 播放时，设置喇叭播放否则音量很小
            AVAudioSession *playSession = [AVAudioSession sharedInstance];
            [playSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            [playSession setActive:YES error:nil];
            
            [self.audioPlayer play];
        }
    }
}

/// 音频播放器停止播放
- (void)audioPlayerStop
{
    if (self.audioPlayer){
        if ([self.audioPlayer isPlaying]){
            [self.audioPlayer stop];
        }
        self.audioPlayer = nil;
    }
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (flag && [self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying)]) {
        [self.delegate audioRecorderDidFinishRecording];
    }
}


#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag && [self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying)]) {
        [self.delegate audioPlayerDidFinishPlaying];
    }
}


#pragma mark - lame

//录音文件转码
- (void)convertCafToMp3:(NSString *)cafPathString{
    NSString *noExtensionPath = [cafPathString stringByDeletingPathExtension];//去掉.caf
    NSString *mp3PathStr = [noExtensionPath stringByAppendingPathExtension:@"mp3"];
    
    @try {
        int read, write;

        FILE *pcm = fopen([cafPathString cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3PathStr cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置

        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];

        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);

        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);

            fwrite(mp3_buffer, write, 1, mp3);

        } while (read != 0);

        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
//        NSLog(@"MP3生成成功: %@",mp3PathStr);
        if (self.audioFilePath) {
            [YFM deleteFileInPath:self.audioFilePath];
        }
        
    }

}





@end
