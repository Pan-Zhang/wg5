//
//  GSMTimeView.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/11.
//  Copyright © 2018年 Gizwits. All rights reserved.
//
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽
#define MCStatusBarH [[UIApplication sharedApplication] statusBarFrame].size.height+44.0
#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]

#import "GSMTimeView.h"

@interface GSMTimeView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)NSMutableArray *hourArray;
@property(nonatomic,strong)NSMutableArray *minuteArray;
@end

@implementation GSMTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    } return self;
}

#pragma mark 界面初始化
-(void)addSubviews{
    self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerView];

    UILabel *hourLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-30, 55, 20, 40)];
    hourLabel.text = NSLocalizedString(@"h", nil);
    [_pickerView addSubview:hourLabel];
    
    UILabel *minuteLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-40, 55, 20, 40)];
    minuteLabel.text = NSLocalizedString(@"m", nil);
    [_pickerView addSubview:minuteLabel];
}

#pragma mark -PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (0 == component) {
        return self.hourArray.count;
    }else{
        return self.minuteArray.count;
    }
}
//确定每个轮子的每一项显示什么内容
#pragma mark 实现协议UIPickerViewDelegate方法
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (0 == component) {
        return [self.hourArray objectAtIndex:row];
    }else{
        return [self.minuteArray objectAtIndex:row];
    }
}

//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (0 == component) {
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        _hour = [self.hourArray objectAtIndex:row];
        _minute = [self.minuteArray objectAtIndex:0];
        self.retutnTime(_hour, _minute);
    }else{
         _minute = [self.minuteArray objectAtIndex:row];
        self.retutnTime(_hour, _minute);
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREENWIDTH/2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}



//  第component列第row行显示怎样的view(内容)
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/2, 40)];
    if (0 == component) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREENWIDTH/2-50, 40)];
        leftLabel.backgroundColor = [UIColor whiteColor];
        leftLabel.font = [UIFont systemFontOfSize:20];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text = [self.hourArray objectAtIndex:row];
        [cellView addSubview:leftLabel];
        
        
    }else{
        UILabel *rigtLabel =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/2-50, 40)];
        rigtLabel.backgroundColor = [UIColor whiteColor];
        rigtLabel.font = [UIFont systemFontOfSize:20];
        rigtLabel.textAlignment = NSTextAlignmentCenter;
        rigtLabel.text = [self.minuteArray objectAtIndex:row];
        [cellView addSubview:rigtLabel];
    }
    return cellView;
}


-(NSMutableArray *)hourArray{
    if (_hourArray == nil) {
        NSMutableArray *hourArray = [NSMutableArray array];
        for (int i = 0; i < 12; i++) {
            [hourArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _hourArray = hourArray;
    }
    return _hourArray;
}

-(NSMutableArray *)minuteArray{
    if (_minuteArray == nil) {
        NSMutableArray *minuteArray = [NSMutableArray array];
        for (int i = 0; i < 60; i++) {
            [minuteArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _minuteArray = minuteArray;
    }
    return _minuteArray;
}

-(void)layoutSubviews{
    [self hourArray];
    [self minuteArray];
    [_pickerView selectRow:[_hour integerValue] inComponent:0 animated:YES];
    [_pickerView selectRow:[_minute integerValue] inComponent:1 animated:YES];
    self.retutnTime(_hour,_minute);
}

@end
