//
//  GSMEmergencyCallSttingViewController.h
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSMEmergencyCallSttingViewController : UIViewController
@property(nonatomic,copy)void (^clickLeftBtn)(NSDictionary *dic);
@property(nonatomic,strong)NSDictionary *dic;

@end
