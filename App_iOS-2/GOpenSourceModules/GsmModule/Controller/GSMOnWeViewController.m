//
//  GSMOnWeViewController.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/10.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMOnWeViewController.h"

@interface GSMOnWeViewController ()

@end

@implementation GSMOnWeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setnavigationItem];
    
    [self initView];
}

-(void)setnavigationItem{
    self.navigationItem.title = NSLocalizedString(@"about", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
    [rightButton setImage:[UIImage imageNamed:@"leftButton_image"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"AppIcon"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height+5, self.view.frame.size.width, 20)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = [NSString stringWithFormat:@"%@:V1.0",NSLocalizedString(@"Program_version", nil)];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
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
