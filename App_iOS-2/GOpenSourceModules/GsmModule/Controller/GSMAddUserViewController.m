//
//  GSMAddUserViewController.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/10.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMAddUserViewController.h"
#import "GsmViewController.h"
#import "GosTipView.h"
#import "GosCommon.h"
#import <GizWifiSDK/GizWifiSDK.h>
#import "GSMUserInfo.h"
#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]
//根据6注释，等比例缩放
#define kAdapterWith(x) MCScreenWidth/375*x
#define MCScreenWidth [UIScreen mainScreen].bounds.size.width

@interface GSMAddUserViewController ()<GizWifiSDKDelegate>{
    UITextField *userNameTextField;
    UITextField *userNumberTextField;
    UITextField *passWordTextField;
    UITextField *repeatPassWordTextField;
}

@end

@implementation GSMAddUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GizWifiSDK sharedInstance].delegate = self;
    
    [self setnavigationItem];
    
    [self initView];
}

-(void)setnavigationItem{
    self.navigationItem.title = NSLocalizedString(@"add_user", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
    [rightButton setImage:[UIImage imageNamed:@"leftButton_image"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton setTitle:NSLocalizedString(@"add", nil) forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
}

-(void)initView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, kAdapterWith(160))];
    headView.backgroundColor = [GosCommon sharedInstance].navigationBarColor;
    [self.view addSubview:headView];
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAdapterWith(80), kAdapterWith(80))];
    headImageView.center = CGPointMake(MCScreenWidth/2, kAdapterWith(80));
    headImageView.layer.cornerRadius = headImageView.frame.size.width / 2;
    headImageView.layer.masksToBounds = YES;
    [headImageView.layer setBorderWidth:1];
    [headImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    headImageView.image = [UIImage imageNamed:@"adduser_image"];
    [headView addSubview:headImageView];
    
    userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, headView.frame.origin.y+headView.frame.size.height+20, self.view.frame.size.width-80, 50)];
    userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    userNameTextField.placeholder = NSLocalizedString(@"enter_user_name", nil);
    userNameTextField.leftView = [self retureLeftViewWithImageName:@"homedisarm"];
   
    [userNameTextField addSubview:[self retureLineview]];
    [self.view addSubview:userNameTextField];
    
    userNumberTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, userNameTextField.frame.origin.y+userNameTextField.frame.size.height, self.view.frame.size.width-80, 50)];
    userNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    userNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    userNumberTextField.placeholder = NSLocalizedString(@"enter_host_phone", nil);
    userNumberTextField.leftView = [self retureLeftViewWithImageName:@"set_phone"];
    [userNumberTextField addSubview:[self retureLineview]];
    [self.view addSubview:userNumberTextField];
    
    passWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, userNumberTextField.frame.origin.y+userNumberTextField.frame.size.height, self.view.frame.size.width-80, 50)];
    passWordTextField.leftViewMode = UITextFieldViewModeAlways;
    passWordTextField.placeholder = NSLocalizedString(@"enter_host_password", nil);
//    passWordTextField.keyboardType = UIKeyboardTypeNumberPad;
    passWordTextField.secureTextEntry = YES;
    passWordTextField.leftView = [self retureLeftViewWithImageName:@"DelayArmDisarmViewController_image_1"];
    [passWordTextField addSubview:[self retureLineview]];
    [self.view addSubview:passWordTextField];
    
    repeatPassWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, passWordTextField.frame.origin.y+passWordTextField.frame.size.height, self.view.frame.size.width-80, 50)];
    [repeatPassWordTextField addSubview:[self retureLineview]];
    repeatPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
//    repeatPassWordTextField.keyboardType = UIKeyboardTypeNumberPad;
    repeatPassWordTextField.placeholder = NSLocalizedString(@"enter_host_password", nil);
    repeatPassWordTextField.secureTextEntry = YES;
    repeatPassWordTextField.leftView = [self retureLeftViewWithImageName:@"DelayArmDisarmViewController_image_1"];
    [self.view addSubview:repeatPassWordTextField];
    
}

-(void)clickLeftButton{
    [self.view endEditing:YES];
    if (userNameTextField.text.length == 0) {
        [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"enter_user_name", nil) delay:1 completion:^{
            [userNameTextField becomeFirstResponder];
        }];
        return;
    }
    if (userNumberTextField.text.length == 0) {
        [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"enter_host_phone", nil) delay:1 completion:^{
            [userNameTextField becomeFirstResponder];
        }];
        return;
    }
    if (passWordTextField.text.length == 0 ) {
        [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"enter_host_password", nil) delay:1 completion:^{}];
        return;
    }
    if (![passWordTextField.text isEqualToString:repeatPassWordTextField.text]) {
        [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"password_entered_twice_inconsistent", nil) delay:1 completion:^{}];
        return;
    }
    GSMUserInfo *userInfo = [[GSMUserInfo alloc]init];
    userInfo.userName = userNameTextField.text;
    userInfo.hostNumber = userNumberTextField.text;
    userInfo.password = passWordTextField.text;
    
    if (self.isAddUser) {
        GSMUserInfo *otheruser = [GSMUserInfo retunUserInfoWithUserName:userInfo.userName];
        if (otheruser == nil) {
            [GSMUserInfo storageUserInfoWithUserInfo:userInfo];
        }else{
            otheruser.hostNumber = userNumberTextField.text;
            otheruser.password = passWordTextField.text;
            [GSMUserInfo storageUserInfoWithUserInfo:userInfo];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        GSMUserInfo *otheruser = [GSMUserInfo retunUserInfoWithUserName:userInfo.userName];
        if (otheruser == nil) {
            userInfo.isLog = @"1";
            [GSMUserInfo storageUserInfoWithUserInfo:userInfo];
            otheruser = userInfo;
        }else{
            otheruser.isLog = @"1";
            otheruser.hostNumber = userNumberTextField.text;
            otheruser.password = passWordTextField.text;
            [GSMUserInfo storageUserInfoWithUserInfo:userInfo];
        }
        GsmViewController *gvc = [[GsmViewController alloc]init];
        gvc.userInfo = otheruser;
        [self.navigationController pushViewController:gvc animated:YES];
    }
}




-(void)clickRightButton{
    [self.navigationController popViewControllerAnimated:YES];
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
    if ([touch view] == self.view){
        [self.view endEditing:YES];
    }
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
