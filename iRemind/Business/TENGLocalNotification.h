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

+ (void)addLocalNotification:(NSDictionary *)notInfo;

+ (void)removeLocalNotification:(TENGNotificationModel *)notiModel;

+ (void)showLocalNotification:(UILocalNotification *)notification;

@end
