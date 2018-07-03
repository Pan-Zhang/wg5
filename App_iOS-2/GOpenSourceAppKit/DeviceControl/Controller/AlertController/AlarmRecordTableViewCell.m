//
//  AlarmRecordTableViewCell.m
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/4/3.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "AlarmRecordTableViewCell.h"

@implementation AlarmRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _time.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-160, _time.frame.origin.y, 150, 21);
    _seperator.frame = CGRectMake(_seperator.frame.origin.x, _seperator.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
