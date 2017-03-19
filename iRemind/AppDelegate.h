//
//  AppDelegate.h
//  iRemind
//
//  Created by tjsoft on 2017/3/19.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TENGNotificationModel;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TENGNotificationModel *notiModel;

@end

