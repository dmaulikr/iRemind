//
//  TENGNotificationModel.m
//  iRemind
//
//  Created by tjsoft on 2017/3/18.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "TENGNotificationModel.h"

@implementation TENGNotificationModel

- (instancetype)initValueWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
