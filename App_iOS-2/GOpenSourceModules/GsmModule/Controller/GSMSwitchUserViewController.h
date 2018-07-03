//
//  GSMSwitchUserViewController.h
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/11.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSMUserInfo.h"
@interface GSMSwitchUserViewController : UIViewController
@property(nonatomic,copy)void(^clickOtherUser)(GSMUserInfo *userinfo);
@property(nonatomic,strong)GSMUserInfo *userInfo;
@end
