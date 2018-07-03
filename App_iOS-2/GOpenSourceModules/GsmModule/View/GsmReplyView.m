//
//  GsmReplyView.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/27.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GsmReplyView.h"
#import "GsmSwitchView.h"

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽

#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]

static const int whiteviewH = 180;//白色区域的大小

@interface GsmReplyView(){
    NSString *_status;
}
@property(nonatomic,weak)UIView *bgView;//背景
@property(nonatomic,weak)UIView *whiteView;//显示区域
@property(nonatomic,weak)UILabel *titleLabel;//标题
@property(nonatomic,weak)GsmSwitchView *sview;

@property(nonatomic,weak)UIButton *saveButton;
@property(nonatomic,weak)UIButton *shutdownButton;


@end


@implementation GsmReplyView

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
    
    [self sview];
    [self saveButton];
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
        whiteView.backgroundColor =  [UIColor whiteColor];
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
        titleLabel.text = NSLocalizedString(@"SMS_reply_switch", nil);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = TitleLabelColor;
        [_whiteView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

-(GsmSwitchView *)sview{
    if (_sview == nil) {
        GsmSwitchView *sview = [[GsmSwitchView alloc]initWithFrame:CGRectMake(0, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, _whiteView.frame.size.width, 50)];
        sview.tag = 1;
        sview.returnSwitchStatus = ^(NSString *status, NSInteger viewTag) {
            _status = status;
        };
        [_whiteView addSubview:sview];
        _sview = sview;
    }
    return _sview;
}

-(UIButton *)saveButton{
    if (_saveButton == nil) {
        UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(_whiteView.frame.size.width-120, _whiteView.frame.size.height-60, 100, 40)];
        [saveButton addTarget:self action:@selector(clickSaveButton) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
        [saveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [saveButton setBackgroundColor:TitleLabelColor];
        saveButton.layer.cornerRadius = 20;
        saveButton.layer.masksToBounds = YES;
        [_whiteView addSubview:saveButton];
        _saveButton = saveButton;
    }
    return _saveButton;
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
    self.clilkDetermine(_status);
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
    _sview.switchStatus = self.userInfo.smsswitch;
}


@end
