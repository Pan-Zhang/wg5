//
//  DeviceListViewController.m
//  GBOSA
//
//  Created by Zono on 16/5/6.
//  Copyright © 2016年 Gizwits. All rights reserved.
//

#import "GosDeviceListViewController.h"
#import "GosCommon.h"
#import <GizWifiSDK/GizWifiSDK.h>
#import <AVFoundation/AVFoundation.h>
#import "QRCodeController.h"
#import "SSPullToRefresh.h"
#import "AppDelegate.h"
#import "GosSettingsViewController.h"
#import "GosDeviceListCell.h"
#import "GosDeviceAcceptSharingInfo.h"

#import "GosPushManager.h"
#import "GosAnonymousLogin.h"
#import "GosCommon.h"

#import <TargetConditionals.h>

#if USE_UMENG
#import <UMMobClick/MobClick.h>
#endif

@interface GosDeviceListViewController () <UIActionSheetDelegate, GizWifiSDKDelegate, GizWifiDeviceDelegate, UITableViewDelegate, UITableViewDataSource, SSPullToRefreshViewDelegate, GizDeviceSharingDelegate>

@property (nonatomic, strong) IBOutlet UITableView *deviceListTableView;

@property (nonatomic, weak) IBOutlet UIButton *addDeviceImageBtn;
@property (nonatomic, weak) IBOutlet UIButton *addDeviceLabelBtn;

@property (strong, nonatomic) GizWifiDevice *lastSubscribedDevice;
@property (strong, nonatomic) SSPullToRefreshView *pullToRefreshView;

@property (strong, nonatomic) NSString *lastSharingCode;

@end

@implementation GosDeviceListViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.pullToRefreshView == nil) {
        self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.deviceListTableView delegate:self];//下拉刷新
    } else {
        [self.pullToRefreshView setDefaultContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.deviceListArray = @[@[],@[],@[]];
    
    if ([GosCommon sharedInstance].anonymousLoginOn) {
        GosAnonymousLoginStatus lastLoginStatus = [GosAnonymousLogin lastLoginStatus];
        if ([GosCommon sharedInstance].currentLoginStatus == GizLoginNone || lastLoginStatus == GosAnonymousLoginStatusLogout) {
            GosDidLogin loginHandler = ^(NSError *result, NSString *uid, NSString *token) {
                if (result.code == GIZ_SDK_SUCCESS) {
//                    [GizCommon sharedInstance].hasBeenLoggedIn = YES;
                    NSString *info = [NSString stringWithFormat:@"%@，%@ - %@", NSLocalizedString(@"Login successful", nil), @(result.code), [result.userInfo objectForKey:@"NSLocalizedDescription"]];
                    GIZ_LOG_BIZ("userLoginAnonymous_end", "success", "%s", info.UTF8String);
                    [[GosCommon sharedInstance] saveUserDefaults:nil password:nil uid:uid token:token];
                    [GosPushManager unbindToGDMS:NO];
                    [GosPushManager bindToGDMS];
                }
                else {
                    [GosCommon sharedInstance].currentLoginStatus = GizLoginNone;
                    NSString *info = [NSString stringWithFormat:@"%@，%@ - %@", NSLocalizedString(@"Login failed", nil), @(result.code), [result.userInfo objectForKey:@"NSLocalizedDescription"]];
                    GIZ_LOG_BIZ("userLoginAnonymous_end", "failed", "%s", info.UTF8String);
                    double delayInSeconds = 3.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        if ([GosCommon sharedInstance].currentLoginStatus == GizLoginNone) {
                            [GosAnonymousLogin loginAnonymous:loginHandler];
                        }
                    });
                }
            };
            [GosAnonymousLogin loginAnonymous:loginHandler];
        }
    }
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(actionSheet:)];
    
    [self.addDeviceLabelBtn.layer setCornerRadius:20.0];
    [self.addDeviceLabelBtn.layer setBorderWidth:1.0];
    self.addDeviceLabelBtn.layer.borderColor=[UIColor grayColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.lastSubscribedDevice = nil;
    [GizWifiSDK sharedInstance].delegate = self;
    [GizDeviceSharing setDelegate:self];
    [GizWifiSDK disableLAN:NO];
    [self refreshTableView];
    
    if (self.tabBarController) {
        self.tabBarController.navigationItem.title = self.navigationItem.title;
        self.tabBarController.navigationItem.rightBarButtonItems = self.navigationItem.rightBarButtonItems;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.lastSubscribedDevice.isLAN) { //只有大循环控制才可以禁用小循环设备
        [GizWifiSDK disableLAN:YES];
    }
}

