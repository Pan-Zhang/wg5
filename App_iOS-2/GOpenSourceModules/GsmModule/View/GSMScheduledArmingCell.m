//
//  GSMScheduledArmingCell.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/11.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMScheduledArmingCell.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽
#define OPENCOLOR [UIColor blackColor];
#define OFFCOLOR [UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1.0];
#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]

@implementation GSMScheduledArmingCell{
    UILabel *timeLabel;
    UILabel *socketLabel;
    UILabel *statusLabel;
    UISwitch *mySwitch;
    
    UIView *weekViwe;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
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
    UIView *bcview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130)];
    bcview.backgroundColor = [UIColor whiteColor];
    [self addSubview:bcview];
    
    socketLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,25,25,25)];
    socketLabel.textColor = OFFCOLOR;
    socketLabel.text = @"1";
    socketLabel.layer.cornerRadius = 12.5;
    socketLabel.layer.masksToBounds = YES;
    [socketLabel.layer setBorderWidth:1];
    [socketLabel.layer setBorderColor:[socketLabel.textColor CGColor]];
    
    socketLabel.font = [UIFont boldSystemFontOfSize:25];
    socketLabel.textAlignment = NSTextAlignmentCenter;
    [bcview addSubview:socketLabel];
    
    timeLabel = [[UILabel alloc]init];
    timeLabel.font = [UIFont boldSystemFontOfSize:25];
    NSString *timeString = @"00:00";
    CGRect rect = [timeString boundingRectWithSize:CGSizeMake(MAXFLOAT,50)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:timeLabel.font}
                                           context:nil];
    timeLabel.frame = CGRectMake(socketLabel.frame.origin.x+socketLabel.frame.size.width+20, 20, rect.size.width, rect.size.height);
    timeLabel.text = timeString;
    [bcview addSubview:timeLabel];
    
    
    
    mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREENWIDTH-60, timeLabel.frame.origin.y, 50, 30)];
    mySwitch.onTintColor =  TitleLabelColor;
    [mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [bcview addSubview:mySwitch];
    
    UILabel *statusNameLabel = [[UILabel alloc]init];
    statusNameLabel.font = [UIFont systemFontOfSize:15];
    statusNameLabel.textColor = OFFCOLOR;
    NSString *statusname = NSLocalizedString(@"state", nil);
    CGRect rect_1 = [statusname boundingRectWithSize:CGSizeMake(MAXFLOAT,50)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:statusNameLabel.font}
                                             context:nil];
    statusNameLabel.frame = CGRectMake(20, timeLabel.frame.origin.y+timeLabel.frame.size.height+10, rect_1.size.width, 20);
    statusNameLabel.text = statusname;
    [bcview addSubview:statusNameLabel];
    
    NSString *statusstring = NSLocalizedString(@"alarm", nil);
    
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(statusNameLabel.frame.origin.x+statusNameLabel.frame.size.width+3, statusNameLabel.frame.origin.y, 100, 20)];
    statusLabel.font = [UIFont boldSystemFontOfSize:20];
    statusLabel.textColor = OFFCOLOR;
    statusLabel.text = statusstring;
    [bcview addSubview:statusLabel];
    
    UILabel *repeatLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, statusLabel.frame.origin.y+statusLabel.frame.size.height+15, rect_1.size.width, 20)];
    repeatLabel.textColor = OFFCOLOR;
    repeatLabel.font = [UIFont systemFontOfSize:15];
    repeatLabel.text = NSLocalizedString(@"repeat", nil);
    [bcview addSubview:repeatLabel];
    
    weekViwe = [[UIView alloc]initWithFrame:CGRectMake(repeatLabel.frame.origin.x+repeatLabel.frame.size.width+3, repeatLabel.frame.origin.y, SCREENWIDTH - 70 - (repeatLabel.frame.origin.x+repeatLabel.frame.size.width+3) , 20)];
    [bcview addSubview:weekViwe];
    
    for (int i = 1; i < 8; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25*(i-1), 0, 20, 20)];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = OFFCOLOR;
        label.textAlignment  = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d",i];
        label.layer.borderWidth = 1.0f;
        label.layer.cornerRadius = 10;
        label.layer.borderColor = label.textColor.CGColor;
        [weekViwe addSubview:label];
    }
    
    UIButton *InquireButton = [[UIButton alloc]initWithFrame:CGRectMake(weekViwe.frame.origin.x+weekViwe.frame.size.width+10,weekViwe.frame.origin.y-5,50, 30)];
    [InquireButton addTarget:self action:@selector(clickInquireButton) forControlEvents:UIControlEventTouchUpInside];
    [InquireButton setTitle:NSLocalizedString(@"query", nil) forState:UIControlStateNormal];
    [InquireButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [InquireButton setBackgroundColor:TitleLabelColor];
    InquireButton.layer.cornerRadius = 15;
    InquireButton.layer.masksToBounds = YES;
    [bcview addSubview:InquireButton];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 129.5, SCREENWIDTH-20, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    [bcview addSubview:line];
}

-(void)clickInquireButton{
    self.clickInquireBtn();
}
-(void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSString *status;
    if (isButtonOn) {
        status = @"1";
    }else {
        status = @"0";
    }
    self.clickSwitch(status);
}

-(void)layoutSubviews{
    socketLabel.text = [self.dic objectForKey:@"switchName"];
    NSString *hour = [self.dic objectForKey:@"hour"];
    NSString *minute = [self.dic objectForKey:@"minute"];
    if (hour.length == 1) {
        hour = [NSString stringWithFormat:@"0%@",hour];
    }
    if (minute.length == 1) {
        minute = [NSString stringWithFormat:@"0%@",minute];
    }
    
    timeLabel.text = [NSString stringWithFormat:@"%@:%@",hour,minute];
    
    NSString *status = [self.dic objectForKey:@"status"];
    if ([status isEqualToString:@"0"]) {
        statusLabel.text = NSLocalizedString(@"disarm", nil);
    }else{
        statusLabel.text = NSLocalizedString(@"alarm", nil);
    }
    
    for (UIView *view in weekViwe.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 1; i < 8; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25*(i-1), 0, 20, 20)];
        label.font = [UIFont systemFontOfSize:16];
        NSString *weekstatus = [self.dic objectForKey:[NSString stringWithFormat:@"%d",i]];
        if ([weekstatus isEqualToString:@"0"]) {
            label.textColor = OFFCOLOR;
        }else{
            label.textColor = TitleLabelColor;
        }
        label.textAlignment  = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d",i];
        label.layer.borderWidth = 1.0f;
        label.layer.cornerRadius = 10;
        label.layer.borderColor = label.textColor.CGColor;
        [weekViwe addSubview:label];
    }
    
    NSString *switchStatus = [self.dic objectForKey:@"switchStatus"];
    if ([switchStatus isEqualToString:@"0"]) {
        mySwitch.on = NO;
    }else{
        mySwitch.on = YES;
    }
    
}

@end
