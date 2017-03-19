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

+ (void)addLocalNotification:(TENGNotificationModel *)notifiModel{
    if (!notifiModel) {
        return;
    }
    
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
        
        NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitEra |
        NSCalendarUnitYear |
        NSCalendarUnitMonth |
        NSCalendarUnitDay |
        NSCalendarUnitHour |
        NSCalendarUnitMinute |
        NSCalendarUnitSecond |
        NSCalendarUnitWeekOfYear |
        NSCalendarUnitWeekday |
        NSCalendarUnitWeekdayOrdinal |
        NSCalendarUnitQuarter;
        comps = [calendar components:unitFlags fromDate:[NSDate date]];
        for (int i = 0; i <100; i++) {
            NSDate *newFireDate = [[calendar dateFromComponents:comps] dateByAddingTimeInterval:1*i];
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            if (notification) {
                notification.fireDate = newFireDate;
                notification.alertBody = notifiModel.alertBody;
                notification.alertTitle = notifiModel.alertTitle;
                notification.soundName = notifiModel.soundName;
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.userInfo = @{NOTIFICATION_ID:notifiModel.notificationId};
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
        }

    }else{
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
        [(AppDelegate *)[UIApplication sharedApplication].delegate setNotiModel:notifiModel];
    }
    
}
+ (void)removeLocalNotification:(NSString *)notificationId{
    
    if (!notificationId) {
        return;
    }
    
    for (UILocalNotification *noti in  [UIApplication sharedApplication].scheduledLocalNotifications) {
        NSString *notifiId = noti.userInfo[NOTIFICATION_ID];
        if ([notifiId isEqualToString:notificationId]) {
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
            break;
        }
    }

}
+ (void)changeLocalNotification:(NSString *)notificationId{
    
    if (!notificationId) {
        return;
    }
    
    for (UILocalNotification *noti in  [UIApplication sharedApplication].scheduledLocalNotifications) {
        NSString *notifiId = noti.userInfo[NOTIFICATION_ID];
        if ([notifiId isEqualToString:notificationId]) {
            noti.fireDate = [noti.fireDate dateByAddingTimeInterval:10];
            [[UIApplication sharedApplication] scheduleLocalNotification:noti];

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
    
    NSString *nId = notification.userInfo[NOTIFICATION_ID];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:notification.alertTitle message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认提醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [TENGLocalNotification removeLocalNotification:nId];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"待会再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [TENGLocalNotification changeLocalNotification:nId];
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }]];
    APP_PRESENT(alert);
}

+ (void)addLocalNoti{
    
}
@end