- (void)getBoundDevice {
    NSString *uid = [GosCommon sharedInstance].uid;
    NSString *token = [GosCommon sharedInstance].token;
    if (uid.length == 0) {
        uid = nil;
    }
    if (token.length == 0) {
        token = nil;
    }
    [[GizWifiSDK sharedInstance] getBoundDevices:uid token:token specialProductKeys:[GosCommon sharedInstance].productKey];
}

- (IBAction)actionSheet:(id)sender {
#if USE_UMENG
    [MobClick event:@"setting_btn_more"];
#endif

    UIActionSheet *actionSheet = nil;
    if (self.tabBarController) {
        if ([GosCommon sharedInstance].currentLoginStatus == GizLoginUser) {
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:nil
                           delegate:self
                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                           destructiveButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"Scan QR code", nil), NSLocalizedString(@"Add Device", nil), nil];
        }
        else {
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:nil
                           delegate:self
                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                           destructiveButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"Scan QR code", nil), NSLocalizedString(@"Add Device", nil), nil];
        }
    } else {
        if ([GosCommon sharedInstance].currentLoginStatus == GizLoginUser) {
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:nil
                           delegate:self
                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                           destructiveButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"Scan QR code", nil), NSLocalizedString(@"Add Device", nil), NSLocalizedString(@"Personal Center", nil), nil];
        }
        else {
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:nil
                           delegate:self
                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                           destructiveButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"Scan QR code", nil), NSLocalizedString(@"Add Device", nil), NSLocalizedString(@"Personal Center", nil), nil];
        }
    }
    
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger offset = 0;
//    if (![GizCommon sharedInstance].isLogin) {
//        offset = -1;
//    }
    if (buttonIndex == offset) {
#if USE_UMENG
        [MobClick event:@"more_actionsheet_scan_qr_code"];
#endif
        [self intoQRCodeVC];
    }else if (buttonIndex == offset+1) {
#if USE_UMENG
        [MobClick event:@"more_actionsheet_add_device"];
#endif
        [self toAirLink:nil];
    }else if(buttonIndex == offset+2) {
#if USE_UMENG
        [MobClick event:@"more_actionsheet_setting"];
#endif
        if (nil == self.tabBarController) { //取消按钮不做响应
            [self toSettings];
        }
    }
}

-(void)showAlert:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"tip", nil)
                          message:msg
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles: nil];
    [alert show];
}

- (void)refreshTableView {
    NSArray *devList = [GizWifiSDK sharedInstance].deviceList;
    if ([devList count] == 0) {
        [self.addDeviceImageBtn setHidden:NO];
        [self.addDeviceLabelBtn setHidden:NO];
    }
    else {
        [self.addDeviceImageBtn setHidden:YES];
        [self.addDeviceLabelBtn setHidden:YES];
    }
    NSMutableArray *deviceListBind = [[NSMutableArray alloc] init];
    NSMutableArray *deviceListUnBind = [[NSMutableArray alloc] init];
    NSMutableArray *deviceListOffLine = [[NSMutableArray alloc] init];
    for (GizWifiDevice *dev in devList) {
        if (dev.netStatus == GizDeviceOnline || dev.netStatus == GizDeviceControlled) {
            if (dev.isBind) {
                [deviceListBind addObject:dev];
            }
            else {
                [deviceListUnBind addObject:dev];
            }
        }
        else if (dev.isBind) [deviceListOffLine addObject:dev];
    }
    self.deviceListArray = @[deviceListBind, deviceListUnBind, deviceListOffLine];
    [self.deviceListTableView reloadData];
}

