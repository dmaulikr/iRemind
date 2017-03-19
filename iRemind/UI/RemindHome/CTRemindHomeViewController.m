//
//  ViewController.m
//  iRemind
//
//  Created by 腾 on 2017/2/25.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "CTRemindHomeViewController.h"
#import "RemindTableViewCell.h"
#import "CTNewRemindViewController.h"
#import "CTRootViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "CTTool.h"
#import "TENGNotificationModel.h"
#import "TENGLocalNotification.h"

@interface CTRemindHomeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray <AVObject *> *eventTimeArray;

@property (strong,nonatomic) AVQuery *query;

@property (assign,nonatomic) NSInteger pageSize;
@property (assign,nonatomic) NSInteger pageNum;
@property (assign,nonatomic) NSInteger testNum;
@end

@implementation CTRemindHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的事件";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RemindTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RemindTableViewCell class])];

    self.tableView.mj_header = [CTTool makeMJRefeshWithTarget:self andMethod:@selector(loadStartPage)];
    [SVProgressHUD show];
    [self performSelector:@selector(testDataArray) withObject:nil afterDelay:1.0];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavitationBarItems];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _testNum;
//    return self.eventTimeArray.count;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemindTableViewCell *mycell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RemindTableViewCell class]) forIndexPath:indexPath];
    BUTTON_ACTION(mycell.deleteBtn, self, @selector(deleteCellAction:));
    mycell.deleteBtn.tag =indexPath.row;
    
//    mycell.cellData = self.eventTimeArray[indexPath.row];
    return mycell;
}

#pragma mark UITableViewDelegate UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _testNum--;

        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (IBAction)addNewEventAction:(UIButton *)sender {
    CTNewRemindViewController *newRemind = [CTNewRemindViewController new];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:newRemind] animated:YES completion:nil];
}

- (NSMutableArray <AVObject *> *)eventTimeArray{
    if (_eventTimeArray==nil) {
        _eventTimeArray = [NSMutableArray new];
        
    }
    return _eventTimeArray;
}

- (void)showUserCenter{
    if ([self.navigationController.parentViewController isKindOfClass:[CTRootViewController class]]) {
        [(CTRootViewController *)self.navigationController.parentViewController showMenu];
    }
}

- (void)initNavitationBarItems{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserCenter)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(goSearch)];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.navigationItem.rightBarButtonItem.imageInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    self.navigationItem.leftBarButtonItem.tintColor  = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem.tintColor  = [UIColor blackColor];

}
- (void)goSearch{
    
    TENGNotificationModel *test = [TENGNotificationModel new];
    test.alertBody  = @"testBody";
    test.alertTitle = @"testTitle";
    test.fireDate = [[NSDate new] dateByAddingTimeInterval:10];
    test.soundName = UILocalNotificationDefaultSoundName;
    test.repeatInterval = NSCalendarUnitSecond;
    test.notificationId = @"test1";
    [TENGLocalNotification addLocalNotification:test];
    debugLog(@"search");
}
- (void)deleteCellAction:(UIButton *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"删除该条提醒?" preferredStyle:UIAlertControllerStyleAlert];
   
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _testNum--;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    APP_PRESENT(alert);
}
- (void)loadStartPage{
    

    self.pageNum = 0;
    self.pageSize = 40;
    AVQuery *query = [AVQuery queryWithClassName:EVENT_CLASS];
    query.limit = self.pageSize;
    query.skip = self.pageSize *self.pageNum;
//    [query includeKey:USER_ID];
    [query orderByDescending:@"createdAt"];
    self.query = query;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (error) {
            return;
        }
        [self.eventTimeArray removeAllObjects];
        if (objects.count==self.pageSize) {
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPage)];
            self.pageNum++;
        }
        [self.eventTimeArray addObjectsFromArray:objects];
        
        _testNum = 10;
        [self.tableView reloadData];
        
    }];
   
}
- (void)loadNextPage{
    self.query.skip = self.pageSize *self.pageNum;
    
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        
        if (error) {
            return;
        }
        if (objects.count==self.pageSize) {
            self.pageNum++;
        }else{
            self.tableView.mj_footer = nil;
        }
        [self.eventTimeArray addObjectsFromArray:objects];
        [self.tableView reloadData];
        
    }];
}

- (void)testDataArray{
    [SVProgressHUD dismiss];
    _testNum = 10;
    [self.tableView reloadData];
    self.tableView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.alpha = 1.0;
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
