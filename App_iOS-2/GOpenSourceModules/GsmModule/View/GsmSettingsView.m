//
//  GsmSettingsView.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/23.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GsmSettingsView.h"
#import "GosTipView.h"

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽

#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]

static const int whiteviewH = 250;//白色区域的大小

@interface GsmSettingsView()

@property(nonatomic,weak)UIView *bgView;//背景
@property(nonatomic,weak)UIView *whiteView;//显示区域
@property(nonatomic,weak)UILabel *titleLabel;//标题

@property(nonatomic,weak)UITextField *phoneTextField;//电话
@property(nonatomic,weak)UITextField *passwordTextField;//密码

@property(nonatomic,weak)UIButton *saveButton;

@property(nonatomic,weak)UIButton *shutdownButton;

@end

@implementation GsmSettingsView
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
    [self phoneTextField];
    [self passwordTextField];
    [self saveButton];
    
    [self shutdownButton];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
        titleLabel.text = NSLocalizedString(@"Host_settings", nil);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = TitleLabelColor;
        [_whiteView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

-(UITextField *)phoneTextField{
    if (_phoneTextField == nil) {
        UITextField *phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, _titleLabel.frame.origin.y+70, _whiteView.frame.size.width-40, 40)];
        phoneTextField.placeholder = NSLocalizedString(@"enter_host_phone", nil);
        phoneTextField.textColor = TitleLabelColor;
        phoneTextField.clearButtonMode = UITextFieldViewModeAlways;
        phoneTextField.layer.borderWidth = 1.0f;
        phoneTextField.layer.cornerRadius = 5;
        phoneTextField.layer.borderColor =TitleLabelColor.CGColor;
        [_whiteView addSubview:phoneTextField];
        _phoneTextField = phoneTextField;
    }
    return _phoneTextField;
}//passwordTextField

-(UITextField *)passwordTextField{
    if (_passwordTextField == nil) {
        UITextField *passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, _phoneTextField.frame.origin.y+60, _whiteView.frame.size.width-40, 40)];
        passwordTextField.placeholder = NSLocalizedString(@"enter_host_password", nil);
        passwordTextField.textColor = TitleLabelColor;
        passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
        passwordTextField.layer.borderWidth = 1.0f;
        passwordTextField.layer.cornerRadius = 5;
        passwordTextField.layer.borderColor =TitleLabelColor.CGColor;
        [_whiteView addSubview:passwordTextField];
        _passwordTextField = passwordTextField;
    }
    return _passwordTextField;
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
    [_phoneTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    if (_phoneTextField.text.length == 0) {
        [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"enter_host_phone", nil) delay:1 completion:^{
            [_phoneTextField becomeFirstResponder];
        }];
        return;
    }
    if (_passwordTextField.text.length == 0) {
        [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"enter_host_password", nil) delay:1 completion:^{
            [_passwordTextField becomeFirstResponder];
        }];
        return;
    }
    self.userInfo.hostNumber = _phoneTextField.text;
    self.userInfo.password = _passwordTextField.text;
    [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
    [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"Settings_OK", nil) delay:1 completion:^{
        [self removeSuperView];
    }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] == _bgView){
        [self removeSuperView];
    }
}



-(void)removeSuperView{
    [UIView animateWithDuration:1.0 animations:^{
        [_phoneTextField resignFirstResponder];
        [_passwordTextField resignFirstResponder];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
        [self removeFromSuperview];
    }];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self convertRect:keyboardRect fromView:nil];
    CGRect frame = _whiteView.frame;
    frame.origin.y = SCREENHEIGHT-keyboardRect.size.height - whiteviewH;
    [UIView animateWithDuration:0.25 animations:^{
        _whiteView.frame = frame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        _whiteView.center = self.center;
    }];
}

-(void)layoutSubviews{
    _phoneTextField.text = self.userInfo.hostNumber;
    _passwordTextField.text = self.userInfo.password;
}


@end