#pragma mark - table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.deviceListArray objectAtIndex:indexPath.section] count] == 0) {
        return 60;//60
    }
    return 80;//80
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[self.deviceListArray objectAtIndex:0] count] == 0 &&
        [[self.deviceListArray objectAtIndex:1] count] == 0 &&
        [[self.deviceListArray objectAtIndex:2] count] == 0) {
        return 0;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.deviceListArray objectAtIndex:section] count] == 0) {
        return 1;
    }
    return [[self.deviceListArray objectAtIndex:section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    CGRect frameRect = CGRectMake(10, 5, 300, 30);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frameRect];
    label.font = [UIFont boldSystemFontOfSize:16];
    if (section == 0){
        label.text=  NSLocalizedString(@"Bound devices", nil);
    }
    else if (section == 1) {
        label.text= NSLocalizedString(@"Discovery of new devices", nil);
    }
    else {
        label.text= NSLocalizedString(@"Offline devices", nil);
    }
    [view addSubview:label];
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    
    return 40.0;
    
}

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) return NSLocalizedString(@"Bound devices", nil);
//    else if (section == 1) return NSLocalizedString(@"Discovery of new devices", nil);
//    else return NSLocalizedString(@"Offline devices", nil);
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GosDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GosDeviceListCell" owner:self options:nil] lastObject];
//        UILabel *lanLabel = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 110, 0, 74, 80)];
//        lanLabel.textAlignment = NSTextAlignmentRight;
//        lanLabel.tag = 99;
//        [cell addSubview:lanLabel];
    }
    
    NSMutableArray *devArr = [self.deviceListArray objectAtIndex:indexPath.section];
    /*
    UILabel *lanLabel = nil;
    for (UILabel *label in cell.subviews) {
        if (label.tag == 99) {
            lanLabel = label;
            lanLabel.text = @"";
        }
    }
    if (!lanLabel) {
        for (UILabel *label in cell.subviews[0].subviews) {
            if (label.tag == 99) {
                lanLabel = label;
                lanLabel.text = @"";
            }
        }
    }
    */
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([devArr count] > 0) {
        GizWifiDevice *dev = [devArr objectAtIndex:indexPath.row];
        NSString *devName = dev.alias;
        if (devName == nil || devName.length == 0) {
            devName = dev.productName;
        }
        cell.title.text = devName;
        [self customCell:cell device:dev];
        cell.imageView.hidden = NO;
        cell.textLabel.text = @"";
    }
    else {
        cell.textLabel.text = NSLocalizedString(@"No device", nil);
        cell.title.text = @"";
        cell.mac.text = @"";
        cell.lan.text = @"";
        [cell.imageView setImage:nil];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *devArr = [self.deviceListArray objectAtIndex:indexPath.section];
    if (devArr.count == 0) {
        return NO;
    }
    return YES;
}

- (void)customCell:(GosDeviceListCell *)cell device:(GizWifiDevice *)dev {
    // 添加左边的图片
    UIGraphicsBeginImageContext(CGSizeMake(48, 48));
    UIImage *blankImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *subImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"08-icon-Device"]];
    CGRect frame = subImageView.frame;
    
    frame.origin = CGPointMake(4, 6);
    subImageView.frame = frame;
    
    [cell.imageView addSubview:subImageView];
    cell.imageView.image = blankImage;
    cell.imageView.layer.cornerRadius = 10;
    
    cell.mac.text = dev.macAddress;
    
    if (dev.netStatus == GizDeviceOnline || dev.netStatus == GizDeviceControlled) {
        cell.imageView.backgroundColor = CUSTOM_BLUE_COLOR();
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.lan.text = dev.isLAN?NSLocalizedString(@"Lan", nil):NSLocalizedString(@"Remote", nil);
        if (!dev.isBind) {
            cell.lan.text = NSLocalizedString(@"unbound", nil);
        }
    }
    else {
        cell.imageView.backgroundColor = [UIColor lightGrayColor];
        cell.lan.text = @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSArray *devArray = [self.deviceListArray objectAtIndex:indexPath.section];
//    if ([devArray count] > 0) {
////        [self.delegate deviceListController:self device:[devArray objectAtIndex:indexPath.row]];
//        [[GizDeviceControllerInstance sharedInstance] controller:self device:[devArray objectAtIndex:indexPath.row]];
//    }
    
    NSMutableArray *devArr = [self.deviceListArray objectAtIndex:indexPath.section];
    if ([devArr count] > 0) {
//        if ([[GizCommon sharedInstance] currentLoginStatus] == GizLoginNone) {
//            [self showAlert:@"请登录后再进行绑定操作"];
//            return;
//        }
        GizWifiDevice *dev = [devArr objectAtIndex:indexPath.row];
        if (dev.netStatus == GizDeviceOnline || dev.netStatus == GizDeviceControlled) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dev.delegate = self;
            [dev setSubscribe:nil subscribed:YES];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return NO;
    }
    NSMutableArray *devArr = [self.deviceListArray objectAtIndex:indexPath.section];
    if (devArr.count == 0) {
        return NO;
    }
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [dataArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
//        [self.deviceListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSString *uid = [GosCommon sharedInstance].uid;
        NSString *token = [GosCommon sharedInstance].token;
        GizWifiDevice *dev = [self getDeviceFromTable:indexPath];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[GizWifiSDK sharedInstance] unbindDevice:uid token:token did:dev.did];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"Unbinding", nil);
}

#pragma mark
- (GizWifiDevice *)getDeviceFromTable:(NSIndexPath *)indexPath {
    NSArray *deviceArray = [self.deviceListArray objectAtIndex:indexPath.section];
    return [deviceArray objectAtIndex:indexPath.row];
}

