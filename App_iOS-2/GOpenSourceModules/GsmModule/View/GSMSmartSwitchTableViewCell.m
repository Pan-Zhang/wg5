//
//  GSMSmartSwitchTableViewCell.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMSmartSwitchTableViewCell.h"

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽

@implementation GSMSmartSwitchTableViewCell{
    
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UISwitch *_smartSwitch;
    
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
    
    _smartSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREENWIDTH-71, 14.5, 51, 31)];//51x31
    [_smartSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [bcview addSubview:_smartSwitch];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 59.5, SCREENWIDTH-20, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    [bcview addSubview:line];
}

-(void)layoutSubviews{
    _titleLabel.text = [_dic objectForKey:@"switchName"];
    if ([[_dic objectForKey:@"switchStatus"] isEqualToString:@"0"]) {
       _smartSwitch.on = NO;
    }else{
        _smartSwitch.on = YES;
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

@end
