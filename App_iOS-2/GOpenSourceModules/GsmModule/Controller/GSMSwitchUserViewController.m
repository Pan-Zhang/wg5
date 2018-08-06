//
//  GSMSwitchUserViewController.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/11.
//  Copyright © 2018年 Gizwits. All rights reserved.
//
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽
#import "GSMSwitchUserViewController.h"
#import "GSMAddUserViewController.h"
#import "GSMUserInfo.h"
#import "GosTipView.h"

#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]

@interface GSMSwitchUserViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation GSMSwitchUserViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _dataArray = [NSMutableArray arrayWithArray:[GSMUserInfo returnUserArray]];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray arrayWithArray:[GSMUserInfo returnUserArray]];
    [self setnavigationItem];
    
    [self initView];
}

-(void)setnavigationItem{
    self.navigationItem.title = NSLocalizedString(@"switch_users", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
    [rightButton setImage:[UIImage imageNamed:@"leftButton_image"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
}

-(void)initView{
    [self tableView];
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc]init];
        //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark UITableViewDelegate , UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GSMUserInfo *userinfo = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = userinfo.userName;
    if ([userinfo.userName isEqualToString:self.userInfo.userName]) {
        cell.textLabel.textColor = TitleLabelColor;
    }
    cell.imageView.image = [UIImage imageNamed:@"adduser_cell_image"];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-80, 15, 60, 30)];
    button.tag = indexPath.row;
    [button setBackgroundColor:[UIColor redColor]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:button];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GSMUserInfo *userinfo = [self.dataArray objectAtIndex:indexPath.row];
    if ([userinfo.userName isEqualToString:self.userInfo.userName]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.clickOtherUser(userinfo);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)clickLeftButton{
    GSMAddUserViewController *auvc = [[GSMAddUserViewController alloc]init];
    auvc.isAddUser = YES;
    [self.navigationController pushViewController:auvc animated:YES];
}

-(void)clickRightButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickDeleteButton:(UIButton *)sender{
    UIAlertView *deleteUserAlertView=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"delete_confirm", nil) message:NSLocalizedString(@"delete_massage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"confirm_delete", nil), nil];
    deleteUserAlertView.delegate=self;
    deleteUserAlertView.tag = sender.tag;
    [deleteUserAlertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        GSMUserInfo *userinfo = [self.dataArray objectAtIndex:alertView.tag];
        [GSMUserInfo deleteUserWithUserName:userinfo.userName];
        self.dataArray = [NSMutableArray arrayWithArray:[GSMUserInfo returnUserArray]];
        [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"USER_is_Delete", nil) delay:1 completion:^{
            [self.tableView reloadData];
            if ([userinfo.userName isEqualToString: self.userInfo.userName]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
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