- (void)safePushViewController:(UIViewController *)viewController {
    UINavigationController *navController = nil;
    BOOL isValidPush = NO;
    if (self.tabBarController) {
        navController = self.tabBarController.navigationController;
        if (navController.viewControllers.lastObject == self.tabBarController) {
            isValidPush = YES;
        }
    } else {
        navController = self.navigationController;
        if (navController.viewControllers.lastObject == self) {
            isValidPush = YES;
        }
    }
    
    if (isValidPush) {
        [navController pushViewController:viewController animated:YES];
    }
}

- (void)safePopToViewController:(UIViewController *)viewController {
    BOOL isValidPop = NO;
    UINavigationController *navController = viewController.navigationController;
    NSInteger index = [navController.viewControllers indexOfObject:viewController];
    if (index >= 0 && index != navController.viewControllers.count) {
        isValidPop = YES;
    }
    
    if (isValidPop) {
        [navController popToViewController:viewController animated:YES];
    }
}

- (IBAction)toAirLink:(id)sender {
#if (!TARGET_IPHONE_SIMULATOR)
    if (GetCurrentSSID().length > 0) {
#endif
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"GosAirLink" bundle:nil] instantiateInitialViewController];
        GosConfigStart *configStartVC = nav.viewControllers.firstObject;
        configStartVC.delegate = self;
        [self safePushViewController:configStartVC];
#if (!TARGET_IPHONE_SIMULATOR)
    } else {
        [self showAlert:NSLocalizedString(@"Please switch to Wifi environment", nil)];
    }
#endif
}

- (void)toSettings {
    GosCommon *dataCommon = [GosCommon sharedInstance];
    if (dataCommon.settingPageHandler) {
        dataCommon.settingPageHandler(self);
    } else {
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"GosSettings" bundle:nil] instantiateInitialViewController];
        GosSettingsViewController *settingsVC = nav.viewControllers.firstObject;
        [self safePushViewController:settingsVC];
    }
}

#pragma mark - Back to root
- (void)gosConfigDidFinished {
    if (self.tabBarController) {
        [self safePopToViewController:self.tabBarController];
    } else {
        [self safePopToViewController:self];
    }
}

- (void)gosConfigDidSucceed:(GizWifiDevice *)device {
    //延迟1s执行
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self loginWithDevice:device];
            [[GosCommon sharedInstance] onCancel];
        });
    });
}

