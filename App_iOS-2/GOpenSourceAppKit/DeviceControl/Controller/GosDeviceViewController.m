//
//  GizDeviceViewController.m
//  GOpenSource_AppKit
//
//  Created by danly on 2017/2/7.
//  Copyright © 2017年 Gizwits. All rights reserved.
//
#import "GosDeviceViewController.h"
#import "GosDeviceLabelCell.h"
#import "GosDeviceBoolCell.h"
#import "GosDeviceEnumCell.h"
#import "GosDeviceEnumSelectionController.h"
#import "GosDeviceControl.h"

#import "GosTipView.h"
#import "GosAlertView.h"
#import "GosCommon.h"
#import "Common.h"
#import "SmartSocketTime.h"
#import "AlarmCall.h"
#import "AlarmRecord.h"
#import "AlarmDisarmRecord.h"
#import "SocketTimeViewController.h"
#import "AlarmPhoneViewController.h"
#import "AlarmRecordViewController.h"
#import "ArmDisarmViewController.h"
#import "MBProgressHUD.h"

// 各类Cell的重用标识
#define GosDeviceLabelCellReuseIdentifier @"GosDeviceLabelCellReuseIdentifier"
#define GosDeviceBoolCellReuseIdentifier @"GosDeviceBoolCellReuseIdentifier"
#define GosDeviceEnumCellReuseIdentifier @"GosDeviceEnumCellReuseIdentifier"

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽

/**
 设备控制界面
 */
@interface GosDeviceViewController ()<UITableViewDataSource, UITableViewDelegate,GosDeviceBoolCellDelegate,GosDeviceEnumCellDelegate, GizWifiDeviceDelegate, UIActionSheetDelegate>

// 当前设备
@property (nonatomic, strong) GizWifiDevice *device;
@property (nonatomic, weak) UITableView *tableView;

// 线程
@property (nonatomic, strong) NSOperationQueue *queue;
// 设备读写工具
@property (nonatomic, strong) GosDeviceControl *deviceControl;
// 设备名称
@property (nonatomic, copy) NSString *deviceName;
//提示框
@property (nonatomic, strong) GosTipView *tipView;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) UIButton *alarm;
@property (nonatomic, strong) UIButton *disarm;
@property (nonatomic, strong) UIButton *home_alarm;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSMutableArray *alarmDisarmRecordArray;
@property (nonatomic, strong) NSMutableArray *alarmRecordArray;
@property (nonatomic, strong) NSMutableArray *callArray;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, assign) int previoutNum;

@end

@implementation GosDeviceViewController

- (instancetype)initWithDevice:(GizWifiDevice *)device
{
    if (self = [super init])
    {
        self.device = device;
        self.device.delegate = self;
        self.deviceControl.device = device;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 检查设备状态
    [self checkDeviceStatus];
}

#pragma mark - NavigaitonBar 导航栏部分设置
- (void)setupNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(menuBtnPressed)];
    self.navigationItem.title = self.deviceName;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)onBack
{
    if(_isShow){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.device setSubscribe:nil subscribed:NO];
        self.device.delegate = nil;
        [[GosTipView sharedInstance] hideTipView];
        [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        _myView.hidden = NO;
        self.navigationItem.title = self.deviceName;
        _isShow = true;
    }
    
}

- (void)menuBtnPressed
{
    _actionSheet = nil;
    
    _actionSheet = [[UIActionSheet alloc]
                   initWithTitle:nil
                   delegate:self
                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                   destructiveButtonTitle:nil
                   otherButtonTitles:NSLocalizedString(@"get device status", nil), NSLocalizedString(@"get device hardware info", nil), NSLocalizedString(@"set device info", nil), nil];
    
    _actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [_actionSheet showInView:self.view];
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // 点击了《获取设备状态》
        [self.tipView showLoadTipWithMessage:nil];
        [self.device getDeviceStatus:nil];
    }
    else if (buttonIndex == 1)
    {
        // 点击了《获取硬件信息》
        if (self.device.isLAN)
        {
            [self.device getHardwareInfo];
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tipView showTipMessage:NSLocalizedString(@"only_get_device_mess_in_lan", nil) delay:1 completion:nil];
            });
        }
    }
    else if (buttonIndex == 2)
    {
        // 点击了《设置设备信息》
        _alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"set alias and remark", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        
        [_alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        
        UITextField *aliasField = [_alertView textFieldAtIndex:0];
        aliasField.placeholder = NSLocalizedString(@"input alias", nil);
        aliasField.text = self.device.alias;
        
        UITextField *remarkField = [_alertView textFieldAtIndex:1];
        [remarkField setSecureTextEntry:NO];
        remarkField.placeholder = NSLocalizedString(@"input remark", nil);
        remarkField.text = self.device.remark;
        
        [_alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        //设置别名及备注，点击了《确定》
        UITextField *aliasField = [alertView textFieldAtIndex:0];
        UITextField *remarkField = [alertView textFieldAtIndex:1];
        [aliasField resignFirstResponder];
        [remarkField resignFirstResponder];
        if ([aliasField.text isEqualToString:@""] &&[remarkField.text isEqualToString:@""])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self.tipView showTipMessage:NSLocalizedString(@"rename", nil) delay:1 completion:nil];
            });
        }
        else
        {
            [self.tipView showLoadTipWithMessage:nil];
            [self.device setCustomInfo:remarkField.text alias:aliasField.text];
        }
    }
}

