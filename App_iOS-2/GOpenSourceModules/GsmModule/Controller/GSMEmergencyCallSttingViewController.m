//
//  GSMEmergencyCallSttingViewController.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#define MCStatusBarH [[UIApplication sharedApplication] statusBarFrame].size.height+44.0
#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]
#define OFFCOLOR [UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1.0]
#import "GSMEmergencyCallSttingViewController.h"
#import "GosTipView.h"
@interface GSMEmergencyCallSttingViewController (){
    UITextField *textField;
    NSString *callstatus;
}

@end

@implementation GSMEmergencyCallSttingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    callstatus = [NSString stringWithFormat:@"%@%@%@",[self.dic objectForKey:@"0"],[self.dic objectForKey:@"1"],[self.dic objectForKey:@"2"]];
    // Do any additional setup after loading the view.
    [self setnavigationItem];
    
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)setnavigationItem{
    self.navigationItem.title = NSLocalizedString(@"alarm_phone_set", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
    [rightButton setImage:[UIImage imageNamed:@"leftButton_image"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
}

-(void)initView{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, MCStatusBarH+20, self.view.frame.size.width-60, 30)];
    titleLabel.text = NSLocalizedString(@"enter_phonenumber", nil);
    titleLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
    [self.view addSubview:titleLabel];
    
   textField = [[UITextField alloc]initWithFrame:CGRectMake(30,titleLabel.frame.size.height+titleLabel.frame.origin.y+10,self.view.frame.size.width-60,40)];
    textField.placeholder = NSLocalizedString(@"enter_phonenumber", nil);
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = TitleLabelColor;
    textField.font = [UIFont systemFontOfSize:18];
    textField.layer.borderWidth = 1.0f;
    textField.layer.cornerRadius = 5;
    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.layer.borderColor =TitleLabelColor.CGColor;
    NSString *phone = [self.dic objectForKey:@"phone"];
    if (![phone isEqualToString:@"电话号码"]) {
        textField.text = phone;
    }
    [self.view addSubview:textField];
    
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, textField.frame.size.height+textField.frame.origin.y+20, self.view.frame.size.width, 30)];
    [self.view addSubview:buttonView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, buttonView.frame.size.height+buttonView.frame.origin.y+20, self.view.frame.size.width, 30)];
    line.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:line];
    
    NSArray *array = [NSArray arrayWithObjects:@"○ CALL",@"○ SMS",@"○ RFID", nil];
    NSArray *selarray = [NSArray arrayWithObjects:@"● CALL",@"● SMS",@"● RFID",nil];
    CGFloat buttonX = (self.view.frame.size.width - 230)/2;
    
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonX+70*i, 0, 60, 30)];
        button.selected = NO;
        button.tag = i;
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitleColor:OFFCOLOR forState:UIControlStateNormal];
        [button setTitleColor:TitleLabelColor forState:UIControlStateSelected];
        [button setTitle:[NSString stringWithFormat:@"%@",[array objectAtIndex:i]] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%@",[selarray objectAtIndex:i]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:button];
        NSString *callstatus = [self.dic objectForKey:[NSString stringWithFormat:@"%d",i]];
        if ([callstatus isEqualToString:@"0"]) {
            button.selected = NO;
        }else{
            button.selected = YES;
        }
    }
    
}

-(void)clickButton:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSString *callstatus;
    if (sender.selected) {
        callstatus = @"1";
    }else{
        callstatus = @"0";
    }
    [self.dic setValue:callstatus forKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
}

-(void)clickRightButton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickLeftButton{
    if (textField.text.length == 0) {
        [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"enter_phonenumber", nil) delay:1 completion:^{
           
        }];
    }else{
        if (![textField.text isEqualToString:[self.dic objectForKey:@"phone"]]||![callstatus isEqualToString:[NSString stringWithFormat:@"%@%@%@",[self.dic objectForKey:@"0"],[self.dic objectForKey:@"1"],[self.dic objectForKey:@"2"]]]) {
            [self.dic setValue:textField.text forKey:@"phone"];
            self.clickLeftBtn(_dic);
            [self clickRightButton];
        }else{
            [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"No_set_No_save", nil) delay:1 completion:^{
                
            }];
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
