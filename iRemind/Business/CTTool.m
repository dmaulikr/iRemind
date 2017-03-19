//
//  CTTool.m
//  iRemind
//
//  Created by 腾 on 2017/2/25.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "CTTool.h"
#import <MJRefresh/MJRefresh.h>
#import "NSString+Extension.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@implementation CTTool

+ (UIButton *)makeCustomRightBtn:(NSString *)title target:(id)target sel:(SEL)actionName{
    CGFloat width = [title sizeWithMaxSize:CGSizeMake(200, 25) fontSize:15].width;
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width+8, 25)];
    [right setTitle:title forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:14];
    right.layer.masksToBounds = YES;
    right.layer.cornerRadius = 5.0;
    right.layer.borderWidth = 0.5;
    right.layer.borderColor = [UIColor blackColor].CGColor;
    [right addTarget:target action:actionName forControlEvents:UIControlEventTouchUpInside];
    return right;
}

+ (MJRefreshNormalHeader *)makeMJRefeshWithTarget:(id)root andMethod:(SEL)methodName{
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc]init];
    [header setTitle:@"继续下拉以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    
    header.stateLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14];
    header.lastUpdatedTimeLabel.hidden = YES;
    //    header.lastUpdatedTimeLabel.font = [UIFont fontWithName:@"Avenir-Book" size:10];
    //    header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    header.stateLabel.textColor = [UIColor blackColor];
    header.refreshingTarget = root;
    header.refreshingAction = methodName;
    return header;
}
@end