#pragma mark - 检测设备状态
// 检查设备状态
- (void)checkDeviceStatus
{
    if (self.device.netStatus == GizDeviceControlled)
    {
        // 设备可控获取设备状态
        [[GosTipView sharedInstance] hideTipView];
        [self.device getDeviceStatus:nil];
        return;
    }
    
    [[GosTipView sharedInstance] showLoadTipWithMessage:NSLocalizedString(@"wait link", nil)];
    
    // 开启一个子线程 检测设备状态
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    __weak NSBlockOperation *weakOperation = operation;
    [operation addExecutionBlock:^{
        int timeInterval = self.device.isLAN ? 10 : 20;
        
        // 小循环延时 10s / 大循环延时 20s
        [NSThread sleepForTimeInterval:timeInterval];
        
        if (![weakOperation isCancelled])
        {
            if (self.device.netStatus != GizDeviceControlled)
            {
                // 10s/20s后 设备不可控，退到设备列表
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[GosTipView sharedInstance] hideTipView];
                    // 退到设备列表
                    if (self.navigationController.viewControllers.lastObject == self)
                    {
                        [[GosTipView sharedInstance] showTipMessage:NSLocalizedString(@"no_response", nil) delay:1 completion:^{
                            [self onBack];
                        }];
                    }
                });
                
            }
            else
            {
                // 可控，获取设备状态
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.device getDeviceStatus:nil];
                    
                });
            }
            // 关闭所有线程
            [self.queue cancelAllOperations];
        }
        
    }];
    
    // 取消其它所有正在检测设备网络状态的线程
    if (self.queue.operationCount > 0)
    {
        [self.queue cancelAllOperations];
    }
    [self.queue addOperation:operation];
}

