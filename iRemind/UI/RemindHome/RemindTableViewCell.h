//
//  RemindTableViewCell.h
//  iRemind
//
//  Created by 腾 on 2017/2/25.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVObject;
@interface RemindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) AVObject *cellData;
@end
