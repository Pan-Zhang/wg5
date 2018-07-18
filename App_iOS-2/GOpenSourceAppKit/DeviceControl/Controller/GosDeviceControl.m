//
//  GosDeviceControl.m
//  GOpenSource_AppKit
//
//  Created by danly on 2017/2/16.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import "GosDeviceControl.h"
#import "NSString+HexToBytes.h"

@interface GosDeviceControl()<GizWifiDeviceDelegate>

@end

@implementation GosDeviceControl

+ (instancetype)sharedInstance
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone: zone];
    });
    
    return instance;
}

#pragma mark - write Action
/**
 *  写数据点的值到设备
 *
 *  @param dataPoint 标识数据点的枚举值
 *  @param value     数据点值
 */
- (void)writeDataPoint:(GosDeviceDataPoint)dataPoint value:(id)value
{
    NSDictionary *data = nil;
    switch (dataPoint) {
        case GosDevice_Outlet1:
        {
            self.key_Outlet1 = [value boolValue];
            data = @{Data__Attr_Outlet1: value};
            break;
        }
        case GosDevice_Outlet2:
        {
            self.key_Outlet2 = [value boolValue];
            data = @{Data__Attr_Outlet2: value};
            break;
        }
        case GosDevice_Outlet3:
        {
            self.key_Outlet3 = [value boolValue];
            data = @{Data__Attr_Outlet3: value};
            break;
        }
        case GosDevice_Outlet4:
        {
            self.key_Outlet4 = [value boolValue];
            data = @{Data__Attr_Outlet4: value};
            break;
        }
        case GosDevice_Outlet5:
        {
            self.key_Outlet5 = [value boolValue];
            data = @{Data__Attr_Outlet5: value};
            break;
        }
        case GosDevice_Outlet6:
        {
            self.key_Outlet6 = [value boolValue];
            data = @{Data__Attr_Outlet6: value};
            break;
        }
        case GosDevice_Outlet7:
        {
            self.key_Outlet7 = [value boolValue];
            data = @{Data__Attr_Outlet7: value};
            break;
        }
        case GosDevice_Outlet8:
        {
            self.key_Outlet8 = [value boolValue];
            data = @{Data__Attr_Outlet8: value};
            break;
        }
        case GosDevice_Outlet9:
        {
            self.key_Outlet9 = [value boolValue];
            data = @{Data__Attr_Outlet9: value};
            break;
        }
        case GosDevice_Outlet10:
        {
            self.key_Outlet10 = [value boolValue];
            data = @{Data__Attr_Outlet10: value};
            break;
        }
        case GosDevice_Outlet11:
        {
            self.key_Outlet11 = [value boolValue];
            data = @{Data__Attr_Outlet11: value};
            break;
        }
        case GosDevice_Outlet12:
        {
            self.key_Outlet12 = [value boolValue];
            data = @{Data__Attr_Outlet12: value};
            break;
        }
        case GosDevice_Outlet13:
        {
            self.key_Outlet13 = [value boolValue];
            data = @{Data__Attr_Outlet13: value};
            break;
        }
        case GosDevice_Outlet14:
        {
            self.key_Outlet14 = [value boolValue];
            data = @{Data__Attr_Outlet14: value};
            break;
        }
        case GosDevice_Outlet15:
        {
            self.key_Outlet15 = [value boolValue];
            data = @{Data__Attr_Outlet15: value};
            break;
        }
        case GosDevice_Outlet16:
        {
            self.key_Outlet16 = [value boolValue];
            data = @{Data__Attr_Outlet16: value};
            break;
        }
        case GosDevice_Outlet17:
        {
            self.key_Outlet17 = [value boolValue];
            data = @{Data__Attr_Outlet17: value};
            break;
        }
        case GosDevice_Outlet18:
        {
            self.key_Outlet18 = [value boolValue];
            data = @{Data__Attr_Outlet18: value};
            break;
        }
        case GosDevice_Outlet19:
        {
            self.key_Outlet19 = [value boolValue];
            data = @{Data__Attr_Outlet19: value};
            break;
        }
        case GosDevice_Outlet20:
        {
            self.key_Outlet20 = [value boolValue];
            data = @{Data__Attr_Outlet20: value};
            break;
        }
        case GosDevice_ZoneStatus:
        {
            self.key_ZoneStatus = [value integerValue];
            data = @{Data__Attr_ZoneStatus: value};
            break;
        }
        default:
            NSLog(@"Error: write invalid datapoint, skip.");
            return;
    }
    NSLog(@"Write data: %@", data);
    [self.device write:data withSN:0];
}

