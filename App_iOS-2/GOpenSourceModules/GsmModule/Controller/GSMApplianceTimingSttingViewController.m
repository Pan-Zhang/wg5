//
//  GSMApplianceTimingSttingViewController.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMApplianceTimingSttingViewController.h"
#import "GSMTimeView.h"
#import "GSMButtonView.h"
#import "GsmSwitchView.h"
#import "GSMSwitchNumberView.h"
#define MCStatusBarH [[UIApplication sharedApplication] statusBarFrame].size.height+44.0
@interface GSMApplianceTimingSttingViewController ()

@end

@implementation GSMApplianceTimingSttingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setnavigationItem];
    
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)setnavigationItem{
    self.navigationItem.title = NSLocalizedString(@"home_time_Settings", nil);
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
    
    GsmSwitchView *sv = [[GsmSwitchView alloc]initWithFrame:CGRectMake(0, bv.frame.origin.y+bv.frame.size.height, self.view.frame.size.width, 50)];
    sv.titleString = NSLocalizedString(@"action", nil);
    sv.switchStatus = [self.dic objectForKey:@"status"];
    sv.returnSwitchStatus = ^(NSString *status, NSInteger viewTag) {
        [self.dic setObject:status forKey:@"status"];
    };
    [self.view addSubview:sv];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,  sv.frame.origin.y+sv.frame.size.height, self.view.frame.size.width, 20)];
    line.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:line];
    
    GSMSwitchNumberView *snv = [[GSMSwitchNumberView alloc]initWithFrame:CGRectMake(0, line.frame.origin.y+line.frame.size.height, self.view.frame.size.width, 170)];
    snv.switchID = [self.dic objectForKey:@"socketID"];
    snv.retutnSwitchID = ^(NSString *switchID) {
        NSLog(@"socketID:%@",switchID);
        [self.dic setObject:switchID forKey:@"socketID"];
    };
    [self.view addSubview:snv];
    
}

-(void)clickRightButton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickLeftButton{
    self.clickLeftBtn(self.dic);
    [self clickRightButton];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
