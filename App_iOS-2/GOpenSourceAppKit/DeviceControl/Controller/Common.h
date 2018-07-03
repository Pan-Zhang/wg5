//
//  Common.h
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string;

// 十六进制转换为普通字符串的。
+ (NSString *)convertHexStrToString:(NSString *)hexString;

// 十六进制转二进制
+(NSString *)getBinaryByhex:(NSString *)hex;

//十进制转十六进制
+ (NSString *)ToHex:(uint16_t)tmpid;

//十六进制简单算术和
+ (NSString *)hexsumstring:(NSString *)string;

//十进制转二进制
+ (NSString *)toBinarySystemWithDecimalSystem:(NSInteger)decimal;

//  二进制转十进制
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary;

/**
 二进制转换成十六进制
 
 @param binary 二进制数
 @return 十六进制数
 */
+ (NSString *)getHexByBinary:(NSString *)binary;

@end