#pragma mark - read Action
/**
 *  从数据点集合中获取数据点的值
 *
 *  @param dataMap 数据点集合
 */
- (void)readDataPointsFromData:(NSDictionary *)dataMap
{
    // 读取普通数据点的值
    NSDictionary *data = [dataMap valueForKey:@"data"];
    [self readDataPoint:GosDevice_Outlet1 data:data];
    [self readDataPoint:GosDevice_Outlet2 data:data];
    [self readDataPoint:GosDevice_Outlet3 data:data];
    [self readDataPoint:GosDevice_Outlet4 data:data];
    [self readDataPoint:GosDevice_Outlet5 data:data];
    [self readDataPoint:GosDevice_Outlet6 data:data];
    [self readDataPoint:GosDevice_Outlet7 data:data];
    [self readDataPoint:GosDevice_Outlet8 data:data];
    [self readDataPoint:GosDevice_Outlet9 data:data];
    [self readDataPoint:GosDevice_Outlet10 data:data];
    [self readDataPoint:GosDevice_Outlet11 data:data];
    [self readDataPoint:GosDevice_Outlet12 data:data];
    [self readDataPoint:GosDevice_Outlet13 data:data];
    [self readDataPoint:GosDevice_Outlet14 data:data];
    [self readDataPoint:GosDevice_Outlet15 data:data];
    [self readDataPoint:GosDevice_Outlet16 data:data];
    [self readDataPoint:GosDevice_Outlet17 data:data];
    [self readDataPoint:GosDevice_Outlet18 data:data];
    [self readDataPoint:GosDevice_Outlet19 data:data];
    [self readDataPoint:GosDevice_Outlet20 data:data];
    [self readDataPoint:GosDevice_ZoneStatus data:data];
    [self readDataPoint:GosDevice_AlarmZone data:data];

    // 读取故障报警数据点的值
    NSDictionary *alerts = [dataMap valueForKey:@"alerts"];
    [self readDataPoint:GosDevice_Alarm data:alerts];
}


/**
 *  获取普通数据点的各个数据点值
 *
 *  @param data 普通数据点集合
 */
