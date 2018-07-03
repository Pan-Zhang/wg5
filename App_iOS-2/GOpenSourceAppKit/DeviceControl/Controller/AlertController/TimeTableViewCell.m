//
//  TimeTableViewCell.m
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "TimeTableViewCell.h"

@implementation TimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _isValid.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-76, _isValid.frame.origin.y, _isValid.frame.size.width, _isValid.frame.size.height);
    _seperator.frame = CGRectMake(_seperator.frame.origin.x, _seperator.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 10);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
