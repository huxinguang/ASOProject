//
//  YbsQuestionViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/30.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsQuestionViewController.h"

@interface YbsQuestionViewController ()

@end

@implementation YbsQuestionViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.pageBlock) {
        self.pageBlock(self.view.tag);
    }
//    LoggerApp(2,@"YbsQuestionViewController viewDidAppear  viewTag=%ld",self.view.tag);
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    LoggerApp(2,@"YbsQuestionViewController viewDidLoad  viewTag=%ld",self.view.tag);
}

-(void)dealloc{
//    LoggerApp(2,@"YbsQuestionViewController dealloc");
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
