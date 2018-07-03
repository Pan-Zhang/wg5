//
//  GSMSwitchNumberView.h
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/11.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSMSwitchNumberView : UIView
@property(nonatomic,strong)NSString *switchID;
@property(nonatomic,copy)void(^retutnSwitchID)(NSString *switchID);
@end
