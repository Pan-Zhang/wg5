//
//  GsmSMSview.h
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSMUserInfo.h"

@interface GsmSMSview : UIView
@property(nonatomic,strong)GSMUserInfo *userInfo;
@property(nonatomic,copy) void(^clickInquireBtn)(void);
@property(nonatomic,copy) void(^clickSaveBtn)(NSString *ArmSmsNotice,NSString *DisarmSmsNotice,NSString *HomeSmsNotice);

@end
