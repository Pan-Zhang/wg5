//
//  GsmViewController.m
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/5/11.
//  Copyright © 2018年 Gizwits. All rights reserved.
//



#import "GsmViewController.h"
#import "GsmSettingsView.h"
#import "GsmReplyView.h"
#import "GsmSMSview.h"//短信通知
#import "GSMSmartSwitchViewController.h"//智能开关
#import "GSMScheduledArmingViewController.h"//定时布撤防
#import "DelayArmDisarmViewController.h"//延时布撤防
#import "GSMApplianceTimingViewController.h"//家电定时
#import "GSMEmergencyCallViewController.h"//报警电话

#import "GSMMenuView.h"//菜单
#import "GSMOnWeViewController.h"//关于
#import "GSMSwitchUserViewController.h"//切换用户

#define GSMCallBack [NSString stringWithFormat:@"%@1400",self.userInfo.password]//电话回拨
#define GSMDisarmCheck [NSString stringWithFormat:@"%@0000",self.userInfo.password]//布撤防查询
#define GSMSMSReply [NSString stringWithFormat:@"%@1501%@",self.userInfo.password,self.userInfo.smsswitch]//短信回复开关
#define GSMDisarmSMSCheck [NSString stringWithFormat:@"%@1600",self.userInfo.password]//布撤防短信查询
#define GSMSMSNoticeSAVE [NSString stringWithFormat:@"%@1703%@%@%@",self.userInfo.password,self.userInfo.ArmSmsNotice,self.userInfo.DisarmSmsNotice,self.userInfo.HomeSmsNotice]//布撤防短信通知设置

#define GSMA_D_H_Settings [NSString stringWithFormat:@"%@0101%@",self.userInfo.password,self.userInfo.A_D_H_Settings]//布撤防短信通知设置

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽
#define MCStatusBarH [[UIApplication sharedApplication] statusBarFrame].size.height+44.0

@interface GsmViewController (){
    BOOL isHidderMenuView;
}

@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) UIButton *alarm;
@property (nonatomic, strong) UIButton *disarm;
@property (nonatomic, strong) UIButton *home_alarm;

@end

@implementation GsmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isHidderMenuView = NO;
    
    [self initView];
    
    [self setnavigationItem];
}

