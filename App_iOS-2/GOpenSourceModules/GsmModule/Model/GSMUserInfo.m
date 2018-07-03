//
//  GSMUserInfo.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/12.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMUserInfo.h"

@implementation GSMUserInfo
-(NSString *)A_D_H_Settings{
    if (_A_D_H_Settings == nil) {
        _A_D_H_Settings = @"3";
    }
    return _A_D_H_Settings;
}

-(NSString *)smsswitch{
    if (_smsswitch == nil) {
        _smsswitch = @"0";
    }
    return _smsswitch;
}

-(NSString *)armingTime{
    if (_armingTime == nil) {
        _armingTime = @"0";
    }
    return _armingTime;
}

-(NSString *)policeTime{
    if (_policeTime == nil) {
        _policeTime = @"0";
    }
    return _policeTime;
}

-(NSString *)ArmSmsNotice{
    if (_ArmSmsNotice == nil) {
        _ArmSmsNotice = @"0";
    }
    return _ArmSmsNotice;
}

-(NSString *)isLog{
    if (_isLog == nil) {
        _isLog = @"0";
    }
    return _isLog;
}

-(NSString *)DisarmSmsNotice{
    if (_DisarmSmsNotice == nil) {
        _DisarmSmsNotice = @"0";
    }
    return _DisarmSmsNotice;
}

-(NSString *)HomeSmsNotice{
    if (_HomeSmsNotice == nil) {
        _HomeSmsNotice = @"0";
    }
    return _HomeSmsNotice;
}

-(NSMutableArray *)smartSwitchArray{
    if (_smartSwitchArray == nil) {
        _smartSwitchArray = [NSMutableArray array];
        for (int i = 0; i < 20; i ++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSString *switchID;
            if ([NSString stringWithFormat:@"%d",i].length == 1) {
                switchID = [NSString stringWithFormat:@"0%d",i+1];
            }else{
                switchID = [NSString stringWithFormat:@"%d",i+1];
            }
            [dic setObject:switchID forKey:@"switchID"];//开关ID
            [dic setObject:[NSString stringWithFormat:@"Outlet%d",i+1] forKey:@"switchName"];//开关名称
            [dic setObject:@"0" forKey:@"switchStatus"];//开关状态
            
            [_smartSwitchArray addObject:dic];
        }
    }
    return _smartSwitchArray;
}

-(NSMutableArray *)policeArray{
    if (_policeArray == nil) {
        _policeArray = [NSMutableArray array];
        for (int i = 0; i < 8; i ++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"switchID"];//开关ID
//            [dic setObject:[NSString stringWithFormat:@"第%d组",i+1] forKey:@"switchName"];//开关名称
            [dic setObject:[NSString stringWithFormat:@"%d%@",i+1,NSLocalizedString(@"GP", nil)] forKey:@"switchName"];
            [dic setObject:@"0" forKey:@"0"];//开关状态
            [dic setObject:@"0" forKey:@"1"];
            [dic setObject:@"0" forKey:@"2"];
            [dic setObject:@"电话号码" forKey:@"phone"];
            [_policeArray addObject:dic];
        }
    }
    return _policeArray;
}

-(NSMutableArray *)scheduledArmingArray{
    if (_scheduledArmingArray == nil) {
        _scheduledArmingArray = [NSMutableArray array];
        for (int i = 0; i < 8; i ++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"switchID"];//开关ID
            [dic setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"switchName"];//开关名称
            [dic setObject:@"0" forKey:@"switchStatus"];//开关状态
            [dic setObject:@"0" forKey:@"hour"];//小时
            [dic setObject:@"0" forKey:@"minute"];
            [dic setObject:@"0" forKey:@"status"];//布撤防状态
            //重复状态
            [dic setObject:@"0" forKey:@"1"];
            [dic setObject:@"0" forKey:@"2"];
            [dic setObject:@"0" forKey:@"3"];
            [dic setObject:@"0" forKey:@"4"];
            [dic setObject:@"0" forKey:@"5"];
            [dic setObject:@"0" forKey:@"6"];
            [dic setObject:@"0" forKey:@"7"];
            [_scheduledArmingArray addObject:dic];
        }
    }
    return _scheduledArmingArray;
}