#pragma mark - GizWifiDeviceDelegate 
// 获取设备数据点状态回调
- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary *)dataMap withSN:(NSNumber *)sn
{
    [[GosTipView sharedInstance] hideTipView];
    
    NSData *binary = dataMap[@"binary"];

    if(binary!=nil && binary.length>4){
        NSLog(@"dataMap = %@", binary);
        Byte *bytes = (Byte *)[binary bytes];
        if(bytes[4]==0x09){
            int length = bytes[5];
            int group = length/6;
            _timeArray = [[NSMutableArray alloc]init];
            for(int i=0; i<group; i++){
                SmartSocketTime *socketTime = [[SmartSocketTime alloc]init];
                socketTime.number = i;
                for(int j=0; j<6; j++){
                    switch (j) {
                        case 0:
                        {
                            int isValid = bytes[6 + i * 6 + j];
                            socketTime.isValid = isValid==1;
                        }
                        break;
                        
                        case 1:
                        {
                            int onOff = bytes[6 + i * 6 + j];
                            socketTime.onOff = onOff==1;
                        }
                        break;
                        
                        case 2:
                        {
                            int number = bytes[6 + i * 6 + j];
                            socketTime.socket_num = number;
                        }
                        break;
                        
                        case 3:
                        {
                            int week = bytes[6 + i * 6 + j];
                            NSString *weekStr = [Common toBinarySystemWithDecimalSystem:week];
                            NSInteger size = weekStr.length;
                            if(size<8){
                                for(int k=0; k<8-size; k++){
                                    weekStr = [@"0" stringByAppendingString:weekStr];
                                }
                            }
                            
                            NSRange range = NSMakeRange(1, 1);
                            int sunday = [[weekStr substringWithRange:range]intValue];
                            socketTime.sunday = sunday==1;
                            
                            range = NSMakeRange(2, 1);
                            int saturday = [[weekStr substringWithRange:range]intValue];
                            socketTime.saturday = saturday==1;
                            
                            range = NSMakeRange(3, 1);
                            int friday = [[weekStr substringWithRange:range]intValue];
                            socketTime.friday = friday==1;
                            
                            range = NSMakeRange(4, 1);
                            int thursday = [[weekStr substringWithRange:range]intValue];
                            socketTime.thursday = thursday==1;
                            
                            range = NSMakeRange(5, 1);
                            int wednesday = [[weekStr substringWithRange:range]intValue];
                            socketTime.wednesday = wednesday==1;
                            
                            range = NSMakeRange(6, 1);
                            int tuesday = [[weekStr substringWithRange:range]intValue];
                            socketTime.tuesday = tuesday==1;
                            
                            range = NSMakeRange(7, 1);
                            int monday = [[weekStr substringWithRange:range]intValue];
                            socketTime.monday = monday==1;
                        }
                        break;
                        
                        case 4:
                        {
                            int hour = bytes[6 + i * 6 + j];
                            socketTime.hour = hour;
                        }
                        break;
                        
                        case 5:
                        {
                            int minute = bytes[6 + i * 6 + j];
                            socketTime.minute = minute;
                        }
                        break;
                        
                        default:
                        break;
                    }
                }
                if(!(!socketTime.isValid && !socketTime.onOff && socketTime.socket_num==0 && !socketTime.monday
                     && !socketTime.tuesday && !socketTime.wednesday && !socketTime.thursday && !socketTime.friday
                     && !socketTime.saturday && !socketTime.sunday && socketTime.hour==0 && socketTime.minute==0)) {
                    
                    [_timeArray addObject:socketTime];
                }
            }
            if(self.isViewVisable){
                SocketTimeViewController *controller = [[SocketTimeViewController alloc]init];
                controller.timeArray = _timeArray;
                controller.device = _device;
                _socketTimeController = controller;
                [self.navigationController pushViewController:controller animated:YES];
            }
            else{
                if(_socketTimeController!=nil){
                    [MBProgressHUD hideHUDForView:_socketTimeController.view animated:true];
                    _socketTimeController.timeArray = _timeArray;
                    [_socketTimeController refreshView];
                }
            }
        }
        else if(bytes[4]==0x0b){
            int number = bytes[6];
            int res = bytes[7];
            if(res==0){//成功
                if(_socketTimeController!=nil){
                    [_socketTimeController hideChild:YES];
                }
                char input1[7] = {0x53, 0x5A, 0x57, 0x4C, 0x08, 0x00, 0x58};
                NSData* data = [NSData dataWithBytes:input1 length:sizeof(input1)];
                NSDictionary *request = @{@"binary": data};
                [self.device write:request withSN:0];
            }
            else{
                [MBProgressHUD hideHUDForView:_socketTimeController.view animated:true];
                if(_socketTimeController!=nil){
                    [_socketTimeController hideChild:NO];
                }
            }
        }
        else if(bytes[4]==0x11){
            _callArray = [[NSMutableArray alloc]init];
            for(int i=0; i<7; i++){
                AlarmCall *alarmCall = [[AlarmCall alloc]init];
                alarmCall.number = [[NSMutableArray alloc]init];
                for(int j=0; j<35; j++){
                    switch (j) {
                        case 0:
                        {
                            alarmCall.callEnable = bytes[6+i*35+j]==1;
                        }
                        break;
                        
                        case 1:
                        {
                            alarmCall.smsEnable = bytes[6+i*35+j]==1;
                        }
                        break;
                        
                        case 2:
                        {
                            alarmCall.rfidEnable = bytes[6+i*35+j]==1;
                        }
                        break;
                        
                        case 3:
                        {
                            alarmCall.numLength = bytes[6+i*35+j];
                        }
                        break;
                        
                        default:
                        {
                            int number = bytes[6+i*35+j];
                            NSString *string = [NSString stringWithFormat:@"%c", number];
                            [alarmCall.number addObject:string];
                        }
                        break;
                    }
                }
                if(alarmCall.numLength>0){
                    alarmCall.index = i;
                    [_callArray addObject:alarmCall];
                }
            }
            if(self.isViewVisable){
                AlarmPhoneViewController *controller = [[AlarmPhoneViewController alloc]init];
                controller.callArray = _callArray;
                _alarmPhoneViewController = controller;
                _alarmPhoneViewController.device = self.device;
                [self.navigationController pushViewController:controller animated:YES];
            }
            else{
                if(_alarmPhoneViewController!=nil){
                    [MBProgressHUD hideHUDForView:_alarmPhoneViewController.view animated:true];
                    _alarmPhoneViewController.callArray = _callArray;
                    [_alarmPhoneViewController refreshView];
                }
            }
        }
        else if(bytes[4]==0x13){
            int number = bytes[6];
            int res = bytes[7];
            if(res==0){
                if(_alarmPhoneViewController!=nil){
                   [_alarmPhoneViewController hideChild:YES];
                }
                char input1[7] = {0x53, 0x5A, 0x57, 0x4C, 0x10, 0x00, 0x60};
                NSData* data = [NSData dataWithBytes:input1 length:sizeof(input1)];
                NSDictionary *request = @{@"binary": data};
                [self.device write:request withSN:0];
            }
            else{
                [MBProgressHUD hideHUDForView:_alarmPhoneViewController.view animated:true];
                if(_alarmPhoneViewController!=nil){
                    [_alarmPhoneViewController hideChild:NO];
                }
            }
        }
        else if(bytes[4]==0x19){
            int length = bytes[5];
            int group = length/5;
            _alarmRecordArray = [[NSMutableArray alloc]init];
            for(int i=0; i<group; i++){
                AlarmRecord *alarmRecord = [[AlarmRecord alloc]init];
                Byte time[4];
                for(int j=0; j<5; j++){
                    if(j<4){
                        time[3-j] = bytes[6+i*5+j];
                    }
                }
                alarmRecord.time = [self lBytesToInt:time];
                alarmRecord.reason = bytes[6+i*5+4];
                [alarmRecord getTime];
                [alarmRecord getReason];
                
                [_alarmRecordArray insertObject:alarmRecord atIndex:0];
            }
            if(self.isViewVisable){
                AlarmRecordViewController *controller = [[AlarmRecordViewController alloc]init];
                controller.recordArray = _alarmRecordArray;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
        else if(bytes[4]==0x1B){
            int length = bytes[5];
            int group = length/6;
            _alarmDisarmRecordArray = [[NSMutableArray alloc]init];
            for(int i=0; i<group; i++){
                AlarmDisarmRecord *alarmDisarmRecord = [[AlarmDisarmRecord alloc]init];
                Byte time[4];
                for(int j=0; j<6; j++){
                    if(j<4){
                        time[3-j] = bytes[6+i*6+j];
                    }
                }
                alarmDisarmRecord.time = [self lBytesToInt:time];
                alarmDisarmRecord.reason = bytes[6+i*6+4];
                alarmDisarmRecord.type = bytes[6+i*6+5];
                [alarmDisarmRecord getTime];
                [alarmDisarmRecord getReason];
                [alarmDisarmRecord getType];
                [_alarmDisarmRecordArray insertObject:alarmDisarmRecord atIndex:0];
            }
            if(self.isViewVisable){
                ArmDisarmViewController *controller = [[ArmDisarmViewController alloc]init];
                controller.recordArray = _alarmDisarmRecordArray;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }
    else{
        //读取设备状态
        NSDictionary *data = [dataMap valueForKey:@"data"];
        
        if(data != nil && [data count] != 0)
        {
            int alarmZone = [[data valueForKey:@"AlarmZone"]intValue];
            if(_previoutNum!=alarmZone){
                _previoutNum = alarmZone;
                NSString *warn_mess = @"";
                if(alarmZone>0 && alarmZone<100){
                    warn_mess = [NSString stringWithFormat:@"%d防区报警", alarmZone];
                }
                else if(alarmZone==126){
                    warn_mess = @"电量不足";
                }
                else if(alarmZone==125){
                    warn_mess = @"交流电关";
                }
                else if(alarmZone==124){
                    warn_mess = @"交流电开";
                }
                if(![warn_mess isEqualToString:@""]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警报" message:warn_mess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            
            // 读取所有数据点值
            [self.deviceControl readDataPointsFromData:dataMap];
            [self.tableView reloadData];
            if(self.deviceControl.key_ZoneStatus==0){
                [self.alarm setBackgroundImage:[UIImage imageNamed:@"arm"] forState:UIControlStateNormal];
                [self.disarm setBackgroundImage:[UIImage imageNamed:@"disarm_cover"] forState:UIControlStateNormal];
                [self.home_alarm setBackgroundImage:[UIImage imageNamed:@"homedisarm"] forState:UIControlStateNormal];
            }
            else if(self.deviceControl.key_ZoneStatus==1){
                [self.alarm setBackgroundImage:[UIImage imageNamed:@"arm_cover"] forState:UIControlStateNormal];
                [self.disarm setBackgroundImage:[UIImage imageNamed:@"disarm"] forState:UIControlStateNormal];
                [self.home_alarm setBackgroundImage:[UIImage imageNamed:@"homedisarm"] forState:UIControlStateNormal];
            }
            else{
                [self.alarm setBackgroundImage:[UIImage imageNamed:@"arm"] forState:UIControlStateNormal];
                [self.disarm setBackgroundImage:[UIImage imageNamed:@"disarm"] forState:UIControlStateNormal];
                [self.home_alarm setBackgroundImage:[UIImage imageNamed:@"homedisarm_cover"] forState:UIControlStateNormal];
            }
        }
    }
    // 显示所有报警和故障
//    [self showAlertAndFaults:dataMap];
}

-(long) lBytesToInt:(Byte[]) b
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date1=[dateFormatter dateFromString:@"2000-01-01 00:00:00"];
    
    long t = [date1 timeIntervalSince1970];
    
    long date = (b[3] & 0xFF) |
    (b[2] & 0xFF) << 8 |
    (b[1] & 0xFF) << 16 |
    (b[0] & 0xFF) << 24;
    
    return date+t;
}

// 设备离在线状态回调
- (void)device:(GizWifiDevice *)device didUpdateNetStatus:(GizWifiDeviceNetStatus)netStatus
{
    if (netStatus == GizDeviceControlled)
    {
        [self.queue cancelAllOperations];
        [[GosTipView sharedInstance] hideTipView];
        [self.device getDeviceStatus:nil];
        return;
    }
    
    if (netStatus != GizDeviceControlled && self.navigationController.viewControllers.lastObject == self)
    {
        [[GosTipView sharedInstance] showTipMessage:NSLocalizedString(@"cut_link", nil)  delay:1 completion:^{
            [self onBack];
        }];
    }
}

// 设置设备别名回调
- (void)device:(GizWifiDevice *)device didSetCustomInfo:(NSError *)result
{
    [self.tipView hideTipView];
    if (result.code == GIZ_SDK_SUCCESS)
    {
        [self.tipView showTipMessage:NSLocalizedString(@"set_success", nil) delay:1 completion:^{
            [self onBack];
        }];
    }
    else
    {
        [self.tipView showTipMessage:NSLocalizedString(@"set_fail", nil) delay:1 completion:nil];
    }
}

// 获取设备硬件信息回调
- (void)device:(GizWifiDevice *)device didGetHardwareInfo:(NSError *)result hardwareInfo:(NSDictionary *)hardwareInfo
{
    NSString *hardWareInfo = [NSString stringWithFormat:@"WiFi Hardware Version: %@,\nWiFi Software Version: %@,\nMCU Hardware Version: %@,\nMCU Software Version: %@,\nFirmware Id: %@,\nFirmware Version: %@,\nProduct Key: %@,\nDevice ID: %@,\nDevice IP: %@,\nDevice MAC: %@"
                              , [hardwareInfo valueForKey:@"wifiHardVersion"]
                              , [hardwareInfo valueForKey:@"wifiSoftVersion"]
                              , [hardwareInfo valueForKey:@"mcuHardVersion"]
                              , [hardwareInfo valueForKey:@"mcuSoftVersion"]
                              , [hardwareInfo valueForKey:@"wifiFirmwareId"]
                              , [hardwareInfo valueForKey:@"wifiFirmwareVer"]
                              , [hardwareInfo valueForKey:@"productKey"]
                              , self.device.did, self.device.ipAddress, self.device.macAddress];
    dispatch_async(dispatch_get_main_queue(), ^{
        _alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"device_info", nil) message:hardWareInfo delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [self.alertView show];
    });
}

/**
 将报警和故障显示到界面
 
 @param dataMap 数据点集合
 */
- (void)showAlertAndFaults:(NSDictionary *)dataMap
{
    /**
     * 报警和错误
     */
    if ([self.navigationController.viewControllers lastObject] != self) return;
    
    NSString *str = @"";
    NSArray *alerts = [dataMap valueForKey:@"alerts"];
    NSArray *faults = [dataMap valueForKey:@"faults"];
    
    if (alerts.count == 0 && faults.count == 0) return;
    if (alerts.count > 0)
    {
        BOOL isFirst = YES;
        for (NSString *name in alerts)
        {
            NSNumber *value = [alerts valueForKey:name];
            
            if (![value isKindOfClass:[NSNumber class]]) continue;
            if ([value integerValue] == 0) continue;
            
            if (isFirst)
            {
                str = NSLocalizedString(@"device_alarm", nil);
                isFirst = NO;
            }
            
            if (str.length > 0)
            {
                str = [str stringByAppendingString:@"\n"];
            }
            
            NSString *alert = [NSString stringWithFormat:NSLocalizedString(@"error_code", nil), name, value];
            str = [str stringByAppendingString:alert];
        }
    }
    
    if (faults.count > 0)
    {
        BOOL isFirst = YES;
        
        for (NSString *name in faults)
        {
            NSNumber *value = [faults valueForKey:name];
            
            if (![value isKindOfClass:[NSNumber class]]) continue;
            if ([value integerValue] == 0) continue;
            
            if (isFirst)
            {
                if (str.length > 0)
                {
                    str = [str stringByAppendingString:@"\n"];
                }
                str = [str stringByAppendingString:NSLocalizedString(@"device_error", nil)];
                isFirst = NO;
            }
            
            if (str.length > 0)
            {
                str = [str stringByAppendingString:@"\n"];
            }
            
            NSString *fault = [NSString stringWithFormat:NSLocalizedString(@"error_code", nil), name, value];
            str = [str stringByAppendingString:fault];
        }
    }
    
    if (str.length > 0)
    {
        [[GosCommon sharedInstance] showAlert:str disappear:YES];
    }
}


#pragma mark - Table view data source And delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet1_Cell = (GosDeviceBoolCell *)cell;
            Outlet1_Cell.title = @"Outlet1";
            Outlet1_Cell.value = self.deviceControl.key_Outlet1;
            Outlet1_Cell.dataPoint = GosDevice_Outlet1;
            Outlet1_Cell.isWrite = YES;
            Outlet1_Cell.delegate = self;
            return cell;
  
        }
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet2_Cell = (GosDeviceBoolCell *)cell;
            Outlet2_Cell.title = @"Outlet2";
            Outlet2_Cell.value = self.deviceControl.key_Outlet2;
            Outlet2_Cell.dataPoint = GosDevice_Outlet2;
            Outlet2_Cell.isWrite = YES;
            Outlet2_Cell.delegate = self;
            return cell;
  
        }
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet3_Cell = (GosDeviceBoolCell *)cell;
            Outlet3_Cell.title = @"Outlet3";
            Outlet3_Cell.value = self.deviceControl.key_Outlet3;
            Outlet3_Cell.dataPoint = GosDevice_Outlet3;
            Outlet3_Cell.isWrite = YES;
            Outlet3_Cell.delegate = self;
            return cell;
  
        }
        case 3:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet4_Cell = (GosDeviceBoolCell *)cell;
            Outlet4_Cell.title = @"Outlet4";
            Outlet4_Cell.value = self.deviceControl.key_Outlet4;
            Outlet4_Cell.dataPoint = GosDevice_Outlet4;
            Outlet4_Cell.isWrite = YES;
            Outlet4_Cell.delegate = self;
            return cell;
  
        }
        case 4:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet5_Cell = (GosDeviceBoolCell *)cell;
            Outlet5_Cell.title = @"Outlet5";
            Outlet5_Cell.value = self.deviceControl.key_Outlet5;
            Outlet5_Cell.dataPoint = GosDevice_Outlet5;
            Outlet5_Cell.isWrite = YES;
            Outlet5_Cell.delegate = self;
            return cell;
  
        }
        case 5:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet6_Cell = (GosDeviceBoolCell *)cell;
            Outlet6_Cell.title = @"Outlet6";
            Outlet6_Cell.value = self.deviceControl.key_Outlet6;
            Outlet6_Cell.dataPoint = GosDevice_Outlet6;
            Outlet6_Cell.isWrite = YES;
            Outlet6_Cell.delegate = self;
            return cell;
  
        }
        case 6:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet7_Cell = (GosDeviceBoolCell *)cell;
            Outlet7_Cell.title = @"Outlet7";
            Outlet7_Cell.value = self.deviceControl.key_Outlet7;
            Outlet7_Cell.dataPoint = GosDevice_Outlet7;
            Outlet7_Cell.isWrite = YES;
            Outlet7_Cell.delegate = self;
            return cell;
  
        }
        case 7:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet8_Cell = (GosDeviceBoolCell *)cell;
            Outlet8_Cell.title = @"Outlet8";
            Outlet8_Cell.value = self.deviceControl.key_Outlet8;
            Outlet8_Cell.dataPoint = GosDevice_Outlet8;
            Outlet8_Cell.isWrite = YES;
            Outlet8_Cell.delegate = self;
            return cell;
  
        }
        case 8:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet9_Cell = (GosDeviceBoolCell *)cell;
            Outlet9_Cell.title = @"Outlet9";
            Outlet9_Cell.value = self.deviceControl.key_Outlet9;
            Outlet9_Cell.dataPoint = GosDevice_Outlet9;
            Outlet9_Cell.isWrite = YES;
            Outlet9_Cell.delegate = self;
            return cell;
  
        }
        case 9:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet10_Cell = (GosDeviceBoolCell *)cell;
            Outlet10_Cell.title = @"Outlet10";
            Outlet10_Cell.value = self.deviceControl.key_Outlet10;
            Outlet10_Cell.dataPoint = GosDevice_Outlet10;
            Outlet10_Cell.isWrite = YES;
            Outlet10_Cell.delegate = self;
            return cell;
  
        }
        case 10:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet11_Cell = (GosDeviceBoolCell *)cell;
            Outlet11_Cell.title = @"Outlet11";
            Outlet11_Cell.value = self.deviceControl.key_Outlet11;
            Outlet11_Cell.dataPoint = GosDevice_Outlet11;
            Outlet11_Cell.isWrite = YES;
            Outlet11_Cell.delegate = self;
            return cell;
  
        }
        case 11:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet12_Cell = (GosDeviceBoolCell *)cell;
            Outlet12_Cell.title = @"Outlet12";
            Outlet12_Cell.value = self.deviceControl.key_Outlet12;
            Outlet12_Cell.dataPoint = GosDevice_Outlet12;
            Outlet12_Cell.isWrite = YES;
            Outlet12_Cell.delegate = self;
            return cell;
  
        }
        case 12:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet13_Cell = (GosDeviceBoolCell *)cell;
            Outlet13_Cell.title = @"Outlet13";
            Outlet13_Cell.value = self.deviceControl.key_Outlet13;
            Outlet13_Cell.dataPoint = GosDevice_Outlet13;
            Outlet13_Cell.isWrite = YES;
            Outlet13_Cell.delegate = self;
            return cell;
  
        }
        case 13:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet14_Cell = (GosDeviceBoolCell *)cell;
            Outlet14_Cell.title = @"Outlet14";
            Outlet14_Cell.value = self.deviceControl.key_Outlet14;
            Outlet14_Cell.dataPoint = GosDevice_Outlet14;
            Outlet14_Cell.isWrite = YES;
            Outlet14_Cell.delegate = self;
            return cell;
  
        }
        case 14:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet15_Cell = (GosDeviceBoolCell *)cell;
            Outlet15_Cell.title = @"Outlet15";
            Outlet15_Cell.value = self.deviceControl.key_Outlet15;
            Outlet15_Cell.dataPoint = GosDevice_Outlet15;
            Outlet15_Cell.isWrite = YES;
            Outlet15_Cell.delegate = self;
            return cell;
  
        }
        case 15:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet16_Cell = (GosDeviceBoolCell *)cell;
            Outlet16_Cell.title = @"Outlet16";
            Outlet16_Cell.value = self.deviceControl.key_Outlet16;
            Outlet16_Cell.dataPoint = GosDevice_Outlet16;
            Outlet16_Cell.isWrite = YES;
            Outlet16_Cell.delegate = self;
            return cell;
  
        }
        case 16:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet17_Cell = (GosDeviceBoolCell *)cell;
            Outlet17_Cell.title = @"Outlet17";
            Outlet17_Cell.value = self.deviceControl.key_Outlet17;
            Outlet17_Cell.dataPoint = GosDevice_Outlet17;
            Outlet17_Cell.isWrite = YES;
            Outlet17_Cell.delegate = self;
            return cell;
  
        }
        case 17:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet18_Cell = (GosDeviceBoolCell *)cell;
            Outlet18_Cell.title = @"Outlet18";
            Outlet18_Cell.value = self.deviceControl.key_Outlet18;
            Outlet18_Cell.dataPoint = GosDevice_Outlet18;
            Outlet18_Cell.isWrite = YES;
            Outlet18_Cell.delegate = self;
            return cell;
  
        }
        case 18:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet19_Cell = (GosDeviceBoolCell *)cell;
            Outlet19_Cell.title = @"Outlet19";
            Outlet19_Cell.value = self.deviceControl.key_Outlet19;
            Outlet19_Cell.dataPoint = GosDevice_Outlet19;
            Outlet19_Cell.isWrite = YES;
            Outlet19_Cell.delegate = self;
            return cell;
  
        }
        case 19:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceBoolCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceBoolCell *Outlet20_Cell = (GosDeviceBoolCell *)cell;
            Outlet20_Cell.title = @"Outlet20";
            Outlet20_Cell.value = self.deviceControl.key_Outlet20;
            Outlet20_Cell.dataPoint = GosDevice_Outlet20;
            Outlet20_Cell.isWrite = YES;
            Outlet20_Cell.delegate = self;
            return cell;
  
        }
        case 20:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceEnumCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceEnumCell *ZoneStatus_Cell = (GosDeviceEnumCell *)cell;
            ZoneStatus_Cell.title = @"ZoneStatus";
            ZoneStatus_Cell.values = @[@"eZone_Disarming",@"eZone_Arming",@"eZone_HomeArming"];
            ZoneStatus_Cell.index = self.deviceControl.key_ZoneStatus;
            ZoneStatus_Cell.dataPoint = GosDevice_ZoneStatus;
            ZoneStatus_Cell.isWrite = YES;
            ZoneStatus_Cell.delegate = self;
            return cell;
  
        }
        case 21:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GosDeviceLabelCellReuseIdentifier forIndexPath:indexPath];
            GosDeviceLabelCell *AlarmZone_Cell = (GosDeviceLabelCell *)cell;
            AlarmZone_Cell.title = @"AlarmZone";
            AlarmZone_Cell.value = self.deviceControl.key_AlarmZone;
            AlarmZone_Cell.radio = @"1";
            AlarmZone_Cell.addition = @"0";
            AlarmZone_Cell.dataPoint = GosDevice_AlarmZone;
            [AlarmZone_Cell updateUI];
            return cell;
  
        }
        default:
            return nil;
    }
}