- (void)readDataPoint:(GosDeviceDataPoint)dataPoint data:(NSDictionary *)data
{
    if(![data isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Error: could not read data, error data format.");
        return;
    }
    switch (dataPoint) {
        case GosDevice_Outlet1:
        {
            if([data valueForKey:Data__Attr_Outlet1]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet1];
                self.key_Outlet1 = dataPointStr.boolValue;
            }
            break;
        }
        case GosDevice_Outlet2:
        {
            if([data valueForKey:Data__Attr_Outlet2]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet2];
                self.key_Outlet2 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet3:
        {
            if([data valueForKey:Data__Attr_Outlet3]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet3];
                self.key_Outlet3 = dataPointStr.boolValue;
            }
           
            break;
        }
        case GosDevice_Outlet4:
        {
            if([data valueForKey:Data__Attr_Outlet4]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet4];
                self.key_Outlet4 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet5:
        {
            if([data valueForKey:Data__Attr_Outlet5]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet5];
                self.key_Outlet5 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet6:
        {
            if([data valueForKey:Data__Attr_Outlet6]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet6];
                self.key_Outlet6 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet7:
        {
            if([data valueForKey:Data__Attr_Outlet7]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet7];
                self.key_Outlet7 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet8:
        {
            if([data valueForKey:Data__Attr_Outlet8]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet8];
                self.key_Outlet8 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet9:
        {
            if([data valueForKey:Data__Attr_Outlet9]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet9];
                self.key_Outlet9 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet10:
        {
            if([data valueForKey:Data__Attr_Outlet10]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet10];
                self.key_Outlet10 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet11:
        {
            if([data valueForKey:Data__Attr_Outlet11]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet11];
                self.key_Outlet11 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet12:
        {
            if([data valueForKey:Data__Attr_Outlet12]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet12];
                self.key_Outlet12 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet13:
        {
            if([data valueForKey:Data__Attr_Outlet13]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet13];
                self.key_Outlet13 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet14:
        {
            if([data valueForKey:Data__Attr_Outlet14]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet14];
                self.key_Outlet14 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet15:
        {
            if([data valueForKey:Data__Attr_Outlet15]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet15];
                self.key_Outlet15 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet16:
        {
            if([data valueForKey:Data__Attr_Outlet16]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet16];
                self.key_Outlet16 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet17:
        {
            if([data valueForKey:Data__Attr_Outlet17]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet17];
                self.key_Outlet17 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet18:
        {
            if([data valueForKey:Data__Attr_Outlet18]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet18];
                self.key_Outlet18 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet19:
        {
            if([data valueForKey:Data__Attr_Outlet19]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet19];
                self.key_Outlet19 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_Outlet20:
        {
            if([data valueForKey:Data__Attr_Outlet20]!=nil){
                NSString *dataPointStr = [data valueForKey:Data__Attr_Outlet20];
                self.key_Outlet20 = dataPointStr.boolValue;
            }
            
            break;
        }
        case GosDevice_ZoneStatus:
        {
            NSString *dataPointStr = [data valueForKey:Data__Attr_ZoneStatus];
            self.key_ZoneStatus = dataPointStr.integerValue;
            break;
        }
        case GosDevice_AlarmZone:
        {
            NSString *dataPointStr = [data valueForKey:Data__Attr_AlarmZone];
            self.key_AlarmZone = dataPointStr.integerValue;
            break;
        }
        default:
            NSLog(@"Error: read invalid datapoint, skip.");
            break;
    }
}
    
/**
 *  获取报警数据点的各个数据点值
 *
 *  @param faults 报警数据点集合
 */
- (void)readAlterDataPoint:(GosDeviceDataPoint)dataPoint alters:(NSDictionary *)alters
{
    if(![alters isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Error: could not read data, error data format.");
        return;
    }
    switch (dataPoint)
    {
        case GosDevice_Alarm:
        {
            NSString *dataPointStr = [alters valueForKey:Data__Attr_Alarm];
            self.key_Alarm = dataPointStr.boolValue;
            break;
        }
        default:
            NSLog(@"Error: read invalid datapoint, skip.");
            break;
    }
}

/**
 *  初始化设备  ，即将设备的值都设为默认值
 */
- (void)initDevice
{
    // 重新设置设备
    self.key_Alarm = NO;
    self.key_Outlet1 = NO;
    self.key_Outlet2 = NO;
    self.key_Outlet3 = NO;
    self.key_Outlet4 = NO;
    self.key_Outlet5 = NO;
    self.key_Outlet6 = NO;
    self.key_Outlet7 = NO;
    self.key_Outlet8 = NO;
    self.key_Outlet9 = NO;
    self.key_Outlet10 = NO;
    self.key_Outlet11 = NO;
    self.key_Outlet12 = NO;
    self.key_Outlet13 = NO;
    self.key_Outlet14 = NO;
    self.key_Outlet15 = NO;
    self.key_Outlet16 = NO;
    self.key_Outlet17 = NO;
    self.key_Outlet18 = NO;
    self.key_Outlet19 = NO;
    self.key_Outlet20 = NO;
    self.key_ZoneStatus = 0;
    self.key_AlarmZone = 0;
}

@end