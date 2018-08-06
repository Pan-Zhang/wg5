//
//  SetPhoneViewController.m
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/4/3.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "SetPhoneViewController.h"
#import "MBProgressHUD.h"

@interface SetPhoneViewController (){
    UITapGestureRecognizer *tap1, *tap2, *tap3;
    Boolean call_bool, rfid_bool, sms_bool;
}

@end

@implementation SetPhoneViewController

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
    _input.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-299)/2, _input.frame.origin.y, _input.frame.size.width, _input.frame.size.height);
    _edit_text.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-293)/2, _edit_text.frame.origin.y, _edit_text.frame.size.width, 43);
    _edit_text.layer.borderWidth = 1;
    _edit_text.layer.cornerRadius = 20;
    _edit_text.layer.borderColor = [[UIColor colorWithRed:0 green:168/255.0 blue:248/255.0 alpha:1]CGColor];
    _edit_text.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
    //设置显示模式为永远显示(默认不显示)
    _edit_text.leftViewMode = UITextFieldViewModeAlways;
    
    tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    _call_btn.frame = CGRectMake(90, _call_btn.frame.origin.y, _call_btn.frame.size.width, _call_btn.frame.size.height);
    _call.frame = CGRectMake(CGRectGetMaxX(_call_btn.frame)+8, _call.frame.origin.y, _call.frame.size.width, _call.frame.size.height);
    _call.userInteractionEnabled = YES;
    [_call addGestureRecognizer:tap1];
    
    tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    _rfid_btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-55/2, _rfid_btn.frame.origin.y, _rfid_btn.frame.size.width, _rfid_btn.frame.size.height);
    _rfid.frame = CGRectMake(CGRectGetMaxX(_rfid_btn.frame)+8, _rfid.frame.origin.y, _rfid.frame.size.width, _rfid.frame.size.height);
    _rfid.userInteractionEnabled = YES;
    [_rfid addGestureRecognizer:tap2];
    
    tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    _sms_btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-145, _sms_btn.frame.origin.y, _sms_btn.frame.size.width, _sms_btn.frame.size.height);
    _sms.frame = CGRectMake(CGRectGetMaxX(_sms_btn.frame)+8, _sms.frame.origin.y, _sms.frame.size.width, _sms.frame.size.height);
    _sms.userInteractionEnabled = YES;
    [_sms addGestureRecognizer:tap3];
    
    if(_type==0){
        
        _edit_text.text = [_alarmCall getNumber];
        if(_alarmCall.callEnable){
            [_call_btn setImage:[UIImage imageNamed:@"dot_cover"] forState:UIControlStateNormal];
        }
        else{
            [_call_btn setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
        }
        
        if(_alarmCall.rfidEnable){
            [_rfid_btn setImage:[UIImage imageNamed:@"dot_cover"] forState:UIControlStateNormal];
        }
        else{
            [_rfid_btn setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
        }
        
        if(_alarmCall.smsEnable){
            [_sms_btn setImage:[UIImage imageNamed:@"dot_cover"] forState:UIControlStateNormal];
        }
        else{
            [_sms_btn setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
        }
        call_bool = _alarmCall.callEnable;
        rfid_bool = _alarmCall.rfidEnable;
        sms_bool = _alarmCall.smsEnable;
    }
    
    [_call_btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [_rfid_btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [_sms_btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightClick{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    if(_type==0){
        char input1[43] = {0x53, 0x5A, 0x57, 0x4C, 0x12, 0x24};
        input1[6] = _alarmCall.index;
        input1[7] = call_bool?0x01:0x00;
        input1[8] = sms_bool?0x01:0x00;
        input1[9] = rfid_bool?0x01:0x00;
        NSString *str = _edit_text.text;
        if(str.length>30){
            str = [str substringToIndex:30];
        }
        input1[10] = [str length];
        for(int i=0; i<[str length]; i++){
            input1[11+i] = (int)[str characterAtIndex:i];
        }
        input1[42] = 0x00;
        NSData* data = [NSData dataWithBytes:input1 length:sizeof(input1)];
        NSDictionary *request = @{@"binary": data};
        [self.device write:request withSN:0];
    }
    else{
        char input1[43] = {0x53, 0x5A, 0x57, 0x4C, 0x12, 0x24};
        input1[6] = _length;
        input1[7] = call_bool?0x01:0x00;
        input1[8] = sms_bool?0x01:0x00;
        input1[9] = rfid_bool?0x01:0x00;
        NSString *str = _edit_text.text;
        if(str.length>30){
            str = [str substringToIndex:30];
        }
        input1[10] = [str length];
        for(int i=0; i<[str length]; i++){
            input1[11+i] = (int)[str characterAtIndex:i];
        }
        input1[42] = 0x00;
        NSData* data = [NSData dataWithBytes:input1 length:sizeof(input1)];
        NSDictionary *request = @{@"binary": data};
        [self.device write:request withSN:0];
    }
}

- (void)hideSelf:(Boolean)res{
    if(res){
        [self.navigationController popViewControllerAnimated:NO];
    }
    else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"set_fail", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
    }
}

- (void)click:(UIButton *)sender{
    if(sender==_call_btn){
        if(call_bool){
            [_call_btn setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
            call_bool = false;
        }
        else{
            [_call_btn setImage:[UIImage imageNamed:@"dot_cover"] forState:UIControlStateNormal];
            call_bool = true;
        }
    }
    else if(sender==_rfid_btn){
        if(rfid_bool){
            [_rfid_btn setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
            rfid_bool = false;
        }
        else{
            [_rfid_btn setImage:[UIImage imageNamed:@"dot_cover"] forState:UIControlStateNormal];
            rfid_bool = true;
        }
    }
    else if(sender==_sms_btn){
        if(sms_bool){
            [_sms_btn setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
            sms_bool = false;
        }
        else{
            [_sms_btn setImage:[UIImage imageNamed:@"dot_cover"] forState:UIControlStateNormal];
            sms_bool = true;
        }
    }
}

- (void)tapView:(UITapGestureRecognizer *)sender{
    if(sender==tap1){
        if(call_bool){
            [_call_btn setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
            call_bool = false;
        }
        else{
            [_call_btn setImage:[UIImage imageNamed:@"dot_cover"] forState:UIControlStateNormal];
            call_bool = true;
        }
    }
    else if(sender==tap2){
        if(rfid_bool){
            [_rfid_btn setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
            rfid_bool = false;
        }
        else{
            [_rfid_btn setImage:[UIImage imageNamed:@"dot_cover"] forState:UIControlStateNormal];
            rfid_bool = true;
        }
    }
    else if(sender==tap3){
        if(sms_bool){
            [_sms_btn setImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
            sms_bool = false;
        }
        else{
            [_sms_btn setImage:[UIImage imageNamed:@"dot_cover"] forState:UIControlStateNormal];
            sms_bool = true;
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
