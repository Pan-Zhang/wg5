//
//  GSMEmergencyCallTableViewCell.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/5/28.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#import "GSMEmergencyCallTableViewCell.h"
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽
//根据6注释，等比例缩放
#define kAdapterWith(x) SCREENWIDTH/375*x

#define OPENCOLOR [UIColor blackColor];
#define OFFCOLOR [UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1];
#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]

@implementation GSMEmergencyCallTableViewCell{
    UILabel *titleLabel;
    UILabel *phoneLabel;
    NSArray *array;
    UIView *bcview;
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
    bcview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    bcview.backgroundColor = [UIColor whiteColor];
    [self addSubview:bcview];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 59.0, SCREENWIDTH-20, 0.5)];
    line.backgroundColor = OFFCOLOR;
    line.alpha = .5;
    [bcview addSubview:line];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 30, 30)];
    imageview.image = [UIImage imageNamed:@"set_phone"];
    [bcview addSubview:imageview];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, 45, 15)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.tag = 100;
    titleLabel.textColor = OFFCOLOR;
    [bcview addSubview:titleLabel];
    
    phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.size.width+titleLabel.frame.origin.x+10, 15, SCREENWIDTH/2, 15)];
    phoneLabel.font = [UIFont systemFontOfSize:16];
    phoneLabel.tag = 101;
    phoneLabel.textColor = TitleLabelColor;
    [bcview addSubview:phoneLabel];
    
    UIButton *InquireButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - kAdapterWith(70),15, kAdapterWith(50), 30)];
    [InquireButton addTarget:self action:@selector(clickInquireButton:) forControlEvents:UIControlEventTouchUpInside];
    [InquireButton setTitle:NSLocalizedString(@"edit", nil) forState:UIControlStateNormal];
    [InquireButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [InquireButton setBackgroundColor:TitleLabelColor];
    InquireButton.layer.cornerRadius = 15;
    InquireButton.layer.masksToBounds = YES;
    [bcview addSubview:InquireButton];
    
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-kAdapterWith(130),15, kAdapterWith(50), 30)];
    [saveButton addTarget:self action:@selector(clickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:NSLocalizedString(@"query", nil) forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [saveButton setBackgroundColor:TitleLabelColor];
    saveButton.layer.cornerRadius = 15;
    saveButton.layer.masksToBounds = YES;
    [bcview addSubview:saveButton];
    
    array = [NSArray arrayWithObjects:@"○ CALL",@"○ SMS",@"○ RFID", nil];
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(70+55*i, 35, 50, 15)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = OFFCOLOR;
        label.textAlignment  = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%@",[array objectAtIndex:i]];
        [bcview addSubview:label];
    }
}

-(void)layoutSubviews{
    titleLabel.text = [self.dic objectForKey:@"switchName"];
    NSString *phone = [self.dic objectForKey:@"phone"];
    if (![phone isEqualToString:@"电话号码"]) {
        phoneLabel.text = phone;
    }
    for (UIView *view in bcview.subviews) {
        if ([view isKindOfClass:[UILabel class]]&& view.tag < 100) {
            [view removeFromSuperview];
        }
    }
    NSArray *selarray = [NSArray arrayWithObjects:@"● CALL",@"● SMS",@"● RFID",nil];
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(70+55*i, 35, 50, 15)];
        label.font = [UIFont systemFontOfSize:12];
        NSString *callstatus = [self.dic objectForKey:[NSString stringWithFormat:@"%d",i]];
        if ([callstatus isEqualToString:@"0"]) {
            label.textColor = OFFCOLOR;
            label.text = [NSString stringWithFormat:@"%@",[array objectAtIndex:i]];
        }else{
            label.textColor = TitleLabelColor;
            label.text = [NSString stringWithFormat:@"%@",[selarray objectAtIndex:i]];
        }
        label.textAlignment  = NSTextAlignmentCenter;
        
        [bcview addSubview:label];
    }
}

-(void)clickInquireButton:(UIButton *)sender{
    self.clickInquireButton();
}

-(void)clickSaveButton:(UIButton *)sender{
    self.clickSaveButton();
}

@end
