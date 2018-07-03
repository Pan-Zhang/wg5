//
//  GSMScheduledArmingCell.h
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/11.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSMScheduledArmingCell : UITableViewCell
@property(nonatomic,copy)void(^clickInquireBtn)(void);
@property(nonatomic,copy)void(^clickSwitch)(NSString *status);
@property(nonatomic,strong)NSMutableDictionary *dic;

@end
