//
//  AlarmRecord.m
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "AlarmRecord.h"

@implementation AlarmRecord

- (NSString *)getReason{
    if(_reason<100){
        _reasonStr = [[NSString stringWithFormat:@"%d", _reason] stringByAppendingString:@" Zone"];
    }
    else if(_reason==124){
        _reasonStr = @"Panel Battery Low";
    }
    else if(_reason==125){
        _reasonStr = @"Panel Power Off";
    }
    else if(_reason==126){
        _reasonStr = @"Panel Power On";
    }
    else if(_reason==127){
        _reasonStr = @"Panel Alarm";
    }
    else if(_reason>127 && _reason<228){
        _reasonStr = [[NSString stringWithFormat:@"%d", _reason] stringByAppendingString:@" Remote"];
    }
    return _reasonStr;
}

- (NSString *)getTime{
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:_time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    _timeStr = [formatter stringFromDate:d];
    
    return _timeStr;
}

@end
