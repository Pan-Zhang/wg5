//
//  GSMEmergencyCallViewController.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMEmergencyCallViewController.h"
#import "GSMEmergencyCallTableViewCell.h"
#import "GSMEmergencyCallSttingViewController.h"

#define GSMInquiryAlarmPhone [NSString stringWithFormat:@"%@0601%@",self.userInfo.password,switchID]

/**
 数据说明
 
 self.userInfo.password   用户密码
 settingNumber：参数长度：（一个开关ID，三位设置状态）+2（电话号码的长度 ）+电话号码的长度
 switchID  开关ID
 callstatus 设置状态
 
 phoneLenth：电话号码长度
 phone：电话号码
 
 */
#define GSMSettingsAlarmPhone [NSString stringWithFormat:@"%@07%@%@%@%@%@",self.userInfo.password,settingNumber,switchID,callstatus,phoneLenth,phone]

@interface GSMEmergencyCallViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *settingNumber;
    NSString *switchID;
    NSString *callstatus;
    NSString *phoneLenth;
    NSString *phone;
}
@property(nonatomic,weak)UITableView *tableView;

@end

@implementation GSMEmergencyCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setnavigationItem];
    
    [self initView];
}

-(void)setnavigationItem{
    self.navigationItem.title = NSLocalizedString(@"alarm_phone", nil);
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
    return self.userInfo.policeArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    GSMEmergencyCallTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[GSMEmergencyCallTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dic = [self.userInfo.policeArray objectAtIndex:indexPath.row];
    cell.dic = dic;
    cell.clickSaveButton = ^{
        switchID = [dic objectForKey:@"switchID"];
        [self showMessageView:self.userInfo.hostNumber title:nil body:GSMInquiryAlarmPhone];
    };
    cell.clickInquireButton = ^{
        GSMEmergencyCallSttingViewController *ecsvc = [[GSMEmergencyCallSttingViewController alloc]init];
        NSMutableDictionary *ecsvcdic = [NSMutableDictionary dictionaryWithDictionary: [self.userInfo.policeArray objectAtIndex:indexPath.row]];
        ecsvc.dic = ecsvcdic;
        ecsvc.clickLeftBtn = ^(NSDictionary *dic) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.userInfo.policeArray];
            [array replaceObjectAtIndex:indexPath.row withObject:dic];
            self.userInfo.policeArray = array;
            [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
            [self.tableView reloadData];
            switchID = [dic objectForKey:@"switchID"];
            callstatus = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"0"],[dic objectForKey:@"1"],[dic objectForKey:@"2"]];
            phone = [dic objectForKey:@"phone"];
            phoneLenth = [NSString stringWithFormat:@"%lu",(unsigned long)phone.length];
            if (phoneLenth.length == 1) {
               phoneLenth = [NSString stringWithFormat:@"0%@",phoneLenth];
            }
            settingNumber = [NSString stringWithFormat:@"%ld",6+[phoneLenth integerValue]];
            if (settingNumber.length == 1) {
                settingNumber = [NSString stringWithFormat:@"0%@",settingNumber];
            }
            [self showMessageView:self.userInfo.hostNumber title:nil body:GSMSettingsAlarmPhone];
        };
        [self.navigationController pushViewController:ecsvc animated:YES];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)clickRightButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
