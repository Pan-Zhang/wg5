//
//  TimeTableViewCell.h
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *socket_num;
@property (weak, nonatomic) IBOutlet UISwitch *isValid;
@property (weak, nonatomic) IBOutlet UILabel *onOff;
@property (weak, nonatomic) IBOutlet UIImageView *one;
@property (weak, nonatomic) IBOutlet UIImageView *two;
@property (weak, nonatomic) IBOutlet UIImageView *three;
@property (weak, nonatomic) IBOutlet UIImageView *four;
@property (weak, nonatomic) IBOutlet UIImageView *five;
@property (weak, nonatomic) IBOutlet UIImageView *six;
@property (weak, nonatomic) IBOutlet UIImageView *seven;
@property (weak, nonatomic) IBOutlet UIView *seperator;

@end
