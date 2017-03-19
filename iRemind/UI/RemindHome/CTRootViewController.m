//
//  CTRootViewController.m
//  iRemind
//
//  Created by 腾 on 2017/2/25.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "CTRootViewController.h"
#import "CTRemindHomeViewController.h"
#import "CTUserCentreViewController.h"
@interface CTRootViewController ()

@end

@implementation CTRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isResponseGesture = YES;
    
    //添加左侧菜单界面
    CTUserCentreViewController *user = [CTUserCentreViewController new];
    user.view.frame = self.leftMenuView.bounds;
    [self.leftMenuView addSubview:user.view];
    [self addChildViewController:user];
    
    //添加主页面视图
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[CTRemindHomeViewController new]];
    
    [self.view addSubview:nav.view];
    [self addChildViewController:nav];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
