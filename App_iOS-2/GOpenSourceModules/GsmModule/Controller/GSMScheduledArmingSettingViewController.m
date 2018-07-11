//
//  GSMScheduledArmingSettingViewController.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#define MCStatusBarH [[UIApplication sharedApplication] statusBarFrame].size.height+44.0

#import "GSMScheduledArmingSettingViewController.h"
#import "GSMTimeView.h"
#import "GSMButtonView.h"

@interface GSMScheduledArmingSettingViewController (){
    NSMutableArray *btnArray;
}

@end

@implementation GSMScheduledArmingSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    btnArray = [NSMutableArray array];
    
    [self setnavigationItem];
    
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)setnavigationItem{
    self.navigationItem.title = NSLocalizedString(@"time_arm_disarm_Settings", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
    [rightButton setImage:[UIImage imageNamed:@"leftButton_image"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
}

-(void)initView{
    GSMTimeView *tv = [[GSMTimeView alloc]initWithFrame:CGRectMake(0, MCStatusBarH, self.view.frame.size.width, 170)];
    tv.hour = [self.dic objectForKey:@"hour"];
    tv.minute = [self.dic objectForKey:@"minute"];
    tv.retutnTime = ^(NSString *hour, NSString *minute) {
        [self.dic setObject:hour forKey:@"hour"];//小时
        [self.dic setObject:minute forKey:@"minute"];
    };
    [self.view addSubview:tv];
    
    GSMButtonView *bv = [[GSMButtonView alloc]initWithFrame:CGRectMake(0, tv.frame.origin.y+tv.frame.size.height, self.view.frame.size.width, 120)];
    bv.dic = self.dic;
    bv.retutnButtonArray = ^(NSMutableDictionary *dic) {
        self.dic = dic;
    };
    [self.view addSubview:bv];
    
    NSArray *buttonArray = [NSArray arrayWithObjects:NSLocalizedString(@"alarm", nil),NSLocalizedString(@"disarm", nil), nil];
    NSArray *btnimageArray = [NSArray arrayWithObjects:@"arm",@"disarm", nil];
    CGFloat buttonX = self.view.frame.size.width - 180;
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonX/2+i*100, bv.frame.size.height+bv.frame.origin.y+20, 80, 80)];
        button.tag = i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_cover",[btnimageArray objectAtIndex:i]]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[btnimageArray objectAtIndex:i]]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [btnArray addObject:button];
        if (i == 0) {
            NSString *status = [self.dic objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                button.selected = YES;
            }else{
                button.selected = NO;
            }
        }else{
            NSString *status = [self.dic objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                button.selected = NO;
            }else{
                button.selected = YES;
            }
        }

        [self.view addSubview:button];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.size.height+button.frame.origin.y, button.frame.size.width, 20)];
        label.text = [buttonArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
   
}

-(void)clickButton:(UIButton *)sender{
    if (!sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    for (int i = 0; i < btnArray.count; i ++) {
        UIButton * b = [btnArray objectAtIndex:i];
        if (b.tag != sender.tag) {
            b.selected = !sender.selected;
        }
    }
    if (sender.tag == 0) {
        [self.dic setObject:@"1" forKey:@"status"];
    }else{
        [self.dic setObject:@"0" forKey:@"status"];
    }
}

-(void)clickRightButton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickLeftButton{
    self.clickLeftBtn(self.dic);
    [self clickRightButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
