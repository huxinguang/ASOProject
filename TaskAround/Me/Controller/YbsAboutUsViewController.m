//
//  YbsAboutUsViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/22.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsAboutUsViewController.h"

@interface YbsAboutUsViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appIconTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionBottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation YbsAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"关于我们"];
    self.appIconTopConstraint.constant = 60*(kAppScreenHeight/1334);
    self.versionBottomConstraint.constant = 40*(kAppScreenHeight/1334);
    self.emailBottomConstraint.constant = 120*(kAppScreenHeight/1334);
    self.versionLabel.font = kYbsFontCustom(15);
    self.contentLabel.font = kYbsFontCustom(15);
    self.contactLabel.font = kYbsFontCustomBold(18);
    self.wechatLabel.font = kYbsFontCustom(15);
    self.emailLabel.font = kYbsFontCustom(15);
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