- (void)initView{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    
    _myView = [[UIView alloc]initWithFrame:self.view.bounds];
    _myView.backgroundColor = [UIColor whiteColor];
    int pic_width = (SCREENWIDTH-150)/3;
    
    UIButton *socket_time = [[UIButton alloc]initWithFrame:CGRectMake(30, 10, pic_width, pic_width)];
    [socket_time setBackgroundImage:[UIImage imageNamed:@"call_back"] forState:UIControlStateNormal];
    socket_time.tag = 1;
    [socket_time addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:socket_time];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(socket_time.frame), pic_width, 30)];
    label1.text = NSLocalizedString(@"call_back", nil);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:13];
    label1.textColor = [UIColor blackColor];
    [_myView addSubview:label1];
    
    UIButton *alarm_phone = [[UIButton alloc]initWithFrame:CGRectMake(75+pic_width, 10, pic_width, pic_width)];
    [alarm_phone setBackgroundImage:[UIImage imageNamed:@"arm_disarm_query"] forState:UIControlStateNormal];
    alarm_phone.tag = 2;
    [alarm_phone addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:alarm_phone];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(75+pic_width, CGRectGetMaxY(alarm_phone.frame), pic_width, 30)];
    label2.text = NSLocalizedString(@"arm_disarm_query", nil);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:13];
    label2.textColor = [UIColor blackColor];
    [_myView addSubview:label2];
    
    UIButton *alarm_record = [[UIButton alloc]initWithFrame:CGRectMake(120+pic_width*2, 10, pic_width, pic_width)];
    [alarm_record setBackgroundImage:[UIImage imageNamed:@"delay_arm_disarm"] forState:UIControlStateNormal];
    alarm_record.tag = 3;
    [alarm_record addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:alarm_record];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(120+pic_width*2, CGRectGetMaxY(alarm_record.frame), pic_width, 30)];
    label3.text = NSLocalizedString(@"delay_arm_disarm", nil);
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:13];
    label3.textColor = [UIColor blackColor];
    [_myView addSubview:label3];
    
    //第二排
    
    UIButton *alarm_disalarm_record = [[UIButton alloc]initWithFrame:CGRectMake(30, 10+pic_width+50, pic_width, pic_width)];
    [alarm_disalarm_record setBackgroundImage:[UIImage imageNamed:@"time_arm_disarm"] forState:UIControlStateNormal];
    alarm_disalarm_record.tag = 4;
    [alarm_disalarm_record addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:alarm_disalarm_record];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(alarm_disalarm_record.frame), pic_width, 30)];
    label4.text = NSLocalizedString(@"time_arm_disarm", nil);
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font = [UIFont systemFontOfSize:13];
    label4.textColor = [UIColor blackColor];
    [_myView addSubview:label4];
    
    UIButton *socket_outlet = [[UIButton alloc]initWithFrame:CGRectMake(75+pic_width, 10+pic_width+50, pic_width, pic_width)];
    [socket_outlet setBackgroundImage:[UIImage imageNamed:@"home_time"] forState:UIControlStateNormal];
    socket_outlet.tag = 5;
    [socket_outlet addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:socket_outlet];
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(75+pic_width, CGRectGetMaxY(alarm_disalarm_record.frame), pic_width, 30)];
    label5.text = NSLocalizedString(@"home_time", nil);
    label5.textAlignment = NSTextAlignmentCenter;
    label5.font = [UIFont systemFontOfSize:13];
    label5.textColor = [UIColor blackColor];
    [_myView addSubview:label5];
    
    UIButton *call_phone = [[UIButton alloc]initWithFrame:CGRectMake(120+pic_width*2, 10+pic_width+50, pic_width, pic_width)];
    [call_phone setBackgroundImage:[UIImage imageNamed:@"arm_phone"] forState:UIControlStateNormal];
    call_phone.tag = 10;
    [call_phone addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:call_phone];
    
    UILabel *label10 = [[UILabel alloc]initWithFrame:CGRectMake(120+pic_width*2, CGRectGetMaxY(alarm_disalarm_record.frame), pic_width, 30)];
    label10.text = NSLocalizedString(@"arm_phone", nil);
    label10.textAlignment = NSTextAlignmentCenter;
    label10.font = [UIFont systemFontOfSize:13];
    label10.textColor = [UIColor blackColor];
    [_myView addSubview:label10];
    
    //第三排
    
    UIButton *sms_reply = [[UIButton alloc]initWithFrame:CGRectMake(30, 10+2*pic_width+100, pic_width, pic_width)];
    [sms_reply setBackgroundImage:[UIImage imageNamed:@"sms_reply"] forState:UIControlStateNormal];
    sms_reply.tag = 11;
    [sms_reply addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:sms_reply];
    
    UILabel *label11 = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(sms_reply.frame), pic_width, 30)];
    label11.text = NSLocalizedString(@"sms_reply", nil);
    label11.textAlignment = NSTextAlignmentCenter;
    label11.font = [UIFont systemFontOfSize:13];
    label11.textColor = [UIColor blackColor];
    [_myView addSubview:label11];
    
    UIButton *arm_disarm_sms = [[UIButton alloc]initWithFrame:CGRectMake(75+pic_width, 10+2*pic_width+100, pic_width, pic_width)];
    [arm_disarm_sms setBackgroundImage:[UIImage imageNamed:@"arm_disarm_sms"] forState:UIControlStateNormal];
    arm_disarm_sms.tag = 12;
    [arm_disarm_sms addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:arm_disarm_sms];
    
    UILabel *label12 = [[UILabel alloc]initWithFrame:CGRectMake(65+pic_width, CGRectGetMaxY(arm_disarm_sms.frame), pic_width+20, 30)];
    label12.text = NSLocalizedString(@"arm_disarm_sms", nil);
    label12.textAlignment = NSTextAlignmentCenter;
    label12.font = [UIFont systemFontOfSize:13];
    label12.textColor = [UIColor blackColor];
    [_myView addSubview:label12];
    
    UIButton *smart_socket = [[UIButton alloc]initWithFrame:CGRectMake(120+pic_width*2, 10+2*pic_width+100, pic_width, pic_width)];
    [smart_socket setBackgroundImage:[UIImage imageNamed:@"smart_socket"] forState:UIControlStateNormal];
    smart_socket.tag = 13;
    [smart_socket addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:smart_socket];
    
    UILabel *label13 = [[UILabel alloc]initWithFrame:CGRectMake(120+pic_width*2, CGRectGetMaxY(smart_socket.frame), pic_width, 30)];
    label13.text = NSLocalizedString(@"smart_switch", nil);
    label13.textAlignment = NSTextAlignmentCenter;
    label13.font = [UIFont systemFontOfSize:13];
    label13.textColor = [UIColor blackColor];
    [_myView addSubview:label13];
    
    
    
    
    UIView *camera_view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label13.frame)+30, SCREENWIDTH, 70)];
    [camera_view setBackgroundColor:[UIColor colorWithRed:0 green:191/255.0 blue:248/255.0 alpha:1]];
    [_myView addSubview:camera_view];
    
    UIImageView *camera = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-45, CGRectGetMaxY(label13.frame)+20, 90, 90)];
    [camera setImage:[UIImage imageNamed:@"camera"]];
    [_myView addSubview:camera];
    
    
    
    
    
    self.alarm = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(camera.frame)+20, pic_width, pic_width)];
    [self.alarm setBackgroundImage:[UIImage imageNamed:@"arm"] forState:UIControlStateNormal];
    [self.alarm setBackgroundImage:[UIImage imageNamed:@"arm_cover"] forState:UIControlStateSelected];
    self.alarm.tag = 6;
    [self.alarm addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:self.alarm];
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.alarm.frame), pic_width, 30)];
    label6.text = NSLocalizedString(@"alarm", nil);
    label6.textAlignment = NSTextAlignmentCenter;
    label6.font = [UIFont systemFontOfSize:13];
    label6.textColor = [UIColor blackColor];
    [_myView addSubview:label6];
    
    self.disarm = [[UIButton alloc]initWithFrame:CGRectMake(75+pic_width, CGRectGetMaxY(camera.frame)+20, pic_width, pic_width)];
    [self.disarm setBackgroundImage:[UIImage imageNamed:@"disarm"] forState:UIControlStateNormal];
    [self.disarm setBackgroundImage:[UIImage imageNamed:@"disarm_cover"] forState:UIControlStateSelected];
    self.disarm.tag = 7;
    [self.disarm addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:self.disarm];
    
    UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(75+pic_width, CGRectGetMaxY(self.disarm.frame), pic_width, 30)];
    label7.text = NSLocalizedString(@"disarm", nil);
    label7.textAlignment = NSTextAlignmentCenter;
    label7.font = [UIFont systemFontOfSize:13];
    label7.textColor = [UIColor blackColor];
    [_myView addSubview:label7];
    
    self.home_alarm = [[UIButton alloc]initWithFrame:CGRectMake(120+pic_width*2, CGRectGetMaxY(camera.frame)+20, pic_width, pic_width)];
    [self.home_alarm setBackgroundImage:[UIImage imageNamed:@"homedisarm"] forState:UIControlStateNormal];
    [self.home_alarm setBackgroundImage:[UIImage imageNamed:@"homedisarm_cover"] forState:UIControlStateSelected];
    self.home_alarm.tag = 8;
    [self.home_alarm addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myView addSubview:self.home_alarm];
    
    UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(120+pic_width*2, CGRectGetMaxY(self.home_alarm.frame), pic_width, 30)];
    label8.text = NSLocalizedString(@"stay_in_guard", nil);
    label8.textAlignment = NSTextAlignmentCenter;
    label8.font = [UIFont systemFontOfSize:13];
    label8.textColor = [UIColor blackColor];
    [_myView addSubview:label8];
    
    [scrollView addSubview:_myView];
    
    if ([self.userInfo.A_D_H_Settings isEqualToString:@"0"]) {
        self.disarm.selected = YES;
        self.alarm.selected = NO;
        self.home_alarm.selected = NO;
    }else if ([self.userInfo.A_D_H_Settings isEqualToString:@"1"]) {
        self.disarm.selected = NO;
        self.alarm.selected = YES;
        self.home_alarm.selected = NO;
    }else if ([self.userInfo.A_D_H_Settings isEqualToString:@"2"]) {
        self.disarm.selected = NO;
        self.alarm.selected = NO;
        self.home_alarm.selected = YES;
    }
    
    scrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(label8.frame));
    
    [self.view addSubview:scrollView];
    
    
}

