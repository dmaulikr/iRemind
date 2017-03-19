//
//  RemindTableViewCell.m
//  iRemind
//
//  Created by 腾 on 2017/2/25.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "RemindTableViewCell.h"

@interface RemindTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dataTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UILabel *eventContent;

@end
@implementation RemindTableViewCell

- (void)setCellData:(AVObject *)cellData{
    _cellData = cellData;
    self.eventContent.text = cellData[EVENT_CONTENT];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
