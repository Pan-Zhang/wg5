//
//  GsmSMSview.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GsmSMSview.h"
#import "GsmSwitchView.h"

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽

#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]

static const int whiteviewH = 310;//白色区域的大小

@interface GsmSMSview(){
    NSString *ArmSmsNotice;
    NSString *DisarmSmsNotice;
    NSString *HomeSmsNotice;
}
@property(nonatomic,weak)UIView *bgView;//背景
@property(nonatomic,weak)UIView *whiteView;//显示区域
@property(nonatomic,weak)UILabel *titleLabel;//标题
@property(nonatomic,weak)GsmSwitchView *sview_1;
@property(nonatomic,weak)GsmSwitchView *sview_2;
@property(nonatomic,weak)GsmSwitchView *sview_3;
@property(nonatomic,weak)UIView *buttomview;

@property(nonatomic,weak)UIButton *saveButton;
@property(nonatomic,weak)UIButton *InquireButton;
@property(nonatomic,weak)UIButton *shutdownButton;

@end

@implementation GsmSMSview

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    } return self;
}

#pragma mark 界面初始化
-(void)addSubviews{
    [self bgView];
    [self whiteView];
    [self titleLabel];
    
    [self sview_1];
    [self sview_2];
    [self sview_3];
    
    [self buttomview];
    [self saveButton];
    [self InquireButton];
    [self shutdownButton];
}

- (UIView *)bgView {
    if (_bgView == nil) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addSubview:bgView];
        _bgView = bgView;
    }
    return _bgView;
}


- (UIView *)whiteView {
    if (_whiteView == nil) {
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH-40, whiteviewH)];
        whiteView.center = self.center;
        whiteView.backgroundColor =  [UIColor colorWithRed:244/255.0 green:235/255.0 blue:230/255.0 alpha:1/1.0];
        whiteView.layer.cornerRadius = 5;
        whiteView.layer.masksToBounds = YES;
        [self addSubview:whiteView];
        
        _whiteView = whiteView;
    }
    return _whiteView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH-40, 50)];
        titleLabel.text = NSLocalizedString(@"Arming_disarming_SMS_notification", nil);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = TitleLabelColor;
        [_whiteView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

-(GsmSwitchView *)sview_1{
    if (_sview_1 == nil) {
        GsmSwitchView *sview_1 = [[GsmSwitchView alloc]initWithFrame:CGRectMake(0, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, _whiteView.frame.size.width, 50)];
        sview_1.titleString = NSLocalizedString(@"Arming_notice", nil);
        sview_1.returnSwitchStatus = ^(NSString *status, NSInteger viewTag) {
            ArmSmsNotice = status;
        };
        [_whiteView addSubview:sview_1];
        _sview_1 = sview_1;
    }
    return _sview_1;
}

-(GsmSwitchView *)sview_2{
    if (_sview_2 == nil) {
        GsmSwitchView *sview_2 = [[GsmSwitchView alloc]initWithFrame:CGRectMake(0, _sview_1.frame.origin.y+_sview_1.frame.size.height+10, _whiteView.frame.size.width, 50)];
        sview_2.titleString = NSLocalizedString(@"Dismissal_notice", nil);
        sview_2.returnSwitchStatus = ^(NSString *status, NSInteger viewTag) {
            DisarmSmsNotice = status;
        };
        [_whiteView addSubview:sview_2];
        _sview_2 = sview_2;
    }
    return _sview_2;
}

-(GsmSwitchView *)sview_3{
    if (_sview_3 == nil) {
        GsmSwitchView *sview_3 = [[GsmSwitchView alloc]initWithFrame:CGRectMake(0, _sview_2.frame.origin.y+_sview_2.frame.size.height+10, _whiteView.frame.size.width, 50)];
        sview_3.titleString = NSLocalizedString(@"Stay_informed", nil);
        sview_3.returnSwitchStatus = ^(NSString *status, NSInteger viewTag) {
            HomeSmsNotice = status;
        };
        [_whiteView addSubview:sview_3];
        _sview_3 = sview_3;
    }
    return _sview_3;
}

-(UIView *)buttomview{
    if (_buttomview == nil) {
        UIView *buttomview = [[UIView alloc]initWithFrame:CGRectMake(0, _whiteView.frame.size.height-80, _whiteView.frame.size.width, 80)];
        buttomview.backgroundColor = [UIColor whiteColor];
        [_whiteView addSubview:buttomview];
        _buttomview = buttomview;
    }
    
    return _buttomview;
}

-(UIButton *)saveButton{
    if (_saveButton == nil) {
        UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(20,20, _buttomview.frame.size.width/2-40, 40)];
        [saveButton addTarget:self action:@selector(clickSaveButton) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
        [saveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [saveButton setBackgroundColor:TitleLabelColor];
        saveButton.layer.cornerRadius = 20;
        saveButton.layer.masksToBounds = YES;
        [_buttomview addSubview:saveButton];
        
        _saveButton = saveButton;
    }
    return _saveButton;
}

-(UIButton *)InquireButton{
    if (_InquireButton == nil) {
        UIButton *InquireButton = [[UIButton alloc]initWithFrame:CGRectMake(_buttomview.frame.size.width/2+20,20, _buttomview.frame.size.width/2-40, 40)];
        [InquireButton addTarget:self action:@selector(clickInquireButton) forControlEvents:UIControlEventTouchUpInside];
        [InquireButton setTitle:NSLocalizedString(@"query", nil) forState:UIControlStateNormal];
        [InquireButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [InquireButton setBackgroundColor:TitleLabelColor];
        InquireButton.layer.cornerRadius = 20;
        InquireButton.layer.masksToBounds = YES;
        [_buttomview addSubview:InquireButton];
        
        _InquireButton = InquireButton;
    }
    return _InquireButton;
}
-(UIButton *)shutdownButton{
    if (_shutdownButton == nil) {
        UIButton *shutdownButton = [[UIButton alloc]initWithFrame:CGRectMake(_titleLabel.frame.size.width-40, 0,40, 40)];
        [shutdownButton setImage:[UIImage imageNamed:@"view_shut_down"] forState:UIControlStateNormal];
        [shutdownButton addTarget:self action:@selector(clickShutdownButton) forControlEvents:UIControlEventTouchUpInside];
        [_whiteView addSubview:shutdownButton];
        
        _shutdownButton = shutdownButton;
    }
    return _shutdownButton;
}

-(void)clickShutdownButton{
    [self removeSuperView];
}


-(void)clickSaveButton{
    self.clickSaveBtn(ArmSmsNotice, DisarmSmsNotice, HomeSmsNotice);
}

-(void)clickInquireButton{
    self.clickInquireBtn();
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] == _bgView){
        [self removeSuperView];
    }
}

-(void)removeSuperView{
    [UIView animateWithDuration:1.0 animations:^{
        [self removeFromSuperview];
    }];
}

-(void)layoutSubviews{
    _sview_1.switchStatus = self.userInfo.ArmSmsNotice;
    _sview_2.switchStatus = self.userInfo.DisarmSmsNotice;
    _sview_3.switchStatus = self.userInfo.HomeSmsNotice;
}


@end
