//
//  TestViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/3/4.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "TestViewController.h"
#import "QCloudCore.h"
#import <QCloudCOSXML/QCloudCOSXML.h>
#import "YbsFileManager.h"

@interface TestViewController ()

@property (nonatomic ,assign) BOOL uploadFailed;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 200, 60, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 300, 60, 40);
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"图片" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(100, 400, 60, 40);
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"文件" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(100, 480, 60, 40);
    btn3.backgroundColor = [UIColor redColor];
    [btn3 setTitle:@"删除文件" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btn3Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}


- (void)btnClick{
    self.uploadFailed = NO;
    
//    QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
//
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"test2" ofType:@"png"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
//    NSData *data = UIImageJPEGRepresentation(image, 0.5);
////    NSURL *url = [NSURL fileURLWithPath:path] /*文件的URL*/;
//    put.object = @"ios/444.jpg";
//    put.bucket = @"yunbangshou-cos-1258434628";
//    put.body = data;
//    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
//        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
//    }];
//    [put setFinishBlock:^(id outputObject, NSError* error) {
//        id outobj = outputObject;
//
//    }];
//    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i=0; i<10; i++) {
        [arr addObject:@""];
    }

    dispatch_group_t group =dispatch_group_create();
    dispatch_queue_t globalQueue=dispatch_get_global_queue(0, 0);

    
    
    @weakify(self);
    for (int i=0; i<10; i++) {
        dispatch_group_enter(group);
        dispatch_group_async(group, globalQueue, ^{
            
            @strongify(self);
            if (!self) return;
            QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
            
            NSString *path = [[NSBundle mainBundle]pathForResource:@"test1" ofType:@"png"];
            UIImage *img = [UIImage imageWithContentsOfFile:path];
            NSData *data = UIImageJPEGRepresentation(img, 0.5);
            
            put.object = [NSString stringWithFormat:@"ios/%d_3.jpg",i];
            put.bucket = @"yunbangshou-cos-1258434628";
            put.body = data;
            [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            }];
            [put setFinishBlock:^(QCloudUploadObjectResult *outputObject, NSError* error) {
                [arr replaceObjectAtIndex:i withObject:outputObject.location];
                dispatch_group_leave(group);
            }];
            [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
            
        });
    }


    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *array = arr;

    });
    

}

- (void)btn1Click{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"test2" ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    NSData *data1 = UIImageJPEGRepresentation(img, 0.5);
    NSData *data2 = UIImagePNGRepresentation(img);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath1 = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"3.jpg"];
    NSString *filePath2 = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"3.png"];
    // 保存文件的名称
    NSLog(@"%@",filePath1);
    
    BOOL result1 = [data1 writeToFile:filePath1 atomically:YES];
    BOOL result2 = [data2 writeToFile:filePath2 atomically:YES];
    

    
//    LoggerApp(1,@"%.3f, %.3f",data1.length/1024.0/1024.0,data2.length/1024.0/1024.0);
    
    
}

- (void)btn2Click{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"test3" ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    NSData *data = UIImageJPEGRepresentation(img, 0.5);
    
    NSString *dir = [YFM createDirectoryInDocumentWithName:@"aaaa"];
    if (dir) {
        NSString *destinationPath = [dir stringByAppendingPathComponent:@"211.jpg"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
            [data writeToFile:destinationPath atomically:YES];
        }
    }

}

- (void)btn3Click{
    NSString *dir = [YFM createDirectoryInDocumentWithName:@"aaaa"];
//    [YFM deleteFileInDocumentSubdirectory:@"aaaa" fileName:<#(nonnull NSString *)#>]
    if ([YFM deleteFileInPath:dir]) {//会连文件夹一块删除
        [self showMessage:@"success" hideDelay:1];
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