#pragma mark - GizWifiSDK Delegate
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUserLogin:(NSError *)result uid:(NSString *)uid token:(NSString *)token {
    if ([GosCommon sharedInstance].anonymousLoginOn) {
        [GosAnonymousLogin didUserLogin:result uid:uid token:token];
    }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didDiscovered:(NSError *)result deviceList:(NSArray *)deviceList {
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    if (self.pullToRefreshView.state == SSPullToRefreshViewStateLoading) {
        [self.pullToRefreshView finishLoadingAnimated:YES completion:^{
            [self refreshTableView];
        }];
    } else {
        [self refreshTableView];
    }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didBindDevice:(NSError *)result did:(NSString *)did {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (result.code != GIZ_SDK_SUCCESS) {
        NSString *info = [[GosCommon sharedInstance] checkErrorCode:result.code];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", nil) message:info delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
    }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUnbindDevice:(NSError *)result did:(NSString *)did {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (result.code == GIZ_SDK_SUCCESS) {
//        [self getBoundDevice];
    }
    else {
        NSString *info = [[GosCommon sharedInstance] checkErrorCode:result.code];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", nil) message:info delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
    }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didChannelIDUnBind:(NSError *)result {
    [GosPushManager didUnbind:result];
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didChannelIDBind:(NSError *)result {
    [GosPushManager didBind:result];
}

#pragma mark - GizWifiSDKDeviceDelegate
- (void)device:(GizWifiDevice *)device didSetSubscribe:(NSError *)result isSubscribed:(BOOL)isSubscribed {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (result.code == GIZ_SDK_SUCCESS && isSubscribed == YES) {
        self.lastSubscribedDevice = device;
        UIViewController *lastCtrl = self.navigationController.viewControllers.lastObject;
        if (lastCtrl == self || lastCtrl == self.tabBarController) {
            [GosCommon sharedInstance].controlHandler(device, self);
        }
    }
    else {
        device.delegate = nil;
    }
}

#pragma mark - QRCode
- (void)intoQRCodeVC {
#if (!TARGET_OS_SIMULATOR)
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    if(authStatus == AVAuthorizationStatusDenied){
        if (IS_VAILABLE_IOS8) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Camera access restricted", nil) message:[NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"Allow camera prepend", nil), app_Name, NSLocalizedString(@"Allow camera append", nil)] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Go to Setting", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([self canOpenSystemSettingView]) {
                    [self systemSettingView];
                }
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera access restricted", nil) message:[NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"Allow camera prepend", nil), app_Name, NSLocalizedString(@"Allow camera append", nil)] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert show];
        }
        
        return;
    }
    
    QRCodeController *qrcodeVC = [[QRCodeController alloc] init];
    qrcodeVC.view.alpha = 0;
    [qrcodeVC setDidCancelBlock:^{
        if ([GosCommon sharedInstance].recordPageHandler) {
            [GosCommon sharedInstance].recordPageHandler(self);
        }
    }];
    [qrcodeVC setDidReceiveBlock:^(NSString *result) {
        if ([result rangeOfString:@"type=share&code="].location == 0) { //共享二维码特征
            self.lastSharingCode = [result substringFromIndex:16];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [GizDeviceSharing checkDeviceSharingInfoByQRCode:[GosCommon sharedInstance].token QRCode:self.lastSharingCode];
        } else {
            NSDictionary *dict = [self getScanResult:result];
            if (dict != nil) {
                NSString *did = [dict valueForKey:@"did"];
                NSString *passcode = [dict valueForKey:@"passcode"];
                NSString *productkey = [dict valueForKey:@"product_key"];
                
                //这里，要通过did，passcode，productkey获取一个设备
                if (did.length > 0 && passcode.length > 0 && productkey > 0) {
                    NSString *uid = [GosCommon sharedInstance].uid;
                    NSString *token = [GosCommon sharedInstance].token;
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [[GizWifiSDK sharedInstance] bindDeviceWithUid:uid token:token did:did passCode:passcode remark:nil];
                } else {
                    [self showAlert:NSLocalizedString(@"Unknown QR Code", nil)];
                }
            } else {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[GizWifiSDK sharedInstance] bindDeviceByQRCode:[GosCommon sharedInstance].uid token:[GosCommon sharedInstance].token QRContent:result];
            }
        }
    }];
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del.window.rootViewController addChildViewController:qrcodeVC];
    [del.window.rootViewController.view addSubview:qrcodeVC.view];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        qrcodeVC.view.alpha = 1;
        if ([GosCommon sharedInstance].recordPageHandler) {
            [GosCommon sharedInstance].recordPageHandler(qrcodeVC);
        }
    } completion:^(BOOL finished) {
    }];
#else
    NSLog(@"warning: Scan QR code could not be supported by iPhone Simulator.");
#endif
}

- (BOOL)canOpenSystemSettingView {
    if (IS_VAILABLE_IOS8) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)systemSettingView {
    if (IS_VAILABLE_IOS8) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (NSDictionary *)getScanResult:(NSString *)result
{
    NSArray *arr1 = [result componentsSeparatedByString:@"?"];
    if(arr1.count != 2)
        return nil;
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    NSArray *arr2 = [arr1[1] componentsSeparatedByString:@"&"];
    for(NSString *str in arr2)
    {
        NSArray *keyValue = [str componentsSeparatedByString:@"="];
        if(keyValue.count != 2)
            continue;
        
        NSString *key = keyValue[0];
        NSString *value = keyValue[1];
        [mdict setValue:value forKeyPath:key];
    }
    return mdict;
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self getBoundDevice];
}

- (void)didCheckDeviceSharingInfoByQRCode:(NSError *)result userName:(NSString *)userName productName:(NSString *)productName deviceAlias:(NSString *)deviceAlias expiredAt:(NSString *)expiredAt {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (result.code == GIZ_SDK_SUCCESS) {
        NSString *deviceInfo = deviceAlias;//设备名称
        NSString *qrcode = self.lastSharingCode;//二维码
        NSDate *expiredDate = nil;
        if (deviceInfo.length == 0) {
            deviceInfo = productName;
        }
        if (expiredAt.length > 0) {
            expiredDate = [GosCommon serviceDateFromString:expiredAt];//计算剩余分钟数
        }
        GosDeviceAcceptSharingInfo *acceptCtrl = [[GosDeviceAcceptSharingInfo alloc] initWithUser:userName deviceInfo:deviceInfo qrcode:qrcode expiredDate:expiredDate];
        [self safePushViewController:acceptCtrl];
    } else {
        NSString *message = nil;
        if (result.code == 9088) {
            message = NSLocalizedString(@"Sorry unable to get sharing info. Please check your internet connection", nil);
        } else {
            message = NSLocalizedString(@"Sorry unable to get sharing info. Please check your QR code", nil);
        }
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", nil)
                                    message:message delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
}

@end
