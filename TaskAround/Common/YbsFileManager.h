//
//  YbsFileManager.h
//  TaskAround
//
//  Created by xinguang hu on 2019/2/20.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YFM [YbsFileManager shareInstance]

NS_ASSUME_NONNULL_BEGIN

@interface YbsFileManager : NSObject

@property (nonatomic, copy) NSString *documentPath; //持久化

+ (instancetype)shareInstance;

- (NSString *)createDirectoryInDocumentWithName:(NSString *)dName;

- (BOOL)archiveToDocument:(id)file inSubdirectory:(NSString *)dName fileName:(NSString *)fName;
- (id)unarchiveFileInDocumentSubdirectory:(NSString *)dName fileName:(NSString *)fName;

- (BOOL)deleteFileInDocumentSubdirectory:(NSString *)dName fileName:(NSString *)fName;

- (BOOL)deleteFileInPath:(NSString *)path;

- (BOOL)fileExistAtDocumentSubdirectory:(NSString *)dirName fileName:(NSString *)fName;

@end

NS_ASSUME_NONNULL_END
