//
//  SetTimeViewController.m
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/4/3.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "SetTimeViewController.h"
#import "Common.h"
#import "MBProgressHUD.h"

@interface SetTimeViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSMutableArray *_hourArray;
    NSMutableArray *_minuteArray;
    NSMutableArray *_outletArray;
    BOOL one_bool, two_bool, three_bool, four_bool, five_bool, six_bool, seven_bool;
    NSInteger hour, minute, outlet;
}

@end

@implementation SetTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *barBtn5;
    if(_type==0){
        barBtn5=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"OK", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    }
    else{
        barBtn5=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Add", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    }
    self.navigationItem.rightBarButtonItem = barBtn5;
    
    hour = _socketTime.hour;
    minute = _socketTime.minute;
    outlet = _socketTime.socket_num;
    
    _hourPicker.delegate = self;
    _hourPicker.dataSource = self;
    
    _minutePicker.delegate = self;
    _minutePicker.dataSource = self;
    
    _outlet.delegate = self;
    _outlet.dataSource = self;
    _hourArray = [[NSMutableArray alloc]init];
    _minuteArray = [[NSMutableArray alloc]init];
    _outletArray = [[NSMutableArray alloc]init];
    for(int i=0; i<24; i++){
        [_hourArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    for(int i=0; i<60; i++){
        [_minuteArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    for(int i=1; i<21; i++){
        [_outletArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    int s = ([UIScreen mainScreen].bounds.size.width-100)/6;
    _one.frame = CGRectMake(40, _one.frame.origin.y, 20, 20);
    _two.frame = CGRectMake(40+s, _two.frame.origin.y, 20, 20);
    _three.frame = CGRectMake(40+2*s, _three.frame.origin.y, 20, 20);
    _four.frame = CGRectMake(40+3*s, _four.frame.origin.y, 20, 20);
    _five.frame = CGRectMake(40+4*s, _five.frame.origin.y, 20, 20);
    _six.frame = CGRectMake(40+5*s, _six.frame.origin.y, 20, 20);
    _seven.frame = CGRectMake(40+6*s, _seven.frame.origin.y, 20, 20);
    
    [_one addTarget:self action:@selector(weekClick:) forControlEvents:UIControlEventTouchUpInside];
    _one.tag = 0;
    [_two addTarget:self action:@selector(weekClick:) forControlEvents:UIControlEventTouchUpInside];
    _two.tag = 1;
    [_three addTarget:self action:@selector(weekClick:) forControlEvents:UIControlEventTouchUpInside];
    _three.tag = 2;
    [_four addTarget:self action:@selector(weekClick:) forControlEvents:UIControlEventTouchUpInside];
    _four.tag = 3;
    [_five addTarget:self action:@selector(weekClick:) forControlEvents:UIControlEventTouchUpInside];
    _five.tag = 4;
    [_six addTarget:self action:@selector(weekClick:) forControlEvents:UIControlEventTouchUpInside];
    _six.tag = 5;
    [_seven addTarget:self action:@selector(weekClick:) forControlEvents:UIControlEventTouchUpInside];
    _seven.tag = 6;
    
    _divider1.frame = CGRectMake(0, _divider1.frame.origin.y, [UIScreen mainScreen].bounds.size.width, _divider1.frame.size.height);
    
    _divider2.frame = CGRectMake(0, _divider2.frame.origin.y, [UIScreen mainScreen].bounds.size.width, _divider2.frame.size.height);
    
    _divider3.frame = CGRectMake(0, _divider3.frame.origin.y, [UIScreen mainScreen].bounds.size.width, _divider3.frame.size.height);
    
    _repeat.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-42)/2, _repeat.frame.origin.y, 42, 21);
    
    _onoff.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-103, _onoff.frame.origin.y, 49, 31);
    
    _outlet.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-144, _outlet.frame.origin.y, _outlet.frame.size.width, _outlet.frame.size.height);
    
    [_hourPicker selectRow:_socketTime.hour inComponent:0 animated:NO];
    [_minutePicker selectRow:_socketTime.minute inComponent:0 animated:NO];
    [_outlet selectRow:_socketTime.socket_num inComponent:0 animated:NO];
    
    one_bool = _socketTime.monday;
    if(_socketTime.monday){
        [_one setImage:[UIImage imageNamed:@"one_cover"] forState:UIControlStateNormal];
    }
    else{
        [_one setImage:[UIImage imageNamed:@"one"] forState:UIControlStateNormal];
    }
    
    two_bool = _socketTime.tuesday;
    if(_socketTime.tuesday){
        [_two setImage:[UIImage imageNamed:@"two_cover"] forState:UIControlStateNormal];
    }
    else{
        [_two setImage:[UIImage imageNamed:@"two"] forState:UIControlStateNormal];
    }
    
    three_bool = _socketTime.wednesday;
    if(_socketTime.wednesday){
        [_three setImage:[UIImage imageNamed:@"three_cover"] forState:UIControlStateNormal];
    }
    else{
        [_three setImage:[UIImage imageNamed:@"three"] forState:UIControlStateNormal];
    }
    
    four_bool = _socketTime.thursday;
    if(_socketTime.thursday){
        [_four setImage:[UIImage imageNamed:@"four_cover"] forState:UIControlStateNormal];
    }
    else{
        [_four setImage:[UIImage imageNamed:@"four"] forState:UIControlStateNormal];
    }
    
    five_bool = _socketTime.friday;
    if(_socketTime.friday){
        [_five setImage:[UIImage imageNamed:@"five_cover"] forState:UIControlStateNormal];
    }
    else{
        [_five setImage:[UIImage imageNamed:@"five"] forState:UIControlStateNormal];
    }
    
    six_bool = _socketTime.saturday;
    if(_socketTime.saturday){
        [_six setImage:[UIImage imageNamed:@"six_cover"] forState:UIControlStateNormal];
    }
    else{
        [_six setImage:[UIImage imageNamed:@"six"] forState:UIControlStateNormal];
    }
    
    seven_bool = _socketTime.sunday;
    if(_socketTime.sunday){
        [_seven setImage:[UIImage imageNamed:@"seven_cover"] forState:UIControlStateNormal];
    }
    else{
        [_seven setImage:[UIImage imageNamed:@"seven"] forState:UIControlStateNormal];
    }
    
    [_onoff setOn:_socketTime.onOff];
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
        return 1;
}

//返回指定列的行数

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView==_hourPicker){
        return [_hourArray count];
    }
    else if(pickerView==_minutePicker){
        return [_minuteArray count];
    }
    else if(pickerView==_outlet){
        return [_outletArray count];
    }
    return 0;
}