#pragma mark - GosDeviceBoolCellDelegate - 可写布尔型回调
// 开关状态变化回调
- (void)deviceBoolCell:(GosDeviceBoolCell *)cell switchDidUpdateValue:(BOOL)value
{
    NSLog(@"deviceBoolCell布尔值发生改变: %d", value);
    [self.deviceControl writeDataPoint:cell.dataPoint value:[NSNumber numberWithBool:value]];
}

#pragma mark - GosDeviceEnumCellDelegate - 可写枚举值回调
// 选中枚举控件回调
- (void)deviceEnumCellDidSelected:(GosDeviceEnumCell *)cell
{
    GosDeviceEnumSelectionController *deviceEnumController = [[GosDeviceEnumSelectionController alloc] initWithEnumCell:cell];
    [deviceEnumController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackControl)]];
    [self.navigationController pushViewController:deviceEnumController animated:YES];
}

// 选中数据点的某个枚举值回调
- (void)deviceEnumCell:(GosDeviceEnumCell *)cell didSelectedIndex:(NSInteger)index
{
    [self.deviceControl writeDataPoint:cell.dataPoint value:[NSNumber numberWithInteger:index]];
}

#pragma mark - 界面设置
// 设置显示界面
- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
    [self setupNavigationBar];
    
    // 设置数据点初始值，更新界面
    [self.deviceControl initDevice];
    [self.tableView reloadData];
    
    [self initButton];
    _isShow = YES;
}

