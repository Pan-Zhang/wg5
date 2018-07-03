//
//  ArmDisarmViewController.m
//  GOpenSource_AppKit
//
//  Created by 张攀 on 2018/4/3.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "ArmDisarmViewController.h"
#import "ArmDIsarmTableViewCell.h"
#import "AlarmDisarmRecord.h"

#define ArmDisarmRecordIdentifier @"ArmDisarmRecord"

@interface ArmDisarmViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ArmDisarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"alarm_disarm_record_list", nil);
    _myTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView registerNib:[UINib nibWithNibName:@"ArmDIsarmTableViewCell" bundle:nil] forCellReuseIdentifier:ArmDisarmRecordIdentifier];
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103.5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_recordArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ArmDisarmRecordIdentifier forIndexPath:indexPath];
    ArmDIsarmTableViewCell *recordCell = (ArmDIsarmTableViewCell *)cell;
    AlarmDisarmRecord *record = _recordArray[indexPath.row];
    recordCell.reason.text = record.reasonStr;
    recordCell.type.text = record.typeStr;
    recordCell.time.text = record.timeStr;
    return recordCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
