//
//  AlarmCall.m
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "AlarmCall.h"

@implementation AlarmCall

-(NSString *)getNumber{
    NSString *str = @"";
    for(int i=0; i<_numLength; i++){
        str = [str stringByAppendingString:_number[i]];
    }
    return str;
}

@end
