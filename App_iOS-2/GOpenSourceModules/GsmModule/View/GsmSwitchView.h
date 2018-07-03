//
//  GsmSwitchView.h
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GsmSwitchView : UIView
@property(nonatomic,copy)void(^returnSwitchStatus)(NSString *status,NSInteger viewTag);
@property(nonatomic,strong)NSString *titleString;
@property(nonatomic,strong)NSString *switchStatus;

@end
