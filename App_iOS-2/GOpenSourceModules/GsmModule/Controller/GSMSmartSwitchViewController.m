//
//  GSMSmartSwitchViewController.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMSmartSwitchViewController.h"
#import "GSMSmartSwitchTableViewCell.h"

#define GSMSmartSwitch [NSString stringWithFormat:@"%@0303%@%@",self.userInfo.password,_switchID,_switchStatus]//智能开关

@interface GSMSmartSwitchViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_switchID;
    NSString *_switchStatus;
}
@property(nonatomic,weak)UITableView *tableView;

@end

@implementation GSMSmartSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setnavigationItem];
    
    [self initView];
    // Do any additional setup after loading the view.
}



-(void)setnavigationItem{
    self.navigationItem.title = NSLocalizedString(@"smart_switch", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
    [rightButton setImage:[UIImage imageNamed:@"leftButton_image"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

-(void)initView{
    [self tableView];
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark UITableViewDelegate , UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userInfo.smartSwitchArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    GSMSmartSwitchTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[GSMSmartSwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.userInfo.smartSwitchArray objectAtIndex:indexPath.row]];
    cell.dic = dic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.returnSwitchStatus = ^(NSString *switchStatus) {
  
        [dic setObject:switchStatus forKey:@"switchStatus"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.userInfo.smartSwitchArray];
        [array replaceObjectAtIndex:indexPath.row withObject:[NSDictionary dictionaryWithDictionary:dic]];
        self.userInfo.smartSwitchArray = array;
        [GSMUserInfo storageUserInfoWithUserInfo:self.userInfo];
        _switchID = [dic objectForKey:@"switchID"];
        _switchStatus = [dic objectForKey:@"switchStatus"];
        [self showMessageView:self.userInfo.hostNumber title:nil body:GSMSmartSwitch];
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)clickRightButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

@end
