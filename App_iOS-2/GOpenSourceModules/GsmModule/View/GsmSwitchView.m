//
//  GsmSwitchView.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GsmSwitchView.h"

#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]

@interface GsmSwitchView()
@property(nonatomic,weak)UIView *bgView;//背景
@property(nonatomic,weak)UILabel *titleLabel;//标题
@property(nonatomic,weak)UISwitch *myswitch;//开关
@end

@implementation GsmSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    } return self;
}

#pragma mark 界面初始化
-(void)addSubviews{
    [self bgView];
    [self titleLabel];
    [self myswitch];
}

- (UIView *)bgView {
    if (_bgView == nil) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,self.frame.size.height)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        _bgView = bgView;
    }
    return _bgView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width/2, self.frame.size.height)];
        titleLabel.text = NSLocalizedString(@"A_D_SMS_not", nil);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

-(UISwitch *)myswitch{
    if (_myswitch == nil) {
        UISwitch *myswitch = [[UISwitch alloc]initWithFrame:CGRectMake(_titleLabel.frame.size.width, self.frame.size.height/4, 80, self.frame.size.height/2)];
        myswitch.onTintColor =  TitleLabelColor;
        [myswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        myswitch.center = CGPointMake(self.frame.size.width/4*3, self.frame.size.height/2);
    
        [_bgView addSubview:myswitch];
        _myswitch = myswitch;
    }
    return _myswitch;
}

-(void)layoutSubviews{
    if (self.titleString.length !=0 ) {
         _titleLabel.text = self.titleString;
    }
    if ([self.switchStatus isEqualToString:@"0"]) {
        _myswitch.on = NO;
    }else{
        _myswitch.on = YES;
    }
   
}

-(void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSString *status;
    if (isButtonOn) {
        status = @"1";
    }else {
        status = @"0";
    }
    self.returnSwitchStatus(status, self.tag);
}



@end
