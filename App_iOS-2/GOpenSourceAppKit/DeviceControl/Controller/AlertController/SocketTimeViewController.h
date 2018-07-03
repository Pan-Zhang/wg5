//
//  SocketTimeViewController.h
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetTimeViewController.h"
#import <GizWifiSDK/GizWifiDevice.h>

@interface SocketTimeViewController : UIViewController

@property(nonatomic, strong) UITableView *myTableView;

@property(nonatomic, strong) NSMutableArray *timeArray;

@property(nonatomic, weak) GizWifiDevice *device;

- (void)setTimeArray:(NSMutableArray *)timeArray;

- (void)refreshView;

- (void)hideChild:(Boolean)res;

@property(nonatomic, weak)SetTimeViewController *setTimeViewController;

@end
