//
//  GsmViewController.h
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/5/11.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSMSmsViewController.h"
#import "GSMUserInfo.h"

@interface GsmViewController : GSMSmsViewController
@property(nonatomic,strong)GSMUserInfo *userInfo;

@end
