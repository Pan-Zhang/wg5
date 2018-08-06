//
//  GSMUserInfo.h
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/12.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSMUserInfo : NSObject
@property(nonatomic,strong)NSString *userName;//用户名
@property(nonatomic,strong)NSString *hostNumber;//主机号
@property(nonatomic,strong)NSString *password;//密码

@property(nonatomic,strong)NSString *isLog;//是否是当前登录

@property(nonatomic,strong)NSString *armingTime;//延时布防时间
@property(nonatomic,strong)NSString *policeTime;//延时报警时间

@property(nonatomic,strong)NSString *smsswitch;//短信回复开关 0:关 1:开

@property(nonatomic,strong)NSString *ArmSmsNotice;//布防短信通知 0:关 1:开
@property(nonatomic,strong)NSString *DisarmSmsNotice;//撤防短信通知 0:关 1:开
@property(nonatomic,strong)NSString *HomeSmsNotice;//留守短信通知 0:关 1:开

@property(nonatomic,strong)NSString *A_D_H_Settings;//撤防（0）、布防（1）、留守（2）//未设置（3）


@property(nonatomic,strong)NSMutableArray *smartSwitchArray;//智能开关组

@property(nonatomic,strong)NSMutableArray *policeArray;//报警电话组

@property(nonatomic,strong)NSMutableArray *scheduledArmingArray;//定时布撤防

@property(nonatomic,strong)NSMutableArray *applianceTimingArray;//定时布撤防

//保存数据
+(void)storageUserInfoWithUserInfo:(GSMUserInfo *)userInfo;
//返回登陆的用户
+(GSMUserInfo *)retunUserInfo;
//根据用户名返回一个用户
+(GSMUserInfo *)retunUserInfoWithUserName:(NSString *)userName;

//返回所有的用户
+(NSMutableArray *)returnUserArray;

+(NSMutableDictionary *)returnUserInfoDictionaryWithUserInfo:(GSMUserInfo *)userInfo;
+(GSMUserInfo *)returnGSMUserInfoWithDic:(NSMutableDictionary *)dic;

//删除用户：根据用户名
+(void)deleteUserWithUserName:(NSString *)userName;
@end
