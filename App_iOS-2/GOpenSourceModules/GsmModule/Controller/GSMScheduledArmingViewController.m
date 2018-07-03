//
//  GSMScheduledArmingViewController.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#define GSMInquiryArming [NSString stringWithFormat:@"%@08%@",self.userInfo.password,switchID]//查询
#define GSMSettingArming [NSString stringWithFormat:@"%@0914%@%@%@%@%@%@%@%@%@%@%@%@",self.userInfo.password,switchID,enable,IsArm,week_1,week_2,week_3,week_4,week_5,week_6,week_7,hour,minute]//查询

#import "GSMScheduledArmingViewController.h"
#import "GSMScheduledArmingCell.h"

#import "GSMScheduledArmingSettingViewController.h"

@interface GSMScheduledArmingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *switchID;
    
    NSString *week_1;
    NSString *week_2;
    NSString *week_3;
    NSString *week_4;
    NSString *week_5;
    NSString *week_6;
    NSString *week_7;
    NSString *hour;
    NSString *minute;
    NSString *enable;//开或关
    NSString *IsArm;//布防或撤防
}
@property(nonatomic,weak)UITableView *tableView;

@end

@implementation GSMScheduledArmingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setnavigationItem];
    
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)setnavigationItem{
    self.navigationItem.title = NSLocalizedString(@"time_arm_disarm", nil);
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
    return self.userInfo.scheduledArmingArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    GSMScheduledArmingCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[GSMScheduledArmingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.dic = [self.userInfo.scheduledArmingArray objectAtIndex:indexPath.row];
    cell.clickInquireBtn = ^{
        switchID = [cell.dic objectForKey:@"switchID"];
        [self showMessageView:self.userInfo.hostNumber title:nil body:GSMInquiryArming];
    };
    cell.clickSwitch = ^(NSString *status) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.userInfo.scheduledArmingArray objectAtIndex:indexPath.row]];
        [dic setObject:status forKey:@"switchStatus"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.userInfo.scheduledArmingArray];
        [array replaceObjectAtIndex:indexPath.row withObject:dic];
        self.userInfo.scheduledArmingArray = array;
        
        [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
        [self settingDataWithDic:dic];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GSMScheduledArmingSettingViewController *sasvc = [[GSMScheduledArmingSettingViewController alloc]init];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithDictionary:[self.userInfo.scheduledArmingArray objectAtIndex:indexPath.row]];
    sasvc.dic = dictionary;
    sasvc.clickLeftBtn = ^(NSMutableDictionary *dic) {
        //设置数据后，开关直接打开
        [dic setObject:@"1" forKey:@"switchStatus"];
        NSMutableArray *arrya = [NSMutableArray arrayWithArray:self.userInfo.scheduledArmingArray];
        [arrya replaceObjectAtIndex:indexPath.row withObject:dic];
        self.userInfo.scheduledArmingArray = arrya;
        [self.tableView reloadData];
        [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
        [self settingDataWithDic:dic];
    };
    [self.navigationController pushViewController:sasvc animated:YES];
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
    enable = [dic objectForKey:@"switchStatus"];//开或关
    IsArm = [dic objectForKey:@"status"];//布防或撤防
   
    [self showMessageView:self.userInfo.hostNumber title:nil body:GSMSettingArming];
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
