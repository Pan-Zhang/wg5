//
//  GsmReplyView.h
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSMUserInfo.h"

@interface GsmReplyView : UIView
@property(nonatomic,copy)void (^clilkDetermine)(NSString *status);
@property(nonatomic,strong)GSMUserInfo *userInfo;

@end
