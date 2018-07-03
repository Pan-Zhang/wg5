//
//  SmartSocketTime.h
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmartSocketTime : NSObject

@property(nonatomic, assign) BOOL isValid;
@property(nonatomic, assign) BOOL onOff;
@property(nonatomic, assign) int number;
@property(nonatomic, assign) BOOL monday;
@property(nonatomic, assign) BOOL tuesday;
@property(nonatomic, assign) BOOL wednesday;
@property(nonatomic, assign) BOOL thursday;
@property(nonatomic, assign) BOOL friday;
@property(nonatomic, assign) BOOL saturday;
@property(nonatomic, assign) BOOL sunday;
@property(nonatomic, assign) int socket_num;
@property(nonatomic, assign) int hour;
@property(nonatomic, assign) int minute;

@end
