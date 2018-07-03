//
//  AlarmRecord.h
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmRecord : NSObject

@property(nonatomic, assign)long time;
@property(nonatomic, assign)int reason;
@property(nonatomic, copy)NSString *timeStr;
@property(nonatomic, copy)NSString *reasonStr;

- (NSString *)getReason;

- (NSString *)getTime;

@end
