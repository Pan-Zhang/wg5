//
//  PhoneTableViewCell.m
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "PhoneTableViewCell.h"

@implementation PhoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _edit.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-125, _edit.frame.origin.y, 50, 30);
    _del.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-60, _del.frame.origin.y, 50, 30);
    _seperator.frame = CGRectMake(_seperator.frame.origin.x, _seperator.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
