//
//  TENGLocalNotification.h
//  iRemind
//
//  Created by tjsoft on 2017/3/18.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TENGNotificationModel;
@interface TENGLocalNotification : NSObject

+ (void)addLocalNotification:(TENGNotificationModel *)notifiModel;

+ (void)removeLocalNotification:(NSString *)notificationId;

+ (void)showLocalNotification:(UILocalNotification *)notification;

+ (void)changeLocalNotification:(NSString *)notificationId;

@end
