//
//  YbsFileManager.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/20.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsFileManager.h"

static YbsFileManager *singleton = nil;

@interface YbsFileManager ()

@end

@implementation YbsFileManager

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[YbsFileManager alloc]init];
    });
    return singleton;
}

- (NSString *)documentPath{
    if (!_documentPath) {
        _documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    }
    return _documentPath;
}

- (NSString *)createDirectoryInDocumentWithName:(NSString *)dName{
    NSString *docPath = [self documentPath];
    NSString *directoryPath = [docPath stringByAppendingPathComponent:dName];
    BOOL isDir = NO;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir];
    if(!(isDirExist && isDir)){
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (result) {
            return directoryPath;
        }else{
            return nil;
        }
        
    }else{
        return directoryPath;
    }
}


- (BOOL)archiveToDocument:(id)file inSubdirectory:(NSString *)dName fileName:(NSString *)fName{
    
    NSString *fileFullPath = [[self.documentPath stringByAppendingPathComponent:dName] stringByAppendingPathComponent:fName];
//    LoggerApp(1,@"%@",fileFullPath);
    return [self archiveFile:file toPath:fileFullPath];
}


- (id)unarchiveFileInDocumentSubdirectory:(NSString *)dName fileName:(NSString *)fName{
    NSString *fileFullPath = [[self.documentPath stringByAppendingPathComponent:dName] stringByAppendingPathComponent:fName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:fileFullPath];
}


- (BOOL)deleteFileInDocumentSubdirectory:(NSString *)dName fileName:(NSString *)fName{
    NSString *fileFullPath = [[self.documentPath stringByAppendingPathComponent:dName] stringByAppendingPathComponent:fName];
    return [self deleteFileInPath:fileFullPath];
}


- (BOOL)archiveFile:(id)file toPath:(NSString *)path{
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (error) {
            return NO;
        }
    }
    return [NSKeyedArchiver archiveRootObject:file toFile:path];
}

- (BOOL)deleteFileInPath:(NSString *)path{
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (error) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}

- (BOOL)fileExistAtDocumentSubdirectory:(NSString *)dName fileName:(NSString *)fName{
    NSString *fileFullPath = [[self.documentPath stringByAppendingPathComponent:dName] stringByAppendingPathComponent:fName];
    return [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
}






@end
