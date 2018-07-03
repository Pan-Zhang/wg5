//
//  ArmDIsarmTableViewCell.h
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/4/3.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArmDIsarmTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *reason;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *seperator;

@end
