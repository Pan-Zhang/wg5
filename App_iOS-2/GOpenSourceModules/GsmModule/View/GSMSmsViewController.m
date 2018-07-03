//
//  GSMSmsViewController.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/13.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMSmsViewController.h"
#import "GosTipView.h"
#import <MessageUI/MessageUI.h>

@interface GSMSmsViewController ()<MFMessageComposeViewControllerDelegate>{
    MFMessageComposeViewController * controller;
}

@end

@implementation GSMSmsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)showMessageView:(NSString *)phone title:(NSString *)title body:(NSString *)body{
    if( [MFMessageComposeViewController canSendText] ){
        [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"System_commands_SMS_not_modify_content", nil) delay:1 completion:^{
        }];
        controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = [NSArray arrayWithObject:phone];
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", nil)
                                                        message:NSLocalizedString(@"device_not_support_SMS", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:{
            [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"Successful_transmission_information", nil) delay:1 completion:^{
            }];
        }break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultCancelled:
            NSLog(@"信息被用户取消传送");
            //信息被用户取消传送
            
            break;
        default:
            break;
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
