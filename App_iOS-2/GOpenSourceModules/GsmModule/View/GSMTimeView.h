//
//  GSMTimeView.h
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/11.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSMTimeView : UIView
@property(nonatomic,strong)NSString *hour;
@property(nonatomic,strong)NSString *minute;
@property(nonatomic,copy)void(^retutnTime)(NSString *hour,NSString *minute);
@end
