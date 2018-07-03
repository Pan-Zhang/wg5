//
//  SetPhoneViewController.h
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/4/3.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmCall.h"
#import <GizWifiSDK/GizWifiDevice.h>

@interface SetPhoneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *input;
@property (weak, nonatomic) IBOutlet UITextField *edit_text;
@property (weak, nonatomic) IBOutlet UILabel *call;
@property (weak, nonatomic) IBOutlet UIButton *call_btn;
@property (weak, nonatomic) IBOutlet UILabel *rfid;
@property (weak, nonatomic) IBOutlet UIButton *rfid_btn;
@property (weak, nonatomic) IBOutlet UILabel *sms;
@property (weak, nonatomic) IBOutlet UIButton *sms_btn;

@property (assign, nonatomic) int type;

@property (assign, nonatomic) NSInteger length;

@property (strong, nonatomic) AlarmCall *alarmCall;

@property(nonatomic, weak) GizWifiDevice *device;

- (void)hideSelf:(Boolean)res;

@end
