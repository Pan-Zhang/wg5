//
//  GSMApplianceTimingViewController.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMApplianceTimingViewController.h"
#import "GSMApplianceTimingTableViewCell.h"
#import "GSMApplianceTimingSttingViewController.h"

#define GSMInquiryAppliance [NSString stringWithFormat:@"%@0402%@",self.userInfo.password,switchID]//查询
#define GSMSettingAppliance [NSString stringWithFormat:@"%@0517%@%@%@%@%@%@%@%@%@%@%@%@%@",self.userInfo.password,switchID,enable,IsOff,socketID,week_1,week_2,week_3,week_4,week_5,week_6,week_7,hour,minute]//设置

@interface GSMApplianceTimingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *switchID;//开关id
    NSString *enable;//开或关
    NSString *IsOff;//定时开定时关
    NSString *socketID;//插座id
    NSString *week_1;
    NSString *week_2;
    NSString *week_3;
    NSString *week_4;
    NSString *week_5;
    NSString *week_6;
    NSString *week_7;
    NSString *hour;
    NSString *minute;
    
}
@property(nonatomic,weak)UITableView *tableView;

@end

@implementation GSMApplianceTimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setnavigationItem];
    
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)setnavigationItem{
    self.navigationItem.title = NSLocalizedString(@"home_time", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
    [rightButton setImage:[UIImage imageNamed:@"leftButton_image"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

-(void)initView{
    [self tableView];
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc]init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark UITableViewDelegate , UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userInfo.applianceTimingArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    GSMApplianceTimingTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[GSMApplianceTimingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.dic = [self.userInfo.applianceTimingArray objectAtIndex:indexPath.row];
    cell.clickSwitch = ^(NSMutableDictionary *dic) {
        [self.userInfo.applianceTimingArray replaceObjectAtIndex:indexPath.row withObject:dic];
        [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
        [self settingDataWithDic:dic];
    };//开关
    cell.clickInquireBtn = ^{
        NSMutableDictionary *dic = [self.userInfo.applianceTimingArray objectAtIndex:indexPath.row];
        switchID = [dic objectForKey:@"switchID"];
        [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
        if (switchID.length == 1) {
            switchID = [NSString stringWithFormat:@"0%@",switchID];
        }
        [self showMessageView:self.userInfo.hostNumber title:nil body:GSMInquiryAppliance];
    };//查询
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GSMApplianceTimingSttingViewController *atsvc = [[GSMApplianceTimingSttingViewController alloc]init];
    atsvc.dic = [NSMutableDictionary dictionaryWithDictionary:[self.userInfo.applianceTimingArray objectAtIndex:indexPath.row]];
    atsvc.clickLeftBtn = ^(NSMutableDictionary *dic) {
        [dic setObject:@"1" forKey:@"switchStatus"];//对参数设置后，开关自动打开
        NSMutableArray *arrya = [NSMutableArray arrayWithArray:self.userInfo.applianceTimingArray];
        [arrya replaceObjectAtIndex:indexPath.row withObject:dic];
        self.userInfo.applianceTimingArray = arrya;
        [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
        [self.tableView reloadData];
        [self settingDataWithDic:dic];
    };
    [self.navigationController pushViewController:atsvc animated:YES];
}

-(void)clickRightButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)settingDataWithDic:(NSDictionary *)dic{
    switchID = [dic objectForKey:@"switchID"];
    if (switchID.length == 1) {
        switchID = [NSString stringWithFormat:@"0%@",switchID];
    }
    enable = [dic objectForKey:@"switchStatus"];//开或关
    IsOff = [dic objectForKey:@"status"];//定时开定时关
    socketID = [dic objectForKey:@"socketID"];//插座id
    if (socketID.length == 1) {
        socketID  = [NSString stringWithFormat:@"0%@",socketID];
    }
    week_1 = [dic objectForKey:@"1"];
    week_2 = [dic objectForKey:@"2"];
    week_3 = [dic objectForKey:@"3"];
    week_4 = [dic objectForKey:@"4"];
    week_5 = [dic objectForKey:@"5"];
    week_6 = [dic objectForKey:@"6"];
    week_7 = [dic objectForKey:@"7"];
    hour = [dic objectForKey:@"hour"];
    minute = [dic objectForKey:@"minute"];
    if (hour.length == 1) {
        hour = [NSString stringWithFormat:@"0%@",hour];
    }
    if (minute.length == 1) {
        minute = [NSString stringWithFormat:@"0%@",minute];
    }
    
    [self showMessageView:self.userInfo.hostNumber title:nil body:GSMSettingAppliance];
}

@end
