//
//  AlarmPhoneViewController.h
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GizWifiSDK/GizWifiDevice.h>
#import "SetPhoneViewController.h"

@interface AlarmPhoneViewController : UIViewController

@property(nonatomic, strong) UITableView *myTableView;

@property(nonatomic, strong) NSMutableArray *callArray;

- (void)setTimeArray:(NSMutableArray *)callArray;

@property(nonatomic, weak) GizWifiDevice *device;

@property(nonatomic, weak) SetPhoneViewController *setPhoneViewController;

- (void)refreshView;

- (void)hideChild:(Boolean)res;

@end
