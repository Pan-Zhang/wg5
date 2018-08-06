//
//  AlarmPhoneViewController.m
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "AlarmPhoneViewController.h"
#import "PhoneTableViewCell.h"
#import "AlarmCall.h"
#import "MBProgressHUD.h"
#import "SetPhoneViewController.h"

#define AlarmCellInentifer @"AlarmCellInentifer"

@interface AlarmPhoneViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation AlarmPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"set_alarm_phone", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_item"] style:UIBarButtonItemStylePlain target:self action:@selector(addPress)];
    _myTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView registerNib:[UINib nibWithNibName:@"PhoneTableViewCell" bundle:nil] forCellReuseIdentifier:AlarmCellInentifer];
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_callArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlarmCellInentifer forIndexPath:indexPath];
    PhoneTableViewCell *phoneCell = (PhoneTableViewCell *)cell;
    AlarmCall *alarmCall = _callArray[indexPath.row];
    phoneCell.number.text = [NSString stringWithFormat:NSLocalizedString(@"group", nil), indexPath.row+1];
    
    NSString *str = @"";
    for(int i=0; i<(alarmCall.numLength<31?alarmCall.numLength:31); i++){
        str = [str stringByAppendingString:(NSString *)alarmCall.number[i]];
    }
    phoneCell.phone.text = str;

    if(alarmCall.callEnable){
        [phoneCell.call setImage:[UIImage imageNamed:@"dot_cover"]];
    }
    else{
        [phoneCell.call setImage:[UIImage imageNamed:@"dot"]];
    }

    if(alarmCall.rfidEnable){
        [phoneCell.rfid setImage:[UIImage imageNamed:@"dot_cover"]];
    }
    else{
        [phoneCell.rfid setImage:[UIImage imageNamed:@"dot"]];
    }

    if(alarmCall.smsEnable){
        [phoneCell.sms setImage:[UIImage imageNamed:@"dot_cover"]];
    }
    else{
        [phoneCell.sms setImage:[UIImage imageNamed:@"dot"]];
    }
    phoneCell.edit.tag = indexPath.row;
    [phoneCell.edit addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    phoneCell.del.tag = indexPath.row;
    [phoneCell.del addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    return phoneCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)deleteClick:(UIButton *)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    char input1[43] = {0x53, 0x5A, 0x57, 0x4C, 0x12, 0x24};
    AlarmCall *call = _callArray[sender.tag];
    input1[6] = call.index;
    for(int i=7; i<43; i++){
        input1[i] = 0;
    }
    NSData* data = [NSData dataWithBytes:input1 length:sizeof(input1)];
    NSDictionary *request = @{@"binary": data};
    [self.device write:request withSN:0];
}

- (void)editClick:(UIButton *)sender{
    SetPhoneViewController *controller = [[SetPhoneViewController alloc]init];
    controller.type = 0;
    controller.length = [_callArray count];
    controller.alarmCall = _callArray[sender.tag];
    controller.device = self.device;
    _setPhoneViewController = controller;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)refreshView{
    [_myTableView reloadData];
}

- (void)addPress{
    if([_callArray count]<7){
        SetPhoneViewController *controller = [[SetPhoneViewController alloc]init];
        controller.type = 1;
        for(int i=0; i<[_callArray count]; i++){
            AlarmCall *call = _callArray[i];
            if(i!=call.index){
                controller.length = i;
                break;
            }
            else{
                controller.length = [_callArray count];
            }
        }
        controller.device = self.device;
        _setPhoneViewController = controller;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"almost_seven_number", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
    }
}

- (void)hideChild:(Boolean)res{
    if(_setPhoneViewController!=nil){
        [_setPhoneViewController hideSelf:res];
    }
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