//显示的标题

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView==_hourPicker){
        return _hourArray[row];
    }
    else if(pickerView==_minutePicker){
        return _minuteArray[row];
    }
    else if(pickerView==_outlet){
        return _outletArray[row];
    }
    return @"";
}

//被选择的行

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView==_hourPicker){
        hour = row;
    }
    else if(pickerView==_minutePicker){
        minute = row;
    }
    else if(pickerView==_outlet){
        outlet = row;
    }
}

- (void)rightClick{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    if(_type==0){
        char input1[14] = {0x53, 0x5A, 0x57, 0x4C, 0x0A, 0x07};
        input1[6] = _socketTime.number;
        input1[7] = 0x01;
        input1[8] = [_onoff isOn]?0x01:0x00;
        input1[9] = outlet;
        NSString *week = [[[[[[[@"0" stringByAppendingString:seven_bool?@"1":@"0"] stringByAppendingString:six_bool?@"1":@"0"] stringByAppendingString:five_bool?@"1":@"0"] stringByAppendingString:four_bool?@"1":@"0"] stringByAppendingString:three_bool?@"1":@"0"] stringByAppendingString:two_bool?@"1":@"0"] stringByAppendingString:one_bool?@"1":@"0"];
        input1[10] = [[Common toDecimalSystemWithBinarySystem:week]intValue];
        input1[11] = hour;
        input1[12] = minute;
        input1[13] = 0x00;
        NSData* data = [NSData dataWithBytes:input1 length:sizeof(input1)];
        NSDictionary *request = @{@"binary": data};
        [self.device write:request withSN:0];
    }
    else{
        char input1[14] = {0x53, 0x5A, 0x57, 0x4C, 0x0A, 0x07};
        input1[6] = _length;
        input1[7] = 0x01;
        input1[8] = [_onoff isOn]?0x01:0x00;
        input1[9] = outlet;
        NSString *week = [[[[[[[@"0" stringByAppendingString:seven_bool?@"1":@"0"] stringByAppendingString:six_bool?@"1":@"0"] stringByAppendingString:five_bool?@"1":@"0"] stringByAppendingString:four_bool?@"1":@"0"] stringByAppendingString:three_bool?@"1":@"0"] stringByAppendingString:two_bool?@"1":@"0"] stringByAppendingString:one_bool?@"1":@"0"];
        input1[10] = [[Common toDecimalSystemWithBinarySystem:week]intValue];
        input1[11] = hour;
        input1[12] = minute;
        input1[13] = 0x00;
        NSData* data = [NSData dataWithBytes:input1 length:sizeof(input1)];
        NSDictionary *request = @{@"binary": data};
        [self.device write:request withSN:0];
    }
}

