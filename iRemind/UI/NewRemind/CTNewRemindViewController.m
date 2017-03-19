//
//  CTNewRemindViewController.m
//  iRemind
//
//  Created by 腾 on 2017/2/25.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "CTNewRemindViewController.h"

@interface CTNewRemindViewController ()
@property (weak, nonatomic) IBOutlet UITextView *eventContent;
@property (weak, nonatomic) IBOutlet UITextField *eventTitle;

@end

@implementation CTNewRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建提醒";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[CTTool makeCustomRightBtn:@"保 存" target:self sel:@selector(saveNewEvents)]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)saveNewEvents{
  
    if (!_eventTitle.hasText) {
        return;
    }
    if (!_eventContent.hasText) {
        return;
    }
    NSInteger nowTime = [[NSDate new] timeIntervalSince1970];
    AVObject *testObject = [AVObject objectWithClassName:EVENT_CLASS];
    [testObject setObject:_eventContent.text forKey:EVENT_CONTENT];
    [testObject setObject:_eventTitle.text   forKey:EVENT_TITLE];
    [testObject setObject:[NSString stringWithFormat:@"%ld",(long)nowTime]   forKey:REMIND_TIME];

//    [SVProgressHUD show];
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        [SVProgressHUD dismiss];
        if (succeeded) {
            debugLog(@"保存成功");
            [self backToPreVC];
        }
    }];
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
