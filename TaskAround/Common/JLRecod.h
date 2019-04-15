//
//  JLRecod.h
//  PatchedTogetherTask
//
//  Created by 陈建林 on 2018/4/18.
//  Copyright © 2018年 chenjianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JLRecodDelegate <NSObject>

- (void)audioRecorderDidFinishRecording;
- (void)audioPlayerDidFinishPlaying;

@end


@interface JLRecod : NSObject

@property (nonatomic, weak) id<JLRecodDelegate> delegate;

#pragma mark - 录音

/// 实例化单例
+ (JLRecod *)shareManager;

@property (nonatomic, assign) BOOL isRecording;
#pragma mark - 音频处理-录音

/// 开始录音
- (void)audioRecorderStartWithFilePath:(NSString *)filePath;

/// 停止录音
- (void)audioRecorderStop;

/// 录音时长
- (NSTimeInterval)durationAudioRecorderWithFilePath:(NSString *)filePath;

#pragma mark - 音频处理-播放/停止

/// 音频开始播放或停止
- (void)audioPlayWithFilePath:(NSString *)filePath;

/// 音频播放停止
- (void)audioStop; 
@end