-(void)hideSelf:(Boolean)res{
    if(res){
        [self.navigationController popViewControllerAnimated:NO];
    }
    else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"set_fail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
    }
}

- (void)weekClick:(UIButton *)sender{
    NSInteger tag = sender.tag;
    if(tag==0){
        if(one_bool){
            [_one setImage:[UIImage imageNamed:@"one"] forState:UIControlStateNormal];
            one_bool = false;
        }
        else{
            [_one setImage:[UIImage imageNamed:@"one_cover"] forState:UIControlStateNormal];
            one_bool = true;
        }
    }
    else if(tag==1){
        if(two_bool){
            [_two setImage:[UIImage imageNamed:@"two"] forState:UIControlStateNormal];
            two_bool = false;
        }
        else{
            [_two setImage:[UIImage imageNamed:@"two_cover"] forState:UIControlStateNormal];
            two_bool = true;
        }
    }
    else if(tag==2){
        if(three_bool){
            [_three setImage:[UIImage imageNamed:@"three"] forState:UIControlStateNormal];
            three_bool = false;
        }
        else{
            [_three setImage:[UIImage imageNamed:@"three_cover"] forState:UIControlStateNormal];
            three_bool = true;
        }
    }
    else if(tag==3){
        if(four_bool){
            [_four setImage:[UIImage imageNamed:@"four"] forState:UIControlStateNormal];
            four_bool = false;
        }
        else{
            [_four setImage:[UIImage imageNamed:@"four_cover"] forState:UIControlStateNormal];
            four_bool = true;
        }
    }
    else if(tag==4){
        if(five_bool){
            [_five setImage:[UIImage imageNamed:@"five"] forState:UIControlStateNormal];
            five_bool = false;
        }
        else{
            [_five setImage:[UIImage imageNamed:@"five_cover"] forState:UIControlStateNormal];
            five_bool = true;
        }
    }
    else if(tag==5){
        if(six_bool){
            [_six setImage:[UIImage imageNamed:@"six"] forState:UIControlStateNormal];
            six_bool = false;
        }
        else{
            [_six setImage:[UIImage imageNamed:@"six_cover"] forState:UIControlStateNormal];
            six_bool = true;
        }
    }
    else if(tag==6){
        if(seven_bool){
            [_seven setImage:[UIImage imageNamed:@"seven"] forState:UIControlStateNormal];
            seven_bool = false;
        }
        else{
            [_seven setImage:[UIImage imageNamed:@"seven_cover"] forState:UIControlStateNormal];
            seven_bool = true;
        }
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
