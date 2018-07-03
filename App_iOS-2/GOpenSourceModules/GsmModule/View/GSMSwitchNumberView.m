//
//  GSMSwitchNumberView.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/11.
//  Copyright © 2018年 Gizwits. All rights reserved.
//
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽
#define MCStatusBarH [[UIApplication sharedApplication] statusBarFrame].size.height+44.0
#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]

#import "GSMSwitchNumberView.h"

@interface GSMSwitchNumberView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)NSMutableArray *switchNumberArray;

@end

@implementation GSMSwitchNumberView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    } return self;
}

#pragma mark 界面初始化
-(void)addSubviews{
    self.backgroundColor = [UIColor whiteColor];
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/2, 150)];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerView];
    
    UILabel *hourLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, SCREENWIDTH/2, 40)];
    hourLabel.textAlignment = NSTextAlignmentCenter;
    hourLabel.text = @"Outlet";
    [self addSubview:hourLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,_pickerView.frame.size.height+_pickerView.frame.origin.y , SCREENWIDTH, SCREENWIDTH)];
    line.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self addSubview:line];
}

#pragma mark -PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return self.switchNumberArray.count;
}
//确定每个轮子的每一项显示什么内容
#pragma mark 实现协议UIPickerViewDelegate方法
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.switchNumberArray objectAtIndex:row];
}

//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _switchID = [NSString stringWithFormat:@"%ld",(long)row];
    self.retutnSwitchID(_switchID);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREENWIDTH/2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}



//  第component列第row行显示怎样的view(内容)
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/2, 40)];
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,cellView.frame.size.width, 40)];
    leftLabel.backgroundColor = [UIColor whiteColor];
    leftLabel.font = [UIFont systemFontOfSize:20];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.text = [self.switchNumberArray objectAtIndex:row];
    [cellView addSubview:leftLabel];
    return cellView;
}


-(NSMutableArray *)switchNumberArray{
    if (_switchNumberArray == nil) {
        NSMutableArray *switchNumberArray = [NSMutableArray array];
        for (int i = 1; i < 21; i++) {
            [switchNumberArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _switchNumberArray = switchNumberArray;
    }
    return _switchNumberArray;
}

-(void)layoutSubviews{
    [self switchNumberArray];
    [_pickerView selectRow:[_switchID integerValue] inComponent:0 animated:YES];
    self.retutnSwitchID(_switchID);
}

@end
