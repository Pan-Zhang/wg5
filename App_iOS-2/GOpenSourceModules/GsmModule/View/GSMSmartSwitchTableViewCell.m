//
//  GSMSmartSwitchTableViewCell.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMSmartSwitchTableViewCell.h"
#import "GosTipView.h"

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽
#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]

@implementation GSMSmartSwitchTableViewCell{
    
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UISwitch *_smartSwitch;
    
    UIButton *offButton;
    UIButton *openButton;
    UILabel *statusLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    UIView *bcview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    bcview.backgroundColor = [UIColor whiteColor];
    [self addSubview:bcview];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 30, 30)];
    _imageView.image = [UIImage imageNamed:@"smartSwitch_2"];
    [bcview addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, SCREENWIDTH/2, 60)];
    _titleLabel.text = NSLocalizedString(@"outle", nil);
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor blackColor];
    [bcview addSubview:_titleLabel];
    
    offButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-60, 10, 40, 40)];
    [offButton setBackgroundColor:TitleLabelColor];
    [offButton setTitle:NSLocalizedString(@"off", nil) forState:UIControlStateNormal];
    [offButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [offButton addTarget:self action:@selector(clickOffButton) forControlEvents:UIControlEventTouchUpInside];
    offButton.layer.cornerRadius = 20;
    offButton.layer.masksToBounds = YES;
    [bcview addSubview:offButton];
    
    openButton  = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-110, 10, 40, 40)];
    [openButton setBackgroundColor:TitleLabelColor];
    [openButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [openButton setTitle:NSLocalizedString(@"open", nil) forState:UIControlStateNormal];
    [openButton addTarget:self action:@selector(clickOpenButton) forControlEvents:UIControlEventTouchUpInside];
    openButton.layer.cornerRadius = 20;
    openButton.layer.masksToBounds = YES;
    [bcview addSubview:openButton];
    
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-180, 0, 60, 60)];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.font = [UIFont systemFontOfSize:18];
    
    [bcview addSubview:statusLabel];
    
    //    _smartSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREENWIDTH-71, 14.5, 51, 31)];//51x31
    //    [_smartSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    //    [bcview addSubview:_smartSwitch];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 59.5, SCREENWIDTH-20, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    [bcview addSubview:line];
}

-(void)layoutSubviews{
    _titleLabel.text = [_dic objectForKey:@"switchName"];
    if ([[_dic objectForKey:@"switchStatus"] isEqualToString:@"0"]) {
        _titleLabel.textColor = [UIColor blackColor];
        statusLabel.textColor = [UIColor blackColor];
        statusLabel.text = NSLocalizedString(@"off", nil);
        //       _smartSwitch.on = NO;
    }else{
        //        _smartSwitch.on = YES;
        statusLabel.textColor = TitleLabelColor;
        _titleLabel.textColor = TitleLabelColor;
        statusLabel.text = NSLocalizedString(@"open", nil);
    }
}

-(void)switchAction:(UISwitch *)sender{
    BOOL isButtonOn = [sender isOn];
    NSString *status;
    if (isButtonOn) {
        status = @"1";
    }else {
        status = @"0";
    }
    self.returnSwitchStatus(status);
}


-(void)clickOffButton{
//    if ([[_dic objectForKey:@"switchStatus"] isEqualToString:@"0"]){
//        [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"The_current_state_is_closed", nil) delay:1 completion:^{
//
//        }];
//        return;
//    }
    self.returnSwitchStatus(@"0");
}
-(void)clickOpenButton{
//    if ([[_dic objectForKey:@"switchStatus"] isEqualToString:@"1"]){
//        [[GosTipView sharedInstance]showTipMessage:NSLocalizedString(@"The_current_state_is_open", nil) delay:1 completion:^{
//            
//        }];
//        return;
//    }
    self.returnSwitchStatus(@"1");
    
}

@end
