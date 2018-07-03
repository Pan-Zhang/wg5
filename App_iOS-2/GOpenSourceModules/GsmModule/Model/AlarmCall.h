//
//  AlarmCall.h
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmCall : NSObject

@property(nonatomic, assign)BOOL callEnable;
@property(nonatomic, assign)BOOL smsEnable;
@property(nonatomic, assign)BOOL rfidEnable;
@property(nonatomic, assign)int numLength;
@property(nonatomic, assign)int index;
@property(nonatomic, strong)NSMutableArray *number;

- (NSString *)getNumber;

@end
