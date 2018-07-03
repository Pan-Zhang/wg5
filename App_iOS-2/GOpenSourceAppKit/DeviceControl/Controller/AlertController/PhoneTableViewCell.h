//
//  PhoneTableViewCell.h
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIImageView *call;
@property (weak, nonatomic) IBOutlet UIImageView *rfid;
@property (weak, nonatomic) IBOutlet UIImageView *sms;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (weak, nonatomic) IBOutlet UIButton *del;
@property (weak, nonatomic) IBOutlet UIView *seperator;

@end