-(void)setnavigationItem{
    self.navigationItem.title = @"GSM";
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftButton setTitle:NSLocalizedString(@"Settings", nil) forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitle:NSLocalizedString(@"menu", nil) forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

-(void)clickLeftButton{
    GsmSettingsView *gsview = [[GsmSettingsView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    gsview.userInfo = self.userInfo;
    [self.view.window addSubview:gsview];
}

-(void)clickRightButton{
    isHidderMenuView = !isHidderMenuView;
    if (isHidderMenuView) {
        GSMMenuView *mv = [[GSMMenuView alloc]initWithFrame:CGRectMake(0, MCStatusBarH, SCREENWIDTH, SCREENHEIGHT-MCStatusBarH)];
        mv.userInfo = self.userInfo;
        mv.clickRemove = ^{
            isHidderMenuView = NO;
        };//点击界面退出
        mv.clickSwitchUsersButton = ^{
            GSMSwitchUserViewController *suvc = [[GSMSwitchUserViewController alloc]init];
            suvc.userInfo = self.userInfo;
            suvc.clickOtherUser = ^(GSMUserInfo *userinfo) {
                self.userInfo.isLog = @"0";
                [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
                self.userInfo = userinfo;
                self.userInfo.isLog = @"1";
                [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
                [self removeMenuView];
                isHidderMenuView = NO;
            };
            [self.navigationController pushViewController:suvc animated:YES];
        };//切换用户
        mv.clickOnWeButton = ^{
            GSMOnWeViewController *owvc = [[GSMOnWeViewController alloc]init];
            [self.navigationController pushViewController:owvc animated:YES];
            
        };//关于
        mv.clickSignOutButton = ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        };//退出登录
        [self.view addSubview:mv];
    }else{
        [self removeMenuView];
    }
}

-(void)removeMenuView{
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[GSMMenuView class]]) {
            [v removeFromSuperview];
        }
    }
}

- (void)buttonClick:(UIButton *)sender{
    NSInteger tag = sender.tag;
    switch (tag) {
        case 1:
            [self showMessageView:self.userInfo.hostNumber title:nil body:GSMCallBack];
            break;//电话回拨
            
        case 2:
            [self showMessageView:self.userInfo.hostNumber title:nil body:GSMDisarmCheck];
            break;//布撤防查询
            
        case 3:{
            DelayArmDisarmViewController *dadvc = [[DelayArmDisarmViewController alloc]init];
            dadvc.userInfo = self.userInfo;
            [self.navigationController pushViewController:dadvc animated:YES];
            
        }break;//延时布撤防
            
        case 4:{
            GSMScheduledArmingViewController *savc = [[GSMScheduledArmingViewController alloc]init];
            savc.userInfo = self.userInfo;
            [self.navigationController pushViewController:savc animated:YES];
        }break;//定时布撤防
            
        case 5:{
            GSMApplianceTimingViewController *atvc = [[GSMApplianceTimingViewController alloc]init];
            atvc.userInfo = self.userInfo;
            [self.navigationController pushViewController:atvc animated:YES];
        }break;//家电定时
            
        case 6:{
            if (![self.userInfo.A_D_H_Settings isEqualToString:@"1"]) {
                self.userInfo.A_D_H_Settings = @"1";
                self.disarm.selected = NO;
                self.alarm.selected = YES;
                self.home_alarm.selected = NO;
                [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
                [self showMessageView:self.userInfo.hostNumber title:nil body:GSMA_D_H_Settings];
            }
        }break;
            
        case 7:{
            if (![self.userInfo.A_D_H_Settings isEqualToString:@"0"]) {
                self.userInfo.A_D_H_Settings = @"0";
                self.disarm.selected = YES;
                self.alarm.selected = NO;
                self.home_alarm.selected = NO;
                [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
                [self showMessageView:self.userInfo.hostNumber title:nil body:GSMA_D_H_Settings];
            }
            
        }break;
            
        case 8:{
            if (![self.userInfo.A_D_H_Settings isEqualToString:@"2"]) {
                self.userInfo.A_D_H_Settings = @"2";
                self.disarm.selected = NO;
                self.alarm.selected = NO;
                self.home_alarm.selected = YES;
                [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
                [self showMessageView:self.userInfo.hostNumber title:nil body:GSMA_D_H_Settings];
            }
        }break;
            
        case 10:{
            GSMEmergencyCallViewController *ecvc = [[GSMEmergencyCallViewController alloc]init];
            ecvc.userInfo = self.userInfo;
            [self.navigationController pushViewController:ecvc animated:YES];
        }break;//报警电话
            
        case 11:{
            GsmReplyView *rmsview = [[GsmReplyView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            rmsview.userInfo = self.userInfo;
            rmsview.clilkDetermine = ^(NSString *status) {
                self.userInfo.smsswitch = status;
                [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
                [self showMessageView:self.userInfo.hostNumber title:nil body:GSMSMSReply];
                for (UIView *view in self.view.subviews) {
                    if ([view isKindOfClass:[GsmReplyView class]]) {
                        [view removeFromSuperview];
                    }
                }
            };
            [self.view addSubview:rmsview];
        }break;//短信回复开关
            
        case 12:{
            GsmSMSview *smsview = [[GsmSMSview alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            smsview.userInfo = self.userInfo;
            smsview.clickInquireBtn = ^{
               [self showMessageView:self.userInfo.hostNumber title:nil body:GSMDisarmSMSCheck];
            };//布撤防短信查询
            smsview.clickSaveBtn = ^(NSString *ArmSmsNotice, NSString *DisarmSmsNotice, NSString *HomeSmsNotice) {
                self.userInfo.ArmSmsNotice = ArmSmsNotice;
                self.userInfo.DisarmSmsNotice = DisarmSmsNotice;
                self.userInfo.HomeSmsNotice = HomeSmsNotice;
                [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
                [self showMessageView:self.userInfo.hostNumber title:nil body:GSMSMSNoticeSAVE];
                for (UIView *view in self.view.subviews) {
                    if ([view isKindOfClass:[GsmSMSview class]]) {
                        [view removeFromSuperview];
                    }
                }
            };//布撤防短信通知设置
            [self.view addSubview:smsview];
        } break;//布撤防短信通知
            
        case 13:{
            GSMSmartSwitchViewController *ssvc = [[GSMSmartSwitchViewController alloc]init];
            ssvc.userInfo = self.userInfo;
            [self.navigationController pushViewController:ssvc animated:YES];
        }break;//智能开关
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
