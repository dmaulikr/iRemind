//
//  TENGLocalNotification.m
//  iRemind
//
//  Created by tjsoft on 2017/3/18.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "TENGLocalNotification.h"
#import "TENGNotificationModel.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

NSString const *NOTIFICATION_ID = @"notification_id";

@implementation TENGLocalNotification

+ (void)addLocalNotification:(NSDictionary *)notInfo{
    if (!notInfo) {
        return;
    }
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
        TENGNotificationModel *model = [[TENGNotificationModel alloc] initValueWithDic:notInfo];
        
        UILocalNotification *notification = [UILocalNotification new];
        notification.alertBody = model.alertBody;
        notification.alertTitle = model.alertTitle;
        notification.soundName = model.soundName;
        notification.fireDate = model.fireDate;
        notification.userInfo = @{NOTIFICATION_ID:model.notificationId};
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }else{
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
        [(AppDelegate *)[UIApplication sharedApplication].delegate setNotificationDic:notInfo];
    }
    
}
+ (void)removeLocalNotification:(TENGNotificationModel *)notiModel{
    
    if (!notiModel.notificationId) {
        return;
    }
    
    for (UILocalNotification *noti in  [UIApplication sharedApplication].scheduledLocalNotifications) {
        NSString *notifiId = noti.userInfo[NOTIFICATION_ID];
        if ([notifiId isEqualToString:notiModel.notificationId]) {
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
            break;
        }
    }

}
+ (void)showLocalNotification:(UILocalNotification *)notification{
    
    //应用在前台 收到了本地通知，需要手动添加震动或声音提醒
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //通知提醒声音
        AudioServicesPlaySystemSound(1007);//声音
        
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标

    //应用在后台，声音后震动提醒本地通知，用户点击了通知栏 进入该方法
    //弹出alert提示框、或者自定义提示框
    //当应用在后台，用户没有点击通知栏时,提醒事件应当根据提醒事件，提醒状态改变背景颜色，提醒用户有事件提醒
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:notification.alertTitle message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    APP_PRESENT(alert);
}
@end
