//
//  SelectView.m
//  微妮
//
//  Created by 刘锦 on 14-10-8.
//  Copyright (c) 2014年 liujin. All rights reserved.
//

#import "SelectView.h"

@interface SelectView()

@end

@implementation SelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _sinaButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_sinaButton setTitle:@"新浪微博" forState:UIControlStateNormal];
        [_sinaButton setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2.0)];
        _tencentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_tencentButton setTitle:@"腾讯微博" forState:UIControlStateNormal];
        [_tencentButton setFrame:CGRectMake(0, self.bounds.size.height/2.0, self.bounds.size.width, self.bounds.size.height/2.0)];
        [self addSubview:_sinaButton];
        [self addSubview:_tencentButton];
        //画中间的线条
        [self setNeedsDisplay];
    }
    return self;
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1.0);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, self.bounds.size.height/2.0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height/2.0);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}

@end
