//
//  SetTimeViewController.h
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/4/3.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartSocketTime.h"
#import <GizWifiSDK/GizWifiDevice.h>

@interface SetTimeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPickerView *hourPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *minutePicker;
@property (weak, nonatomic) IBOutlet UIButton *one;
@property (weak, nonatomic) IBOutlet UIButton *two;
@property (weak, nonatomic) IBOutlet UIButton *three;
@property (weak, nonatomic) IBOutlet UIButton *four;
@property (weak, nonatomic) IBOutlet UIButton *five;
@property (weak, nonatomic) IBOutlet UIButton *six;
@property (weak, nonatomic) IBOutlet UIButton *seven;
@property (weak, nonatomic) IBOutlet UISwitch *onoff;
@property (weak, nonatomic) IBOutlet UIPickerView *outlet;
@property (weak, nonatomic) IBOutlet UIView *divider1;
@property (weak, nonatomic) IBOutlet UIView *divider2;
@property (weak, nonatomic) IBOutlet UIView *divider3;
@property (weak, nonatomic) IBOutlet UILabel *repeat;

@property (strong, nonatomic) SmartSocketTime *socketTime;
@property (assign, nonatomic) int type;
@property (assign, nonatomic) NSInteger length;
@property(nonatomic, weak) GizWifiDevice *device;
- (void)hideSelf:(Boolean)res;

@end
