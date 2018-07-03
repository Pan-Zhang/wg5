//
//  SocketTimeViewController.m
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/3/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "SocketTimeViewController.h"
#import "TimeTableViewCell.h"
#import "SmartSocketTime.h"
#import "MBProgressHUD.h"
#import "Common.h"
#import "SetTimeViewController.h"

#define TimeCellInentifer @"TimeCellInentifer"

@interface SocketTimeViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SocketTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"set_time", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_item"] style:UIBarButtonItemStylePlain target:self action:@selector(addPress)];
    _myTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView registerNib:[UINib nibWithNibName:@"TimeTableViewCell" bundle:nil] forCellReuseIdentifier:TimeCellInentifer];
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
}

- (void)setTimeArray:(NSMutableArray *)timeArray{
    _timeArray = timeArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_timeArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TimeCellInentifer forIndexPath:indexPath];
    TimeTableViewCell *timeCell = (TimeTableViewCell *)cell;
    SmartSocketTime *socketTime = [_timeArray objectAtIndex:indexPath.row];
    NSString *time = @"";
    if(socketTime.hour<10){
        time = [NSString stringWithFormat:@"0%d", socketTime.hour];
    }
    else{
        time = [NSString stringWithFormat:@"%d", socketTime.hour];
    }
    
    if(socketTime.minute<10){
        time = [NSString stringWithFormat:@"%@:0%d", time, socketTime.minute];
    }
    else{
        time = [NSString stringWithFormat:@"%@:%d", time, socketTime.minute];
    }
    timeCell.time.text = time;
    
    timeCell.socket_num.text = [NSString stringWithFormat:NSLocalizedString(@"socket", nil), socketTime.socket_num+1];
    timeCell.onOff.text = socketTime.onOff?NSLocalizedString(@"time_on", nil):NSLocalizedString(@"time_off", nil);
    
    if(socketTime.monday){
        [timeCell.one setImage:[UIImage imageNamed:@"one_cover"]];
    }
    else{
        [timeCell.one setImage:[UIImage imageNamed:@"one"]];
    }
    
    if(socketTime.tuesday){
        [timeCell.two setImage:[UIImage imageNamed:@"two_cover"]];
    }
    else{
        [timeCell.two setImage:[UIImage imageNamed:@"two"]];
    }
    
    if(socketTime.wednesday){
        [timeCell.three setImage:[UIImage imageNamed:@"three_cover"]];
    }
    else{
        [timeCell.three setImage:[UIImage imageNamed:@"three"]];
    }
    
    if(socketTime.thursday){
        [timeCell.four setImage:[UIImage imageNamed:@"four_cover"]];
    }
    else{
        [timeCell.four setImage:[UIImage imageNamed:@"four"]];
    }
    
    if(socketTime.friday){
        [timeCell.five setImage:[UIImage imageNamed:@"five_cover"]];
    }
    else{
        [timeCell.five setImage:[UIImage imageNamed:@"five"]];
    }
    
    if(socketTime.saturday){
        [timeCell.six setImage:[UIImage imageNamed:@"six_cover"]];
    }
    else{
        [timeCell.six setImage:[UIImage imageNamed:@"six"]];
    }
    
    if(socketTime.sunday){
        [timeCell.seven setImage:[UIImage imageNamed:@"seven_cover"]];
    }
    else{
        [timeCell.seven setImage:[UIImage imageNamed:@"seven"]];
    }
    
    [timeCell.isValid setOn:socketTime.isValid];
    timeCell.isValid.tag = indexPath.row;
    [timeCell.isValid addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    if(socketTime.isValid){
        timeCell.time.textColor = [UIColor blackColor];
        timeCell.socket_num.textColor = [UIColor blackColor];
        timeCell.onOff.textColor = [UIColor blackColor];
    }
    else{
        timeCell.time.textColor = [UIColor lightGrayColor];
        timeCell.socket_num.textColor = [UIColor lightGrayColor];
        timeCell.onOff.textColor = [UIColor lightGrayColor];
    }
    return timeCell;
}

-(void)switchAction:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    SmartSocketTime *socketTime = _timeArray[switchButton.tag];
    char input1[14] = {0x53, 0x5A, 0x57, 0x4C, 0x0A, 0x07};
    input1[6] = socketTime.number;
    input1[7] = isButtonOn?0x01:0x00;
    input1[8] = socketTime.onOff?0x01:0x00;
    input1[9] = socketTime.socket_num;
    NSString *str = [[[[[[[@"0" stringByAppendingString:socketTime.sunday?@"1":@"0"] stringByAppendingString:socketTime.saturday?@"1":@"0"] stringByAppendingString:socketTime.friday?@"1":@"0"] stringByAppendingString:socketTime.thursday?@"1":@"0"] stringByAppendingString:socketTime.wednesday?@"1":@"0"] stringByAppendingString:socketTime.tuesday?@"1":@"0"] stringByAppendingString:socketTime.monday?@"1":@"0"];
    input1[10] = [[Common toDecimalSystemWithBinarySystem:str]intValue];
    input1[11] = socketTime.hour;
    input1[12] = socketTime.minute;
    input1[13] = 0x00;
    NSData* data = [NSData dataWithBytes:input1 length:sizeof(input1)];
    NSDictionary *request = @{@"binary": data};
    [self.device write:request withSN:0];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SetTimeViewController *controller = [[SetTimeViewController alloc]init];
    controller.socketTime = _timeArray[indexPath.row];
    controller.type = 0;
    controller.device = self.device;
    _setTimeViewController = controller;
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"Delete", nil);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SmartSocketTime *socketTime = _timeArray[indexPath.row];
    char input1[14] = {0x53, 0x5A, 0x57, 0x4C, 0x0A, 0x07};
    input1[6] = socketTime.number;
    for(int i=0; i<7; i++){
        input1[7+i] = 0x00;
    }
    NSData* data = [NSData dataWithBytes:input1 length:sizeof(input1)];
    NSDictionary *request = @{@"binary": data};
    [self.device write:request withSN:0];
}

-(void)refreshView{
    [_myTableView reloadData];
}

- (void)addPress{
    SetTimeViewController *controller = [[SetTimeViewController alloc]init];
    controller.type = 1;
    controller.length = [_timeArray count];
    controller.device = self.device;
    _setTimeViewController = controller;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)hideChild:(Boolean)res{
    if(_setTimeViewController!=nil){
        [_setTimeViewController hideSelf:res];
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
