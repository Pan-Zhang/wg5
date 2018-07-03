//
//  GSMApplianceTimingTableViewCell.h
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSMApplianceTimingTableViewCell : UITableViewCell
@property(nonatomic,strong)NSMutableDictionary *dic;
@property(nonatomic,copy)void(^clickInquireBtn)(void);
@property(nonatomic,copy)void(^clickSwitch)(NSMutableDictionary *dic);

@end
