//
//  TENGNotificationModel.h
//  iRemind
//
//  Created by tjsoft on 2017/3/18.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TENGNotificationModel : NSObject

@property (strong, nonatomic) NSString *alertTitle;
@property (strong, nonatomic) NSString *alertBody;
@property (strong, nonatomic) NSDate *fireDate;
@property (strong, nonatomic) NSString *soundName;
@property (strong, nonatomic) NSString *notificationId;

- (instancetype)initValueWithDic:(NSDictionary *)dic;
@end