- (void)setupTableView
{
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"GosDeviceLabelCell" bundle:nil] forCellReuseIdentifier:GosDeviceLabelCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"GosDeviceBoolCell" bundle:nil] forCellReuseIdentifier:GosDeviceBoolCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"GosDeviceEnumCell" bundle:nil] forCellReuseIdentifier:GosDeviceEnumCellReuseIdentifier];
}

- (void)initButton
{
    _myView = [[UIView alloc]initWithFrame:self.view.bounds];
    _myView.backgroundColor = [UIColor whiteColor];
    int pic_width = (SCREENWIDTH-150)/3;
    
    UIButton *socket_time = [[UIButton alloc]initWithFrame:CGRectMake(30, 100, pic_width, pic_width)];
    [socket_time setBackgroundImage:[UIImage imageNamed:@"socket_time_search"] forState:UIControlStateNormal];
    socket_time.tag = 1;
    [socket_time addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:socket_time];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(socket_time.frame), pic_width, 30)];
    label1.text = NSLocalizedString(@"time_switch", nil);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:13];
    label1.textColor = [UIColor blackColor];
    [_myView addSubview:label1];
    
    UIButton *alarm_phone = [[UIButton alloc]initWithFrame:CGRectMake(75+pic_width, 100, pic_width, pic_width)];
    [alarm_phone setBackgroundImage:[UIImage imageNamed:@"search_alarm_phone"] forState:UIControlStateNormal];
    alarm_phone.tag = 2;
    [alarm_phone addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:alarm_phone];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(75+pic_width, CGRectGetMaxY(alarm_phone.frame), pic_width, 30)];
    label2.text = NSLocalizedString(@"alarm_phone", nil);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:13];
    label2.textColor = [UIColor blackColor];
    [_myView addSubview:label2];
    
    UIButton *alarm_record = [[UIButton alloc]initWithFrame:CGRectMake(120+pic_width*2, 100, pic_width, pic_width)];
    [alarm_record setBackgroundImage:[UIImage imageNamed:@"search_alarm_record"] forState:UIControlStateNormal];
    alarm_record.tag = 3;
    [alarm_record addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:alarm_record];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(120+pic_width*2, CGRectGetMaxY(alarm_record.frame), pic_width, 30)];
    label3.text = NSLocalizedString(@"alarm_record", nil);
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:13];
    label3.textColor = [UIColor blackColor];
    [_myView addSubview:label3];
    
    UIButton *alarm_disalarm_record = [[UIButton alloc]initWithFrame:CGRectMake(30, 100+pic_width+50, pic_width, pic_width)];
    [alarm_disalarm_record setBackgroundImage:[UIImage imageNamed:@"search_alarm_disarm_record"] forState:UIControlStateNormal];
    alarm_disalarm_record.tag = 4;
    [alarm_disalarm_record addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:alarm_disalarm_record];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(alarm_disalarm_record.frame), pic_width, 30)];
    label4.text = NSLocalizedString(@"cloth_withdrawal_record", nil);
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font = [UIFont systemFontOfSize:13];
    label4.textColor = [UIColor blackColor];
    [_myView addSubview:label4];
    
    UIButton *socket_outlet = [[UIButton alloc]initWithFrame:CGRectMake(75+pic_width, 100+pic_width+50, pic_width, pic_width)];
    [socket_outlet setBackgroundImage:[UIImage imageNamed:@"smart_socket"] forState:UIControlStateNormal];
    socket_outlet.tag = 5;
    [socket_outlet addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:socket_outlet];
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(75+pic_width, CGRectGetMaxY(alarm_disalarm_record.frame), pic_width, 30)];
    label5.text = NSLocalizedString(@"smart_switch", nil);
    label5.textAlignment = NSTextAlignmentCenter;
    label5.font = [UIFont systemFontOfSize:13];
    label5.textColor = [UIColor blackColor];
    [_myView addSubview:label5];
    
    self.alarm = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(alarm_disalarm_record.frame)+80, pic_width, pic_width)];
    [self.alarm setBackgroundImage:[UIImage imageNamed:@"arm"] forState:UIControlStateNormal];
    self.alarm.tag = 6;
    [self.alarm addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:self.alarm];
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.alarm.frame), pic_width, 30)];
    label6.text = NSLocalizedString(@"alarm", nil);
    label6.textAlignment = NSTextAlignmentCenter;
    label6.font = [UIFont systemFontOfSize:13];
    label6.textColor = [UIColor blackColor];
    [_myView addSubview:label6];
    
    self.disarm = [[UIButton alloc]initWithFrame:CGRectMake(75+pic_width, CGRectGetMaxY(alarm_disalarm_record.frame)+80, pic_width, pic_width)];
    [self.disarm setBackgroundImage:[UIImage imageNamed:@"disarm"] forState:UIControlStateNormal];
    self.disarm.tag = 7;
    [self.disarm addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:self.disarm];
    
    UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(75+pic_width, CGRectGetMaxY(self.disarm.frame), pic_width, 30)];
    label7.text = NSLocalizedString(@"disarm", nil);
    label7.textAlignment = NSTextAlignmentCenter;
    label7.font = [UIFont systemFontOfSize:13];
    label7.textColor = [UIColor blackColor];
    [_myView addSubview:label7];
    
    self.home_alarm = [[UIButton alloc]initWithFrame:CGRectMake(120+pic_width*2, CGRectGetMaxY(alarm_disalarm_record.frame)+80, pic_width, pic_width)];
    [self.home_alarm setBackgroundImage:[UIImage imageNamed:@"homedisarm"] forState:UIControlStateNormal];
    self.home_alarm.tag = 8;
    [self.home_alarm addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:self.home_alarm];
    
    UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(120+pic_width*2, CGRectGetMaxY(self.home_alarm.frame), pic_width, 30)];
    label8.text = NSLocalizedString(@"stay_in_guard", nil);
    label8.textAlignment = NSTextAlignmentCenter;
    label8.font = [UIFont systemFontOfSize:13];
    label8.textColor = [UIColor blackColor];
    [_myView addSubview:label8];
    
    [self.view addSubview:_myView];
}

