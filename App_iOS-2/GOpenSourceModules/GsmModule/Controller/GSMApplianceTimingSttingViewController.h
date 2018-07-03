//
//  GSMApplianceTimingSttingViewController.h
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSMApplianceTimingSttingViewController : UIViewController
@property(nonatomic,copy)void(^clickLeftBtn)(NSMutableDictionary *dic);
@property(nonatomic,strong)NSMutableDictionary *dic;
@end
