//
//  CTUserCentreViewController.m
//  iRemind
//
//  Created by 腾 on 2017/2/25.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "CTUserCentreViewController.h"
#import <TYKYLibrary/TYKYLibrary.h>
#import "UIImageView+WebCache.h"

NSString *const SETTING_CELL = @"settingCell";
NSString *const HEADIMAGE = @"headImage";


@interface CTUserCentreViewController ()<CTONEPhotoDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation CTUserCentreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVUser *user = [AVUser currentUser];

    if (user[HEADIMAGE]) {
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:user[HEADIMAGE]]];
    }

    self.dataArray = @[@"已删除事件",@"我的计划",@"任务暂存",@"番茄工作法",@"设置"];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SETTING_CELL];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma 设置每行数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *mycell = [tableView dequeueReusableCellWithIdentifier:SETTING_CELL forIndexPath:indexPath];
    if (mycell==nil) {
        mycell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SETTING_CELL];
    }
    mycell.textLabel.text = self.dataArray[indexPath.row];
    mycell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return mycell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (IBAction)chooseHeadImgAction:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [CTONEPhoto shareSigtonPhoto].delegate = self;
        [[CTONEPhoto shareSigtonPhoto] openCamera:self editModal:YES];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [CTONEPhoto shareSigtonPhoto].delegate = self;
        [[CTONEPhoto shareSigtonPhoto] openAlbum:self editModal:YES];

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           }]];
    APP_PRESENT(alert);
    
}
- (void)sendOnePhoto:(UIImage *)image withImageName:(NSString *)imageName{
    [self saveUserHeadImage:image];
}
#pragma mark 上传用户头像
- (void)saveUserHeadImage:(UIImage *)image{
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.6);
    NSString *imageName = [NSString stringWithFormat:@"%.0f",[[NSDate new] timeIntervalSince1970]];

//    [SVProgressHUD show];
    AVFile *file = [AVFile fileWithName:imageName data:imgData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        [SVProgressHUD dismiss];

        if (succeeded) {
            self.headImg.image = image;
            [[AVUser currentUser] setObject:file.url forKey:HEADIMAGE];
            [[AVUser currentUser] saveInBackground];
        }else{
            
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
