//
//  GSMMenuView.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/10.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMMenuView.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽
#define MCStatusBarH [[UIApplication sharedApplication] statusBarFrame].size.height+44.0
#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]

#define BgViewH [UIScreen mainScreen].bounds.size.height - ([[UIApplication sharedApplication] statusBarFrame].size.height+44.0)

@interface GSMMenuView(){
    UITextField *userNameTextField;
    UITextField *userNumberTextField;
    UITextField *passWordTextField;
}
@property(nonatomic,weak)UIView *bgView;//背景
@property(nonatomic,weak)UIView *whiteView;//显示区域

@property(nonatomic,weak)UIButton *switchUsersButton;
@property(nonatomic,weak)UIButton *onWeButton;
@property(nonatomic,weak)UIButton *signOutButton;


@end

@implementation GSMMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    } return self;
}

#pragma mark 界面初始化
-(void)addSubviews{
    [self bgView];
    [self whiteView];
 
    [self signOutButton];
    [self onWeButton];
    [self switchUsersButton];
    
    userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 20, _whiteView.frame.size.width, 50)];
    userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    userNameTextField.leftView = [self retureLeftViewWithImageName:@"homedisarm"];
    userNameTextField.userInteractionEnabled = NO;
    [userNameTextField addSubview:[self retureLineview]];
    [_whiteView addSubview:userNameTextField];
    
    userNumberTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, userNameTextField.frame.origin.y+userNameTextField.frame.size.height, _whiteView.frame.size.width, 50)];
    userNumberTextField.userInteractionEnabled = NO;
    userNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    userNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    userNumberTextField.leftView = [self retureLeftViewWithImageName:@"set_phone"];
    [userNumberTextField addSubview:[self retureLineview]];
    [_whiteView addSubview:userNumberTextField];
    
    passWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, userNumberTextField.frame.origin.y+userNumberTextField.frame.size.height, _whiteView.frame.size.width, 50)];
    passWordTextField.userInteractionEnabled = NO;
    passWordTextField.leftViewMode = UITextFieldViewModeAlways;
    passWordTextField.keyboardType = UIKeyboardTypeNumberPad;
    passWordTextField.leftView = [self retureLeftViewWithImageName:@"DelayArmDisarmViewController_image_1"];
    [passWordTextField addSubview:[self retureLineview]];
    [_whiteView addSubview:passWordTextField];
}

-(void)layoutSubviews{
    userNameTextField.text = self.userInfo.userName;
    userNumberTextField.text = self.userInfo.hostNumber;
    passWordTextField.text = self.userInfo.password;
}

- (UIView *)bgView {
    if (_bgView == nil) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH,BgViewH)];
        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addSubview:bgView];
        _bgView = bgView;
    }
    return _bgView;
}

- (UIView *)whiteView {
    if (_whiteView == nil) {
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,_bgView.frame.size.width*0.6, _bgView.frame.size.height)];
        whiteView.backgroundColor =  [UIColor whiteColor];;
        [_bgView addSubview:whiteView];
        _whiteView = whiteView;
    }
    return _whiteView;
}

-(UIButton *)signOutButton{
    if (_signOutButton == nil) {
        UIButton *signOutButton = [[UIButton alloc]initWithFrame:CGRectMake(20, _whiteView.frame.size.height-50, _whiteView.frame.size.width-40, 40)];
        [signOutButton addTarget:self action:@selector(clickSignOutBtn) forControlEvents:UIControlEventTouchUpInside];
        [signOutButton setTitle:NSLocalizedString(@"sign_out", nil) forState:UIControlStateNormal];
        [signOutButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [signOutButton setBackgroundColor:TitleLabelColor];
        signOutButton.layer.cornerRadius = 20;
        signOutButton.layer.masksToBounds = YES;
        [_whiteView addSubview:signOutButton];
        
        _signOutButton = signOutButton;
    }
    
    return _signOutButton;
}

-(UIButton *)onWeButton{
    if (_onWeButton == nil) {
        UIButton *onWeButton = [[UIButton alloc]initWithFrame:CGRectMake(20, _signOutButton.frame.origin.y-50, _whiteView.frame.size.width-40, 40)];
        [onWeButton addTarget:self action:@selector(clickOnWeBtn) forControlEvents:UIControlEventTouchUpInside];
        [onWeButton setTitle:NSLocalizedString(@"about", nil) forState:UIControlStateNormal];
        [onWeButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [onWeButton setBackgroundColor:TitleLabelColor];
        onWeButton.layer.cornerRadius = 20;
        onWeButton.layer.masksToBounds = YES;
        [_whiteView addSubview:onWeButton];
        
        _onWeButton = onWeButton;
    }
    
    return _onWeButton;
}

-(UIButton *)switchUsersButton{
    if (_switchUsersButton == nil) {
        UIButton *switchUsersButton = [[UIButton alloc]initWithFrame:CGRectMake(20, _onWeButton.frame.origin.y-50, _whiteView.frame.size.width-40, 40)];
        [switchUsersButton addTarget:self action:@selector(clickSwitchUsersBtn) forControlEvents:UIControlEventTouchUpInside];
        [switchUsersButton setTitle:NSLocalizedString(@"switch_users", nil) forState:UIControlStateNormal];
        [switchUsersButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [switchUsersButton setBackgroundColor:TitleLabelColor];
        switchUsersButton.layer.cornerRadius = 20;
        switchUsersButton.layer.masksToBounds = YES;
        [_whiteView addSubview:switchUsersButton];
        
        _switchUsersButton = switchUsersButton;
    }
    
    return _switchUsersButton;
}

-(UIView *)retureLineview{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, userNameTextField.frame.size.height-0.5, userNameTextField.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    return line;
}

-(UIView *)retureLeftViewWithImageName:(NSString *)imageName{
    UIImage *im = [UIImage imageNamed:imageName];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    iv.image = im;
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    lv.backgroundColor = [UIColor whiteColor];
    iv.center = lv.center;
    [lv addSubview:iv];
    return lv;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] == _bgView){
        [self removeFromSuperview];
        self.clickRemove();
    }
}

-(void)clickOnWeBtn{
    self.clickOnWeButton();
}

-(void)clickSignOutBtn{
    self.clickSignOutButton();
}

-(void)clickSwitchUsersBtn{
    self.clickSwitchUsersButton();
}
@end
