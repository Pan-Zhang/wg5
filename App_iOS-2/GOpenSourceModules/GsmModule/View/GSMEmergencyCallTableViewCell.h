//
//  GSMEmergencyCallTableViewCell.h
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSMEmergencyCallTableViewCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,copy)void (^clickInquireButton)(void);
@property(nonatomic,copy)void (^clickSaveButton)(void);

@end