-(NSMutableArray *)applianceTimingArray{
    if (_applianceTimingArray == nil) {
        _applianceTimingArray = [NSMutableArray array];
        for (int i = 0; i < 40; i ++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"switchID"];//开关ID
            [dic setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"switchName"];//开关名称
            [dic setObject:@"0" forKey:@"socketID"];//插座ID
            [dic setObject:@"0" forKey:@"switchStatus"];//开关状态
            [dic setObject:@"0" forKey:@"hour"];//小时
            [dic setObject:@"0" forKey:@"minute"];
            [dic setObject:@"0" forKey:@"status"];//状态：定时开、定时关
            //重复状态
            [dic setObject:@"0" forKey:@"1"];
            [dic setObject:@"0" forKey:@"2"];
            [dic setObject:@"0" forKey:@"3"];
            [dic setObject:@"0" forKey:@"4"];
            [dic setObject:@"0" forKey:@"5"];
            [dic setObject:@"0" forKey:@"6"];
            [dic setObject:@"0" forKey:@"7"];
            [_applianceTimingArray addObject:dic];
        }
    }
    return _applianceTimingArray;
}

+(void)storageUserInfoWithUserInfo:(GSMUserInfo *)userInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *userInfoArray  = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"USERINFO"]];
//    NSString *filePathName = [[NSBundle mainBundle] pathForResource:@"/UserInfo" ofType:@"plist"];
//    NSArray *plistArray = [NSArray arrayWithContentsOfFile:filePathName];
//    NSMutableArray *userInfoArray = [NSMutableArray arrayWithArray:plistArray];
    if (userInfoArray.count == 0) {
        userInfoArray = [NSMutableArray array];
        NSMutableDictionary *userdic = [self returnUserInfoDictionaryWithUserInfo:userInfo];
        [userInfoArray addObject:userdic];
    }else{
        BOOL isADD = YES;
        for (int i = 0; i < userInfoArray.count; i++) {
            NSMutableDictionary *userdic = [NSMutableDictionary dictionaryWithDictionary:[userInfoArray objectAtIndex:i]];
            if ([[userdic objectForKey:@"userName"] isEqualToString:userInfo.userName]) {
                NSMutableDictionary *userdic = [self returnUserInfoDictionaryWithUserInfo:userInfo];
                [userInfoArray replaceObjectAtIndex:i  withObject:userdic];
                isADD = NO;
            }
        }
        if (isADD) {
            NSMutableDictionary *userdic = [self returnUserInfoDictionaryWithUserInfo:userInfo];
            [userInfoArray addObject:userdic];
        }
    }
    NSArray *arr = [NSArray arrayWithArray:userInfoArray];
//    NSURL *fileUrl = [NSURL fileURLWithPath:filePathName];
//    [arr writeToURL:fileUrl atomically:YES];
    [userDefaults setObject:arr forKey:@"USERINFO"];
    [userDefaults synchronize];
}

+(GSMUserInfo *)retunUserInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *userInfoArray  = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"USERINFO"]];
//    NSString *filePathName = [[NSBundle mainBundle] pathForResource:@"/UserInfo" ofType:@"plist"];
//    NSArray *plistArray = [NSArray arrayWithContentsOfFile:filePathName];
//    NSMutableArray *userInfoArray = [NSMutableArray arrayWithArray:plistArray];
    GSMUserInfo *uf;
    for (int i = 0; i < userInfoArray.count; i++) {
        NSMutableDictionary *userdic = [NSMutableDictionary dictionaryWithDictionary:[userInfoArray objectAtIndex:i]];
        if ([[userdic objectForKey:@"isLog"]  isEqualToString:@"1"]) {
            uf = [self returnGSMUserInfoWithDic:userdic];
        }
    }
    return uf;
}

