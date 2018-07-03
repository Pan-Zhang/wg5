//
//  GSMMenuView.h
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/10.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSMUserInfo.h"

@interface GSMMenuView : UIView
@property(nonatomic,strong)GSMUserInfo *userInfo;
@property(nonatomic,copy)void (^clickRemove)(void);
@property(nonatomic,copy)void(^clickSwitchUsersButton)(void);
@property(nonatomic,copy)void(^clickOnWeButton)(void);
@property(nonatomic,copy)void(^clickSignOutButton)(void);
@end
