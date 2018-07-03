//
//  GSMSwitchUserViewController.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/11.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMSwitchUserViewController.h"
#import "GSMAddUserViewController.h"
#import "GSMUserInfo.h"

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
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
