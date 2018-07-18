//
//  AlarmDisarmRecord.m
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "AlarmDisarmRecord.h"

@implementation AlarmDisarmRecord

- (NSString *)getReason{
    if(_reason<100){
        _reasonStr = [@"Remote " stringByAppendingString:[NSString stringWithFormat:@"%d", _reason]];
    }
    else if(_reason==125){
        _reasonStr = @"Keypad";
    }
    else if(_reason==126){
        _reasonStr = @"Auto";
    }
    else if(_reason==127){
        _reasonStr = @"App";
    }
    else if(_reason>127 && _reason<149){
        _reasonStr = [@"RFID " stringByAppendingString:[NSString stringWithFormat:@"%d", _reason-128]];
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

- (NSString *)getType{
    switch (_type){
        case 0:
        _typeStr = @"Disarming";
        break;
        
        case 1:
        _typeStr = @"Arming";
        break;
        
        case 2:
        _typeStr = @"HomeArming";
        break;
    }
    return _typeStr;
}

@end
