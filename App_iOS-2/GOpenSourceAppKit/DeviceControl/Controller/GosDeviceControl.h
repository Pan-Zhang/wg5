//
//  GosDeviceControl.h
//  GOpenSource_AppKit
//
//  Created by danly on 2017/2/16.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

// 设备收发数据的工具类
#import <UIKit/UIKit.h>
#import <GizWifiSDK/GizWifiDevice.h>

// 数据点标识符
#define Data__Attr_Alarm @"Alarm"
#define Data__Attr_Outlet1 @"Outlet1"
#define Data__Attr_Outlet2 @"Outlet2"
#define Data__Attr_Outlet3 @"Outlet3"
#define Data__Attr_Outlet4 @"Outlet4"
#define Data__Attr_Outlet5 @"Outlet5"
#define Data__Attr_Outlet6 @"Outlet6"
#define Data__Attr_Outlet7 @"Outlet7"
#define Data__Attr_Outlet8 @"Outlet8"
#define Data__Attr_Outlet9 @"Outlet9"
#define Data__Attr_Outlet10 @"Outlet10"
#define Data__Attr_Outlet11 @"Outlet11"
#define Data__Attr_Outlet12 @"Outlet12"
#define Data__Attr_Outlet13 @"Outlet13"
#define Data__Attr_Outlet14 @"Outlet14"
#define Data__Attr_Outlet15 @"Outlet15"
#define Data__Attr_Outlet16 @"Outlet16"
#define Data__Attr_Outlet17 @"Outlet17"
#define Data__Attr_Outlet18 @"Outlet18"
#define Data__Attr_Outlet19 @"Outlet19"
#define Data__Attr_Outlet20 @"Outlet20"
#define Data__Attr_ZoneStatus @"ZoneStatus"
#define Data__Attr_AlarmZone @"AlarmZone"

// 标识各个数据点的枚举值
typedef enum
{
    GosDevice_Alarm,
    GosDevice_Outlet1,
    GosDevice_Outlet2,
    GosDevice_Outlet3,
    GosDevice_Outlet4,
    GosDevice_Outlet5,
    GosDevice_Outlet6,
    GosDevice_Outlet7,
    GosDevice_Outlet8,
    GosDevice_Outlet9,
    GosDevice_Outlet10,
    GosDevice_Outlet11,
    GosDevice_Outlet12,
    GosDevice_Outlet13,
    GosDevice_Outlet14,
    GosDevice_Outlet15,
    GosDevice_Outlet16,
    GosDevice_Outlet17,
    GosDevice_Outlet18,
    GosDevice_Outlet19,
    GosDevice_Outlet20,
    GosDevice_ZoneStatus,
    GosDevice_AlarmZone,
}GosDeviceDataPoint;

// 设备控制类
@interface GosDeviceControl : NSObject

// 以下是存储各个数据点值的属性
@property (nonatomic, assign) BOOL key_Alarm;
@property (nonatomic, assign) BOOL key_Outlet1;
@property (nonatomic, assign) BOOL key_Outlet2;
@property (nonatomic, assign) BOOL key_Outlet3;
@property (nonatomic, assign) BOOL key_Outlet4;
@property (nonatomic, assign) BOOL key_Outlet5;
@property (nonatomic, assign) BOOL key_Outlet6;
@property (nonatomic, assign) BOOL key_Outlet7;
@property (nonatomic, assign) BOOL key_Outlet8;
@property (nonatomic, assign) BOOL key_Outlet9;
@property (nonatomic, assign) BOOL key_Outlet10;
@property (nonatomic, assign) BOOL key_Outlet11;
@property (nonatomic, assign) BOOL key_Outlet12;
@property (nonatomic, assign) BOOL key_Outlet13;
@property (nonatomic, assign) BOOL key_Outlet14;
@property (nonatomic, assign) BOOL key_Outlet15;
@property (nonatomic, assign) BOOL key_Outlet16;
@property (nonatomic, assign) BOOL key_Outlet17;
@property (nonatomic, assign) BOOL key_Outlet18;
@property (nonatomic, assign) BOOL key_Outlet19;
@property (nonatomic, assign) BOOL key_Outlet20;
@property (nonatomic, assign) NSInteger key_ZoneStatus;
@property (nonatomic, assign) NSInteger key_AlarmZone;

@property (nonatomic, assign) BOOL isFirstView;

// 设备
@property (nonatomic, strong)  GizWifiDevice *device;

+ (instancetype)sharedInstance;

/**
 *  初始化设备  ，即将设备的值都设为默认值
 */
- (void)initDevice;

/**
 *  写数据点的值到设备
 *
 *  @param dataPoint 标识数据点的枚举值
 *  @param value     数据点值
 */
- (void)writeDataPoint:(GosDeviceDataPoint)dataPoint value:(id)value;

/**
 *  从数据点集合中获取数据点的值
 *
 *  @param dataMap 数据点集合
 */
- (void)readDataPointsFromData:(NSDictionary *)dataMap;


@end