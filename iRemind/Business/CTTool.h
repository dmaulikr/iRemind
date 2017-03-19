//
//  CTTool.h
//  iRemind
//
//  Created by 腾 on 2017/2/25.
//  Copyright © 2017年 腾. All rights reserved.
//

@class MJRefreshNormalHeader;

@interface CTTool : NSObject

+ (UIButton *)makeCustomRightBtn:(NSString *)title target:(id)target sel:(SEL)actionName;
+ (MJRefreshNormalHeader *)makeMJRefeshWithTarget:(id)root andMethod:(SEL)methodName;

@end
