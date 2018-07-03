//
//  DelayArmDisarmViewController.m
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/5/15.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "DelayArmDisarmViewController.h"
#import "GosTipView.h"

static const int smallviewH = 80;//小界面的高度
#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]
#define MCStatusBarH [[UIApplication sharedApplication] statusBarFrame].size.height+44.0
//根据6注释，等比例缩放
#define kAdapterWith(x) MCScreenWidth/375*x
#define MCScreenWidth [UIScreen mainScreen].bounds.size.width

#define GSMArmingCheck [NSString stringWithFormat:@"%@1000",self.userInfo.password]//布防查询
#define GSMArmingDelay [NSString stringWithFormat:@"%@1103%@",self.userInfo.password,self.userInfo.armingTime]//延时布防

#define GSMPoliceCheck [NSString stringWithFormat:@"%@1200",self.userInfo.password]//报警查询
#define GSMPoliceDelay [NSString stringWithFormat:@"%@1303%@",self.userInfo.password,self.userInfo.policeTime]//延时报警
@interface DelayArmDisarmViewController (){
    NSString *armingTime;
    NSString *policeTime;
}

@end

@implementation DelayArmDisarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setnavigationItem];
    
    [self initView];
}

-(void)setnavigationItem{
    self.navigationItem.title = NSLocalizedString(@"delay_arm_disarm", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
    [rightButton setImage:[UIImage imageNamed:@"leftButton_image"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

-(void)initView{
    [self.view addSubview:[self addSettingViewWithFrame:CGRectMake(0,MCStatusBarH, self.view.frame.size.width, smallviewH) andImageName:@"DelayArmDisarmViewController_image_1" andTitle:NSLocalizedString(@"delay_arm", nil) andViewTag:1]];
    
     [self.view addSubview:[self addSettingViewWithFrame:CGRectMake(0,MCStatusBarH+smallviewH, self.view.frame.size.width, smallviewH) andImageName:@"DelayArmDisarmViewController_image_2" andTitle:NSLocalizedString(@"d_callpol", nil) andViewTag:2]];
}


-(void)clickRightButton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView *)addSettingViewWithFrame:(CGRect)frame
                      andImageName:(NSString *)imageName
                          andTitle:(NSString *)title
                        andViewTag:(NSInteger)viewtag{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(kAdapterWith(20),(smallviewH -35)/2, 30, 30)];
    imageview.image = [UIImage imageNamed:imageName];
    [view addSubview:imageview];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-5, frame.size.width, 5)];
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.3];
    [view addSubview:line];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, smallviewH-5)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:titleLabel.font}
                                     context:nil];
    titleLabel.frame = CGRectMake(imageview.frame.origin.x+imageview.frame.size.width+10, 0, rect.size.width, frame.size.height-5);
    titleLabel.text = title;
    [view addSubview:titleLabel];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+5, (smallviewH -35)/2,kAdapterWith(80), 30)];
    textField.placeholder = NSLocalizedString(@"0-255_seconds", nil);
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = TitleLabelColor;
    textField.font = [UIFont systemFontOfSize:16];
    textField.layer.borderWidth = 1.0f;
    textField.layer.cornerRadius = 5;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.layer.borderColor =TitleLabelColor.CGColor;
    textField.tag = viewtag;
    [textField addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    if (viewtag == 1) {
        if (![self.userInfo.armingTime isEqualToString:@"0"]) {
            textField.text = self.userInfo.armingTime;
            armingTime = self.userInfo.armingTime;
        }
        
    }else{
        if (![self.userInfo.policeTime isEqualToString:@"0"]) {
            textField.text = self.userInfo.policeTime;
            policeTime = self.userInfo.policeTime;
        }
    }
    [view addSubview:textField];
    
    UIButton *InquireButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-kAdapterWith(70),(smallviewH -35)/2, kAdapterWith(50), 30)];
    [InquireButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [InquireButton setTitle:NSLocalizedString(@"query", nil) forState:UIControlStateNormal];
    [InquireButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [InquireButton setBackgroundColor:TitleLabelColor];
    InquireButton.layer.cornerRadius = 15;
    InquireButton.layer.masksToBounds = YES;
    InquireButton.tag = viewtag;
    [view addSubview:InquireButton];
    
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-kAdapterWith(140),(smallviewH -35)/2, kAdapterWith(50), 30)];
    [saveButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [saveButton setBackgroundColor:TitleLabelColor];
    saveButton.layer.cornerRadius = 15;
    saveButton.layer.masksToBounds = YES;
    saveButton.tag = viewtag + 100;
    [view addSubview:saveButton];
    
    return view;
}

-(void)clickButton:(UIButton *)sender{
    [self.view endEditing:YES];
    if (sender.tag == 1) {
        [self showMessageView:self.userInfo.hostNumber title:nil body:GSMArmingCheck];//布防查询
    }else if(sender.tag == 2){
        [self showMessageView:self.userInfo.hostNumber title:nil body:GSMPoliceCheck];//报警查询
    }else if(sender.tag == 101){
        if (armingTime.length == 0) {
            [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"enter_delay_arm_time", nil) delay:1 completion:^{
            }];
        }else{
            if ([armingTime isEqualToString:self.userInfo.armingTime]) {
                [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"time_no_Settings", nil) delay:1 completion:^{
                }];
            }else{
                self.userInfo.armingTime = armingTime;
                [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
                if (self.userInfo.armingTime.length == 1) {
                    self.userInfo.armingTime = [NSString stringWithFormat:@"00%@",self.userInfo.armingTime];
                }else if (self.userInfo.armingTime.length == 2) {
                    self.userInfo.armingTime = [NSString stringWithFormat:@"0%@",self.userInfo.armingTime];
                }
                [self showMessageView:self.userInfo.hostNumber title:nil body:GSMArmingDelay];//布防设置
            }
        }
    }else if(sender.tag == 102){
        if (self.userInfo.policeTime.length == 0) {
            [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"enter_delay_call_police_time", nil) delay:1 completion:^{
            }];
        }else{
            if ([policeTime isEqualToString:self.userInfo.policeTime]) {
                [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"time_no_Settings", nil) delay:1 completion:^{
                }];
            }else{
                self.userInfo.policeTime = policeTime;
                [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
                if (self.userInfo.policeTime.length == 1) {
                    self.userInfo.policeTime = [NSString stringWithFormat:@"00%@",self.userInfo.policeTime];
                }else if (self.userInfo.policeTime.length == 2) {
                    self.userInfo.policeTime = [NSString stringWithFormat:@"0%@",self.userInfo.policeTime];
                }
                [self showMessageView:self.userInfo.hostNumber title:nil body:GSMPoliceDelay];//报警设置
            }
        }
    }
}

- (void) textFieldDidChange:(UITextField*) sender{
    NSInteger number = [sender.text integerValue];
    if (number > 255) {
        sender.text = @"255";
    }
    if (sender.tag == 1) {
        armingTime = sender.text;
    }else{
        policeTime = sender.text;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