- (void)onBackControl
{
    // 返回前一个界面
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonClick:(UIButton *)sender{
    NSInteger tag = sender.tag;
    switch (tag) {
        case 1:
        {
            char input1[7] = {0x53, 0x5A, 0x57, 0x4C, 0x08, 0x00, 0x58};
            // char input2[7] = {11, 22, 33, 44, 55, 66, 77};
            NSData* data = [NSData dataWithBytes:input1 length:sizeof(input1)];
            NSDictionary *request = @{@"binary": data};
            [self.device write:request withSN:0];
        }
            break;
        
        case 2:
        {
            char input1[7] = {0x53, 0x5A, 0x57, 0x4C, 0x10, 0x00, 0x60};
            // char input2[7] = {11, 22, 33, 44, 55, 66, 77};
            NSData* data = [NSData dataWithBytes:input1 length:sizeof(input1)];
            NSDictionary *request = @{@"binary": data};
            [self.device write:request withSN:0];
        }
            break;
        
        case 3:
        {
            char input1[7] = {0x53, 0x5A, 0x57, 0x4C, 0x18, 0x00, 0x68};
            // char input2[7] = {11, 22, 33, 44, 55, 66, 77};
            NSData* data = [NSData dataWithBytes:input1 length:sizeof(input1)];
            NSDictionary *request = @{@"binary": data};
            [self.device write:request withSN:0];
        }
            break;
        
        case 4:
        {
            char input1[7] = {0x53, 0x5A, 0x57, 0x4C, 0x1A, 0x00, 0x6A};
            // char input2[7] = {11, 22, 33, 44, 55, 66, 77};
            NSData* data = [NSData dataWithBytes:input1 length:sizeof(input1)];
            NSDictionary *request = @{@"binary": data};
            [self.device write:request withSN:0];
        }
            break;
        
        case 5:
        {
            if(!_isShow){
                _myView.hidden = NO;
                _isShow = YES;
                self.navigationItem.title = self.deviceName;
            }
            else{
                _myView.hidden = YES;
                _isShow = NO;
                self.navigationItem.title = NSLocalizedString(@"setting_switch_state", nil);
            }
        }
            break;
        
        case 6:
        {
            [self.alarm setBackgroundImage:[UIImage imageNamed:@"arm_cover"] forState:UIControlStateNormal];
            [self.disarm setBackgroundImage:[UIImage imageNamed:@"disarm"] forState:UIControlStateNormal];
            [self.home_alarm setBackgroundImage:[UIImage imageNamed:@"homedisarm"] forState:UIControlStateNormal];
            [self.deviceControl writeDataPoint:GosDevice_ZoneStatus value:[NSNumber numberWithInteger:1]];
        }
            break;
        
        case 7:
        {
            [self.alarm setBackgroundImage:[UIImage imageNamed:@"arm"] forState:UIControlStateNormal];
            [self.disarm setBackgroundImage:[UIImage imageNamed:@"disarm_cover"] forState:UIControlStateNormal];
            [self.home_alarm setBackgroundImage:[UIImage imageNamed:@"homedisarm"] forState:UIControlStateNormal];
            [self.deviceControl writeDataPoint:GosDevice_ZoneStatus value:[NSNumber numberWithInteger:0]];
        }
            break;
        
        case 8:
        {
            [self.alarm setBackgroundImage:[UIImage imageNamed:@"arm"] forState:UIControlStateNormal];
            [self.disarm setBackgroundImage:[UIImage imageNamed:@"disarm"] forState:UIControlStateNormal];
            [self.home_alarm setBackgroundImage:[UIImage imageNamed:@"homedisarm_cover"] forState:UIControlStateNormal];
            [self.deviceControl writeDataPoint:GosDevice_ZoneStatus value:[NSNumber numberWithInteger:2]];
        }
            break;
        
        default:
        break;
    }
}

// tableView移动时退出键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}

#pragma mark - Properity
- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        UITableView *tb = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:tb];
        _tableView = tb;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (GosDeviceControl *)deviceControl
{
    return [GosDeviceControl sharedInstance];
}

- (NSString *)deviceName
{
    if (_deviceName == nil)
    {
       _deviceName = self.device.alias == nil || [self.device.alias isEqualToString:@""] ? self.device.productName : self.device.alias;
    }
    return _deviceName;
}

- (GosTipView *)tipView
{
    return [GosTipView sharedInstance];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isViewVisable = YES;
    self.deviceControl.isFirstView = true;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isViewVisable = NO;
    self.deviceControl.isFirstView = false;
}

@end
