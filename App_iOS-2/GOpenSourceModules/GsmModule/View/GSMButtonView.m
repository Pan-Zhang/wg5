//
//  GSMButtonView.m
//  GOpenSource_AppKit
//
//  Created by hello on 2018/6/11.
//  Copyright © 2018年 Gizwits. All rights reserved.
//

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备屏幕的长
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备屏幕的宽
#define MCStatusBarH [[UIApplication sharedApplication] statusBarFrame].size.height+44.0
#define TitleLabelColor [UIColor colorWithRed:19/255.0 green:152/255.0 blue:234/255.0 alpha:1/1.0]
#define OFFCOLOR [UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1.0]
#import "GSMButtonView.h"

@implementation GSMButtonView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    } return self;
}

#pragma mark 界面初始化
-(void)addSubviews{
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 20)];
    titleLabel.text = NSLocalizedString(@"repeat", nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:125/255.0];
    [self addSubview:titleLabel];
    
    CGFloat buttonx = SCREENWIDTH -35*7 -30;
    
    for (int i = 1; i < 8; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonx/2+40*(i-1), 50, 35, 35)];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:OFFCOLOR forState:UIControlStateNormal];
        [button setTitleColor:TitleLabelColor forState:UIControlStateSelected];
        [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        button.layer.borderWidth = 1.0f;
        button.layer.cornerRadius = 17.5;
        button.layer.borderColor = button.titleLabel.textColor.CGColor;
        button.tag = i;
        button.selected = NO;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 20)];
    line.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self addSubview:line];
}

-(void)clickButton:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderColor = [TitleLabelColor CGColor];
        [self.dic setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    }else{
        sender.layer.borderColor = [OFFCOLOR CGColor];
        [self.dic setObject:@"0" forKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    }
    self.retutnButtonArray(self.dic);
}

-(void)layoutSubviews{
    for (UIView *view in self.subviews ) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    CGFloat buttonx = SCREENWIDTH -35*7 -30;
    for (int i = 1; i < 8; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonx/2+40*(i-1), 50, 35, 35)];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:OFFCOLOR forState:UIControlStateNormal];
        [button setTitleColor:TitleLabelColor forState:UIControlStateSelected];
        [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        button.layer.borderWidth = 1.0f;
        button.layer.cornerRadius = 17.5;
        button.layer.borderColor = button.titleLabel.textColor.CGColor;
        button.tag = i;
        NSString *buttonselected = [self.dic objectForKey:[NSString stringWithFormat:@"%d",i]];
        if ([buttonselected isEqualToString:@"0"]) {
           button.selected = NO;
        }else{
            button.selected = YES;
        }
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