+(GSMUserInfo *)retunUserInfoWithUserName:(NSString *)userName{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *userInfoArray  = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"USERINFO"]];
//    NSString *filePathName = [[NSBundle mainBundle] pathForResource:@"/UserInfo" ofType:@"plist"];
//    NSArray *plistArray = [NSArray arrayWithContentsOfFile:filePathName];
//    NSMutableArray *userInfoArray = [NSMutableArray arrayWithArray:plistArray];
    GSMUserInfo *uf;
    for (int i = 0; i < userInfoArray.count; i++) {
         NSMutableDictionary *userdic = [NSMutableDictionary dictionaryWithDictionary:[userInfoArray objectAtIndex:i]];
        if ([[userdic objectForKey:@"userName"] isEqualToString:userName]) {
            uf = [self returnGSMUserInfoWithDic:userdic];
        }
    }
    return uf;
}

+(NSMutableArray *)returnUserArray{
    NSMutableArray *array = [NSMutableArray array];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *userInfoArray  = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"USERINFO"]];
//    NSString *filePathName = [[NSBundle mainBundle] pathForResource:@"/UserInfo" ofType:@"plist"];
//    NSArray *plistArray = [NSArray arrayWithContentsOfFile:filePathName];
//    NSMutableArray *userInfoArray = [NSMutableArray arrayWithArray:plistArray];
    for (int i = 0; i < userInfoArray.count; i++) {
        NSMutableDictionary *userdic = [NSMutableDictionary dictionaryWithDictionary:[userInfoArray objectAtIndex:i]];
        GSMUserInfo *userinfo = [self returnGSMUserInfoWithDic:userdic];
        [array addObject:userinfo];
    }
    return array;
}

+(NSMutableDictionary *)returnUserInfoDictionaryWithUserInfo:(GSMUserInfo *)userInfo{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userInfo.userName forKey:@"userName"];
    [dic setObject:userInfo.hostNumber forKey:@"hostNumber"];
    [dic setObject:userInfo.password forKey:@"password"];
    [dic setObject:userInfo.isLog forKey:@"isLog"];
    [dic setObject:userInfo.armingTime forKey:@"armingTime"];
    [dic setObject:userInfo.policeTime forKey:@"policeTime"];
    [dic setObject:userInfo.smsswitch forKey:@"smsswitch"];
    [dic setObject:userInfo.ArmSmsNotice forKey:@"ArmSmsNotice"];
    [dic setObject:userInfo.DisarmSmsNotice forKey:@"DisarmSmsNotice"];
    [dic setObject:userInfo.HomeSmsNotice forKey:@"HomeSmsNotice"];
    [dic setObject:userInfo.A_D_H_Settings forKey:@"A_D_H_Settings"];
    [dic setObject:userInfo.smartSwitchArray forKey:@"smartSwitchArray"];
    [dic setObject:userInfo.policeArray forKey:@"policeArray"];
    [dic setObject:userInfo.scheduledArmingArray forKey:@"scheduledArmingArray"];
    [dic setObject:userInfo.applianceTimingArray forKey:@"applianceTimingArray"];
    return dic;
}

+(GSMUserInfo *)returnGSMUserInfoWithDic:(NSMutableDictionary *)dic{
    GSMUserInfo *userInfo = [[GSMUserInfo alloc]init];
    userInfo.userName =  [dic objectForKey:@"userName"];
    userInfo.hostNumber =  [dic objectForKey:@"hostNumber"];
    userInfo.password = [dic objectForKey:@"password"];
    userInfo.isLog = [dic objectForKey:@"isLog"];
    userInfo.armingTime = [dic objectForKey:@"armingTime"];
    userInfo.policeTime = [dic objectForKey:@"policeTime"];
    userInfo.smsswitch = [dic objectForKey:@"smsswitch"];
    userInfo.ArmSmsNotice = [dic objectForKey:@"ArmSmsNotice"];
    userInfo.DisarmSmsNotice = [dic objectForKey:@"DisarmSmsNotice"];
    userInfo.HomeSmsNotice = [dic objectForKey:@"HomeSmsNotice"];
    userInfo.A_D_H_Settings = [dic objectForKey:@"A_D_H_Settings"];
    userInfo.smartSwitchArray = [dic objectForKey:@"smartSwitchArray"];
    userInfo.policeArray = [dic objectForKey:@"policeArray"];
    userInfo.scheduledArmingArray = [dic objectForKey:@"scheduledArmingArray"];
    userInfo.applianceTimingArray = [dic objectForKey:@"applianceTimingArray"];
    return userInfo;
}


@end
